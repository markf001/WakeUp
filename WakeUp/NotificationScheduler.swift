import Foundation
import UserNotifications

struct NotificationScheduler {
    // Prefix used to identify repeating alarm notifications
    static let alarmNotificationPrefix = "repeatingAlarm-"
    static let repeatInterval: TimeInterval = 20 // 20 seconds
    static let repeatCount = 30 // Up to 10 minutes (adjust as needed)

    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Permission error: \(error.localizedDescription)")
            } else {
                print(granted ? "Notification permission granted." : "Notification permission denied.")
            }
        }
    }

    /// Schedules a series of notifications repeating every 20 seconds until cancelled.
    static func scheduleAlarm(at date: Date) {
        clearAlarmNotifications() // Remove old repeating notifications

        let content = UNMutableNotificationContent()
        content.title = "⏰ Alarm"
        content.body = "Your alarm is going off!"
        content.sound = UNNotificationSound(named: UNNotificationSoundName("alarm.caf"))
        content.userInfo = ["alarm": true]

        let center = UNUserNotificationCenter.current()
        let start = date
        for i in 0..<repeatCount {
            let fireDate = start.addingTimeInterval(TimeInterval(i) * repeatInterval)
            let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fireDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
            let identifier = "\(alarmNotificationPrefix)\(i)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling alarm #\(i): \(error.localizedDescription)")
                } else if i == 0 {
                    print("First alarm scheduled for \(fireDate)")
                }
            }
        }
        UserDefaults.standard.set(date, forKey: "lastAlarmTime")
    }

    /// Removes all repeating alarm notifications (called when user opens app or taps notification)
    static func clearAlarmNotifications() {
        let identifiers = (0..<repeatCount).map { "\(alarmNotificationPrefix)\($0)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
    }

    // Optional test alarm to trigger in 5 seconds
    static func scheduleTestAlarm() {
        let testDate = Date().addingTimeInterval(5)
        scheduleAlarm(at: testDate)
    }
}
