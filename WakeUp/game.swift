import SwiftUI

struct TapSpot: Identifiable {
    let id = UUID()
    var position: CGPoint
    var isTapped: Bool = false
}

enum GameDestination: Hashable {
    case morning
}

struct TapGameView: View {
    @State private var spots: [TapSpot] = []
    @State private var path = NavigationPath()

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
                        Text("Tap Game")
                            .font(.system(size: 48, weight: .bold))
                            .padding(.top, 20)
                        Spacer()
                        
                        if spots.allSatisfy({ $0.isTapped }) {
                            Button("Complete") {
                                path.append(GameDestination.morning)
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
}

struct TapGameView_Previews: PreviewProvider {
    static var previews: some View {
        TapGameView()
    }
}
