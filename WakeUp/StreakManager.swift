import Foundation
import SwiftData

struct StreakManager {
    static let streakKey = "streakCount"
    static let weekDaysKey = "weekDaysData"

    static func updateForDayCompletion(context: ModelContext, color: String) {
        let calendar = Calendar.current
        let now = Date()
        let weekday = calendar.component(.weekday, from: now)
        let weekdaySymbols = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
        let todaySymbol = weekdaySymbols[weekday - 1]

        // Load weekDays
        var weekDays: [DayStatus]
        if let savedData = UserDefaults.standard.data(forKey: weekDaysKey),
           let decoded = try? JSONDecoder().decode([DayStatus].self, from: savedData) {
            weekDays = decoded
        } else {
            weekDays = [
                DayStatus(name: "Mo", completed: false, color: "gray"),
                DayStatus(name: "Tu", completed: false, color: "gray"),
                DayStatus(name: "We", completed: false, color: "gray"),
                DayStatus(name: "Th", completed: false, color: "gray"),
                DayStatus(name: "Fr", completed: false, color: "gray")
            ]
        }

        // Load streak
        var streakCount = UserDefaults.standard.integer(forKey: streakKey)

        if let index = weekDays.firstIndex(where: { $0.name == todaySymbol }) {
            if !weekDays[index].completed {
                weekDays[index].completed = true
                weekDays[index].color = color
                if color != "gray" { streakCount += 1 }
                context.insert(CompletionData(date: now, color: color))

                // Save changes
                UserDefaults.standard.set(streakCount, forKey: streakKey)
                if let encoded = try? JSONEncoder().encode(weekDays) {
                    UserDefaults.standard.set(encoded, forKey: weekDaysKey)
                }
            }
        }
    }
}
