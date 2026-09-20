import SwiftUI
import Foundation

struct BotGameView: View {
    @State private var fen: String = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    @State private var moveHistory: [String] = []
    @State private var turn: String = "w" // "w" or "b"
    @State private var errorMessage: String?
    @State private var selectedSquare: String? = nil
    @State private var board: Board = Board.fromFEN("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
    @State private var playerPlaysWhite: Bool = true
    @State private var botDifficulty: Double = 0 // 0 easy (random), 1 hard (prefer captures)
    @State private var gameStatus: String = "active" // active, resigned, draw
    @State private var drawOfferedByPlayer: Bool = false

    var body: some View {
        VStack(spacing: 12) {
            Text("Turn: \(turn == "w" ? "White" : "Black")")
                .font(.headline)

            HStack(spacing: 12) {
                Picker("Color", selection: $playerPlaysWhite) {
                    Text("White").tag(true)
                    Text("Black").tag(false)
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 220)

                VStack(alignment: .leading) {
                    Text("Difficulty")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Slider(value: $botDifficulty, in: 0...1)
                        .frame(width: 140)
                }
            }
            .padding(.horizontal)

            HStack(spacing: 12) {
                Button("Resign") {
                    gameStatus = "resigned"
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)

                if !drawOfferedByPlayer {
                    Button("Offer Draw") {
                        drawOfferedByPlayer = true
                    }
                    .buttonStyle(.bordered)
                } else {
                    Button("Accept Draw") {
                        gameStatus = "draw"
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
            }
            .padding(.horizontal)

            Group {
                ChessBoardView(fen: fen, lastMove: lastMoveTuple()) { from, to in
                    guard gameStatus == "active" else { return }
                    handleMoveRequest(from: from, to: to)
                }
                .allowsHitTesting(gameStatus == "active")
                .overlay(alignment: .center) {
                    if gameStatus != "active" {
                        ZStack {
                            Rectangle().fill(Color.black.opacity(0.3))
                            Text(gameStatus.capitalized)
                                .font(.title2.bold())
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .padding(.horizontal)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(moveHistory.enumerated()), id: \.offset) { idx, move in
                        Text("\(idx + 1). \(move)")
                            .font(.caption)
                    }
                }
            }
            .frame(maxHeight: 160)
        }
        .padding()
        .navigationTitle("Play vs Bot")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: playerPlaysWhite) { _ in
            restartGame()
        }
    }

    private func lastMoveTuple() -> (from: String, to: String)? {
        guard let last = moveHistory.last else { return nil }
        let parts = last.split(separator: "-")
        if parts.count == 2 { return (String(parts[0]), String(parts[1])) }
        return nil
    }

    private func handleTap(on coord: String) {
        if let from = selectedSquare {
            if from != coord {
                handleUserMove(from: from, to: coord)
            }
            selectedSquare = nil
        } else {
            selectedSquare = coord
        }
    }

    private func handleUserMove(from: String, to: String) {
        handleMoveRequest(from: from, to: to)
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

    private func handleMoveRequest(from: String, to: String) {
        guard let fromSq = coordToSquare(from), let toSq = coordToSquare(to) else { return }
        // Enforce turn and player color
        guard let piece = board.board[fromSq.rank][fromSq.file] else { return }
        let movingColor = piece.color
        let isPlayersTurn = (turn == "w" && playerPlaysWhite && movingColor == .white) || (turn == "b" && !playerPlaysWhite && movingColor == .black)
        guard isPlayersTurn else { return }

        let legal = ChessEngine.legalMoves(from: fromSq, on: board)
        guard legal.contains(toSq) else { return }

        // Apply user's move
        ChessEngine.applyMove(from: fromSq, to: toSq, on: &board)
        moveHistory.append("\(from)-\(to)")
        turn = (turn == "w") ? "b" : "w"
        fen = board.toFEN()

        // Bot move after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            makeBotMove()
        }
    }

    private func makeBotMove() {
        guard gameStatus == "active" else { return }
        // Determine all legal moves for the side to move and pick one
        let side: PieceColor = (turn == "w") ? .white : .black
        var candidates: [(Square, Square)] = []
        for r in 0..<8 {
            for f in 0..<8 {
                if let p = board.board[r][f], p.color == side {
                    let fromSq = Square(file: f, rank: r)
                    let moves = ChessEngine.legalMoves(from: fromSq, on: board)
                    for toSq in moves { candidates.append((fromSq, toSq)) }
                }
            }
        }
        if candidates.isEmpty { gameStatus = "draw"; return }

        // Prefer captures as difficulty increases
        let filtered: [(Square, Square)]
        if botDifficulty > 0.66 {
            filtered = candidates.filter { move in
                let to = move.1
                if let dest = board.board[to.rank][to.file] { return true }
                return false
            }
        } else if botDifficulty > 0.33 {
            let captures = candidates.filter { board.board[$0.1.rank][$0.1.file] != nil }
            filtered = captures.isEmpty ? candidates : captures
        } else {
            filtered = candidates
        }

        guard let choice = filtered.randomElement() else { return }
        ChessEngine.applyMove(from: choice.0, to: choice.1, on: &board)
        let fromCoord = squareToCoord(choice.0)
        let toCoord = squareToCoord(choice.1)
        moveHistory.append("\(fromCoord)-\(toCoord)")
        turn = (turn == "w") ? "b" : "w"
        fen = board.toFEN()
    }

    private func squareToCoord(_ sq: Square) -> String {
        let files = ["a","b","c","d","e","f","g","h"]
        return files[sq.file] + String(sq.rank + 1)
    }

    private func restartGame() {
        fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
        board = Board.fromFEN(fen)
        moveHistory = []
        turn = "w"
        gameStatus = "active"
        drawOfferedByPlayer = false
        // If player chooses black, let bot make the first move
        if !playerPlaysWhite {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                makeBotMove()
            }
        }
    }
}
