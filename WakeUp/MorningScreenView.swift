import SwiftUI
import SwiftData
import UserNotifications

struct MorningScreenView: View {
    @Environment(\.modelContext) private var context
    @Query private var entries: [CompletionData]

    @State private var weekDays: [DayStatus] = []
    @State private var streakCount = 0

    @State private var showAlarmSheet = false
    @State private var alarmTime: Date? = UserDefaults.standard.object(forKey: "lastAlarmTime") as? Date
    @State private var showAlarmFullScreen = false
    
    @State private var randomEmoji: String = "🙂"

    let streakKey = "streakCount"
    let weekDaysKey = "weekDaysData"
    let alarmTimeKey = "lastAlarmTime"

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.4)]),
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 24) {
                Text("Good Morning!")
                    .font(.system(size: 54, weight: .bold, design: .rounded))
                    .padding(.top, 40)

                Text(randomEmoji)
                    .font(.system(size: 200))

                VStack(spacing: 4) {
                    Text("\(streakCount)")
                        .font(.system(size: 60))
                        .fontWeight(.bold)
                    Text("day streak")
                        .font(.headline)
                        .foregroundColor(.primary)
                }

                HStack(spacing: 12) {
                    ForEach(weekDays, id: \.id) { day in
                        VStack(spacing: 4) {
                            Text(day.name)
                                .font(.caption)
                                .foregroundColor(.primary)
                            Circle()
                                .fill(buttonColor(for: day.color))
                                .frame(width: 50, height: 50)
                                .overlay(Circle().stroke(Color.gray.opacity(0.15), lineWidth: 1))
                        }
                    }
                }

                Spacer()

                // Alarm Button (opens sheet)
                Button(action: { handleWakeupCommit() }) {
                    HStack {
                        Image(systemName: "alarm")
                        if let time = alarmTime {
                            Text("Alarm set for \(formattedTime(time))")
                                .fontWeight(.semibold)
                        } else {
                            Text("Commit to morning!")
                                .fontWeight(.semibold)
                        }
                    }
                    .padding()
                    .foregroundColor(.black)
                    .background(Color(.systemGray5))
                    .clipShape(Capsule())
                }
            }
            .padding()
        }
        .onAppear {
            NotificationScheduler.requestPermission()
            loadData()
            evaluateAlarmCompletion()
            pickRandomEmoji()
            
            NotificationCenter.default.addObserver(forName: Notification.Name("ShowAlarmViewNotification"), object: nil, queue: .main) { _ in
                showAlarmFullScreen = true
                UserDefaults.standard.set(false, forKey: "ShowAlarmView")
            }
            if UserDefaults.standard.bool(forKey: "ShowAlarmView") == true {
                showAlarmFullScreen = true
                UserDefaults.standard.set(false, forKey: "ShowAlarmView")
            }
        }
        .sheet(isPresented: $showAlarmSheet, onDismiss: {
            // Refresh alarm time from UserDefaults
            alarmTime = UserDefaults.standard.object(forKey: alarmTimeKey) as? Date
            evaluateAlarmCompletion()
        }) {
            AlarmSheetView(isPresented: $showAlarmSheet, existingAlarm: alarmTime)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $showAlarmFullScreen) { AlarmFullScreenView() }
    }

    // MARK: - Alarm Evaluation
    func evaluateAlarmCompletion() {
        let calendar = Calendar.current
        let now = Date()
        let weekday = calendar.component(.weekday, from: now)
        let weekdaySymbols = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
        let todaySymbol = weekdaySymbols[weekday - 1]

        guard let alarmTime = UserDefaults.standard.object(forKey: alarmTimeKey) as? Date else { return }

        let minutesSinceAlarm = calendar.dateComponents([.minute], from: alarmTime, to: now).minute ?? 1000
        var color = "gray"

        if minutesSinceAlarm <= 15 {
            color = "green"
        } else if minutesSinceAlarm <= 30 {
            color = "yellow"
        } else {
            streakCount = 0
        }

        if let index = weekDays.firstIndex(where: { $0.name == todaySymbol }) {
            if !weekDays[index].completed {
                weekDays[index].completed = true
                weekDays[index].color = color
                if color != "gray" { streakCount += 1 }
                context.insert(CompletionData(date: now, color: color))
                saveData()
            }
        }
    }
    
    func handleWakeupCommit() {
        print("📱 Alarm button tapped. Current alarm time: \(alarmTime?.description ?? "None")")
        showAlarmSheet = true
    }

    func buttonColor(for colorName: String) -> Color {
        switch colorName {
        case "green": return .green
        case "yellow": return .yellow
        default: return Color.gray.opacity(0.3)
        }
    }

    func saveData() {
        UserDefaults.standard.set(streakCount, forKey: streakKey)
        if let encoded = try? JSONEncoder().encode(weekDays) {
            UserDefaults.standard.set(encoded, forKey: weekDaysKey)
        }
    }

    func loadData() {
        streakCount = UserDefaults.standard.integer(forKey: streakKey)

        if let savedData = UserDefaults.standard.data(forKey: weekDaysKey),
           let decoded = try? JSONDecoder().decode([DayStatus].self, from: savedData) {
            weekDays = decoded
        } else {
            weekDays = defaultWeekDays()
        }

        let today = Calendar.current.component(.weekday, from: Date())
        if today == 2 {
            weekDays = weekDays.map {
                DayStatus(name: $0.name, completed: false, color: "gray")
            }
            saveData()
        }
    }

    func defaultWeekDays() -> [DayStatus] {
        [
            DayStatus(name: "Mo", completed: false, color: "gray"),
            DayStatus(name: "Tu", completed: false, color: "gray"),
            DayStatus(name: "We", completed: false, color: "gray"),
            DayStatus(name: "Th", completed: false, color: "gray"),
            DayStatus(name: "Fr", completed: false, color: "gray")
        ]
    }
    
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    func sendTestNotification() {

        // Schedule a local notification
        let content = UNMutableNotificationContent()
        content.title = "Test Alarm"
        content.body = "This is a test notification alarm."
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "testAlarmNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling test notification: \(error.localizedDescription)")
            } else {
                print("Test notification scheduled!")
            }
        }
    }
    
    func pickRandomEmoji() {
        let allTags: [EmojiTag] = [.good, .bad, .better]
        if let tag = allTags.randomElement(),
           let emoji = EmojiStore().randomEmoji(for: tag) {
            randomEmoji = emoji
        }
    }
}

#Preview {
    MorningScreenView()
}
