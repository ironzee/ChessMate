import SwiftUI

struct GameView: View {
    @StateObject var viewModel: GameViewModel
    let currentUserId: String

    init(gameId: String, currentUserId: String) {
        _viewModel = StateObject(wrappedValue: GameViewModel(gameId: gameId))
        self.currentUserId = currentUserId
    }

    var body: some View {
        VStack(spacing: 12) {
            if let game = viewModel.game {
                Text("Turn: \(game.turn == "w" ? "White" : "Black")")
                    .font(.headline)

                ChessBoardView(fen: game.fen, lastMove: lastMoveTuple()) { from, to in
                    viewModel.makeMove(from: from, to: to, san: nil, by: currentUserId)
                }
                .aspectRatio(1, contentMode: .fit)
                .padding(.horizontal)

                HStack(spacing: 12) {
                    Button("Resign") { viewModel.resign(by: currentUserId) }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)

                    Button("Offer Draw") { viewModel.offerDraw(by: currentUserId) }
                        .buttonStyle(.bordered)
                }
                
                if let offeredBy = (try? (viewModel.game as AnyObject).value(forKey: "drawOfferedBy")) as? String, !offeredBy.isEmpty, offeredBy != currentUserId {
                    Button("Accept Draw") { viewModel.acceptDraw(by: currentUserId) }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                }

                if let _ = viewModel.errorMessage {
                    Text(viewModel.errorMessage ?? "")
                        .foregroundColor(.red)
                        .font(.caption)
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(Array((viewModel.game?.moveHistory ?? []).enumerated()), id: \.offset) { idx, move in
                            Text("\(idx + 1). \(move)")
                                .font(.caption)
                        }
                    }
                }
                .frame(maxHeight: 160)

            } else {
                ProgressView("Loading game...")
            }
        }
        .padding()
        .navigationTitle("Game")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func lastMoveTuple() -> (from: String, to: String)? {
        guard let last = viewModel.game?.moveHistory.last else { return nil }
        let parts = last.split(separator: "-")
        if parts.count == 2 { return (String(parts[0]), String(parts[1])) }
        return nil
    }
}
