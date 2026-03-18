import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isPurchasing = false
    @State private var isRestoring = false
    @State private var errorMessage: String?

    // App Store Connect で登録する Product ID
    private let productID = "com.retailcalcpro.app.unlock"

    var body: some View {
        VStack(spacing: 0) {
            // ドラッグインジケーター
            Capsule()
                .fill(Color(.systemGray4))
                .frame(width: 40, height: 5)
                .padding(.top, 10)
                .padding(.bottom, 20)

            VStack(spacing: 24) {
                Spacer()

                // アプリアイコン
                RoundedRectangle(cornerRadius: 22)
                    .fill(AppTheme.exclusivePrimary)
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "plus.forwardslash.minus")
                            .font(.system(size: 36, weight: .medium))
                            .foregroundStyle(.white)
                    )

                // キャッチコピー
                VStack(spacing: 8) {
                    Text("全ての制限を解除")
                        .font(.system(size: 24, weight: .bold))

                    Text("消費税電卓・割引計算 Pro")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                }

                // 特徴
                HStack(spacing: 14) {
                    Image(systemName: "infinity")
                        .font(.title3)
                        .foregroundStyle(AppTheme.exclusivePrimary)
                        .frame(width: 36, height: 36)
                        .background(AppTheme.exclusivePrimary.opacity(0.1))
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 2) {
                        Text("1日の利用制限なし")
                            .font(.subheadline.weight(.semibold))
                        Text("何度でも計算が可能です")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                // 買い切りボタン
                VStack(spacing: 8) {
                    Button {
                        Task { await purchase() }
                    } label: {
                        VStack(spacing: 4) {
                            if isPurchasing {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("¥100 で購入")
                                    .font(.body.weight(.bold))
                                Text("買い切り・ずっと使える")
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppTheme.exclusivePrimary)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(isPurchasing)

                    // 購入を復元ボタン
                    Button {
                        Task { await restore() }
                    } label: {
                        if isRestoring {
                            ProgressView()
                                .tint(.secondary)
                        } else {
                            Text("購入を復元")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .disabled(isRestoring || isPurchasing)

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
        }
        .background(Color(.systemBackground))
        .presentationDetents([.medium])
    }

    // MARK: - StoreKit 購入処理

    private func purchase() async {
        isPurchasing = true
        errorMessage = nil

        do {
            let products = try await Product.products(for: [productID])
            guard let product = products.first else {
                errorMessage = "商品が見つかりません"
                isPurchasing = false
                return
            }

            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    // 購入成功 → 制限解除
                    await transaction.finish()
                    await MainActor.run {
                        PurchaseManager.shared.unlockPro()
                        dismiss()
                    }
                case .unverified:
                    errorMessage = "購入の検証に失敗しました"
                }
            case .userCancelled:
                break
            case .pending:
                errorMessage = "購入が保留中です"
            @unknown default:
                break
            }
        } catch {
            errorMessage = "購入エラー: \(error.localizedDescription)"
        }

        isPurchasing = false
    }

    private func restore() async {
        isRestoring = true
        errorMessage = nil

        let restored = await PurchaseManager.shared.restorePurchases()
        if restored {
            dismiss()
        } else {
            errorMessage = "復元できる購入が見つかりません"
        }

        isRestoring = false
    }
}
