import SwiftUI
import SwiftData

struct CalculatorView: View {
    @Bindable var viewModel: CalculatorViewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    var onShowHistory: () -> Void
    var onShowSettings: () -> Void

    @State private var selectedDiscountPercent: Int = 0

    private var accent: Color {
        AppTheme.accentColor(for: viewModel.state.taxMethod)
    }

    private var bgColor: Color {
        colorScheme == .dark
            ? AppTheme.backgroundColorDark(for: viewModel.state.taxMethod)
            : AppTheme.backgroundColor(for: viewModel.state.taxMethod)
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                // ── 上部エリア ──
                VStack(spacing: 4) {
                    // ヘッダー（タイトル + メニュー）
                    header

                    // 税抜/税込 切り替え
                    taxMethodToggle
                        .padding(.horizontal, 16)

                    // 入力金額
                    inputDisplay

                    // 計算結果カード
                    DisplaySection(
                        result: viewModel.state.result,
                        taxMethod: viewModel.state.taxMethod,
                        accent: accent
                    )
                    .padding(.horizontal, 16)

                    // 消費税率 + 割引（縦配置）
                    controlRow
                        .padding(.horizontal, 16)
                        .padding(.top, 2)

                    // 適用中の割引
                    if !viewModel.state.appliedDiscounts.isEmpty {
                        appliedDiscountsBadge
                            .padding(.horizontal, 16)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)

                // ── キーパッド ──
                keypadSection(height: geo.size.height * 0.46)
            }
            .background(bgColor)
            .animation(.easeInOut(duration: 0.25), value: viewModel.state.taxMethod)
        }
        .ignoresSafeArea(.keyboard)
        .onAppear {
            viewModel.setModelContext(modelContext)
        }
        .sheet(isPresented: $viewModel.showPaywallSheet) {
            PaywallView()
        }
        .overlay(alignment: .top) {
            // 保存フィードバック
            if viewModel.showSavedFeedback {
                savedToast
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation { viewModel.showSavedFeedback = false }
                        }
                    }
            }
        }
    }

    // MARK: - Saved Toast

    private var savedToast: some View {
        HStack(spacing: 6) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
            Text("履歴に保存しました")
                .font(.caption.weight(.semibold))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .shadow(radius: 4)
        .padding(.top, 60)
    }

    // MARK: - Tax Method Toggle

    private var taxMethodToggle: some View {
        HStack(spacing: 0) {
            ForEach(TaxMethod.allCases, id: \.self) { method in
                Button {
                    viewModel.setTaxMethod(method)
                } label: {
                    Text(method.label)
                        .font(.subheadline.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            viewModel.state.taxMethod == method
                                ? AppTheme.accentColor(for: method)
                                : Color.clear
                        )
                        .foregroundStyle(
                            viewModel.state.taxMethod == method
                                ? .white
                                : .secondary
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding(3)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            HStack(spacing: 5) {
                Image(systemName: "plus.forwardslash.minus")
                    .foregroundStyle(accent)
                    .font(.subheadline)
                Text("消費税電卓・割引計算")
                    .font(.subheadline.weight(.bold))
            }
            Spacer()

            if !PurchaseManager.shared.isProUnlocked {
                Text("残り\(viewModel.remainingCount)回")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.tertiarySystemGroupedBackground))
                    .clipShape(Capsule())
            }

            Menu {
                Button { onShowHistory() } label: {
                    Label("履歴", systemImage: "clock.arrow.circlepath")
                }
                Button { onShowSettings() } label: {
                    Label("設定", systemImage: "gearshape")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.body)
                    .foregroundStyle(accent)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 2)
    }

    // MARK: - Input Display

    private var inputDisplay: some View {
        Text("¥\(viewModel.state.inputPrice.formatted())")
            .font(.system(size: 52, weight: .heavy, design: .rounded))
            .foregroundStyle(.primary)
            .lineLimit(1)
            .minimumScaleFactor(0.3)
            .contentTransition(.numericText())
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal, 20)
    }

    // MARK: - Control Row（縦配置）

    private var controlRow: some View {
        VStack(spacing: 8) {
            // 消費税率
            HStack(spacing: 6) {
                Text("消費税：")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.secondary)

                ForEach(TaxRate.allCases, id: \.self) { rate in
                    Button {
                        viewModel.setTaxRate(rate)
                    } label: {
                        Text(rate.label)
                            .font(.subheadline.weight(.bold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                viewModel.state.taxRate == rate
                                    ? accent : Color(.secondarySystemGroupedBackground)
                            )
                            .foregroundStyle(
                                viewModel.state.taxRate == rate
                                    ? .white : .secondary
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        viewModel.state.taxRate == rate
                                            ? Color.clear : Color(.separator),
                                        lineWidth: 0.5
                                    )
                            )
                    }
                }
                Spacer()
            }

            // 割引
            HStack(spacing: 6) {
                Text("割引：")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.secondary)

                Picker("割引", selection: $selectedDiscountPercent) {
                    Text("なし").tag(0)
                    ForEach(AppSettings.shared.customDiscountPercentages, id: \.self) { pct in
                        Text("\(pct)%引").tag(pct)
                    }
                }
                .pickerStyle(.menu)
                .tint(accent)
                .font(.subheadline.weight(.bold))
                .onChange(of: selectedDiscountPercent) { _, newValue in
                    if newValue > 0 {
                        viewModel.applyPercentageDiscount(newValue)
                    } else {
                        viewModel.clearDiscounts()
                    }
                }

                Spacer()
            }
        }
    }

    // MARK: - Applied Discounts

    private var appliedDiscountsBadge: some View {
        HStack(spacing: 4) {
            ForEach(Array(viewModel.state.appliedDiscounts.enumerated()), id: \.offset) { _, discount in
                Text(discount.label)
                    .font(.caption2.weight(.semibold))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.orange.opacity(0.15))
                    .foregroundStyle(.orange)
                    .clipShape(Capsule())
            }
            Spacer()
            Button {
                viewModel.clearDiscounts()
                selectedDiscountPercent = 0
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Keypad Section

    private func keypadSection(height: CGFloat) -> some View {
        NumericKeypad(
            onDigit: { viewModel.tapDigit($0) },
            onDoubleZero: { viewModel.tapDoubleZero() },
            onBackspace: { viewModel.tapBackspace() },
            onClear: { viewModel.tapClear() },
            onSaveHistory: {
                withAnimation { viewModel.saveToHistory() }
            }
        )
        .frame(height: height)
        .padding(.horizontal, 10)
        .padding(.top, 10)
        .padding(.bottom, 4)
        .background(Color(.systemBackground))
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 24,
                topTrailingRadius: 24
            )
        )
        .shadow(color: .black.opacity(0.06), radius: 8, y: -3)
    }
}
