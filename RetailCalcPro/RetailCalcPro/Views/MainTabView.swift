import SwiftUI

struct MainTabView: View {
    @State private var calculatorVM = CalculatorViewModel()
    @State private var showHistory = false
    @State private var showSettings = false

    var body: some View {
        CalculatorView(
            viewModel: calculatorVM,
            onShowHistory: { showHistory = true },
            onShowSettings: { showSettings = true }
        )
        .sheet(isPresented: $showHistory) {
            NavigationStack {
                HistoryView { history in
                    calculatorVM.restoreFromHistory(history)
                    showHistory = false
                }
                .navigationTitle("履歴")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("閉じる") {
                            showHistory = false
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                SettingsView()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("閉じる") {
                                showSettings = false
                            }
                        }
                    }
            }
        }
    }
}
