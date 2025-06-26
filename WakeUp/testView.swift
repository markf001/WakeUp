import SwiftUI

struct MorningScreenView: View {
    var body: some View {
        ZStack {
            // Background
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.4)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 24) {
                // Title
                Text("Good Morning!")
                    .font(.system(size: 54, weight: .bold))
                    .fontWeight(.bold)
                    .padding(.top, 40)

                // Emoji
                Text("😃")
                    .font(.system(size: 200))
                    

                // Streak
                VStack(spacing: 4) {
                    Text("27")
                        .font(.system(size: 60))
                        .fontWeight(.bold)
                    Text("day streak")
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.7))
                }


                // Button
                Button(action: {
                    print("Alarm committed!")
                    // Add alarm setting logic here
                }) {
                    HStack {
                        Image(systemName: "alarm")
                        Text("Commit to morning!")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .foregroundColor(.black)
                    .background(Color(.systemGray5))
                    .clipShape(Capsule())
                }
                .padding(.bottom, 40)
            }
            .padding()
        }
    }
}

struct MorningScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MorningScreenView()
    }
}
