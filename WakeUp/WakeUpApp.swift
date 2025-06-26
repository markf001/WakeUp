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
            }
        }
    }
}
