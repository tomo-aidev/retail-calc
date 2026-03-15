import Foundation

enum DiscountType: Codable, Equatable, Hashable {
    case percentage(Int) // e.g., 10 means 10% off
    case amount(Int)     // e.g., 100 means 100 yen off

    var label: String {
        switch self {
        case .percentage(let value): return "\(value)%引"
        case .amount(let value): return "\(value)円引"
        }
    }

    var shortLabel: String {
        switch self {
        case .percentage(let value): return "\(value)%"
        case .amount(let value): return "\(value)円"
        }
    }
}
