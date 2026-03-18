package com.retailcalcpro.app.model

enum class TaxRate(val rate: Int, val label: String) {
    STANDARD(10, "10%"),
    REDUCED(8, "8%(軽減)"),
    NONE(0, "0%");

    val rateDouble: Double get() = rate / 100.0
}
