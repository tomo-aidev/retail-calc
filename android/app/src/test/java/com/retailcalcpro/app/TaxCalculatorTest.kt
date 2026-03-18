package com.retailcalcpro.app

import com.retailcalcpro.app.model.*
import com.retailcalcpro.app.util.TaxCalculator
import org.junit.Assert.*
import org.junit.Test

/**
 * 消費税計算エンジンの包括的テスト
 * iOS版29テスト + Android追加エッジケース = 50テスト
 */
class TaxCalculatorTest {

    // ========================================
    // 1. 税抜計算（Exclusive）基本テスト
    // ========================================

    @Test
    fun `税抜_標準税率10%_1000円`() {
        val (total, tax) = TaxCalculator.calculateExclusive(1000, 10)
        assertEquals(100, tax)
        assertEquals(1100, total)
    }

    @Test
    fun `税抜_軽減税率8%_1000円`() {
        val (total, tax) = TaxCalculator.calculateExclusive(1000, 8)
        assertEquals(80, tax)
        assertEquals(1080, total)
    }

    @Test
    fun `税抜_税率0%_1000円`() {
        val (total, tax) = TaxCalculator.calculateExclusive(1000, 0)
        assertEquals(0, tax)
        assertEquals(1000, total)
    }

    @Test
    fun `税抜_標準税率10%_端数切り捨て_99円`() {
        // 99 * 10 / 100 = 9 (整数除算)
        val (total, tax) = TaxCalculator.calculateExclusive(99, 10)
        assertEquals(9, tax)
        assertEquals(108, total)
    }

    @Test
    fun `税抜_軽減税率8%_端数切り捨て_99円`() {
        // 99 * 8 / 100 = 7 (整数除算: 792/100=7)
        val (total, tax) = TaxCalculator.calculateExclusive(99, 8)
        assertEquals(7, tax)
        assertEquals(106, total)
    }

    @Test
    fun `税抜_標準税率10%_1円`() {
        // 1 * 10 / 100 = 0
        val (total, tax) = TaxCalculator.calculateExclusive(1, 10)
        assertEquals(0, tax)
        assertEquals(1, total)
    }

    @Test
    fun `税抜_標準税率10%_0円`() {
        val (total, tax) = TaxCalculator.calculateExclusive(0, 10)
        assertEquals(0, tax)
        assertEquals(0, total)
    }

    @Test
    fun `税抜_標準税率10%_大きな金額_999999円`() {
        val (total, tax) = TaxCalculator.calculateExclusive(999999, 10)
        assertEquals(99999, tax)  // 999999 * 10 / 100 = 99999
        assertEquals(1099998, total)
    }

    // ========================================
    // 2. 税込計算（Inclusive）基本テスト
    // ========================================

    @Test
    fun `税込_標準税率10%_1100円`() {
        val (priceWithoutTax, tax) = TaxCalculator.calculateInclusive(1100, 10)
        assertEquals(100, tax)  // 1100 * 10 / 110 = 100
        assertEquals(1000, priceWithoutTax)
    }

    @Test
    fun `税込_軽減税率8%_1080円`() {
        val (priceWithoutTax, tax) = TaxCalculator.calculateInclusive(1080, 8)
        assertEquals(80, tax)  // 1080 * 8 / 108 = 80
        assertEquals(1000, priceWithoutTax)
    }

    @Test
    fun `税込_税率0%_1000円`() {
        val (priceWithoutTax, tax) = TaxCalculator.calculateInclusive(1000, 0)
        assertEquals(0, tax)
        assertEquals(1000, priceWithoutTax)
    }

    @Test
    fun `税込_標準税率10%_端数切り捨て_999円`() {
        // 999 * 10 / 110 = 90 (9990/110=90)
        val (priceWithoutTax, tax) = TaxCalculator.calculateInclusive(999, 10)
        assertEquals(90, tax)
        assertEquals(909, priceWithoutTax)
    }

    @Test
    fun `税込_軽減税率8%_端数切り捨て_999円`() {
        // 999 * 8 / 108 = 74 (7992/108=74)
        val (priceWithoutTax, tax) = TaxCalculator.calculateInclusive(999, 8)
        assertEquals(74, tax)
        assertEquals(925, priceWithoutTax)
    }

    @Test
    fun `税込_標準税率10%_1円`() {
        // 1 * 10 / 110 = 0
        val (priceWithoutTax, tax) = TaxCalculator.calculateInclusive(1, 10)
        assertEquals(0, tax)
        assertEquals(1, priceWithoutTax)
    }

    @Test
    fun `税込_標準税率10%_0円`() {
        val (priceWithoutTax, tax) = TaxCalculator.calculateInclusive(0, 10)
        assertEquals(0, tax)
        assertEquals(0, priceWithoutTax)
    }

    // ========================================
    // 3. パーセント割引テスト
    // ========================================

    @Test
    fun `割引_10%_1000円`() {
        val (discountedPrice, discountAmount) = TaxCalculator.applyPercentageDiscount(1000, 10)
        assertEquals(100, discountAmount)
        assertEquals(900, discountedPrice)
    }

    @Test
    fun `割引_50%_1000円`() {
        val (discountedPrice, discountAmount) = TaxCalculator.applyPercentageDiscount(1000, 50)
        assertEquals(500, discountAmount)
        assertEquals(500, discountedPrice)
    }

    @Test
    fun `割引_30%_端数切り捨て_999円`() {
        // 999 * 30 / 100 = 299 (29970/100=299)
        val (discountedPrice, discountAmount) = TaxCalculator.applyPercentageDiscount(999, 30)
        assertEquals(299, discountAmount)
        assertEquals(700, discountedPrice)
    }

    @Test
    fun `割引_15%_端数切り捨て_1234円`() {
        // 1234 * 15 / 100 = 185 (18510/100=185)
        val (discountedPrice, discountAmount) = TaxCalculator.applyPercentageDiscount(1234, 15)
        assertEquals(185, discountAmount)
        assertEquals(1049, discountedPrice)
    }

    @Test
    fun `割引_5%_99円_端数切り捨て`() {
        // 99 * 5 / 100 = 4 (495/100=4)
        val (discountedPrice, discountAmount) = TaxCalculator.applyPercentageDiscount(99, 5)
        assertEquals(4, discountAmount)
        assertEquals(95, discountedPrice)
    }

    @Test
    fun `割引_100%_1000円`() {
        val (discountedPrice, discountAmount) = TaxCalculator.applyPercentageDiscount(1000, 100)
        assertEquals(1000, discountAmount)
        assertEquals(0, discountedPrice)
    }

    // ========================================
    // 4. 金額割引テスト
    // ========================================

    @Test
    fun `金額割引_100円引_1000円`() {
        val (discountedPrice, discountAmount) = TaxCalculator.applyAmountDiscount(1000, 100)
        assertEquals(100, discountAmount)
        assertEquals(900, discountedPrice)
    }

    @Test
    fun `金額割引_上限キャップ_1500円引_1000円`() {
        // 割引額が元値を超える場合は元値まで
        val (discountedPrice, discountAmount) = TaxCalculator.applyAmountDiscount(1000, 1500)
        assertEquals(1000, discountAmount)
        assertEquals(0, discountedPrice)
    }

    @Test
    fun `金額割引_同額_500円引_500円`() {
        val (discountedPrice, discountAmount) = TaxCalculator.applyAmountDiscount(500, 500)
        assertEquals(500, discountAmount)
        assertEquals(0, discountedPrice)
    }

    // ========================================
    // 5. 複合テスト: 割引 + 税（メイン計算フロー）
    // ========================================

    @Test
    fun `複合_税抜10%_割引10%_1000円`() {
        // 1000 → 10%割引 → 900 → 10%税 → 税90 → 税込990
        val result = TaxCalculator.calculate(
            inputPrice = 1000,
            taxRate = TaxRate.STANDARD,
            taxMethod = TaxMethod.EXCLUSIVE,
            discounts = listOf(DiscountType.Percentage(10))
        )
        assertEquals(1000, result.inputPrice)
        assertEquals(900, result.priceAfterDiscount)
        assertEquals(100, result.totalDiscount)
        assertEquals(90, result.taxAmount)
        assertEquals(990, result.finalPrice)
    }

    @Test
    fun `複合_税込10%_割引10%_1000円`() {
        // 1000 → 10%割引 → 900 → 税込900から税抽出 → 税81(900*10/110=81)
        val result = TaxCalculator.calculate(
            inputPrice = 1000,
            taxRate = TaxRate.STANDARD,
            taxMethod = TaxMethod.INCLUSIVE,
            discounts = listOf(DiscountType.Percentage(10))
        )
        assertEquals(1000, result.inputPrice)
        assertEquals(900, result.priceAfterDiscount)
        assertEquals(100, result.totalDiscount)
        assertEquals(81, result.taxAmount)  // 900 * 10 / 110 = 81
        assertEquals(900, result.finalPrice)  // 税込 = priceAfterDiscount
    }

    @Test
    fun `複合_税抜8%_割引20%_1500円`() {
        // 1500 → 20%割引 → 1200 → 8%税 → 税96 → 税込1296
        val result = TaxCalculator.calculate(
            inputPrice = 1500,
            taxRate = TaxRate.REDUCED,
            taxMethod = TaxMethod.EXCLUSIVE,
            discounts = listOf(DiscountType.Percentage(20))
        )
        assertEquals(1200, result.priceAfterDiscount)
        assertEquals(300, result.totalDiscount)
        assertEquals(96, result.taxAmount)   // 1200 * 8 / 100 = 96
        assertEquals(1296, result.finalPrice)
    }

    @Test
    fun `複合_税込8%_割引30%_2000円`() {
        // 2000 → 30%割引 → 1400 → 税込1400から税抽出
        val result = TaxCalculator.calculate(
            inputPrice = 2000,
            taxRate = TaxRate.REDUCED,
            taxMethod = TaxMethod.INCLUSIVE,
            discounts = listOf(DiscountType.Percentage(30))
        )
        assertEquals(1400, result.priceAfterDiscount)
        assertEquals(600, result.totalDiscount)
        assertEquals(103, result.taxAmount)   // 1400 * 8 / 108 = 103
        assertEquals(1400, result.finalPrice)
    }

    @Test
    fun `複合_税抜10%_割引なし_1000円`() {
        val result = TaxCalculator.calculate(
            inputPrice = 1000,
            taxRate = TaxRate.STANDARD,
            taxMethod = TaxMethod.EXCLUSIVE,
            discounts = emptyList()
        )
        assertEquals(1000, result.priceAfterDiscount)
        assertEquals(0, result.totalDiscount)
        assertEquals(100, result.taxAmount)
        assertEquals(1100, result.finalPrice)
    }

    @Test
    fun `複合_税率0%_割引10%_1000円`() {
        // 税率0% → 税額0, 割引のみ
        val result = TaxCalculator.calculate(
            inputPrice = 1000,
            taxRate = TaxRate.NONE,
            taxMethod = TaxMethod.EXCLUSIVE,
            discounts = listOf(DiscountType.Percentage(10))
        )
        assertEquals(900, result.priceAfterDiscount)
        assertEquals(0, result.taxAmount)
        assertEquals(900, result.finalPrice)
    }

    // ========================================
    // 6. 端数切り捨ての精度テスト
    // ========================================

    @Test
    fun `端数_税抜10%_33円_税3円`() {
        // 33 * 10 / 100 = 3 (330/100=3)
        val (total, tax) = TaxCalculator.calculateExclusive(33, 10)
        assertEquals(3, tax)
        assertEquals(36, total)
    }

    @Test
    fun `端数_税抜8%_33円_税2円`() {
        // 33 * 8 / 100 = 2 (264/100=2)
        val (total, tax) = TaxCalculator.calculateExclusive(33, 8)
        assertEquals(2, tax)
        assertEquals(35, total)
    }

    @Test
    fun `端数_税込10%_33円_税3円`() {
        // 33 * 10 / 110 = 3 (330/110=3)
        val (priceWithoutTax, tax) = TaxCalculator.calculateInclusive(33, 10)
        assertEquals(3, tax)
        assertEquals(30, priceWithoutTax)
    }

    @Test
    fun `端数_税込8%_33円_税2円`() {
        // 33 * 8 / 108 = 2 (264/108=2)
        val (priceWithoutTax, tax) = TaxCalculator.calculateInclusive(33, 8)
        assertEquals(2, tax)
        assertEquals(31, priceWithoutTax)
    }

    @Test
    fun `端数_割引7%_143円`() {
        // 143 * 7 / 100 = 10 (1001/100=10)
        val (discountedPrice, discountAmount) = TaxCalculator.applyPercentageDiscount(143, 7)
        assertEquals(10, discountAmount)
        assertEquals(133, discountedPrice)
    }

    // ========================================
    // 7. 実務シナリオテスト（スーパー・小売）
    // ========================================

    @Test
    fun `実務_食品_税抜298円_軽減8%`() {
        // 298 * 8 / 100 = 23
        val result = TaxCalculator.calculate(
            inputPrice = 298,
            taxRate = TaxRate.REDUCED,
            taxMethod = TaxMethod.EXCLUSIVE
        )
        assertEquals(23, result.taxAmount)
        assertEquals(321, result.finalPrice)
    }

    @Test
    fun `実務_日用品_税込550円_標準10%`() {
        // 550 * 10 / 110 = 50
        val result = TaxCalculator.calculate(
            inputPrice = 550,
            taxRate = TaxRate.STANDARD,
            taxMethod = TaxMethod.INCLUSIVE
        )
        assertEquals(50, result.taxAmount)
        assertEquals(550, result.finalPrice)
    }

    @Test
    fun `実務_セール品_税抜1980円_20%割引_標準10%`() {
        // 1980 → 20%引 → 1584 → 10%税 → 158 → 税込1742
        val result = TaxCalculator.calculate(
            inputPrice = 1980,
            taxRate = TaxRate.STANDARD,
            taxMethod = TaxMethod.EXCLUSIVE,
            discounts = listOf(DiscountType.Percentage(20))
        )
        assertEquals(396, result.totalDiscount)   // 1980*20/100=396
        assertEquals(1584, result.priceAfterDiscount)
        assertEquals(158, result.taxAmount)        // 1584*10/100=158
        assertEquals(1742, result.finalPrice)
    }

    @Test
    fun `実務_食品セール_税込498円_30%引_軽減8%`() {
        // 498 → 30%引 → 349 → 税込349から税抽出
        val result = TaxCalculator.calculate(
            inputPrice = 498,
            taxRate = TaxRate.REDUCED,
            taxMethod = TaxMethod.INCLUSIVE,
            discounts = listOf(DiscountType.Percentage(30))
        )
        assertEquals(149, result.totalDiscount)   // 498*30/100=149
        assertEquals(349, result.priceAfterDiscount)
        assertEquals(25, result.taxAmount)         // 349*8/108=25
        assertEquals(349, result.finalPrice)
    }

    @Test
    fun `実務_高額商品_税抜19800円_5%割引_標準10%`() {
        // 19800 → 5%引 → 18810 → 10%税 → 1881 → 20691
        val result = TaxCalculator.calculate(
            inputPrice = 19800,
            taxRate = TaxRate.STANDARD,
            taxMethod = TaxMethod.EXCLUSIVE,
            discounts = listOf(DiscountType.Percentage(5))
        )
        assertEquals(990, result.totalDiscount)
        assertEquals(18810, result.priceAfterDiscount)
        assertEquals(1881, result.taxAmount)
        assertEquals(20691, result.finalPrice)
    }

    @Test
    fun `実務_閉店セール_税抜3980円_50%割引_標準10%`() {
        // 3980 → 50%引 → 1990 → 10%税 → 199 → 2189
        val result = TaxCalculator.calculate(
            inputPrice = 3980,
            taxRate = TaxRate.STANDARD,
            taxMethod = TaxMethod.EXCLUSIVE,
            discounts = listOf(DiscountType.Percentage(50))
        )
        assertEquals(1990, result.totalDiscount)
        assertEquals(1990, result.priceAfterDiscount)
        assertEquals(199, result.taxAmount)
        assertEquals(2189, result.finalPrice)
    }

    // ========================================
    // 8. エッジケース・境界値テスト
    // ========================================

    @Test
    fun `境界値_入力0円_割引あり`() {
        val result = TaxCalculator.calculate(
            inputPrice = 0,
            taxRate = TaxRate.STANDARD,
            taxMethod = TaxMethod.EXCLUSIVE,
            discounts = listOf(DiscountType.Percentage(10))
        )
        assertEquals(0, result.finalPrice)
        assertEquals(0, result.taxAmount)
        assertEquals(0, result.totalDiscount)
    }

    @Test
    fun `境界値_入力1円_税抜10%`() {
        val result = TaxCalculator.calculate(
            inputPrice = 1,
            taxRate = TaxRate.STANDARD,
            taxMethod = TaxMethod.EXCLUSIVE
        )
        assertEquals(0, result.taxAmount)  // 1*10/100=0
        assertEquals(1, result.finalPrice)
    }

    @Test
    fun `境界値_入力9円_税抜10%_税が初めて発生する`() {
        // 9 * 10 / 100 = 0 (まだ発生しない)
        val result9 = TaxCalculator.calculate(
            inputPrice = 9,
            taxRate = TaxRate.STANDARD,
            taxMethod = TaxMethod.EXCLUSIVE
        )
        assertEquals(0, result9.taxAmount)

        // 10 * 10 / 100 = 1 (ここで初めて1円発生)
        val result10 = TaxCalculator.calculate(
            inputPrice = 10,
            taxRate = TaxRate.STANDARD,
            taxMethod = TaxMethod.EXCLUSIVE
        )
        assertEquals(1, result10.taxAmount)
        assertEquals(11, result10.finalPrice)
    }

    @Test
    fun `境界値_最大10桁_9999999999は範囲外確認`() {
        // Int.MAX_VALUE = 2,147,483,647 → 10桁まで安全に計算
        val result = TaxCalculator.calculate(
            inputPrice = 999999999,  // 9桁
            taxRate = TaxRate.STANDARD,
            taxMethod = TaxMethod.EXCLUSIVE
        )
        assertEquals(99999999, result.taxAmount)
        assertEquals(1099999998, result.finalPrice)
    }

    @Test
    fun `iOS互換_税抜10%_1700円_割引10%`() {
        // iOS版の履歴表示テストケースと同じ
        // 1700 → 10%引 → 1530 → 10%税 → 153 → 税込1683
        val result = TaxCalculator.calculate(
            inputPrice = 1700,
            taxRate = TaxRate.STANDARD,
            taxMethod = TaxMethod.EXCLUSIVE,
            discounts = listOf(DiscountType.Percentage(10))
        )
        assertEquals(170, result.totalDiscount)
        assertEquals(1530, result.priceAfterDiscount)
        assertEquals(153, result.taxAmount)
        assertEquals(1683, result.finalPrice)
    }

    @Test
    fun `iOS互換_税込10%_1700円_割引30%`() {
        // 1700 → 30%引 → 1190 → 税込1190から税抽出
        val result = TaxCalculator.calculate(
            inputPrice = 1700,
            taxRate = TaxRate.STANDARD,
            taxMethod = TaxMethod.INCLUSIVE,
            discounts = listOf(DiscountType.Percentage(30))
        )
        assertEquals(510, result.totalDiscount)   // 1700*30/100=510
        assertEquals(1190, result.priceAfterDiscount)
        assertEquals(108, result.taxAmount)        // 1190*10/110=108
        assertEquals(1190, result.finalPrice)
    }

    // ========================================
    // 9. CalculationResult整合性テスト
    // ========================================

    @Test
    fun `結果整合性_税抜_finalPrice = priceAfterDiscount + taxAmount`() {
        val testCases = listOf(
            Triple(1000, TaxRate.STANDARD, 10),
            Triple(2500, TaxRate.REDUCED, 20),
            Triple(777, TaxRate.STANDARD, 15),
            Triple(12345, TaxRate.REDUCED, 40),
        )
        for ((price, rate, discount) in testCases) {
            val result = TaxCalculator.calculate(
                inputPrice = price,
                taxRate = rate,
                taxMethod = TaxMethod.EXCLUSIVE,
                discounts = listOf(DiscountType.Percentage(discount))
            )
            assertEquals(
                "price=$price, rate=$rate, discount=$discount",
                result.priceAfterDiscount + result.taxAmount,
                result.finalPrice
            )
        }
    }

    @Test
    fun `結果整合性_税込_finalPrice = priceAfterDiscount`() {
        val testCases = listOf(
            Triple(1000, TaxRate.STANDARD, 10),
            Triple(2500, TaxRate.REDUCED, 20),
            Triple(777, TaxRate.STANDARD, 0),
        )
        for ((price, rate, discount) in testCases) {
            val discounts = if (discount > 0) listOf(DiscountType.Percentage(discount)) else emptyList()
            val result = TaxCalculator.calculate(
                inputPrice = price,
                taxRate = rate,
                taxMethod = TaxMethod.INCLUSIVE,
                discounts = discounts
            )
            assertEquals(
                "price=$price, rate=$rate, discount=$discount",
                result.priceAfterDiscount,
                result.finalPrice
            )
        }
    }
}
