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
    @Binding var isPresented: Bool
    @State private var audioPlayer: AVAudioPlayer?
    @State private var navigateToTestView = false

    var body: some View {
        NavigationStack {
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
                        navigateToTestView = true
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
            .navigationDestination(isPresented: $navigateToTestView) {
                TapGameView(isPresented: $isPresented)
            }
        }
    }

    // MARK: - Sound & Vibration

    private func playAlarmSound() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session: \(error)")
        }
        
        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "caf") else {
            print("Alarm sound file not found.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            print("Playing alarm sound...")
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
