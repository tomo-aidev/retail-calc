package com.retailcalcpro.app.ui.calculator

import androidx.compose.animation.*
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.retailcalcpro.app.model.*
import com.retailcalcpro.app.ui.theme.*
import com.retailcalcpro.app.util.NumberFormatUtil
import com.retailcalcpro.app.viewmodel.CalculatorViewModel
import kotlinx.coroutines.delay

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CalculatorScreen(
    viewModel: CalculatorViewModel = viewModel(),
    onShowHistory: () -> Unit = {},
    onShowSettings: () -> Unit = {}
) {
    val result = viewModel.result
    val accentColor = if (viewModel.taxMethod == TaxMethod.EXCLUSIVE) ExclusivePrimary else InclusivePrimary

    // Auto-dismiss saved feedback
    LaunchedEffect(viewModel.showSavedFeedback) {
        if (viewModel.showSavedFeedback) {
            delay(1500)
            viewModel.dismissSavedFeedback()
        }
    }

    Box(modifier = Modifier.fillMaxSize()) {
        Scaffold(
            topBar = {
                TopAppBar(
                    title = {
                        Text(
                            text = "消費税電卓・割引計算",
                            fontWeight = FontWeight.Bold,
                            fontSize = 16.sp
                        )
                    },
                    actions = {
                        // Remaining count badge
                        if (!viewModel.isProUnlocked) {
                            Text(
                                text = "残り${viewModel.remainingCount}回",
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Medium,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                                modifier = Modifier
                                    .clip(CircleShape)
                                    .background(MaterialTheme.colorScheme.surfaceVariant)
                                    .padding(horizontal = 8.dp, vertical = 4.dp)
                            )
                            Spacer(modifier = Modifier.width(4.dp))
                        }

                        // Right side menu
                        var menuExpanded by remember { mutableStateOf(false) }
                        Box {
                            IconButton(onClick = { menuExpanded = true }) {
                                Icon(
                                    Icons.Default.MoreVert,
                                    contentDescription = "メニュー"
                                )
                            }
                            DropdownMenu(
                                expanded = menuExpanded,
                                onDismissRequest = { menuExpanded = false }
                            ) {
                                DropdownMenuItem(
                                    text = { Text("履歴") },
                                    onClick = {
                                        menuExpanded = false
                                        onShowHistory()
                                    },
                                    leadingIcon = {
                                        Icon(Icons.Default.Refresh, contentDescription = null)
                                    }
                                )
                                DropdownMenuItem(
                                    text = { Text("設定") },
                                    onClick = {
                                        menuExpanded = false
                                        onShowSettings()
                                    },
                                    leadingIcon = {
                                        Icon(Icons.Default.Settings, contentDescription = null)
                                    }
                                )
                            }
                        }
                    }
                )
            }
        ) { padding ->
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(padding)
                    .background(MaterialTheme.colorScheme.background)
            ) {
                // Tax Method Toggle
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 4.dp),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    TaxMethod.entries.forEach { method ->
                        val isSelected = viewModel.taxMethod == method
                        val color = if (method == TaxMethod.EXCLUSIVE) ExclusivePrimary else InclusivePrimary
                        Button(
                            onClick = { viewModel.updateTaxMethod(method) },
                            colors = ButtonDefaults.buttonColors(
                                containerColor = if (isSelected) color else Color.Gray.copy(alpha = 0.3f),
                                contentColor = if (isSelected) Color.White else Color.Gray
                            ),
                            modifier = Modifier.weight(1f),
                            shape = RoundedCornerShape(8.dp)
                        ) {
                            Text(method.label, fontWeight = FontWeight.Bold)
                        }
                    }
                }

                // Input Display
                Text(
                    text = NumberFormatUtil.yenFormatted(viewModel.inputPrice),
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 8.dp),
                    textAlign = TextAlign.End,
                    fontSize = 36.sp,
                    fontWeight = FontWeight.Bold,
                    color = MaterialTheme.colorScheme.onBackground
                )

                // Display Section (results)
                DisplaySection(result = result, accentColor = accentColor)

                // Tax Rate Buttons
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 4.dp),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Text(
                        "消費税：",
                        modifier = Modifier.align(Alignment.CenterVertically),
                        fontWeight = FontWeight.Bold
                    )
                    TaxRate.entries.forEach { rate ->
                        val isSelected = viewModel.taxRate == rate
                        FilterChip(
                            selected = isSelected,
                            onClick = { viewModel.updateTaxRate(rate) },
                            label = { Text(rate.label, fontWeight = FontWeight.Bold) }
                        )
                    }
                }

                // Discount Buttons
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 4.dp),
                    horizontalArrangement = Arrangement.spacedBy(8.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("割引：", fontWeight = FontWeight.Bold)

                    var expanded by remember { mutableStateOf(false) }
                    val discountOptions = listOf(5, 10, 15, 20, 30, 40, 50)

                    Box {
                        FilterChip(
                            selected = viewModel.appliedDiscounts.isNotEmpty(),
                            onClick = { expanded = true },
                            label = {
                                Text(
                                    if (viewModel.appliedDiscounts.isNotEmpty())
                                        viewModel.appliedDiscounts.first().shortLabel
                                    else "なし",
                                    fontWeight = FontWeight.Bold
                                )
                            }
                        )
                        DropdownMenu(expanded = expanded, onDismissRequest = { expanded = false }) {
                            DropdownMenuItem(
                                text = { Text("なし") },
                                onClick = {
                                    viewModel.clearDiscounts()
                                    expanded = false
                                }
                            )
                            discountOptions.forEach { pct ->
                                DropdownMenuItem(
                                    text = { Text("${pct}%引") },
                                    onClick = {
                                        viewModel.applyPercentageDiscount(pct)
                                        expanded = false
                                    }
                                )
                            }
                        }
                    }

                    // Applied discount badge
                    if (viewModel.appliedDiscounts.isNotEmpty()) {
                        AssistChip(
                            onClick = { viewModel.clearDiscounts() },
                            label = { Text(viewModel.appliedDiscounts.first().label) },
                            trailingIcon = {
                                Icon(Icons.Default.Close, contentDescription = "割引解除", modifier = Modifier.size(16.dp))
                            }
                        )
                    }
                }

                Spacer(modifier = Modifier.weight(1f))

                // Numeric Keypad
                NumericKeypad(
                    onDigit = { viewModel.appendDigit(it) },
                    onDoubleZero = { viewModel.appendDoubleZero() },
                    onBackspace = { viewModel.deleteLastDigit() },
                    onClear = { viewModel.clear() },
                    onSave = { viewModel.saveToHistory() },
                    modifier = Modifier
                        .fillMaxWidth()
                        .fillMaxHeight(0.46f)
                        .padding(horizontal = 8.dp, vertical = 4.dp)
                        .navigationBarsPadding()
                )
            }
        }

        // Saved toast overlay
        AnimatedVisibility(
            visible = viewModel.showSavedFeedback,
            enter = slideInVertically(initialOffsetY = { -it }) + fadeIn(),
            exit = fadeOut(),
            modifier = Modifier
                .align(Alignment.TopCenter)
                .padding(top = 100.dp)
        ) {
            Surface(
                shape = CircleShape,
                shadowElevation = 4.dp,
                color = MaterialTheme.colorScheme.surface
            ) {
                Row(
                    modifier = Modifier.padding(horizontal = 16.dp, vertical = 10.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(6.dp)
                ) {
                    Icon(
                        Icons.Default.CheckCircle,
                        contentDescription = null,
                        tint = Color(0xFF4CAF50),
                        modifier = Modifier.size(16.dp)
                    )
                    Text(
                        "履歴に保存しました",
                        fontSize = 13.sp,
                        fontWeight = FontWeight.SemiBold
                    )
                }
            }
        }
    }
}

@Composable
fun DisplaySection(result: CalculationResult, accentColor: Color) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 4.dp),
        shape = RoundedCornerShape(12.dp)
    ) {
        Column(
            modifier = Modifier.padding(12.dp)
        ) {
            // Discount info
            if (result.totalDiscount > 0) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text("割引額", color = Color.Gray, fontSize = 14.sp)
                    Text(
                        "-${NumberFormatUtil.yenFormatted(result.totalDiscount)}",
                        color = DiscountOrange,
                        fontWeight = FontWeight.Bold,
                        fontSize = 14.sp
                    )
                }
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text("割引後", color = Color.Gray, fontSize = 14.sp)
                    Text(
                        NumberFormatUtil.yenFormatted(result.priceAfterDiscount),
                        fontSize = 14.sp
                    )
                }
            }

            // Tax info
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text(
                    "消費税 (${result.taxRate.label})",
                    color = Color.Gray,
                    fontSize = 14.sp
                )
                Text(
                    "+${NumberFormatUtil.yenFormatted(result.taxAmount)}",
                    color = accentColor,
                    fontWeight = FontWeight.Bold,
                    fontSize = 14.sp
                )
            }

            HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))

            // Final price
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text("税込", fontWeight = FontWeight.Bold, fontSize = 16.sp)
                Text(
                    NumberFormatUtil.yenFormatted(result.finalPrice),
                    color = accentColor,
                    fontWeight = FontWeight.Bold,
                    fontSize = 24.sp
                )
            }
        }
    }
}

@Composable
fun NumericKeypad(
    onDigit: (String) -> Unit,
    onDoubleZero: () -> Unit,
    onBackspace: () -> Unit,
    onClear: () -> Unit,
    onSave: () -> Unit,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier,
        verticalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        val buttonModifier = Modifier
            .weight(1f)
            .fillMaxHeight()

        // Row 1: ⌫ C 00
        Row(
            modifier = Modifier.weight(1f).fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(4.dp)
        ) {
            KeypadButton("⌫", KeypadButtonStyle.FUNCTION, buttonModifier) { onBackspace() }
            KeypadButton("C", KeypadButtonStyle.FUNCTION, buttonModifier) { onClear() }
            KeypadButton("00", KeypadButtonStyle.DIGIT, buttonModifier) { onDoubleZero() }
        }

        // Row 2: 7 8 9
        Row(
            modifier = Modifier.weight(1f).fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(4.dp)
        ) {
            for (d in listOf("7", "8", "9")) {
                KeypadButton(d, KeypadButtonStyle.DIGIT, buttonModifier) { onDigit(d) }
            }
        }

        // Row 3: 4 5 6
        Row(
            modifier = Modifier.weight(1f).fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(4.dp)
        ) {
            for (d in listOf("4", "5", "6")) {
                KeypadButton(d, KeypadButtonStyle.DIGIT, buttonModifier) { onDigit(d) }
            }
        }

        // Row 4: 1 2 3
        Row(
            modifier = Modifier.weight(1f).fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(4.dp)
        ) {
            for (d in listOf("1", "2", "3")) {
                KeypadButton(d, KeypadButtonStyle.DIGIT, buttonModifier) { onDigit(d) }
            }
        }

        // Row 5: 保存 0 =
        Row(
            modifier = Modifier.weight(1f).fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(4.dp)
        ) {
            KeypadButton("保存", KeypadButtonStyle.FUNCTION, buttonModifier) { onSave() }
            KeypadButton("0", KeypadButtonStyle.DIGIT, buttonModifier) { onDigit("0") }
            KeypadButton("=", KeypadButtonStyle.PRIMARY, buttonModifier) { /* no-op */ }
        }
    }
}

enum class KeypadButtonStyle { DIGIT, FUNCTION, PRIMARY }

@Composable
fun KeypadButton(
    text: String,
    style: KeypadButtonStyle,
    modifier: Modifier = Modifier,
    onClick: () -> Unit
) {
    val containerColor = when (style) {
        KeypadButtonStyle.DIGIT -> KeypadDark
        KeypadButtonStyle.FUNCTION -> KeypadGray
        KeypadButtonStyle.PRIMARY -> ExclusivePrimary
    }
    val contentColor = when (style) {
        KeypadButtonStyle.DIGIT -> Color.White
        KeypadButtonStyle.FUNCTION -> Color.Black
        KeypadButtonStyle.PRIMARY -> Color.White
    }

    Button(
        onClick = onClick,
        colors = ButtonDefaults.buttonColors(
            containerColor = containerColor,
            contentColor = contentColor
        ),
        shape = RoundedCornerShape(8.dp),
        modifier = modifier,
        contentPadding = PaddingValues(0.dp)
    ) {
        Text(
            text = text,
            fontSize = 20.sp,
            fontWeight = FontWeight.Bold
        )
    }
}
