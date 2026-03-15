import SwiftUI
import SwiftData

struct CalculatorView: View {
    @Bindable var viewModel: CalculatorViewModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 0) {
            // Header
            header

            // Scrollable content area
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    // Tax method toggle
                    taxMethodToggle
                        .padding(.horizontal, 16)

                    // Display Section
                    DisplaySection(
                        result: viewModel.state.result,
                        taxMethod: viewModel.state.taxMethod
                    )
                    .padding(.horizontal, 16)

                    // Tax & Discount Controls
                    TaxDiscountControl(
                        currentTaxRate: viewModel.state.taxRate,
                        appliedDiscounts: viewModel.state.appliedDiscounts,
                        discountPercentages: AppSettings.shared.customDiscountPercentages,
                        onTaxRateChanged: { viewModel.setTaxRate($0) },
                        onDiscountApplied: { discount in
                            switch discount {
                            case .percentage(let pct):
                                viewModel.applyPercentageDiscount(pct)
                            case .amount(let amt):
                                viewModel.applyAmountDiscount(amt)
                            }
                        },
                        onClearDiscounts: { viewModel.clearDiscounts() }
                    )
                    .padding(.horizontal, 16)

                    // Input Amount Display
                    inputDisplay
                        .padding(.horizontal, 16)
                }
                .padding(.vertical, 16)
            }

            // Numeric Keypad (fixed at bottom)
            keypadSection
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            viewModel.setModelContext(modelContext)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "storefront")
                    .foregroundStyle(AppTheme.primary)
                Text("Retail POS")
                    .font(.headline.weight(.bold))
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
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
                                ? Color(.systemBackground)
                                : Color.clear
                        )
                        .foregroundStyle(
                            viewModel.state.taxMethod == method
                                ? AppTheme.primary
                                : .secondary
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(
                            color: viewModel.state.taxMethod == method
                                ? .black.opacity(0.05)
                                : .clear,
                            radius: 2, y: 1
                        )
                }
            }
        }
        .padding(4)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Input Display

    private var inputDisplay: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text("入力金額")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .tracking(2)

            Text(viewModel.state.inputPrice.commaFormatted)
                .font(.system(size: 52, weight: .ultraLight))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.vertical, 8)
    }

    // MARK: - Keypad Section

    private var keypadSection: some View {
        VStack(spacing: 0) {
            NumericKeypad(
                onDigit: { viewModel.tapDigit($0) },
                onDoubleZero: { viewModel.tapDoubleZero() },
                onBackspace: { viewModel.tapBackspace() },
                onClear: { viewModel.tapClear() },
                onEquals: {
                    viewModel.saveToHistory()
                    viewModel.tapAllClear()
                }
            )
            .padding(.vertical, 16)
        }
        .background(Color(.systemBackground))
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 40,
                topTrailingRadius: 40
            )
        )
        .shadow(color: .black.opacity(0.05), radius: 10, y: -5)
    }
}
