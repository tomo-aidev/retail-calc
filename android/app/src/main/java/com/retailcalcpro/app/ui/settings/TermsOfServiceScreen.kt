package com.retailcalcpro.app.ui.settings

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TermsOfServiceScreen(onBack: () -> Unit) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("利用規約") },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "戻る")
                    }
                }
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(horizontal = 16.dp)
                .verticalScroll(rememberScrollState())
        ) {
            Spacer(modifier = Modifier.height(8.dp))
            Text("最終更新日: 2025年3月15日", fontSize = 12.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
            Spacer(modifier = Modifier.height(16.dp))

            TermsSection("第1条（適用）",
                "本規約は、本アプリ「消費税電卓・割引計算」（以下「本アプリ」）の利用条件を定めるものです。ユーザーは本規約に同意の上、本アプリをご利用ください。")

            TermsSection("第2条（利用条件）",
                "本アプリは、消費税の計算および割引計算を目的としたツールです。無料版は1日10回の利用制限があります。")

            TermsSection("第3条（禁止事項）",
                "ユーザーは以下の行為をしてはなりません。\n• 本アプリの不正利用またはリバースエンジニアリング\n• 本アプリを利用した違法行為\n• 本アプリの運営を妨害する行為")

            TermsSection("第4条（免責事項）",
                "本アプリの計算結果は参考値であり、正確性を保証するものではありません。本アプリの利用により生じた損害について、開発者は一切の責任を負いません。")

            TermsSection("第5条（アプリ内課金）",
                "本アプリでは、利用制限解除のためのアプリ内課金（買い切り型）を提供しています。購入後の返金はGoogle Playの規約に準じます。")

            TermsSection("第6条（規約の変更）",
                "開発者は、必要に応じて本規約を変更できるものとします。変更後の規約は、本アプリ内に表示した時点で効力を生じます。")

            TermsSection("第7条（準拠法）",
                "本規約の解釈にあたっては、日本法を準拠法とします。")

            Spacer(modifier = Modifier.height(24.dp))
        }
    }
}

@Composable
private fun TermsSection(title: String, content: String) {
    Text(title, fontWeight = FontWeight.Bold, fontSize = 15.sp)
    Spacer(modifier = Modifier.height(4.dp))
    Text(content, fontSize = 14.sp, lineHeight = 22.sp)
    Spacer(modifier = Modifier.height(16.dp))
}
