import Foundation

enum PieceColor: String { case white = "w", black = "b" }

enum PieceType: Character { case king = "k", queen = "q", rook = "r", bishop = "b", knight = "n", pawn = "p" }

struct Piece { let type: PieceType; let color: PieceColor }

struct Square: Hashable { let file: Int; let rank: Int } // 0..7, 0..7 (a1 = 0,0)

struct Board {
    // board[rank][file] rank 0 is 1st rank
    var board: [[Piece?]] = Array(repeating: Array(repeating: nil, count: 8), count: 8)
    var activeColor: PieceColor = .white
    var halfmoveClock: Int = 0
    var fullmoveNumber: Int = 1

    static func fromFEN(_ fen: String) -> Board {
        var b = Board()
        let parts = fen.split(separator: " ")
        guard parts.count >= 2 else { return b }
        let rows = parts[0].split(separator: "/")
        for (rankIndex, row) in rows.enumerated() {
            var file = 0
            for ch in row {
                if let digit = ch.wholeNumberValue {
                    file += digit
                } else {
                    let isUpper = ch.isUppercase
                    let type = PieceType(rawValue: Character(ch.lowercased()))
                    if let type = type {
                        let color: PieceColor = isUpper ? .white : .black
                        let squareRank = 7 - rankIndex // FEN starts from rank 8
                        if file >= 0 && file < 8 && squareRank >= 0 && squareRank < 8 {
                            b.board[squareRank][file] = Piece(type: type, color: color)
                        }
                        file += 1
                    }
                }
            }
        }
        b.activeColor = parts[1] == "w" ? .white : .black
        if parts.count >= 6 {
            b.fullmoveNumber = Int(parts[5]) ?? 1
        }
        return b
    }

    func toFEN() -> String {
        var rows: [String] = []
        for rank in (0..<8).reversed() { // 7..0
            var row = ""
            var empty = 0
            for file in 0..<8 {
                if let p = board[rank][file] {
                    if empty > 0 { row += String(empty); empty = 0 }
                    let char: Character
                    switch p.type {
                    case .king: char = "k"
                    case .queen: char = "q"
                    case .rook: char = "r"
                    case .bishop: char = "b"
                    case .knight: char = "n"
                    case .pawn: char = "p"
                    }
                    row += p.color == .white ? String(char).uppercased() : String(char)
                } else {
                    empty += 1
                }
            }
            if empty > 0 { row += String(empty) }
            rows.append(row)
        }
        let boardPart = rows.joined(separator: "/")
        let active = activeColor == .white ? "w" : "b"
        // Simplified: omit castling, en passant, halfmove
        return "\(boardPart) \(active) - - 0 \(fullmoveNumber)"
    }
}

struct ChessEngine {
    static func legalMoves(from: Square, on board: Board) -> [Square] {
        guard let piece = board.board[from.rank][from.file] else { return [] }
        var targets: [Square] = []
        let color = piece.color
        func addIfValid(_ f: Int, _ r: Int) {
            guard f >= 0, f < 8, r >= 0, r < 8 else { return }
            if let dest = board.board[r][f] {
                if dest.color != color { targets.append(Square(file: f, rank: r)) }
            } else {
                targets.append(Square(file: f, rank: r))
            }
        }
        switch piece.type {
        case .pawn:
            let dir = (color == .white) ? 1 : -1
            let startRank = (color == .white) ? 1 : 6
            // one step forward if empty
            let oneR = from.rank + dir
            if oneR >= 0 && oneR < 8 && board.board[oneR][from.file] == nil {
                targets.append(Square(file: from.file, rank: oneR))
                // two steps from start
                if from.rank == startRank {
                    let twoR = from.rank + 2*dir
                    if twoR >= 0 && twoR < 8 && board.board[twoR][from.file] == nil {
                        targets.append(Square(file: from.file, rank: twoR))
                    }
                }
            }
            // captures
            for df in [-1, 1] {
                let f = from.file + df
                let r = from.rank + dir
                guard f >= 0 && f < 8 && r >= 0 && r < 8 else { continue }
                if let dest = board.board[r][f], dest.color != color {
                    targets.append(Square(file: f, rank: r))
                }
            }
        case .knight:
            let deltas = [(1,2),(2,1),(-1,2),(-2,1),(1,-2),(2,-1),(-1,-2),(-2,-1)]
            for d in deltas { addIfValid(from.file + d.0, from.rank + d.1) }
        case .bishop:
            for (df, dr) in [(1,1),(-1,1),(1,-1),(-1,-1)] {
                var f = from.file + df
                var r = from.rank + dr
                while f >= 0 && f < 8 && r >= 0 && r < 8 {
                    if let dest = board.board[r][f] {
                        if dest.color != color { targets.append(Square(file: f, rank: r)) }
                        break
                    } else {
                        targets.append(Square(file: f, rank: r))
                    }
                    f += df; r += dr
                }
            }
        case .rook:
            for (df, dr) in [(1,0),(-1,0),(0,1),(0,-1)] {
                var f = from.file + df
                var r = from.rank + dr
                while f >= 0 && f < 8 && r >= 0 && r < 8 {
                    if let dest = board.board[r][f] {
                        if dest.color != color { targets.append(Square(file: f, rank: r)) }
                        break
                    } else {
                        targets.append(Square(file: f, rank: r))
                    }
                    f += df; r += dr
                }
            }
        case .queen:
            for (df, dr) in [(1,0),(-1,0),(0,1),(0,-1),(1,1),(-1,1),(1,-1),(-1,-1)] {
                var f = from.file + df
                var r = from.rank + dr
                while f >= 0 && f < 8 && r >= 0 && r < 8 {
                    if let dest = board.board[r][f] {
                        if dest.color != color { targets.append(Square(file: f, rank: r)) }
                        break
                    } else {
                        targets.append(Square(file: f, rank: r))
                    }
                    f += df; r += dr
                }
            }
        case .king:
            for df in -1...1 {
                for dr in -1...1 {
                    if df == 0 && dr == 0 { continue }
                    addIfValid(from.file + df, from.rank + dr)
                }
            }
        }
        // Filter out moves that land on own piece handled in addIfValid; turn checking is done by caller.
        return targets
    }

    static func applyMove(from: Square, to: Square, on board: inout Board) {
        guard let piece = board.board[from.rank][from.file] else { return }
        board.board[to.rank][to.file] = piece
        board.board[from.rank][from.file] = nil
        board.activeColor = (board.activeColor == .white) ? .black : .white
        if board.activeColor == .white { board.fullmoveNumber += 1 }
    }
}
