package com.retailcalcpro.app.viewmodel

import android.app.Application
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.retailcalcpro.app.data.AppDatabase
import com.retailcalcpro.app.data.CalculationHistory
import com.retailcalcpro.app.model.*
import com.retailcalcpro.app.util.TaxCalculator
import com.retailcalcpro.app.util.UsageLimiter
import com.retailcalcpro.app.util.PurchaseManager
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch

class CalculatorViewModel(application: Application) : AndroidViewModel(application) {

    private val db = AppDatabase.getInstance(application)
    private val historyDao = db.historyDao()
    private val usageLimiter = UsageLimiter.getInstance(application)

    var inputText by mutableStateOf("0")
        private set

    var taxRate by mutableStateOf(TaxRate.STANDARD)
        private set

    var taxMethod by mutableStateOf(TaxMethod.EXCLUSIVE)
        private set

    var appliedDiscounts by mutableStateOf<List<DiscountType>>(emptyList())
        private set

    var showPaywall by mutableStateOf(false)
        private set

    var showSavedFeedback by mutableStateOf(false)
        private set

    val inputPrice: Int
        get() = inputText.toIntOrNull() ?: 0

    val result: CalculationResult
        get() = TaxCalculator.calculate(
            inputPrice = inputPrice,
            taxRate = taxRate,
            taxMethod = taxMethod,
            discounts = appliedDiscounts
        )

    val remainingCount: Int
        get() = usageLimiter.remainingCount

    val isProUnlocked: Boolean
        get() = PurchaseManager.getInstance().isProUnlocked

    val histories = historyDao.getAllHistory()
        .stateIn(viewModelScope, SharingStarted.Lazily, emptyList())

    fun appendDigit(digit: String) {
        if (!usageLimiter.canUse()) {
            showPaywall = true
            return
        }
        if (inputText.length >= 10) return
        inputText = if (inputText == "0") {
            if (digit == "0") "0" else digit
        } else {
            inputText + digit
        }
    }

    fun appendDoubleZero() {
        if (!usageLimiter.canUse()) {
            showPaywall = true
            return
        }
        if (inputText == "0") return
        if (inputText.length >= 9) return
        inputText += "00"
    }

    fun deleteLastDigit() {
        inputText = if (inputText.length <= 1) "0" else inputText.dropLast(1)
    }

    fun clear() {
        if (inputText != "0") {
            usageLimiter.recordUsage()
        }
        inputText = "0"
    }

    fun updateTaxRate(rate: TaxRate) {
        taxRate = rate
    }

    fun updateTaxMethod(method: TaxMethod) {
        taxMethod = method
    }

    fun applyPercentageDiscount(percentage: Int) {
        appliedDiscounts = listOf(DiscountType.Percentage(percentage))
    }

    fun clearDiscounts() {
        appliedDiscounts = emptyList()
    }

    fun saveToHistory() {
        val r = result
        if (r.inputPrice == 0) return

        viewModelScope.launch {
            val discountPct = when (val d = appliedDiscounts.firstOrNull()) {
                is DiscountType.Percentage -> d.value
                is DiscountType.Amount -> 0
                null -> 0
            }
            historyDao.insert(
                CalculationHistory(
                    inputPrice = r.inputPrice,
                    finalPrice = r.finalPrice,
                    priceAfterDiscount = r.priceAfterDiscount,
                    taxAmount = r.taxAmount,
                    totalDiscount = r.totalDiscount,
                    taxRateValue = when (r.taxRate) {
                        TaxRate.STANDARD -> 10
                        TaxRate.REDUCED -> 8
                        TaxRate.NONE -> 0
                    },
                    taxMethodRaw = when (r.taxMethod) {
                        TaxMethod.EXCLUSIVE -> "exclusive"
                        TaxMethod.INCLUSIVE -> "inclusive"
                    },
                    discountPercent = discountPct
                )
            )
            showSavedFeedback = true
        }
    }

    fun deleteHistory(history: CalculationHistory) {
        viewModelScope.launch {
            historyDao.delete(history)
        }
    }

    fun deleteAllHistory() {
        viewModelScope.launch {
            historyDao.deleteAll()
        }
    }

    fun restoreFromHistory(history: CalculationHistory) {
        inputText = history.inputPrice.toString()
        taxRate = when (history.taxRateValue) {
            10 -> TaxRate.STANDARD
            8 -> TaxRate.REDUCED
            else -> TaxRate.NONE
        }
        taxMethod = if (history.taxMethodRaw == "exclusive") TaxMethod.EXCLUSIVE else TaxMethod.INCLUSIVE
        if (history.discountPercent > 0) {
            appliedDiscounts = listOf(DiscountType.Percentage(history.discountPercent))
        } else {
            appliedDiscounts = emptyList()
        }
    }

    fun dismissPaywall() {
        showPaywall = false
    }

    fun onPurchased() {
        showPaywall = false
    }

    fun dismissSavedFeedback() {
        showSavedFeedback = false
    }
}
