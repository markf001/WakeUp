import SwiftUI
import SwiftData

@main
struct WakeUpApp: App {
    var body: some Scene {
        WindowGroup {
            MorningScreenView()
        }
        .modelContainer(for: CompletionData.self)
    }
}
