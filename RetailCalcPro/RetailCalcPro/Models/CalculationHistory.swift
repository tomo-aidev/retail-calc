import Foundation
import SwiftData

@Model
final class CalculationHistory {
    var inputPrice: Int
    var finalPrice: Int
    var priceAfterDiscount: Int
    var taxAmount: Int
    var totalDiscount: Int
    var taxRateValue: Int // TaxRate raw value
    var taxMethodRaw: String // TaxMethod raw value
    var discountsData: Data? // Encoded [DiscountType]
    var createdAt: Date
    var note: String

    init(
        inputPrice: Int,
        finalPrice: Int,
        priceAfterDiscount: Int,
        taxAmount: Int,
        totalDiscount: Int,
        taxRate: TaxRate,
        taxMethod: TaxMethod,
        discounts: [DiscountType],
        createdAt: Date = .now,
        note: String = ""
    ) {
        self.inputPrice = inputPrice
        self.finalPrice = finalPrice
        self.priceAfterDiscount = priceAfterDiscount
        self.taxAmount = taxAmount
        self.totalDiscount = totalDiscount
        self.taxRateValue = taxRate.rawValue
        self.taxMethodRaw = taxMethod.rawValue
        self.discountsData = try? JSONEncoder().encode(discounts)
        self.createdAt = createdAt
        self.note = note
    }

    var taxRate: TaxRate {
        TaxRate(rawValue: taxRateValue) ?? .standard
    }

    var taxMethod: TaxMethod {
        TaxMethod(rawValue: taxMethodRaw) ?? .exclusive
    }

    var discounts: [DiscountType] {
        guard let data = discountsData else { return [] }
        return (try? JSONDecoder().decode([DiscountType].self, from: data)) ?? []
    }

    /// 履歴のカテゴリラベル
    var categoryLabel: String {
        if !discounts.isEmpty && taxAmount > 0 {
            // 割引 + 税
            let discountLabels = discounts.map(\.shortLabel).joined(separator: "+")
            return "割引 \(discountLabels) + 消費税 \(taxRate.label)"
        } else if !discounts.isEmpty {
            let discountLabels = discounts.map(\.shortLabel).joined(separator: "+")
            return "割引 \(discountLabels)"
        } else if taxAmount > 0 {
            return "消費税 \(taxRate.label)"
        } else {
            return "変更なし"
        }
    }

    /// 履歴の種別
    enum Category {
        case taxOnly
        case discountOnly
        case both
        case none
    }

    var category: Category {
        let hasDiscount = !discounts.isEmpty
        let hasTax = taxAmount > 0
        if hasDiscount && hasTax { return .both }
        if hasDiscount { return .discountOnly }
        if hasTax { return .taxOnly }
        return .none
    }
}
