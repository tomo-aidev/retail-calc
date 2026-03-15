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
            // Header
            header

            // Filter tabs
            filterTabs

            // History list
            if filteredHistories.isEmpty {
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

    private var filteredHistories: [CalculationHistory] {
        viewModel.filteredHistory(histories)
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text("履歴")
                .font(.title2.weight(.bold))
            Spacer()
            if !histories.isEmpty {
                Button("すべて削除") {
                    showDeleteConfirmation = true
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.primary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color(.systemBackground).opacity(0.8))
    }

    // MARK: - Filter Tabs

    private var filterTabs: some View {
        HStack(spacing: 8) {
            ForEach(HistoryViewModel.FilterType.allCases, id: \.self) { filter in
                Button {
                    viewModel.selectedFilter = filter
                } label: {
                    Text(filter.rawValue)
                        .font(.caption.weight(.medium))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            viewModel.selectedFilter == filter
                                ? AppTheme.primary
                                : Color(.systemGray5)
                        )
                        .foregroundStyle(
                            viewModel.selectedFilter == filter
                                ? .white
                                : .secondary
                        )
                        .clipShape(Capsule())
                }
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGray6).opacity(0.5))
    }

    // MARK: - History List

    private var historyList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(filteredHistories) { history in
                    HistoryItemRow(history: history, viewModel: viewModel)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onRestore?(history)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.deleteHistory(history, context: modelContext)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }

                    Divider()
                        .padding(.leading, 80)
                }
            }

            // End of list
            Text("これより前の履歴はありません")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.vertical, 32)
        }
    }

    // MARK: - Empty State

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
