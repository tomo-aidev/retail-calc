package com.retailcalcpro.app

import com.retailcalcpro.app.model.*
import com.retailcalcpro.app.viewmodel.CalculatorViewModel
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test

/**
 * CalculatorViewModelの入力操作テスト
 */
class CalculatorViewModelTest {

    private lateinit var vm: CalculatorViewModel

    @Before
    fun setup() {
        vm = CalculatorViewModel()
    }

    // ========================================
    // 1. 数字入力テスト
    // ========================================

    @Test
    fun `初期状態は0`() {
        assertEquals("0", vm.inputText)
        assertEquals(0, vm.inputPrice)
    }

    @Test
    fun `数字1を入力`() {
        vm.appendDigit("1")
        assertEquals("1", vm.inputText)
        assertEquals(1, vm.inputPrice)
    }

    @Test
    fun `複数桁入力_123`() {
        vm.appendDigit("1")
        vm.appendDigit("2")
        vm.appendDigit("3")
        assertEquals("123", vm.inputText)
        assertEquals(123, vm.inputPrice)
    }

    @Test
    fun `先頭0は置換される`() {
        // 初期"0"の状態で"5"を入力 → "5"になる（"05"にならない）
        vm.appendDigit("5")
        assertEquals("5", vm.inputText)
    }

    @Test
    fun `先頭0に0を入力しても0のまま`() {
        vm.appendDigit("0")
        assertEquals("0", vm.inputText)
    }

    @Test
    fun `10桁制限`() {
        repeat(10) { vm.appendDigit("1") }
        assertEquals("1111111111", vm.inputText)
        assertEquals(10, vm.inputText.length)
        // 11桁目は無視
        vm.appendDigit("2")
        assertEquals("1111111111", vm.inputText)
    }

    // ========================================
    // 2. ダブルゼロ入力テスト
    // ========================================

    @Test
    fun `00入力_初期0の場合は無視`() {
        vm.appendDoubleZero()
        assertEquals("0", vm.inputText)
    }

    @Test
    fun `00入力_1の後に00`() {
        vm.appendDigit("1")
        vm.appendDoubleZero()
        assertEquals("100", vm.inputText)
    }

    @Test
    fun `00入力_9桁制限`() {
        // 9桁以上の場合は00を追加しない
        repeat(9) { vm.appendDigit("1") }
        assertEquals(9, vm.inputText.length)
        vm.appendDoubleZero()
        assertEquals(9, vm.inputText.length) // 変わらない
    }

    // ========================================
    // 3. 削除・クリアテスト
    // ========================================

    @Test
    fun `バックスペース_末尾削除`() {
        vm.appendDigit("1")
        vm.appendDigit("2")
        vm.appendDigit("3")
        vm.deleteLastDigit()
        assertEquals("12", vm.inputText)
    }

    @Test
    fun `バックスペース_1桁の場合は0に`() {
        vm.appendDigit("5")
        vm.deleteLastDigit()
        assertEquals("0", vm.inputText)
    }

    @Test
    fun `クリア_0にリセット`() {
        vm.appendDigit("9")
        vm.appendDigit("9")
        vm.appendDigit("9")
        vm.clear()
        assertEquals("0", vm.inputText)
    }

    // ========================================
    // 4. 税率・税方式変更テスト
    // ========================================

    @Test
    fun `初期税率は標準10%`() {
        assertEquals(TaxRate.STANDARD, vm.taxRate)
    }

    @Test
    fun `税率を軽減8%に変更`() {
        vm.updateTaxRate(TaxRate.REDUCED)
        assertEquals(TaxRate.REDUCED, vm.taxRate)
    }

    @Test
    fun `初期税方式は税抜`() {
        assertEquals(TaxMethod.EXCLUSIVE, vm.taxMethod)
    }

    @Test
    fun `税方式を税込に変更`() {
        vm.updateTaxMethod(TaxMethod.INCLUSIVE)
        assertEquals(TaxMethod.INCLUSIVE, vm.taxMethod)
    }

    // ========================================
    // 5. 割引テスト
    // ========================================

    @Test
    fun `初期割引なし`() {
        assertTrue(vm.appliedDiscounts.isEmpty())
    }

    @Test
    fun `10%割引適用`() {
        vm.applyPercentageDiscount(10)
        assertEquals(1, vm.appliedDiscounts.size)
        assertEquals(DiscountType.Percentage(10), vm.appliedDiscounts.first())
    }

    @Test
    fun `割引は上書きされる`() {
        vm.applyPercentageDiscount(10)
        vm.applyPercentageDiscount(20)
        assertEquals(1, vm.appliedDiscounts.size)
        assertEquals(DiscountType.Percentage(20), vm.appliedDiscounts.first())
    }

    @Test
    fun `割引クリア`() {
        vm.applyPercentageDiscount(10)
        vm.clearDiscounts()
        assertTrue(vm.appliedDiscounts.isEmpty())
    }

    // ========================================
    // 6. 結果連動テスト
    // ========================================

    @Test
    fun `入力1000_税抜10%_結果が正しい`() {
        vm.appendDigit("1")
        vm.appendDigit("0")
        vm.appendDigit("0")
        vm.appendDigit("0")
        val result = vm.result
        assertEquals(1000, result.inputPrice)
        assertEquals(100, result.taxAmount)
        assertEquals(1100, result.finalPrice)
    }

    @Test
    fun `入力1000_税込10%_結果が正しい`() {
        vm.appendDigit("1")
        vm.appendDigit("0")
        vm.appendDigit("0")
        vm.appendDigit("0")
        vm.updateTaxMethod(TaxMethod.INCLUSIVE)
        val result = vm.result
        assertEquals(1000, result.inputPrice)
        assertEquals(90, result.taxAmount)   // 1000*10/110=90
        assertEquals(1000, result.finalPrice)
    }

    @Test
    fun `入力1000_20%割引_税抜10%_結果連動`() {
        vm.appendDigit("1")
        vm.appendDigit("0")
        vm.appendDigit("0")
        vm.appendDigit("0")
        vm.applyPercentageDiscount(20)
        val result = vm.result
        assertEquals(800, result.priceAfterDiscount)
        assertEquals(200, result.totalDiscount)
        assertEquals(80, result.taxAmount)
        assertEquals(880, result.finalPrice)
    }

    @Test
    fun `税率変更で結果がリアルタイム更新`() {
        vm.appendDigit("1")
        vm.appendDigit("0")
        vm.appendDigit("0")
        vm.appendDigit("0")

        assertEquals(100, vm.result.taxAmount)  // 10%

        vm.updateTaxRate(TaxRate.REDUCED)
        assertEquals(80, vm.result.taxAmount)   // 8%

        vm.updateTaxRate(TaxRate.NONE)
        assertEquals(0, vm.result.taxAmount)    // 0%
    }
}
