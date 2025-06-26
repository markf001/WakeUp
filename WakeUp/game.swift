import SwiftUI
import SwiftData

struct TapSpot: Identifiable {
    let id = UUID()
    var position: CGPoint
    var isTapped: Bool = false
}

enum GameDestination: Hashable {
    case morning
}

struct TapGameView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    
    @State private var spots: [TapSpot] = []
    
    let spotSize: CGFloat = 70

    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.4)]),
                               startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                
                ForEach(spots) { spot in
                    Circle()
                        .fill(spot.isTapped ? Color.gray : Color.accentColor)
                        .frame(width: spotSize, height: spotSize)
                        .position(spot.position)
                        .onTapGesture {
                            handleTap(on: spot.id)
                        }
                        .animation(.easeInOut, value: spot.isTapped)
                }
                
                VStack {
                    Text("Press buttons to dismiss")
                        .font(.system(size: 48, weight: .bold))
                        .padding(.top, 20)
                    Spacer()
                    
                    if spots.allSatisfy({ $0.isTapped }) {
                        Button("Complete") {
                            completeGame()
                        }
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.teal, Color.blue]),
                                           startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 5)
                    }
                }
                
//                VStack {
//                    HStack {
//                        Spacer()
//                        Button("Close") {
//                            isPresented = false
//                        }
//                        .font(.headline)
//                        .padding()
//                    }
//                    Spacer()
//                }
                
            }
            .onAppear {
                generateSpots(in: geometry.size)
            }
        }
        
    }

    func generateSpots(in size: CGSize) {
        var newSpots: [TapSpot] = []
        let minDistance: CGFloat = spotSize * 1.5 // 1.5x spot size = spacing

        var attempts = 0

        while newSpots.count < 3 && attempts < 100 {
            let newPosition = randomPosition(in: size)
            let isFarEnough = newSpots.allSatisfy { existing in
                let dx = existing.position.x - newPosition.x
                let dy = existing.position.y - newPosition.y
                let distance = sqrt(dx * dx + dy * dy)
                return distance >= minDistance
            }

            if isFarEnough {
                newSpots.append(TapSpot(position: newPosition))
            }

            attempts += 1
        }

        spots = newSpots
    }


    func randomPosition(in size: CGSize) -> CGPoint {
        let padding: CGFloat = spotSize
        let titleSafeZone: CGFloat = 120 // Reserve space at top for "Tap Game" title
        let bottomSafeZone: CGFloat = padding * 2.5 // Reserve space at bottom for buttons

        let x = CGFloat.random(in: padding...(size.width - padding))
        let y = CGFloat.random(in: (titleSafeZone + padding)...(size.height - bottomSafeZone))

        return CGPoint(x: x, y: y)
    }


    func handleTap(on id: UUID) {
        if let index = spots.firstIndex(where: { $0.id == id }) {
            spots[index].isTapped = true
        }
    }

    private func completeGame() {
        updateForDayCompletion(context: modelContext, color: "green")
        isPresented = false
    }
}

struct TapGameView_Previews: PreviewProvider {
    static var previews: some View {
        TapGameView(isPresented: .constant(true))
    }
}

private func updateForDayCompletion(context: ModelContext, color: String) {
    let calendar = Calendar.current
    let now = Date()
    let weekday = calendar.component(.weekday, from: now)
    let weekdaySymbols = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    let todaySymbol = weekdaySymbols[weekday - 1]

    // Load weekDays
    var weekDays: [DayStatus]
    if let savedData = UserDefaults.standard.data(forKey: "weekDaysData"),
       let decoded = try? JSONDecoder().decode([DayStatus].self, from: savedData) {
        weekDays = decoded
    } else {
        weekDays = [
            DayStatus(name: "Mo", completed: false, color: "gray"),
            DayStatus(name: "Tu", completed: false, color: "gray"),
            DayStatus(name: "We", completed: false, color: "gray"),
            DayStatus(name: "Th", completed: false, color: "gray"),
            DayStatus(name: "Fr", completed: false, color: "gray")
        ]
    }

    // Load streak
    var streakCount = UserDefaults.standard.integer(forKey: "streakCount")

    if let index = weekDays.firstIndex(where: { $0.name == todaySymbol }) {
        if !weekDays[index].completed {
            weekDays[index].completed = true
            weekDays[index].color = color
            if color != "gray" { streakCount += 1 }
            context.insert(CompletionData(date: now, color: color))

            // Save changes
            UserDefaults.standard.set(streakCount, forKey: "streakCount")
            if let encoded = try? JSONEncoder().encode(weekDays) {
                UserDefaults.standard.set(encoded, forKey: "weekDaysData")
            }
        }
    }
}
