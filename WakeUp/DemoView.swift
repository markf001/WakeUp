//
//  DemoView.swift
//  WakeUp
//
//  Created by Luke Albrecht on 26/6/2025.
//

import SwiftUI
import UserNotifications

struct DemoView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 32) {
            Text("Demo Mode")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            Button("Wake Up Late") {
                // Placeholder for late wake up logic
            }
            .buttonStyle(.borderedProminent)

            Button("Wake Up On Time") {
                // Placeholder for on time logic
            }
            .buttonStyle(.borderedProminent)
            
            Button("Send Alarm Notification Now") {
                NotificationScheduler.scheduleTestAlarm()
            }
            .buttonStyle(.bordered)

            Button("Dismiss Demo") {
                dismiss()
            }
            .foregroundColor(.red)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    DemoView()
}
