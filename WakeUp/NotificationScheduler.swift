import Foundation
import UserNotifications

struct NotificationScheduler {
    
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Permission error: \(error.localizedDescription)")
            } else {
                print(granted ? "Notification permission granted." : "Notification permission denied.")
            }
        }
    }

    static func scheduleAlarm(at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "⏰ Alarm"
        content.body = "Your alarm is going off!"
        content.sound = UNNotificationSound(named: UNNotificationSoundName("alarm.caf"))
        content.userInfo = ["alarm": true]

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling alarm: \(error.localizedDescription)")
            } else {
                print("Alarm scheduled for \(date)")
                UserDefaults.standard.set(date, forKey: "lastAlarmTime")
            }
        }
    }
}
