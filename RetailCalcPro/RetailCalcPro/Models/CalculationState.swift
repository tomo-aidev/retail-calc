import Foundation

/// 電卓画面の入力状態を保持
@MainActor
@Observable
final class CalculationState {
    var inputText: String = "0"
    var taxRate: TaxRate = .standard
    var taxMethod: TaxMethod = .exclusive
    var appliedDiscounts: [DiscountType] = []

    var inputPrice: Int {
        Int(inputText) ?? 0
    }

    var result: TaxCalculator.CalculationResult {
        TaxCalculator.calculate(
            inputPrice: inputPrice,
            taxRate: taxRate,
            taxMethod: taxMethod,
            discounts: appliedDiscounts
        )
    }

    func reset() {
        inputText = "0"
        appliedDiscounts = []
    }

    func appendDigit(_ digit: String) {
        if inputText == "0" {
            if digit == "0" || digit == "00" { return }
            inputText = digit
        } else {
            // 最大10桁制限（99億9999万9999円）
            let newText = inputText + digit
            if newText.count <= 10 {
                inputText = newText
            }
        }
    }

    func appendDoubleZero() {
        appendDigit("00")
    }

    func deleteLastDigit() {
        if inputText.count > 1 {
            inputText = String(inputText.dropLast())
        } else {
            inputText = "0"
        }
    }

    func clear() {
        inputText = "0"
    }

    func clearAll() {
        reset()
    }

    func addDiscount(_ discount: DiscountType) {
        appliedDiscounts.append(discount)
    }

    func removeLastDiscount() {
        if !appliedDiscounts.isEmpty {
            appliedDiscounts.removeLast()
        }
    }

    func clearDiscounts() {
        appliedDiscounts = []
    }

    /// 履歴から状態を復元
    func restore(from history: CalculationHistory) {
        inputText = String(history.inputPrice)
        taxRate = history.taxRate
        taxMethod = history.taxMethod
        appliedDiscounts = history.discounts
    }
}
