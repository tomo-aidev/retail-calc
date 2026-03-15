import Foundation
import SwiftData
import UIKit

@MainActor
@Observable
final class CalculatorViewModel {
    var state = CalculationState()
    var showDiscountPicker = false
    var customDiscountText = ""

    private var modelContext: ModelContext?

    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }

    // MARK: - Keypad Actions

    func tapDigit(_ digit: String) {
        triggerHaptic()
        state.appendDigit(digit)
    }

    func tapDoubleZero() {
        triggerHaptic()
        state.appendDoubleZero()
    }

    func tapBackspace() {
        triggerHaptic()
        state.deleteLastDigit()
    }

    func tapClear() {
        triggerHaptic()
        state.clear()
    }

    func tapAllClear() {
        triggerHaptic()
        state.clearAll()
    }

    // MARK: - Tax Actions

    func setTaxRate(_ rate: TaxRate) {
        triggerHaptic()
        state.taxRate = rate
    }

    func setTaxMethod(_ method: TaxMethod) {
        triggerHaptic()
        state.taxMethod = method
    }

    // MARK: - Discount Actions

    func applyPercentageDiscount(_ percentage: Int) {
        triggerHaptic()
        state.addDiscount(.percentage(percentage))
    }

    func applyAmountDiscount(_ amount: Int) {
        triggerHaptic()
        state.addDiscount(.amount(amount))
    }

    func applyCustomPercentageDiscount() {
        guard let value = Int(customDiscountText), value > 0, value <= 100 else { return }
        triggerHaptic()
        state.addDiscount(.percentage(value))
        customDiscountText = ""
    }

    func clearDiscounts() {
        triggerHaptic()
        state.clearDiscounts()
    }

    // MARK: - History

    func saveToHistory() {
        guard let modelContext, state.inputPrice > 0 else { return }
        let result = state.result
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
    }

    func restoreFromHistory(_ history: CalculationHistory) {
        state.restore(from: history)
    }

    // MARK: - Haptic Feedback

    private func triggerHaptic() {
        let settings = AppSettings.shared
        guard settings.soundEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
