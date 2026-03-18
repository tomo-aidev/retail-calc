import Foundation

/// 1日の利用回数を管理するクラス
/// 「C（クリア）」で ¥0 に戻ったタイミングを「1回の利用」としてカウント
@MainActor
@Observable
final class UsageLimiter {
    static let shared = UsageLimiter()

    private static let dailyLimit = 10
    private static let usageCountKey = "dailyUsageCount"
    private static let usageDateKey = "dailyUsageDate"

    private(set) var todayUsageCount: Int = 0
    var showPaywall: Bool = false

    var isLimitReached: Bool {
        if PurchaseManager.shared.isProUnlocked { return false }
        return todayUsageCount >= Self.dailyLimit
    }

    var remainingCount: Int {
        if PurchaseManager.shared.isProUnlocked { return 999 }
        return max(0, Self.dailyLimit - todayUsageCount)
    }

    private init() {
        loadTodayUsage()
    }

    /// 利用回数をインクリメント
    @discardableResult
    func recordUsage() -> Bool {
        if PurchaseManager.shared.isProUnlocked { return true }

        loadTodayUsage()

        if todayUsageCount >= Self.dailyLimit {
            showPaywall = true
            return false
        }

        todayUsageCount += 1
        saveTodayUsage()
        return true
    }

    /// 入力開始時に制限をチェック
    func canUse() -> Bool {
        if PurchaseManager.shared.isProUnlocked { return true }

        loadTodayUsage()
        if todayUsageCount >= Self.dailyLimit {
            showPaywall = true
            return false
        }
        return true
    }

    private func loadTodayUsage() {
        let defaults = UserDefaults.standard
        let savedDate = defaults.string(forKey: Self.usageDateKey) ?? ""
        let today = Self.todayString()

        if savedDate == today {
            todayUsageCount = defaults.integer(forKey: Self.usageCountKey)
        } else {
            todayUsageCount = 0
            defaults.set(today, forKey: Self.usageDateKey)
            defaults.set(0, forKey: Self.usageCountKey)
        }
    }

    private func saveTodayUsage() {
        let defaults = UserDefaults.standard
        defaults.set(Self.todayString(), forKey: Self.usageDateKey)
        defaults.set(todayUsageCount, forKey: Self.usageCountKey)
    }

    private static func todayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: Date())
    }
}
