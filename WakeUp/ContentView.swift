//
//  ContentView.swift
//  WakeUp
//
//  Created by Mark Fernandez on 26/6/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedDate = Date()
    @State private var confirmationMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Set an Alarm")
                .font(.title)
                .padding(.top)

            DatePicker("Alarm Time", selection: $selectedDate, displayedComponents: [.hourAndMinute])
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())

            Button("Schedule Alarm") {
                var alarmDate = Calendar.current.date(
                    bySettingHour: Calendar.current.component(.hour, from: selectedDate),
                    minute: Calendar.current.component(.minute, from: selectedDate),
                    second: 0,
                    of: Date()
                ) ?? Date()

                // If selected time has already passed today, schedule for tomorrow
                if alarmDate < Date() {
                    alarmDate = Calendar.current.date(byAdding: .day, value: 1, to: alarmDate) ?? alarmDate
                }

                NotificationScheduler.scheduleAlarm(at: alarmDate)
                confirmationMessage = "Alarm scheduled for \(formattedDate(alarmDate))"
            }
            .buttonStyle(.borderedProminent)

            if !confirmationMessage.isEmpty {
                Text(confirmationMessage)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            NotificationScheduler.requestPermission()
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }
}


#Preview {
    ContentView()
}
