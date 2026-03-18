package com.retailcalcpro.app.util

import com.retailcalcpro.app.model.*

/**
 * 税計算エンジン
 * iOS版と完全に同じロジック：整数演算で端数切り捨て
 */
object TaxCalculator {

    /**
     * 税抜計算: 税抜価格 → 税込価格
     * tax = price * taxRate / 100 (整数除算 = 切り捨て)
     */
    fun calculateExclusive(price: Int, taxRatePercent: Int): Pair<Int, Int> {
        val tax = (price.toLong() * taxRatePercent / 100).toInt()
        val total = price + tax
        return Pair(total, tax)
    }

    /**
     * 税込計算: 税込価格 → 税抜価格
     * tax = totalPrice * taxRate / (100 + taxRate) (整数除算 = 切り捨て)
     */
    fun calculateInclusive(totalPrice: Int, taxRatePercent: Int): Pair<Int, Int> {
        if (taxRatePercent == 0) return Pair(totalPrice, 0)
        val tax = (totalPrice.toLong() * taxRatePercent / (100 + taxRatePercent)).toInt()
        val priceWithoutTax = totalPrice - tax
        return Pair(priceWithoutTax, tax)
    }

    /**
     * パーセント割引
     * discountAmount = price * percentage / 100 (整数除算 = 切り捨て)
     */
    fun applyPercentageDiscount(price: Int, percentage: Int): Pair<Int, Int> {
        val discountAmount = (price.toLong() * percentage / 100).toInt()
        val discountedPrice = price - discountAmount
        return Pair(discountedPrice, discountAmount)
    }

    /**
     * 金額割引
     */
    fun applyAmountDiscount(price: Int, amount: Int): Pair<Int, Int> {
        val cappedAmount = minOf(amount, price)
        val discountedPrice = price - cappedAmount
        return Pair(discountedPrice, cappedAmount)
    }

    /**
     * 複数割引の適用（順次適用）
     */
    fun applyDiscounts(price: Int, discounts: List<DiscountType>): Pair<Int, Int> {
        var currentPrice = price
        var totalDiscount = 0
        for (discount in discounts) {
            val (newPrice, discountAmount) = when (discount) {
                is DiscountType.Percentage -> applyPercentageDiscount(currentPrice, discount.value)
                is DiscountType.Amount -> applyAmountDiscount(currentPrice, discount.value)
            }
            currentPrice = newPrice
            totalDiscount += discountAmount
        }
        return Pair(currentPrice, totalDiscount)
    }

    /**
     * メイン計算: 割引 → 税計算
     * iOS版と同じ適用順: 割引を先に適用 → 割引後金額に税計算
     */
    fun calculate(
        inputPrice: Int,
        taxRate: TaxRate,
        taxMethod: TaxMethod,
        discounts: List<DiscountType> = emptyList()
    ): CalculationResult {
        // 1. 割引適用
        val (priceAfterDiscount, totalDiscount) = applyDiscounts(inputPrice, discounts)

        // 2. 税計算
        val (finalPrice, taxAmount) = when (taxMethod) {
            TaxMethod.EXCLUSIVE -> {
                val (total, tax) = calculateExclusive(priceAfterDiscount, taxRate.rate)
                Pair(total, tax)
            }
            TaxMethod.INCLUSIVE -> {
                val (_, tax) = calculateInclusive(priceAfterDiscount, taxRate.rate)
                Pair(priceAfterDiscount, tax)
            }
        }

        return CalculationResult(
            inputPrice = inputPrice,
            priceAfterDiscount = priceAfterDiscount,
            taxAmount = taxAmount,
            finalPrice = finalPrice,
            totalDiscount = totalDiscount,
            taxRate = taxRate,
            taxMethod = taxMethod,
            appliedDiscounts = discounts
        )
    }
}
