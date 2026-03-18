import SwiftUI

struct HistoryItemRow: View {
    let history: CalculationHistory
    let viewModel: HistoryViewModel

    /// 税込 or 税抜 ラベル
    private var methodLabel: String {
        switch history.taxMethod {
        case .exclusive: return "税込"
        case .inclusive: return "税抜"
        }
    }

    /// 割引ラベル（例: "割引(10%)"）
    private var discountLabel: String? {
        guard let discount = history.discounts.first else { return nil }
        return "割引(\(discount.shortLabel))"
    }

    /// 時刻フォーマット（HH:mm）
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: history.createdAt)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // 1行目: 入力：¥1,700                    20:47
            HStack {
                Text("入力：\(history.inputPrice.yenFormatted)")
                    .font(.body.weight(.bold))
                Spacer()
                Text(timeString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // 2行目: 税込：¥1,309 消費税(10%) +¥119 割引(10%):-¥510
            HStack(spacing: 4) {
                Text("\(methodLabel)：\(history.finalPrice.yenFormatted)")
                    .font(.subheadline.weight(.bold))

                if history.taxAmount > 0 {
                    Text("消費税(\(history.taxRate.label))")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text("+\(history.taxAmount.yenFormatted)")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(AppTheme.exclusivePrimary)
                }

                if let discountLabel, history.totalDiscount > 0 {
                    Text("\(discountLabel):-\(history.totalDiscount.yenFormatted)")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.orange)
                }

                Spacer()
            }
        }
        .padding(.vertical, 4)
    }
}
