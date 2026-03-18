import SwiftUI

struct DisplaySection: View {
    let result: TaxCalculator.CalculationResult
    let taxMethod: TaxMethod
    let accent: Color

    var body: some View {
        VStack(spacing: 6) {
            // 割引額（割引がある場合のみ表示）
            if result.totalDiscount > 0 {
                HStack {
                    Text("割引額")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.orange)
                    Spacer()
                    Text("-\(result.totalDiscount.yenFormatted)")
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(.orange)
                }

                // 割引後金額
                HStack {
                    Text("割引後")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(result.priceAfterDiscount.yenFormatted)
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }

            // 消費税
            HStack {
                Text("消費税 (\(result.taxRate.label))")
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.secondary)
                Spacer()
                if taxMethod == .exclusive {
                    Text("+\(result.taxAmount.yenFormatted)")
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(accent.opacity(0.85))
                } else {
                    Text("-\(result.taxAmount.yenFormatted)")
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(accent.opacity(0.85))
                }
            }

            // 区切り線
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color(.separator))

            // 最終合計（両モード共通で「税込」表記）
            HStack(alignment: .bottom) {
                Text("税込")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text(result.finalPrice.yenFormatted)
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundStyle(accent)
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
