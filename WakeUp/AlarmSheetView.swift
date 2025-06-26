//
//  AlarmSheetView.swift
//  WakeUp
//
//  Created by Luke Albrecht on 26/6/2025.
//
import SwiftUI

struct AlarmSheetView: View {
    @Binding var isPresented: Bool
    @State private var selectedDate: Date
    @State private var confirmationMessage = ""

    init(isPresented: Binding<Bool>, existingAlarm: Date?) {
        _isPresented = isPresented
        _selectedDate = State(initialValue: existingAlarm ?? Date())
    }

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

                if alarmDate < Date() {
                    alarmDate = Calendar.current.date(byAdding: .day, value: 1, to: alarmDate) ?? alarmDate
                }

                print("⏰ Scheduling alarm for \(alarmDate)")
                NotificationScheduler.scheduleAlarm(at: alarmDate)
                UserDefaults.standard.set(alarmDate, forKey: "lastAlarmTime")
                confirmationMessage = "Alarm set for \(formattedDate(alarmDate))"
                isPresented = false
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
            print("🛠 Alarm sheet appeared. Pre-filled time: \(selectedDate)")
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

