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
fun PrivacyPolicyScreen(onBack: () -> Unit) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("プライバシーポリシー") },
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

            PolicySection("はじめに",
                "本プライバシーポリシーは、「消費税電卓・割引計算」（以下「本アプリ」）における個人情報の取り扱いについて定めるものです。")

            PolicySection("収集する情報",
                "本アプリは以下の情報を端末内にのみ保存します。これらの情報は外部に送信されることはありません。\n\n• 計算履歴（入力金額、計算結果、日時）\n• アプリ設定（税率、割引率）\n• 利用回数（1日の利用カウント）\n• 購入状態（Pro版の購入有無）")

            PolicySection("個人情報の収集について",
                "本アプリは、ユーザーの個人情報（氏名、メールアドレス、位置情報等）を一切収集しません。")

            PolicySection("第三者への情報提供",
                "本アプリはユーザーの情報を第三者に提供・共有することはありません。")

            PolicySection("アプリ内課金について",
                "アプリ内課金はGoogle Playのシステムを通じて行われます。決済情報はGoogleが管理し、開発者がユーザーの決済情報にアクセスすることはありません。")

            PolicySection("データの削除",
                "アプリをアンインストールすることで、端末内の全てのデータが削除されます。計算履歴はアプリ内の履歴画面からも削除できます。")

            PolicySection("お子様のプライバシー",
                "本アプリは年齢制限なくご利用いただけます。個人情報の収集を行わないため、お子様の利用においても特別なリスクはありません。")

            PolicySection("ポリシーの変更",
                "本ポリシーは予告なく変更される場合があります。変更後のポリシーは、本アプリ内に表示した時点で効力を生じます。")

            Spacer(modifier = Modifier.height(24.dp))
        }
    }
}

@Composable
private fun PolicySection(title: String, content: String) {
    Text(title, fontWeight = FontWeight.Bold, fontSize = 15.sp)
    Spacer(modifier = Modifier.height(4.dp))
    Text(content, fontSize = 14.sp, lineHeight = 22.sp)
    Spacer(modifier = Modifier.height(16.dp))
}
