//
//  NotificationScheduler.swift
//  WakeUp
//
//  Created by Luke Albrecht on 26/6/2025.
//

import Foundation
import UserNotifications

struct NotificationScheduler {
    
    // Request notification permissions (should be called once early in app lifecycle)
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Permission error: \(error.localizedDescription)")
            } else {
                print(granted ? "Notification permission granted." : "Notification permission denied.")
            }
        }
    }
    
    // Schedule a notification at a specific date with a custom sound
    static func scheduleAlarm(at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "⏰ Alarm"
        content.body = "Your alarm is going off!"
        content.sound = UNNotificationSound(named: UNNotificationSoundName("alarm.caf"))

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling alarm: \(error.localizedDescription)")
            } else {
                print("Alarm scheduled for \(date)")
            }
        }
    }
}
