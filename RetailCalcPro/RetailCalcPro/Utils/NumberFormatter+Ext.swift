import Foundation

extension Int {
    /// 金額を日本円フォーマットで表示（例: ¥1,000）
    var yenFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        let formatted = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return "¥\(formatted)"
    }

    /// カンマ区切り表示（例: 1,000）
    var commaFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
