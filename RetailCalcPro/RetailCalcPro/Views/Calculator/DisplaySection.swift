import SwiftUI

struct DisplaySection: View {
    let result: TaxCalculator.CalculationResult
    let taxMethod: TaxMethod

    var body: some View {
        VStack(spacing: 12) {
            // Tax Method Toggle
            taxMethodToggle

            // Calculation Summary Card
            calculationCard
        }
    }

    private var taxMethodToggle: some View {
        HStack(spacing: 0) {
            ForEach(TaxMethod.allCases, id: \.self) { method in
                Button {
                    // Handled by parent
                } label: {
                    Text(method.label)
                        .font(.subheadline.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            taxMethod == method
                                ? AnyShapeStyle(Color.white)
                                : AnyShapeStyle(Color.clear)
                        )
                        .foregroundStyle(
                            taxMethod == method
                                ? AppTheme.primary
                                : Color.secondary
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(
                            color: taxMethod == method ? .black.opacity(0.05) : .clear,
                            radius: 2, y: 1
                        )
                }
            }
        }
        .padding(4)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .allowsHitTesting(false) // Parent handles this
    }

    private var calculationCard: some View {
        VStack(spacing: 10) {
            // 参考価格
            HStack {
                Text(taxMethod == .exclusive ? "参考価格 (税抜)" : "参考価格 (税込)")
                    .font(.caption.weight(.medium))
                    .textCase(.uppercase)
                    .tracking(1)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(result.inputPrice.yenFormatted)
                    .font(.callout.weight(.semibold))
            }

            // 消費税
            HStack {
                Text("消費税 (\(result.taxRate.label))")
                    .font(.caption.weight(.medium))
                    .textCase(.uppercase)
                    .tracking(1)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("+\(result.taxAmount.yenFormatted)")
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            // 割引額（割引がある場合）
            if result.totalDiscount > 0 {
                HStack {
                    Text("割引額")
                        .font(.caption.weight(.medium))
                        .textCase(.uppercase)
                        .tracking(1)
                        .foregroundStyle(.blue)
                    Spacer()
                    Text("-\(result.totalDiscount.yenFormatted)")
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(.blue)
                }
            }

            // 最終合計
            Divider()
                .frame(height: 1)
                .overlay(
                    Rectangle()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                        .foregroundStyle(Color(.systemGray4))
                )

            HStack(alignment: .bottom) {
                Text(taxMethod == .exclusive ? "最終合計 (税込)" : "最終合計 (税込)")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text(result.finalPrice.yenFormatted)
                    .font(.system(size: 36, weight: .black))
                    .foregroundStyle(AppTheme.primary)
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}
