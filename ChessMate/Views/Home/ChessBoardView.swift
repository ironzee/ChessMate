import SwiftUI

struct ChessBoardView: View {
    let fen: String
    var lastMove: (from: String, to: String)? = nil
    var onMove: (String, String) -> Void

    @State private var selectedSquare: String? = nil

    private let files = ["a","b","c","d","e","f","g","h"]
    private let ranks = [8,7,6,5,4,3,2,1]

    func coordToSquare(_ coord: String) -> Square? {
        guard coord.count == 2,
              let fileChar = coord.first,
              let rankChar = coord.last,
              let fileIndex = files.firstIndex(of: String(fileChar)),
              let rankInt = Int(String(rankChar)) else { return nil }
        return Square(file: fileIndex, rank: rankInt - 1)
    }

    func pieceSymbol(_ piece: Piece) -> String {
        switch (piece.type, piece.color) {
        case (.king, .white): return "♔"
        case (.queen, .white): return "♕"
        case (.rook, .white): return "♖"
        case (.bishop, .white): return "♗"
        case (.knight, .white): return "♘"
        case (.pawn, .white): return "♙"
        case (.king, .black): return "♚"
        case (.queen, .black): return "♛"
        case (.rook, .black): return "♜"
        case (.bishop, .black): return "♝"
        case (.knight, .black): return "♞"
        case (.pawn, .black): return "♟︎"
        }
    }

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let squareSize = size / 8
            let board = Board.fromFEN(fen)

            VStack(spacing: 0) {
                ForEach(ranks, id: \.self) { rank in
                    HStack(spacing: 0) {
                        ForEach(0..<8, id: \.self) { fileIndex in
                            let file = files[fileIndex]
                            let coord = "\(file)\(rank)"
                            let sq = Square(file: fileIndex, rank: rank - 1)
                            let piece = board.board[sq.rank][sq.file]
                            ZStack {
                                Rectangle()
                                    .fill(((fileIndex + rank) % 2 == 0) ? Color.white : Color(.sRGB, red: 0.8, green: 0.2, blue: 0.5, opacity: 1.0))

                                if let last = lastMove {
                                    if last.from == coord || last.to == coord {
                                        Rectangle().stroke(Color.goldenTan, lineWidth: 4)
                                    }
                                }

                                if selectedSquare == coord {
                                    Rectangle().stroke(Color.blue.opacity(0.7), lineWidth: 3)
                                }

                                if let p = piece {
                                    let isLightSquare = ((fileIndex + rank) % 2 == 0)
                                    // On light (white) squares, use pink; on dark (pink) squares, use white
                                    let pieceColor: Color = isLightSquare ? Color(.sRGB, red: 0.8, green: 0.2, blue: 0.5, opacity: 1.0) : .white
                                    Text(pieceSymbol(p))
                                        .font(.system(size: squareSize * 0.7))
                                        .foregroundColor(pieceColor)
                                }
                            }
                            .frame(width: squareSize, height: squareSize)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if let from = selectedSquare {
                                    if from != coord {
                                        onMove(from, coord)
                                    }
                                    selectedSquare = nil
                                } else {
                                    selectedSquare = coord
                                }
                            }
                        }
                    }
                }
            }
            .frame(width: size, height: size)
        }
    }
}
