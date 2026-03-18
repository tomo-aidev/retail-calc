package com.retailcalcpro.app.util

import java.text.NumberFormat
import java.util.Locale

object NumberFormatUtil {
    private val formatter = NumberFormat.getNumberInstance(Locale.JAPAN)

    fun yenFormatted(value: Int): String {
        return "¥${formatter.format(value)}"
    }

    fun commaFormatted(value: Int): String {
        return formatter.format(value)
    }
}
