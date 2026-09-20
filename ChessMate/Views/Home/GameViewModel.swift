import Foundation
import FirebaseFirestore
import Combine

class GameViewModel: ObservableObject {
    @Published var game: GameModel?
    @Published var errorMessage: String?

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    let gameId: String

    init(gameId: String) {
        self.gameId = gameId
        listen()
    }

    deinit {
        listener?.remove()
    }

    private func listen() {
        listener = db.collection("games").document(gameId)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                if let game = try? snapshot?.data(as: GameModel.self) {
                    self?.game = game
                }
            }
    }

    func makeMove(from: String, to: String, san: String? = nil, by userId: String) {
        guard var game = game else { return }

        // Only allow current player's turn
        let myColor: PieceColor = (userId == game.userWhiteId) ? .white : .black
        guard (game.turn == "w" && myColor == .white) || (game.turn == "b" && myColor == .black) else { return }

        var board = Board.fromFEN(game.fen)
        guard let fromSq = coordToSquare(from), let toSq = coordToSquare(to) else { return }

        // Ensure piece belongs to player
        guard let piece = board.board[fromSq.rank][fromSq.file], piece.color == myColor else { return }

        let legal = ChessEngine.legalMoves(from: fromSq, on: board)
        guard legal.contains(toSq) else { return }

        // Apply
        ChessEngine.applyMove(from: fromSq, to: toSq, on: &board)
        let newFEN = board.toFEN()
        game.fen = newFEN
        game.turn = board.activeColor.rawValue
        game.moveHistory.append("\(from)-\(to)")
        game.updatedAt = Date()

        do {
            try db.collection("games").document(gameId).setData(from: game, merge: true)
        } catch {
            self.errorMessage = error.localizedDescription
        }

        let moveRef = db.collection("games").document(gameId).collection("moves").document()
        moveRef.setData([
            "from": from,
            "to": to,
            "san": san ?? "\(from)-\(to)",
            "byUserId": userId,
            "timestamp": FieldValue.serverTimestamp()
        ])
    }

    private func coordToSquare(_ coord: String) -> Square? {
        let files = ["a","b","c","d","e","f","g","h"]
        guard coord.count == 2,
              let fileChar = coord.first,
              let rankChar = coord.last,
              let fileIndex = files.firstIndex(of: String(fileChar)),
              let rankInt = Int(String(rankChar)) else { return nil }
        return Square(file: fileIndex, rank: rankInt - 1)
    }

    func resign(by userId: String) {
        guard var game = game else { return }
        game.status = "resigned"
        game.updatedAt = Date()
        do {
            try db.collection("games").document(gameId).setData(from: game, merge: true)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func offerDraw(by userId: String) {
        db.collection("games").document(gameId).updateData(["drawOfferedBy": userId])
    }

    func acceptDraw(by userId: String) {
        db.collection("games").document(gameId).updateData(["status": "draw"]) { _ in }
    }
}
