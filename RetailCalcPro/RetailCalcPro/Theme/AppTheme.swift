import SwiftUI

enum AppTheme {
    // 税抜モード（青系）
    static let exclusivePrimary = Color(red: 0, green: 0.337, blue: 0.698)
    static let exclusiveBg = Color(red: 0.93, green: 0.95, blue: 0.98)
    static let exclusiveBgDark = Color(red: 0.06, green: 0.10, blue: 0.18)

    // 税込モード（暖色系）
    static let inclusivePrimary = Color(red: 0.85, green: 0.35, blue: 0.15)
    static let inclusiveBg = Color(red: 0.99, green: 0.95, blue: 0.92)
    static let inclusiveBgDark = Color(red: 0.18, green: 0.10, blue: 0.06)

    // キーパッド共通色（モード不変）
    static let keypadDark = Color(red: 0.22, green: 0.22, blue: 0.23)
    static let keypadGray = Color(red: 0.65, green: 0.65, blue: 0.65)
    static let keypadOperator = Color(red: 0.38, green: 0.38, blue: 0.42)

    static let primary = exclusivePrimary

    static func accentColor(for method: TaxMethod) -> Color {
        method == .exclusive ? exclusivePrimary : inclusivePrimary
    }

    static func backgroundColor(for method: TaxMethod) -> Color {
        method == .exclusive ? exclusiveBg : inclusiveBg
    }

    static func backgroundColorDark(for method: TaxMethod) -> Color {
        method == .exclusive ? exclusiveBgDark : inclusiveBgDark
    }
}
