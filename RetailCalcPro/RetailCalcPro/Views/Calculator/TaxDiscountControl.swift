import SwiftUI

struct TaxDiscountControl: View {
    let currentTaxRate: TaxRate
    let appliedDiscounts: [DiscountType]
    let discountPercentages: [Int]
    let onTaxRateChanged: (TaxRate) -> Void
    let onDiscountApplied: (DiscountType) -> Void
    let onClearDiscounts: () -> Void
    @State private var customPercentText = ""

    var body: some View {
        VStack(spacing: 12) {
            // Tax Rate Buttons
            taxRateButtons

            // Discount Buttons
            discountButtons

            // Applied discounts
            if !appliedDiscounts.isEmpty {
                appliedDiscountsList
            }
        }
    }

    private var taxRateButtons: some View {
        HStack(spacing: 8) {
            ForEach(TaxRate.allCases, id: \.self) { rate in
                Button {
                    onTaxRateChanged(rate)
                } label: {
                    Text(rate.label)
                        .font(.subheadline.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            currentTaxRate == rate
                                ? AppTheme.primary
                                : Color(.systemBackground)
                        )
                        .foregroundStyle(
                            currentTaxRate == rate
                                ? .white
                                : .secondary
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(
                                    currentTaxRate == rate
                                        ? Color.clear
                                        : Color(.systemGray4),
                                    lineWidth: 1
                                )
                        )
                        .shadow(
                            color: currentTaxRate == rate
                                ? AppTheme.primary.opacity(0.3)
                                : .clear,
                            radius: 4, y: 2
                        )
                }
            }
        }
    }

    private var discountButtons: some View {
        HStack(spacing: 8) {
            ForEach(discountPercentages, id: \.self) { pct in
                Button {
                    onDiscountApplied(.percentage(pct))
                } label: {
                    Text("\(pct)%")
                        .font(.caption.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            appliedDiscounts.contains(.percentage(pct))
                                ? Color.blue.opacity(0.1)
                                : Color(.systemBackground)
                        )
                        .foregroundStyle(
                            appliedDiscounts.contains(.percentage(pct))
                                ? .blue
                                : .secondary
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    appliedDiscounts.contains(.percentage(pct))
                                        ? Color.blue.opacity(0.3)
                                        : Color(.systemGray4),
                                    lineWidth: 1
                                )
                        )
                }
            }

            // Custom percentage input
            TextField("%", text: $customPercentText)
                .font(.caption.weight(.bold))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                .keyboardType(.numberPad)
                .onSubmit {
                    if let value = Int(customPercentText), value > 0, value <= 100 {
                        onDiscountApplied(.percentage(value))
                        customPercentText = ""
                    }
                }
        }
    }

    private var appliedDiscountsList: some View {
        HStack(spacing: 6) {
            ForEach(Array(appliedDiscounts.enumerated()), id: \.offset) { _, discount in
                Text(discount.label)
                    .font(.caption2.weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundStyle(.blue)
                    .clipShape(Capsule())
            }

            Spacer()

            Button {
                onClearDiscounts()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
    }
}
