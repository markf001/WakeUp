import SwiftUI

struct MorningScreenView: View {
    @State private var showingAlarmSheet = false
    @State private var alarmTime: Date? = nil
    @State private var weekDays: [DayStatus] = []
    @State private var streakCount = 0

    let streakKey = "streakCount"
    let weekDaysKey = "weekDaysData"

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
                            .background(day.completed ? Color.green : Color.gray.opacity(0.3))
                            .foregroundColor(.black)
                            .clipShape(Circle())
                    }
                }

                

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
                
                .sheet(isPresented: $showingAlarmSheet) {
                    AlarmSheetView(isPresented: $showingAlarmSheet)
                        .presentationDetents([.medium]) // Halfway height sheet (iOS 16+)
                        .presentationDragIndicator(.visible)
                }
                .padding(.bottom, 40)
            }
            .padding()
        }
        .onAppear(perform: loadData)
    }

    func handleWakeupCommit() {
        showingAlarmSheet = true
//        let today = Calendar.current.component(.weekday, from: Date())
//        let weekdaySymbols = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
//        let todaySymbol = weekdaySymbols[today - 1]
//
//        if let index = weekDays.firstIndex(where: { $0.name == todaySymbol }) {
//            if !weekDays[index].completed {
//                weekDays[index].completed = true
//                streakCount += 1
//                saveData()
//                print("✅ Wake-up committed for \(todaySymbol)")
//            } else {
//                print("🟢 Already completed today")
//            }
//        }
    }

    func saveData() {
        // Save streak
        UserDefaults.standard.set(streakCount, forKey: streakKey)

        // Save weekDays as JSON
        if let encoded = try? JSONEncoder().encode(weekDays) {
            UserDefaults.standard.set(encoded, forKey: weekDaysKey)
        }
    }

    func loadData() {
        // Load alarm if set
        if let savedAlarmTime = UserDefaults.standard.object(forKey: "morningAlarmTime") as? Date {
            alarmTime = savedAlarmTime
        }

        
        // Load streak
        streakCount = UserDefaults.standard.integer(forKey: streakKey)

        // Load weekDays or use default
        if let savedData = UserDefaults.standard.data(forKey: weekDaysKey),
           let decoded = try? JSONDecoder().decode([DayStatus].self, from: savedData) {
            weekDays = decoded
        } else {
            weekDays = [
                DayStatus(name: "Mon", completed: false),
                DayStatus(name: "Tue", completed: false),
                DayStatus(name: "Wed", completed: false),
                DayStatus(name: "Thu", completed: false),
                DayStatus(name: "Fri", completed: false)
            ]
        }
    }
    
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct MorningScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MorningScreenView()
    }
}
