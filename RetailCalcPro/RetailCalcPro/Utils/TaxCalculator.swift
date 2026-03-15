import Foundation

/// 税・割引計算エンジン
/// 端数処理: 全て切り捨て（floor）
enum TaxCalculator {

    // MARK: - Tax Calculation

    /// 外税計算: 税抜金額から税込金額を算出
    /// 整数演算で浮動小数点誤差を回避
    /// - Parameters:
    ///   - price: 税抜金額（整数）
    ///   - taxRate: 税率（例: 0.10）
    /// - Returns: (税込金額, 税額)
    static func calculateExclusive(price: Int, taxRate: Double) -> (total: Int, tax: Int) {
        let taxRatePercent = Int(round(taxRate * 100))
        // 整数演算: price * taxRatePercent / 100（整数除算 = 切り捨て）
        let tax = price * taxRatePercent / 100
        return (price + tax, tax)
    }

    /// 内税計算: 税込金額から税抜金額を算出
    /// 整数演算で浮動小数点誤差を回避
    /// - Parameters:
    ///   - totalPrice: 税込金額（整数）
    ///   - taxRate: 税率（例: 0.10）
    /// - Returns: (税抜金額, 税額)
    static func calculateInclusive(totalPrice: Int, taxRate: Double) -> (priceWithoutTax: Int, tax: Int) {
        let taxRatePercent = Int(round(taxRate * 100))
        // 整数演算: tax = totalPrice * taxRatePercent / (100 + taxRatePercent)
        // 整数除算は自動的に切り捨て（正数の場合）
        let tax = totalPrice * taxRatePercent / (100 + taxRatePercent)
        let priceWithoutTax = totalPrice - tax
        return (priceWithoutTax, tax)
    }

    // MARK: - Discount Calculation

    /// パーセント割引を適用
    /// - Parameters:
    ///   - price: 元の金額
    ///   - percentage: 割引率（例: 10 → 10%引き）
    /// - Returns: (割引後金額, 割引額)
    static func applyPercentageDiscount(price: Int, percentage: Int) -> (discountedPrice: Int, discountAmount: Int) {
        // 整数演算: price * percentage / 100（切り捨て）
        let discountAmount = price * percentage / 100
        return (price - discountAmount, discountAmount)
    }

    /// 円引き割引を適用
    /// - Parameters:
    ///   - price: 元の金額
    ///   - amount: 割引額（円）
    /// - Returns: (割引後金額, 割引額)
    static func applyAmountDiscount(price: Int, amount: Int) -> (discountedPrice: Int, discountAmount: Int) {
        let actualDiscount = min(amount, price) // 元金額を超えない
        return (price - actualDiscount, actualDiscount)
    }

    /// 複数割引をスタック適用
    /// - Parameters:
    ///   - price: 元の金額
    ///   - discounts: 適用する割引のリスト（順番に適用）
    /// - Returns: (最終金額, 合計割引額)
    static func applyDiscounts(price: Int, discounts: [DiscountType]) -> (finalPrice: Int, totalDiscount: Int) {
        var currentPrice = price
        var totalDiscount = 0

        for discount in discounts {
            switch discount {
            case .percentage(let pct):
                let result = applyPercentageDiscount(price: currentPrice, percentage: pct)
                currentPrice = result.discountedPrice
                totalDiscount += result.discountAmount
            case .amount(let amt):
                let result = applyAmountDiscount(price: currentPrice, amount: amt)
                currentPrice = result.discountedPrice
                totalDiscount += result.discountAmount
            }
        }

        return (max(currentPrice, 0), totalDiscount)
    }

    // MARK: - Full Calculation

    struct CalculationResult {
        let inputPrice: Int
        let priceAfterDiscount: Int
        let totalDiscount: Int
        let taxAmount: Int
        let finalPrice: Int
        let taxRate: TaxRate
        let taxMethod: TaxMethod
        let discounts: [DiscountType]
    }

    /// 完全な計算を実行（割引 → 税計算の順）
    /// - Parameters:
    ///   - inputPrice: 入力金額
    ///   - taxRate: 税率
    ///   - taxMethod: 外税/内税
    ///   - discounts: 適用割引リスト
    /// - Returns: 計算結果
    static func calculate(
        inputPrice: Int,
        taxRate: TaxRate,
        taxMethod: TaxMethod,
        discounts: [DiscountType]
    ) -> CalculationResult {
        guard inputPrice > 0 else {
            return CalculationResult(
                inputPrice: 0,
                priceAfterDiscount: 0,
                totalDiscount: 0,
                taxAmount: 0,
                finalPrice: 0,
                taxRate: taxRate,
                taxMethod: taxMethod,
                discounts: discounts
            )
        }

        // Step 1: 割引を適用
        let discountResult = applyDiscounts(price: inputPrice, discounts: discounts)
        let priceAfterDiscount = discountResult.finalPrice

        // Step 2: 税計算
        let taxAmount: Int
        let finalPrice: Int

        switch taxMethod {
        case .exclusive:
            // 外税: 割引後金額に税を加算
            let taxResult = calculateExclusive(price: priceAfterDiscount, taxRate: taxRate.rate)
            taxAmount = taxResult.tax
            finalPrice = taxResult.total
        case .inclusive:
            // 内税: 入力金額が税込 → 割引後金額から税額を逆算
            let taxResult = calculateInclusive(totalPrice: priceAfterDiscount, taxRate: taxRate.rate)
            taxAmount = taxResult.tax
            finalPrice = priceAfterDiscount // 内税の場合、表示金額＝入力金額（割引後）
        }

        return CalculationResult(
            inputPrice: inputPrice,
            priceAfterDiscount: priceAfterDiscount,
            totalDiscount: discountResult.totalDiscount,
            taxAmount: taxAmount,
            finalPrice: finalPrice,
            taxRate: taxRate,
            taxMethod: taxMethod,
            discounts: discounts
        )
    }
}
