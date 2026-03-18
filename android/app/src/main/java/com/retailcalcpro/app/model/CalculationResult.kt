package com.retailcalcpro.app.model

data class CalculationResult(
    val inputPrice: Int,
    val priceAfterDiscount: Int,
    val taxAmount: Int,
    val finalPrice: Int,
    val totalDiscount: Int,
    val taxRate: TaxRate,
    val taxMethod: TaxMethod,
    val appliedDiscounts: List<DiscountType>
)
