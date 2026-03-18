package com.retailcalcpro.app.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

val ExclusivePrimary = Color(0xFF005BB2)
val ExclusiveBackground = Color(0xFFEDF2FA)
val ExclusiveBackgroundDark = Color(0xFF0F1A2E)

val InclusivePrimary = Color(0xFFD95926)
val InclusiveBackground = Color(0xFFFCF2EB)
val InclusiveBackgroundDark = Color(0xFF2E1A0F)

val KeypadDark = Color(0xFF383839)
val KeypadGray = Color(0xFFA6A6A6)

val DiscountOrange = Color(0xFFE67E22)

private val LightColorScheme = lightColorScheme(
    primary = ExclusivePrimary,
    onPrimary = Color.White,
    surface = Color.White,
    background = ExclusiveBackground,
)

private val DarkColorScheme = darkColorScheme(
    primary = ExclusivePrimary,
    onPrimary = Color.White,
    surface = Color(0xFF1C1C1E),
    background = ExclusiveBackgroundDark,
)

@Composable
fun RetailCalcTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit
) {
    val colorScheme = if (darkTheme) DarkColorScheme else LightColorScheme
    MaterialTheme(
        colorScheme = colorScheme,
        content = content
    )
}
