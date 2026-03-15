import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var calculatorVM = CalculatorViewModel()

    var body: some View {
        TabView(selection: $selectedTab) {
            // Calculator Tab
            CalculatorView(viewModel: calculatorVM)
                .tabItem {
                    Image(systemName: "plus.forwardslash.minus")
                    Text("電卓")
                }
                .tag(0)

            // History Tab
            HistoryView { history in
                calculatorVM.restoreFromHistory(history)
                selectedTab = 0
            }
            .tabItem {
                Image(systemName: "clock.arrow.circlepath")
                Text("履歴")
            }
            .tag(1)

            // Settings Tab
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("設定")
                }
                .tag(2)
        }
        .tint(AppTheme.primary)
    }
}
