import SwiftUI
import SwiftData

struct MorningScreenView: View {
    @Environment(\.modelContext) private var context
    @Query private var entries: [CompletionData]

    @State private var weekDays: [DayStatus] = []
    @State private var streakCount = 0

    @State private var showAlarmSheet = false
    @State private var selectedTime = Date()

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
                    .font(.system(size: 54, weight: .bold))
                    .padding(.top, 40)

                Text("😃")
                    .font(.system(size: 200))

                VStack(spacing: 4) {
                    Text("\(streakCount)")
                        .font(.system(size: 60))
                        .fontWeight(.bold)
                    Text("day streak")
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.7))
                }

                HStack(spacing: 12) {
                    ForEach(weekDays, id: \.id) { day in
                        Text(day.name)
                            .frame(width: 50, height: 50)
                            .background(buttonColor(for: day.color))
                            .foregroundColor(.black)
                            .clipShape(Circle())
                    }
                }

                if let alarmTime = UserDefaults.standard.object(forKey: alarmTimeKey) as? Date {
                    Text("Alarm set for: \(alarmTime.formatted(date: .omitted, time: .shortened))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()

                // Alarm Button (opens sheet)
                Button("Set Alarm") {
                    showAlarmSheet = true
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(Capsule())
                .sheet(isPresented: $showAlarmSheet) {
                    VStack(spacing: 24) {
                        Text("Pick Your Alarm Time")
                            .font(.title2)
                            .bold()

                        DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .frame(height: 200)

                        Button("Confirm") {
                            NotificationScheduler.scheduleAlarm(at: selectedTime)
                            showAlarmSheet = false
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .clipShape(Capsule())

                        Button("Cancel") {
                            showAlarmSheet = false
                        }
                        .foregroundColor(.red)
                    }
                    .padding()
                    .presentationDetents([.height(350)])
                }
            }
            .padding()
        }
        .onAppear {
            NotificationScheduler.requestPermission()
            loadData()
            evaluateAlarmCompletion()
        }
    }

    // MARK: - Alarm Evaluation
    func evaluateAlarmCompletion() {
        let calendar = Calendar.current
        let now = Date()
        let weekday = calendar.component(.weekday, from: now)
        let weekdaySymbols = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
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
            DayStatus(name: "Mon", completed: false, color: "gray"),
            DayStatus(name: "Tue", completed: false, color: "gray"),
            DayStatus(name: "Wed", completed: false, color: "gray"),
            DayStatus(name: "Thu", completed: false, color: "gray"),
            DayStatus(name: "Fri", completed: false, color: "gray")
        ]
    }
}

struct MorningScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MorningScreenView()
    }
}
