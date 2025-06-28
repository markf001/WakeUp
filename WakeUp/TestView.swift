import SwiftUI


struct TestView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 30) {
            Text("Hello, World!")
            Button(action: { dismiss() }) {
                Text("Dismiss Alarm")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .foregroundColor(.red)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
        }
    }
}
