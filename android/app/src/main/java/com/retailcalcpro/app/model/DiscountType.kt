package com.retailcalcpro.app.model

sealed class DiscountType {
    data class Percentage(val value: Int) : DiscountType()
    data class Amount(val value: Int) : DiscountType()

    val label: String
        get() = when (this) {
            is Percentage -> "${value}%引"
            is Amount -> "${value}円引"
        }

    val shortLabel: String
        get() = when (this) {
            is Percentage -> "${value}%"
            is Amount -> "${value}円"
        }
}
