import SwiftUI

struct AlarmSetterView: View {
    @State private var selectedTime = Date()

    var body: some View {
        VStack(spacing: 24) {
            Text("Set Your Alarm")
                .font(.title)
                .bold()

            DatePicker("Pick a Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()

            Button("Set Alarm") {
                NotificationScheduler.scheduleAlarm(at: selectedTime)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .padding()
        .onAppear {
            NotificationScheduler.requestPermission()
        }
    }
}

struct AlarmSetterView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmSetterView()
    }
}
