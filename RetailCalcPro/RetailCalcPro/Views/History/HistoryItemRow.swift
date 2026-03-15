import SwiftUI

struct HistoryItemRow: View {
    let history: CalculationHistory
    let viewModel: HistoryViewModel

    private var iconName: String {
        switch history.category {
        case .taxOnly: return "doc.text"
        case .discountOnly: return "tag"
        case .both: return "tag"
        case .none: return "cart"
        }
    }

    private var badgeColor: Color {
        switch history.category {
        case .taxOnly: return .green
        case .discountOnly: return .red
        case .both: return .orange
        case .none: return .gray
        }
    }

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(AppTheme.primary.opacity(0.1))
                    .frame(width: 48, height: 48)
                Image(systemName: iconName)
                    .foregroundStyle(AppTheme.primary)
                    .font(.title3)
            }

            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(history.finalPrice.yenFormatted)
                        .font(.body.weight(.bold))
                    Spacer()
                    Text(viewModel.relativeDate(for: history.createdAt))
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                        .tracking(1)
                }

                Text("元値: \(history.inputPrice.yenFormatted)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    Text(history.categoryLabel)
                        .font(.caption2.weight(.medium))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(badgeColor.opacity(0.1))
                        .foregroundStyle(badgeColor)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(badgeColor.opacity(0.2), lineWidth: 1)
                        )

                    Text(viewModel.fullDate(for: history.createdAt))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .italic()
                }
            }

            // Chevron
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(Color(.systemGray3))
        }
        .padding(16)
        .background(Color(.systemBackground))
    }
}
