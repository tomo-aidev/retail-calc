import Foundation

enum TaxRate: Int, CaseIterable, Codable {
    case standard = 10
    case reduced = 8
    case none = 0

    var label: String {
        switch self {
        case .standard: return "10%"
        case .reduced: return "8%(軽減)"
        case .none: return "0%"
        }
    }

    var rate: Double {
        Double(rawValue) / 100.0
    }
}

enum TaxMethod: String, CaseIterable, Codable {
    case exclusive = "exclusive" // 外税（税抜表示）
    case inclusive = "inclusive" // 内税（税込表示）

    var label: String {
        switch self {
        case .exclusive: return "税抜表示"
        case .inclusive: return "税込表示"
        }
    }
}
