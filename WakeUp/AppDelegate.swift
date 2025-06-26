//
//  AppDelegate.swift
//  WakeUp
//
//  Created by Luke Albrecht on 26/6/2025.
//

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // Handle notification tap
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let alarm = userInfo["alarm"] as? Bool, alarm == true {
            UserDefaults.standard.set(true, forKey: "ShowAlarmView")
            NotificationCenter.default.post(name: Notification.Name("ShowAlarmViewNotification"), object: nil)
        }
        
        completionHandler()
    }
}
