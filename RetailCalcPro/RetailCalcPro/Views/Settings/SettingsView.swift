import SwiftUI

struct SettingsView: View {
    @State private var settings = AppSettings.shared
    @State private var showCustomDiscountEditor = false

    var body: some View {
        NavigationStack {
            List {
                // Tax Settings
                Section {
                    HStack(spacing: 16) {
                        settingIcon("percent", color: AppTheme.primary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("標準税率")
                                .font(.body.weight(.medium))
                            Text("標準的な消費税率を設定します")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("\(settings.standardTaxRateValue)%")
                            .foregroundStyle(.primary)
                        Stepper("", value: $settings.standardTaxRateValue, in: 1...30)
                            .labelsHidden()
                            .frame(width: 80)
                    }

                    HStack(spacing: 16) {
                        settingIcon("basket", color: AppTheme.primary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("軽減税率")
                                .font(.body.weight(.medium))
                            Text("食料品などの税率を設定します")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("\(settings.reducedTaxRateValue)%")
                            .foregroundStyle(.primary)
                        Stepper("", value: $settings.reducedTaxRateValue, in: 1...30)
                            .labelsHidden()
                            .frame(width: 80)
                    }
                } header: {
                    Text("税設定")
                        .font(.caption.weight(.semibold))
                        .textCase(.uppercase)
                        .tracking(1)
                }

                // Discount Settings
                Section {
                    Button {
                        showCustomDiscountEditor = true
                    } label: {
                        HStack(spacing: 16) {
                            settingIcon("tag", color: AppTheme.primary)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("カスタム割引")
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
                        .font(.caption.weight(.semibold))
                        .textCase(.uppercase)
                        .tracking(1)
                }

                // App Settings
                Section {
                    HStack(spacing: 16) {
                        settingIcon("moon.fill", color: AppTheme.primary)
                        Text("ダークモード")
                            .font(.body.weight(.medium))
                        Spacer()
                        Toggle("", isOn: $settings.darkModeEnabled)
                            .labelsHidden()
                    }

                    HStack(spacing: 16) {
                        settingIcon("speaker.wave.2.fill", color: AppTheme.primary)
                        Text("操作音")
                            .font(.body.weight(.medium))
                        Spacer()
                        Toggle("", isOn: $settings.soundEnabled)
                            .labelsHidden()
                    }
                } header: {
                    Text("アプリ設定")
                        .font(.caption.weight(.semibold))
                        .textCase(.uppercase)
                        .tracking(1)
                }

                // Support & Info
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

                    HStack(spacing: 16) {
                        settingIcon("doc.text", color: .gray)
                        Text("利用規約")
                            .font(.body.weight(.medium))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    HStack(spacing: 16) {
                        settingIcon("shield", color: .gray)
                        Text("プライバシーポリシー")
                            .font(.body.weight(.medium))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("サポートと情報")
                        .font(.caption.weight(.semibold))
                        .textCase(.uppercase)
                        .tracking(1)
                } footer: {
                    Text("© 2024 Retail Calc Pro")
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showCustomDiscountEditor) {
                CustomDiscountEditor()
            }
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
