import Foundation
import SwiftUI

/// アプリ設定（UserDefaults ベース）
@MainActor
@Observable
final class AppSettings: Sendable {
    static let shared = AppSettings()

    var defaultTaxRate: TaxRate {
        didSet { UserDefaults.standard.set(defaultTaxRate.rawValue, forKey: "defaultTaxRate") }
    }

    var defaultTaxMethod: TaxMethod {
        didSet { UserDefaults.standard.set(defaultTaxMethod.rawValue, forKey: "defaultTaxMethod") }
    }

    var darkModeEnabled: Bool {
        didSet { UserDefaults.standard.set(darkModeEnabled, forKey: "darkModeEnabled") }
    }

    var soundEnabled: Bool {
        didSet { UserDefaults.standard.set(soundEnabled, forKey: "soundEnabled") }
    }

    var customDiscountPercentages: [Int] {
        didSet { UserDefaults.standard.set(customDiscountPercentages, forKey: "customDiscountPercentages") }
    }

    var customDiscountAmounts: [Int] {
        didSet { UserDefaults.standard.set(customDiscountAmounts, forKey: "customDiscountAmounts") }
    }

    var standardTaxRateValue: Int {
        didSet { UserDefaults.standard.set(standardTaxRateValue, forKey: "standardTaxRateValue") }
    }

    var reducedTaxRateValue: Int {
        didSet { UserDefaults.standard.set(reducedTaxRateValue, forKey: "reducedTaxRateValue") }
    }

    private init() {
        let defaults = UserDefaults.standard

        if let rate = TaxRate(rawValue: defaults.integer(forKey: "defaultTaxRate")) {
            self.defaultTaxRate = rate
        } else {
            self.defaultTaxRate = .standard
        }

        if let method = TaxMethod(rawValue: defaults.string(forKey: "defaultTaxMethod") ?? "") {
            self.defaultTaxMethod = method
        } else {
            self.defaultTaxMethod = .exclusive
        }

        self.darkModeEnabled = defaults.object(forKey: "darkModeEnabled") != nil
            ? defaults.bool(forKey: "darkModeEnabled")
            : false

        self.soundEnabled = defaults.object(forKey: "soundEnabled") != nil
            ? defaults.bool(forKey: "soundEnabled")
            : true

        let savedPercentages = defaults.array(forKey: "customDiscountPercentages") as? [Int]
        self.customDiscountPercentages = savedPercentages ?? [5, 10, 15, 30]

        let savedAmounts = defaults.array(forKey: "customDiscountAmounts") as? [Int]
        self.customDiscountAmounts = savedAmounts ?? [100, 200, 500, 1000]

        self.standardTaxRateValue = defaults.object(forKey: "standardTaxRateValue") != nil
            ? defaults.integer(forKey: "standardTaxRateValue")
            : 10

        self.reducedTaxRateValue = defaults.object(forKey: "reducedTaxRateValue") != nil
            ? defaults.integer(forKey: "reducedTaxRateValue")
            : 8
    }
}
