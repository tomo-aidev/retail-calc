import Foundation
import SwiftData

@MainActor
@Observable
final class CalculatorViewModel {
    var state = CalculationState()
    var showPaywallSheet = false
    var showSavedFeedback = false

    private var modelContext: ModelContext?
    private let usageLimiter = UsageLimiter.shared

    var isLimitReached: Bool { usageLimiter.isLimitReached }
    var showPaywall: Bool {
        get { usageLimiter.showPaywall }
        set { usageLimiter.showPaywall = newValue }
    }
    var remainingCount: Int { usageLimiter.remainingCount }
    var todayUsageCount: Int { usageLimiter.todayUsageCount }

    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    // MARK: - Keypad Actions

    func tapDigit(_ digit: String) {
        if state.inputPrice == 0 && digit != "0" {
            guard usageLimiter.canUse() else {
                showPaywallSheet = true
                return
            }
        }
        state.appendDigit(digit)
    }

    func tapDoubleZero() {
        if state.inputPrice == 0 {
            guard usageLimiter.canUse() else {
                showPaywallSheet = true
                return
            }
        }
        state.appendDoubleZero()
    }

    func tapBackspace() {
        state.deleteLastDigit()
    }

    func tapClear() {
        state.clear()
        usageLimiter.recordUsage()
    }

    // MARK: - Tax Actions

    func setTaxRate(_ rate: TaxRate) {
        state.taxRate = rate
    }

    func setTaxMethod(_ method: TaxMethod) {
        state.taxMethod = method
    }

    // MARK: - Discount Actions

    func applyPercentageDiscount(_ percentage: Int) {
        state.setDiscount(.percentage(percentage))
    }

    func clearDiscounts() {
        state.clearDiscounts()
    }

    // MARK: - History（手動保存のみ）

    func saveToHistory() {
        guard let modelContext, state.inputPrice > 0 else {
            print("[Calculator] 保存スキップ: modelContext=\(modelContext != nil), inputPrice=\(state.inputPrice)")
            return
        }
        let result = state.result
        print("[Calculator] 保存開始:")
        print("  入力金額: ¥\(result.inputPrice)")
        print("  割引額: ¥\(result.totalDiscount)")
        print("  割引後: ¥\(result.priceAfterDiscount)")
        print("  税額: ¥\(result.taxAmount) (\(result.taxRate.label), \(result.taxMethod == .exclusive ? "税抜" : "税込"))")
        print("  最終金額: ¥\(result.finalPrice)")

        let history = CalculationHistory(
            inputPrice: result.inputPrice,
            finalPrice: result.finalPrice,
            priceAfterDiscount: result.priceAfterDiscount,
            taxAmount: result.taxAmount,
            totalDiscount: result.totalDiscount,
            taxRate: result.taxRate,
            taxMethod: result.taxMethod,
            discounts: result.discounts
        )
        modelContext.insert(history)
        try? modelContext.save()
        showSavedFeedback = true
        print("[Calculator] 履歴保存完了")
    }

    func restoreFromHistory(_ history: CalculationHistory) {
        state.restore(from: history)
    }
}
