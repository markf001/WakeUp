import SwiftUI

struct ContentView: View {
    @State private var showingAlarmSheet = false

    var body: some View {
        Button("Set Alarm") {
            showingAlarmSheet = true
        }
        .buttonStyle(.borderedProminent)
        .sheet(isPresented: $showingAlarmSheet) {
            AlarmSheetView(isPresented: $showingAlarmSheet)
                .presentationDetents([.medium]) // Halfway height sheet (iOS 16+)
                .presentationDragIndicator(.visible)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

