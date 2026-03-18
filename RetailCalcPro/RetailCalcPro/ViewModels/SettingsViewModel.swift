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

    var customDiscountPercentages: [Int] {
        didSet { UserDefaults.standard.set(customDiscountPercentages, forKey: "customDiscountPercentages") }
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

        let savedPercentages = defaults.array(forKey: "customDiscountPercentages") as? [Int]
        self.customDiscountPercentages = savedPercentages ?? [5, 10, 15, 20, 30, 40, 50, 60, 70]

        self.standardTaxRateValue = defaults.object(forKey: "standardTaxRateValue") != nil
            ? defaults.integer(forKey: "standardTaxRateValue")
            : 10

        self.reducedTaxRateValue = defaults.object(forKey: "reducedTaxRateValue") != nil
            ? defaults.integer(forKey: "reducedTaxRateValue")
            : 8
    }
}
