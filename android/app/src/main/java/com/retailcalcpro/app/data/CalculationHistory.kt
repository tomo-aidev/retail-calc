package com.retailcalcpro.app.data

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "calculation_history")
data class CalculationHistory(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val inputPrice: Int,
    val finalPrice: Int,
    val priceAfterDiscount: Int,
    val taxAmount: Int,
    val totalDiscount: Int,
    val taxRateValue: Int,       // 10, 8, 0
    val taxMethodRaw: String,    // "exclusive" or "inclusive"
    val discountPercent: Int,    // 0 if none
    val createdAt: Long = System.currentTimeMillis(),
    val note: String = ""
) {
    val taxRateLabel: String
        get() = when (taxRateValue) {
            10 -> "10%"
            8 -> "8%(軽減)"
            0 -> "0%"
            else -> "${taxRateValue}%"
        }

    val methodLabel: String
        get() = if (taxMethodRaw == "exclusive") "税込" else "税抜"

    val discountLabel: String?
        get() = if (discountPercent > 0) "割引(${discountPercent}%)" else null
}
