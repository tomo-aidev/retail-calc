# Retail Calc Pro ProGuard Rules

# Keep Room entities
-keep class com.retailcalcpro.app.data.** { *; }

# Keep Compose
-dontwarn androidx.compose.**

# Keep Billing
-keep class com.android.vending.billing.** { *; }

# Keep data classes
-keep class com.retailcalcpro.app.model.** { *; }
