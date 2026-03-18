import Foundation
import StoreKit

/// アプリ内課金の状態を管理
@MainActor
@Observable
final class PurchaseManager {
    static let shared = PurchaseManager()

    private static let purchasedKey = "isProUnlocked"
    private let productID = "com.retailcalcpro.app.unlock"

    private(set) var isProUnlocked: Bool = false

    private init() {
        isProUnlocked = UserDefaults.standard.bool(forKey: Self.purchasedKey)
    }

    /// アプリ起動時に呼び出す
    func startObserving() {
        Task {
            await checkExistingPurchases()
        }
        Task.detached {
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await transaction.finish()
                    await MainActor.run {
                        PurchaseManager.shared.unlockPro()
                    }
                }
            }
        }
    }

    /// Pro版をアンロック
    func unlockPro() {
        isProUnlocked = true
        UserDefaults.standard.set(true, forKey: Self.purchasedKey)
        print("[PurchaseManager] Pro版をアンロックしました")
    }

    /// 購入を復元
    func restorePurchases() async -> Bool {
        var restored = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.productID == productID {
                    unlockPro()
                    restored = true
                }
            }
        }
        return restored
    }

    /// 既存の購入を確認
    private func checkExistingPurchases() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.productID == productID {
                    await MainActor.run {
                        PurchaseManager.shared.unlockPro()
                    }
                }
            }
        }
    }
}
