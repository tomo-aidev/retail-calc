package com.retailcalcpro.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.runtime.*
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import com.retailcalcpro.app.ui.calculator.CalculatorScreen
import com.retailcalcpro.app.ui.history.HistoryScreen
import com.retailcalcpro.app.ui.paywall.PaywallSheet
import com.retailcalcpro.app.ui.settings.SettingsScreen
import com.retailcalcpro.app.ui.splash.SplashScreen
import com.retailcalcpro.app.ui.theme.RetailCalcTheme
import com.retailcalcpro.app.util.PurchaseManager
import com.retailcalcpro.app.viewmodel.CalculatorViewModel

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        PurchaseManager.init(this)
        enableEdgeToEdge()
        setContent {
            RetailCalcTheme {
                var showSplash by remember { mutableStateOf(true) }

                if (showSplash) {
                    SplashScreen(onFinished = { showSplash = false })
                } else {
                    MainApp()
                }
            }
        }
    }
}

@Composable
fun MainApp(
    viewModel: CalculatorViewModel = viewModel()
) {
    var currentScreen by remember { mutableStateOf("calculator") }
    val histories by viewModel.histories.collectAsStateWithLifecycle()

    when (currentScreen) {
        "calculator" -> {
            CalculatorScreen(
                viewModel = viewModel,
                onShowHistory = { currentScreen = "history" },
                onShowSettings = { currentScreen = "settings" }
            )

            // Paywall Sheet
            if (viewModel.showPaywall) {
                PaywallSheet(
                    onDismiss = { viewModel.dismissPaywall() },
                    onPurchased = { viewModel.onPurchased() }
                )
            }
        }
        "history" -> {
            HistoryScreen(
                histories = histories,
                onBack = { currentScreen = "calculator" },
                onRestore = { history ->
                    viewModel.restoreFromHistory(history)
                    currentScreen = "calculator"
                },
                onDelete = { viewModel.deleteHistory(it) },
                onDeleteAll = { viewModel.deleteAllHistory() }
            )
        }
        "settings" -> {
            SettingsScreen(onBack = { currentScreen = "calculator" })
        }
    }
}
