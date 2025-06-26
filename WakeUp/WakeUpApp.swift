import UIKit
import SwiftUI
import SwiftData

@main
struct WakeUpApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

        var body: some Scene {
            WindowGroup {
                NavigationStack {
                MorningScreenView()
                    .fullScreenCover(isPresented: $showAlarmView) {
                        AlarmFullScreenView()
                            .onDisappear {
                                showAlarmView = false
                                UserDefaults.standard.set(false, forKey: "ShowAlarmView")
                            }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ShowAlarmViewNotification"))) { _ in
                        showAlarmView = true
                    }}
            }
            
        }
        .modelContainer(for: CompletionData.self)
    }
}
