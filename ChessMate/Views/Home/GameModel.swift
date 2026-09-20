import Foundation
import FirebaseFirestore
import FirebaseFirestore

struct GameModel: Identifiable, Codable {
    @DocumentID var id: String?
    var userWhiteId: String
    var userBlackId: String
    var matchRequestId: String
    var status: String // "active", "resigned", "draw", "checkmate"
    var fen: String // current board state in FEN
    var moveHistory: [String] // SAN or UCI strings
    var turn: String // "w" or "b"
    var createdAt: Date?
    var updatedAt: Date?
}
