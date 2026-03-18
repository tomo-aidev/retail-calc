import SwiftUI

struct TermsOfServiceView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        sectionTitle("第1条（適用）")
                        Text("本利用規約（以下「本規約」）は、消費税電卓（以下「本アプリ」）の利用条件を定めるものです。ユーザーは本規約に同意の上、本アプリを利用するものとします。")

                        sectionTitle("第2条（利用条件）")
                        Text("1. 本アプリは、消費税の計算を補助するためのツールです。\n2. 無料版では1日あたりの利用回数に制限があります。\n3. アプリ内課金により制限を解除することができます。")

                        sectionTitle("第3条（禁止事項）")
                        Text("ユーザーは以下の行為をしてはなりません。\n・本アプリの不正利用またはリバースエンジニアリング\n・本アプリを利用した違法行為\n・本アプリの運営を妨害する行為")

                        sectionTitle("第4条（免責事項）")
                        Text("1. 本アプリの計算結果はあくまで参考値であり、正確性を保証するものではありません。\n2. 本アプリの利用により生じた損害について、開発者は一切の責任を負いません。\n3. 税率の変更等により計算結果が実際と異なる場合があります。")
                    }

                    Group {
                        sectionTitle("第5条（アプリ内課金）")
                        Text("1. 本アプリではアプリ内課金（買い切り型）を提供しています。\n2. 購入後の返金はAppleの返金ポリシーに従います。\n3. 購入はApple IDに紐づけられ、同一Apple IDであれば復元が可能です。")

                        sectionTitle("第6条（規約の変更）")
                        Text("開発者は、必要に応じて本規約を変更することができます。変更後の規約は、本アプリ内に表示した時点で効力を生じるものとします。")

                        sectionTitle("第7条（準拠法）")
                        Text("本規約は日本法に準拠し、解釈されるものとします。")
                    }

                    Text("最終更新日: 2025年3月15日")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 10)
                }
                .font(.subheadline)
                .padding(20)
            }
            .navigationTitle("利用規約")
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
