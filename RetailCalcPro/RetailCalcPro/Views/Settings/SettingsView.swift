import SwiftUI

struct SettingsView: View {
    @State private var settings = AppSettings.shared
    @State private var showCustomDiscountEditor = false
    @State private var showTerms = false
    @State private var showPrivacy = false
    @State private var isRestoring = false
    @State private var restoreMessage: String?

    var body: some View {
        List {
            Section {
                HStack(spacing: 16) {
                    settingIcon("percent", color: AppTheme.exclusivePrimary)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("標準税率")
                            .font(.body.weight(.medium))
                        Text("標準的な消費税率を設定します")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("\(settings.standardTaxRateValue)%")
                    Stepper("", value: $settings.standardTaxRateValue, in: 1...30)
                        .labelsHidden()
                        .frame(width: 80)
                }

                HStack(spacing: 16) {
                    settingIcon("basket", color: AppTheme.exclusivePrimary)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("軽減税率")
                            .font(.body.weight(.medium))
                        Text("食料品などの税率を設定します")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("\(settings.reducedTaxRateValue)%")
                    Stepper("", value: $settings.reducedTaxRateValue, in: 1...30)
                        .labelsHidden()
                        .frame(width: 80)
                }
            } header: {
                Text("税設定")
            }

            Section {
                Button {
                    showCustomDiscountEditor = true
                } label: {
                    HStack(spacing: 16) {
                        settingIcon("tag", color: AppTheme.exclusivePrimary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("カスタム割引率")
                                .font(.body.weight(.medium))
                                .foregroundStyle(.primary)
                            Text("よく使う割引率を登録します")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text("割引設定")
            }

            Section {
                HStack(spacing: 16) {
                    settingIcon("moon.fill", color: AppTheme.exclusivePrimary)
                    Text("ダークモード")
                        .font(.body.weight(.medium))
                    Spacer()
                    Toggle("", isOn: $settings.darkModeEnabled)
                        .labelsHidden()
                }
            } header: {
                Text("アプリ設定")
            }

            Section {
                Button {
                    Task {
                        isRestoring = true
                        restoreMessage = nil
                        let restored = await PurchaseManager.shared.restorePurchases()
                        restoreMessage = restored ? "購入を復元しました" : "復元できる購入が見つかりません"
                        isRestoring = false
                    }
                } label: {
                    HStack(spacing: 16) {
                        settingIcon("arrow.clockwise", color: AppTheme.exclusivePrimary)
                        Text("購入を復元")
                            .font(.body.weight(.medium))
                            .foregroundStyle(.primary)
                        Spacer()
                        if isRestoring {
                            ProgressView()
                        }
                    }
                }
                .disabled(isRestoring)

                if let restoreMessage {
                    Text(restoreMessage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("購入")
            }

            Section {
                HStack(spacing: 16) {
                    settingIcon("info.circle", color: .gray)
                    Text("アプリ情報")
                        .font(.body.weight(.medium))
                    Spacer()
                    Text("v1.0.0")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Button {
                    showTerms = true
                } label: {
                    HStack(spacing: 16) {
                        settingIcon("doc.text", color: .gray)
                        Text("利用規約")
                            .font(.body.weight(.medium))
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Button {
                    showPrivacy = true
                } label: {
                    HStack(spacing: 16) {
                        settingIcon("shield", color: .gray)
                        Text("プライバシーポリシー")
                            .font(.body.weight(.medium))
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text("サポートと情報")
            } footer: {
                Text("© 2026 消費税電卓・割引計算")
                    .frame(maxWidth: .infinity)
                    .padding(.top, 16)
            }
        }
        .navigationTitle("設定")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showCustomDiscountEditor) {
            CustomDiscountEditor()
        }
        .sheet(isPresented: $showTerms) {
            TermsOfServiceView()
        }
        .sheet(isPresented: $showPrivacy) {
            PrivacyPolicyView()
        }
    }

    private func settingIcon(_ name: String, color: Color) -> some View {
        Image(systemName: name)
            .font(.body)
            .foregroundStyle(color)
            .frame(width: 40, height: 40)
            .background(color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
