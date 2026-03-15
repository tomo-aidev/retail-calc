import SwiftUI
import SwiftData

@main
struct RetailCalcProApp: App {
    @State private var showSplash = true
    private let settings = AppSettings.shared

    var body: some Scene {
        WindowGroup {
            ZStack {
                MainTabView()
                    .opacity(showSplash ? 0 : 1)
                    .preferredColorScheme(settings.darkModeEnabled ? .dark : .light)

                if showSplash {
                    SplashView(showSplash: $showSplash)
                        .transition(.opacity)
                }
            }
        }
        .modelContainer(for: CalculationHistory.self)
    }
}
