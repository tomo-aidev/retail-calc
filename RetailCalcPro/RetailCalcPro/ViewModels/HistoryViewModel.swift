import Foundation
import SwiftData

@MainActor
@Observable
final class HistoryViewModel {
    enum FilterType: String, CaseIterable {
        case all = "すべて"
        case tax = "税計算"
        case discount = "割引"
    }

    var selectedFilter: FilterType = .all

    func filteredHistory(_ histories: [CalculationHistory]) -> [CalculationHistory] {
        switch selectedFilter {
        case .all:
            return histories
        case .tax:
            return histories.filter { $0.category == .taxOnly || $0.category == .both }
        case .discount:
            return histories.filter { $0.category == .discountOnly || $0.category == .both }
        }
    }

    func deleteHistory(_ history: CalculationHistory, context: ModelContext) {
        context.delete(history)
        try? context.save()
    }

    func deleteAllHistory(context: ModelContext) {
        do {
            try context.delete(model: CalculationHistory.self)
            try context.save()
        } catch {
            // Silent fail - history deletion is non-critical
        }
    }

    func relativeDate(for date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "昨日"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd"
            return formatter.string(from: date)
        }
    }

    func fullDate(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: date)
    }
}
