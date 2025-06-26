//
//  AlarmFullScreenView.swift
//  WakeUp
//
//  Created by Luke Albrecht on 26/6/2025.
//

import SwiftUI
import AVFoundation
import AudioToolbox

struct AlarmFullScreenView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        ZStack {
            Color.red.opacity(0.9)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                Text("⏰ ALARM ⏰")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("Time to wake up or check in!")
                    .font(.title3)
                    .foregroundColor(.white)

                Button(action: {
                    stopAlarmSound()
                    dismiss()
                }) {
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
            .padding()
        }
        .onAppear {
            playAlarmSound()
            triggerVibration()
        }
        .onDisappear {
            stopAlarmSound()
        }
    }

    // MARK: - Sound & Vibration

    private func playAlarmSound() {
        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "caf") else {
            print("Alarm sound file not found.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // Loop until manually stopped
            audioPlayer?.play()
        } catch {
            print("Error playing alarm sound: \(error.localizedDescription)")
        }
    }

    private func stopAlarmSound() {
        audioPlayer?.stop()
        audioPlayer = nil
    }

    private func triggerVibration() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
