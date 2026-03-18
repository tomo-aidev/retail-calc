import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CalculationHistory.createdAt, order: .reverse) private var histories: [CalculationHistory]
    @State private var viewModel = HistoryViewModel()
    @State private var showDeleteConfirmation = false
    var onRestore: ((CalculationHistory) -> Void)?

    var body: some View {
        VStack(spacing: 0) {
            if !histories.isEmpty {
                HStack {
                    Spacer()
                    Button("すべて削除") {
                        showDeleteConfirmation = true
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.red)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }

            if histories.isEmpty {
                emptyState
            } else {
                historyList
            }
        }
        .background(Color(.systemGroupedBackground))
        .alert("すべての履歴を削除しますか？", isPresented: $showDeleteConfirmation) {
            Button("削除", role: .destructive) {
                viewModel.deleteAllHistory(context: modelContext)
            }
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("この操作は取り消せません。")
        }
    }

    private var historyList: some View {
        List {
            ForEach(histories) { history in
                HistoryItemRow(history: history, viewModel: viewModel)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onRestore?(history)
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
            .onDelete { indexSet in
                for index in indexSet {
                    viewModel.deleteHistory(histories[index], context: modelContext)
                }
            }
        }
        .listStyle(.plain)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("計算履歴がありません")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("電卓で計算すると、ここに履歴が表示されます")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
