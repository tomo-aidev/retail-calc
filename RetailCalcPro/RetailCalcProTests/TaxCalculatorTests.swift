import XCTest
@testable import RetailCalcPro

final class TaxCalculatorTests: XCTestCase {

    // MARK: - 外税計算テスト

    func testExclusive10Percent_1000yen() {
        let result = TaxCalculator.calculateExclusive(price: 1000, taxRate: 0.10)
        XCTAssertEqual(result.total, 1100)
        XCTAssertEqual(result.tax, 100)
    }

    func testExclusive8Percent_1000yen() {
        let result = TaxCalculator.calculateExclusive(price: 1000, taxRate: 0.08)
        XCTAssertEqual(result.total, 1080)
        XCTAssertEqual(result.tax, 80)
    }

    func testExclusive10Percent_999yen_floorRounding() {
        // 999 * 0.10 = 99.9 → floor → 99
        let result = TaxCalculator.calculateExclusive(price: 999, taxRate: 0.10)
        XCTAssertEqual(result.tax, 99)
        XCTAssertEqual(result.total, 1098)
    }

    func testExclusive10Percent_1yen() {
        // 1 * 0.10 = 0.1 → floor → 0
        let result = TaxCalculator.calculateExclusive(price: 1, taxRate: 0.10)
        XCTAssertEqual(result.tax, 0)
        XCTAssertEqual(result.total, 1)
    }

    func testExclusive8Percent_105yen() {
        // 105 * 0.08 = 8.4 → floor → 8
        let result = TaxCalculator.calculateExclusive(price: 105, taxRate: 0.08)
        XCTAssertEqual(result.tax, 8)
        XCTAssertEqual(result.total, 113)
    }

    func testExclusive_0yen() {
        let result = TaxCalculator.calculateExclusive(price: 0, taxRate: 0.10)
        XCTAssertEqual(result.tax, 0)
        XCTAssertEqual(result.total, 0)
    }

    func testExclusive10Percent_largeAmount() {
        // 9999999 * 0.10 = 999999.9 → floor → 999999
        let result = TaxCalculator.calculateExclusive(price: 9999999, taxRate: 0.10)
        XCTAssertEqual(result.tax, 999999)
        XCTAssertEqual(result.total, 10999998)
    }

    // MARK: - 内税計算テスト

    func testInclusive8Percent_1080yen() {
        // 税額 = floor(1080 * 0.08 / 1.08) = floor(80.0) = 80
        let result = TaxCalculator.calculateInclusive(totalPrice: 1080, taxRate: 0.08)
        XCTAssertEqual(result.tax, 80)
        XCTAssertEqual(result.priceWithoutTax, 1000)
    }

    func testInclusive10Percent_1100yen() {
        // 税額 = floor(1100 * 0.10 / 1.10) = floor(100.0) = 100
        let result = TaxCalculator.calculateInclusive(totalPrice: 1100, taxRate: 0.10)
        XCTAssertEqual(result.tax, 100)
        XCTAssertEqual(result.priceWithoutTax, 1000)
    }

    func testInclusive10Percent_1098yen() {
        // 税額 = floor(1098 * 0.10 / 1.10) = floor(99.818...) = 99
        let result = TaxCalculator.calculateInclusive(totalPrice: 1098, taxRate: 0.10)
        XCTAssertEqual(result.tax, 99)
        XCTAssertEqual(result.priceWithoutTax, 999)
    }

    func testInclusive8Percent_108yen() {
        // 税額 = floor(108 * 0.08 / 1.08) = floor(8.0) = 8
        let result = TaxCalculator.calculateInclusive(totalPrice: 108, taxRate: 0.08)
        XCTAssertEqual(result.tax, 8)
        XCTAssertEqual(result.priceWithoutTax, 100)
    }

    func testInclusive_0yen() {
        let result = TaxCalculator.calculateInclusive(totalPrice: 0, taxRate: 0.10)
        XCTAssertEqual(result.tax, 0)
        XCTAssertEqual(result.priceWithoutTax, 0)
    }

    // MARK: - パーセント割引テスト

    func testPercentageDiscount_10percent() {
        let result = TaxCalculator.applyPercentageDiscount(price: 1000, percentage: 10)
        XCTAssertEqual(result.discountedPrice, 900)
        XCTAssertEqual(result.discountAmount, 100)
    }

    func testPercentageDiscount_30percent() {
        let result = TaxCalculator.applyPercentageDiscount(price: 1000, percentage: 30)
        XCTAssertEqual(result.discountedPrice, 700)
        XCTAssertEqual(result.discountAmount, 300)
    }

    func testPercentageDiscount_50percent_halfPrice() {
        let result = TaxCalculator.applyPercentageDiscount(price: 30000, percentage: 50)
        XCTAssertEqual(result.discountedPrice, 15000)
        XCTAssertEqual(result.discountAmount, 15000)
    }

    func testPercentageDiscount_floor() {
        // 999 * 0.33 = 329.67 → floor → 329
        let result = TaxCalculator.applyPercentageDiscount(price: 999, percentage: 33)
        XCTAssertEqual(result.discountAmount, 329)
        XCTAssertEqual(result.discountedPrice, 670)
    }

    // MARK: - 円引き割引テスト

    func testAmountDiscount_100yen() {
        let result = TaxCalculator.applyAmountDiscount(price: 1000, amount: 100)
        XCTAssertEqual(result.discountedPrice, 900)
        XCTAssertEqual(result.discountAmount, 100)
    }

    func testAmountDiscount_exceedsPrice() {
        // 割引額が元金額を超えない
        let result = TaxCalculator.applyAmountDiscount(price: 50, amount: 100)
        XCTAssertEqual(result.discountedPrice, 0)
        XCTAssertEqual(result.discountAmount, 50)
    }

    // MARK: - 複数割引スタックテスト

    func testStackedDiscounts_30then10() {
        // 1000 → 30%引き → 700 → 10%引き → floor(700*0.9) = 630
        let result = TaxCalculator.applyDiscounts(
            price: 1000,
            discounts: [.percentage(30), .percentage(10)]
        )
        XCTAssertEqual(result.finalPrice, 630)
        XCTAssertEqual(result.totalDiscount, 370)
    }

    func testStackedDiscounts_percentThenAmount() {
        // 1000 → 20%引き → 800 → 100円引き → 700
        let result = TaxCalculator.applyDiscounts(
            price: 1000,
            discounts: [.percentage(20), .amount(100)]
        )
        XCTAssertEqual(result.finalPrice, 700)
        XCTAssertEqual(result.totalDiscount, 300)
    }

    // MARK: - 完全計算テスト（割引 → 税）

    func testFullCalc_exclusive10_noDiscount() {
        let result = TaxCalculator.calculate(
            inputPrice: 1000, taxRate: .standard, taxMethod: .exclusive, discounts: []
        )
        XCTAssertEqual(result.finalPrice, 1100)
        XCTAssertEqual(result.taxAmount, 100)
        XCTAssertEqual(result.totalDiscount, 0)
    }

    func testFullCalc_exclusive10_10percentDiscount() {
        // 1000 → 10%引き → 900 → +10%税(90) → 990
        let result = TaxCalculator.calculate(
            inputPrice: 1000, taxRate: .standard, taxMethod: .exclusive,
            discounts: [.percentage(10)]
        )
        XCTAssertEqual(result.priceAfterDiscount, 900)
        XCTAssertEqual(result.taxAmount, 90)
        XCTAssertEqual(result.finalPrice, 990)
    }

    func testFullCalc_exclusive10_30plus10percentDiscount() {
        // 1000 → 30%引き → 700 → 10%引き → 630 → +10%税(63) → 693
        let result = TaxCalculator.calculate(
            inputPrice: 1000, taxRate: .standard, taxMethod: .exclusive,
            discounts: [.percentage(30), .percentage(10)]
        )
        XCTAssertEqual(result.priceAfterDiscount, 630)
        XCTAssertEqual(result.taxAmount, 63)
        XCTAssertEqual(result.finalPrice, 693)
    }

    func testFullCalc_exclusive8_noDiscount() {
        let result = TaxCalculator.calculate(
            inputPrice: 1000, taxRate: .reduced, taxMethod: .exclusive, discounts: []
        )
        XCTAssertEqual(result.finalPrice, 1080)
        XCTAssertEqual(result.taxAmount, 80)
    }

    func testFullCalc_inclusive10_noDiscount() {
        // 内税1100 → 税額 = floor(1100*0.10/1.10) = 100, 税抜 = 1000
        let result = TaxCalculator.calculate(
            inputPrice: 1100, taxRate: .standard, taxMethod: .inclusive, discounts: []
        )
        XCTAssertEqual(result.finalPrice, 1100)
        XCTAssertEqual(result.taxAmount, 100)
    }

    func testFullCalc_0yen() {
        let result = TaxCalculator.calculate(
            inputPrice: 0, taxRate: .standard, taxMethod: .exclusive, discounts: []
        )
        XCTAssertEqual(result.finalPrice, 0)
        XCTAssertEqual(result.taxAmount, 0)
    }

    func testFullCalc_999_exclusive10() {
        // 999 → 税額 floor(999*0.10) = floor(99.9) = 99 → 税込 1098
        let result = TaxCalculator.calculate(
            inputPrice: 999, taxRate: .standard, taxMethod: .exclusive, discounts: []
        )
        XCTAssertEqual(result.taxAmount, 99)
        XCTAssertEqual(result.finalPrice, 1098)
    }

    // MARK: - エッジケース

    func testFullCalc_1yen_exclusive10() {
        let result = TaxCalculator.calculate(
            inputPrice: 1, taxRate: .standard, taxMethod: .exclusive, discounts: []
        )
        XCTAssertEqual(result.taxAmount, 0)
        XCTAssertEqual(result.finalPrice, 1)
    }

    func testFullCalc_100percentDiscount() {
        let result = TaxCalculator.calculate(
            inputPrice: 1000, taxRate: .standard, taxMethod: .exclusive,
            discounts: [.percentage(100)]
        )
        XCTAssertEqual(result.finalPrice, 0)
        XCTAssertEqual(result.totalDiscount, 1000)
    }
}
