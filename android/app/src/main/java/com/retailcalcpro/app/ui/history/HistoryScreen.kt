package com.retailcalcpro.app.ui.history

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.retailcalcpro.app.data.CalculationHistory
import com.retailcalcpro.app.ui.theme.DiscountOrange
import com.retailcalcpro.app.ui.theme.ExclusivePrimary
import com.retailcalcpro.app.util.NumberFormatUtil
import java.text.SimpleDateFormat
import java.util.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HistoryScreen(
    histories: List<CalculationHistory>,
    onBack: () -> Unit,
    onRestore: (CalculationHistory) -> Unit,
    onDelete: (CalculationHistory) -> Unit,
    onDeleteAll: () -> Unit
) {
    var showDeleteConfirmation by remember { mutableStateOf(false) }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("履歴") },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "戻る")
                    }
                },
                actions = {
                    if (histories.isNotEmpty()) {
                        TextButton(onClick = { showDeleteConfirmation = true }) {
                            Text("すべて削除", color = MaterialTheme.colorScheme.error)
                        }
                    }
                }
            )
        }
    ) { padding ->
        if (histories.isEmpty()) {
            // Empty State
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(padding),
                contentAlignment = Alignment.Center
            ) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Icon(
                        Icons.Default.Refresh,
                        contentDescription = null,
                        modifier = Modifier.size(48.dp),
                        tint = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                    Spacer(modifier = Modifier.height(16.dp))
                    Text(
                        "計算履歴がありません",
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        "電卓で計算すると、ここに履歴が表示されます",
                        fontSize = 14.sp,
                        color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.6f)
                    )
                }
            }
        } else {
            LazyColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(padding),
                contentPadding = PaddingValues(horizontal = 16.dp, vertical = 8.dp)
            ) {
                items(histories, key = { it.id }) { history ->
                    HistoryItemRow(
                        history = history,
                        onClick = { onRestore(history) },
                        onDelete = { onDelete(history) }
                    )
                    HorizontalDivider(modifier = Modifier.padding(vertical = 4.dp))
                }
            }
        }
    }

    if (showDeleteConfirmation) {
        AlertDialog(
            onDismissRequest = { showDeleteConfirmation = false },
            title = { Text("すべての履歴を削除しますか？") },
            text = { Text("この操作は取り消せません。") },
            confirmButton = {
                TextButton(onClick = {
                    onDeleteAll()
                    showDeleteConfirmation = false
                }) {
                    Text("削除", color = MaterialTheme.colorScheme.error)
                }
            },
            dismissButton = {
                TextButton(onClick = { showDeleteConfirmation = false }) {
                    Text("キャンセル")
                }
            }
        )
    }
}

@Composable
fun HistoryItemRow(
    history: CalculationHistory,
    onClick: () -> Unit,
    onDelete: () -> Unit
) {
    val timeFormat = remember { SimpleDateFormat("HH:mm", Locale.JAPAN) }
    val timeString = remember(history.createdAt) { timeFormat.format(Date(history.createdAt)) }

    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onClick() }
            .padding(vertical = 4.dp)
    ) {
        // Line 1: 入力：¥1,700                    20:47
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(
                text = "入力：${NumberFormatUtil.yenFormatted(history.inputPrice)}",
                fontWeight = FontWeight.Bold,
                fontSize = 16.sp
            )
            Text(
                text = timeString,
                fontSize = 12.sp,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }

        // Line 2: 税込：¥1,309 消費税(10%) +¥119 割引(10%):-¥510
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.Start,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = "${history.methodLabel}：${NumberFormatUtil.yenFormatted(history.finalPrice)}",
                fontWeight = FontWeight.Bold,
                fontSize = 14.sp
            )

            if (history.taxAmount > 0) {
                Spacer(modifier = Modifier.width(4.dp))
                Text(
                    text = "消費税(${history.taxRateLabel})",
                    fontSize = 10.sp,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Spacer(modifier = Modifier.width(2.dp))
                Text(
                    text = "+${NumberFormatUtil.yenFormatted(history.taxAmount)}",
                    fontSize = 10.sp,
                    fontWeight = FontWeight.Medium,
                    color = ExclusivePrimary
                )
            }

            if (history.discountLabel != null && history.totalDiscount > 0) {
                Spacer(modifier = Modifier.width(4.dp))
                Text(
                    text = "${history.discountLabel}:-${NumberFormatUtil.yenFormatted(history.totalDiscount)}",
                    fontSize = 10.sp,
                    fontWeight = FontWeight.Medium,
                    color = DiscountOrange
                )
            }
        }
    }
}
