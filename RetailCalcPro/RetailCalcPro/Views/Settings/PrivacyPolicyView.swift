import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        sectionTitle("はじめに")
                        Text("消費税電卓（以下「本アプリ」）は、ユーザーのプライバシーを尊重し、個人情報の保護に努めます。本プライバシーポリシーでは、本アプリにおける情報の取り扱いについて説明します。")

                        sectionTitle("収集する情報")
                        Text("本アプリは、以下の情報を端末内にのみ保存します。\n\n・計算履歴（入力金額、税率、割引情報）\n・アプリ設定（税率、割引率、表示設定）\n・利用回数（1日あたりの使用回数）\n・購入状態（アプリ内課金の有無）\n\nこれらの情報は端末内にのみ保存され、外部サーバーへの送信は一切行いません。")

                        sectionTitle("個人情報の収集")
                        Text("本アプリは、ユーザーの個人情報（氏名、メールアドレス、電話番号等）を収集しません。")
                    }

                    Group {
                        sectionTitle("第三者への提供")
                        Text("本アプリは、ユーザーの情報を第三者に提供、販売、共有することはありません。")

                        sectionTitle("アプリ内課金")
                        Text("アプリ内課金の処理はApple Inc.のApp Storeを通じて行われます。決済情報はAppleが管理しており、開発者がアクセスすることはできません。")

                        sectionTitle("データの削除")
                        Text("本アプリをアンインストールすることで、端末内に保存された全てのデータが削除されます。")

                        sectionTitle("お子様のプライバシー")
                        Text("本アプリは年齢制限を設けておらず、お子様の個人情報を意図的に収集することはありません。")

                        sectionTitle("ポリシーの変更")
                        Text("本プライバシーポリシーは、必要に応じて更新される場合があります。重要な変更がある場合は、アプリ内で通知します。")
                    }

                    Text("最終更新日: 2025年3月15日")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 10)
                }
                .font(.subheadline)
                .padding(20)
            }
            .navigationTitle("プライバシーポリシー")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("閉じる") { dismiss() }
                }
            }
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
    }
}
