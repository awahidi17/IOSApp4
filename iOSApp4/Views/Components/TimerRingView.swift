//
//  TimerRingView.swift
//  iOSApp4
//
//  Created by Ahmad Wahidi on 2026-07-13.
//
//  Interval workout timer.
//
//  ★ FEATURE 7 — Combine Timer publisher driving live UI updates
//    (SwiftUI Cookbook: "Timers" / Combine integration).
//  ★ FEATURE 8 — Custom animated progress ring: Circle().trim with an
//    AngularGradient and withAnimation (SwiftUI Cookbook: "Drawing &
//    Animation" chapters).
//

import SwiftUI
// Combine provides the Timer publisher and autoconnect() used below.
import Combine

struct TimerRingView: View {
    // MARK: - Timer State

    /// Selectable session lengths in minutes.
    private let durations = [1, 5, 10, 15, 20, 30]

    @State private var selectedMinutes = 5
    @State private var remainingSeconds = 5 * 60
    @State private var isRunning = false

    // ★ FEATURE 15 — Alert presentation (.alert modifier, SwiftUI
    // Cookbook: "Alerts & Action Sheets"). Shown when the countdown ends.
    @State private var showingDoneAlert = false

    // FEATURE 7: a Combine publisher that fires every second on the
    // main run loop. Views subscribe with .onReceive below.
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    /// Fraction of the session completed, drives the ring's trim.
    private var progress: Double {
        let total = Double(selectedMinutes * 60)
        return total > 0 ? 1 - Double(remainingSeconds) / total : 0
    }

    /// Remaining time formatted as MM:SS.
    private var timeLabel: String {
        String(format: "%02d:%02d", remainingSeconds / 60, remainingSeconds % 60)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                // Duration picker — disabled mid-session.
                Picker("Duration", selection: $selectedMinutes) {
                    ForEach(durations, id: \.self) { minutes in
                        Text("\(minutes) min").tag(minutes)
                    }
                }
                .pickerStyle(.segmented)
                .disabled(isRunning)
                // Reset the countdown when a new duration is chosen.
                .onChange(of: selectedMinutes) {
                    remainingSeconds = selectedMinutes * 60
                }

                // FEATURE 8: animated progress ring.
                ZStack {
                    // Background track.
                    Circle()
                        .stroke(Color(.systemGray5), lineWidth: 20)

                    // Foreground ring: trim() draws only the completed
                    // fraction; the angular gradient sweeps the circle.
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            AngularGradient(colors: [.sky, .emerald, .sky],
                                            center: .center),
                            style: StrokeStyle(lineWidth: 20, lineCap: .round)
                        )
                        // Start the ring at 12 o'clock instead of 3.
                        .rotationEffect(.degrees(-90))
                        // Animate every progress change smoothly.
                        .animation(.easeInOut(duration: 0.5), value: progress)

                    // Live countdown label in the middle.
                    VStack {
                        Text(timeLabel)
                            .font(.system(size: 52, weight: .bold, design: .rounded))
                            .monospacedDigit()
                        Text(isRunning ? "In session" : "Ready")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: 260, height: 260)
                .padding(.vertical)

                // Start/Pause and Reset controls.
                HStack(spacing: 20) {
                    Button {
                        isRunning.toggle()
                    } label: {
                        Label(isRunning ? "Pause" : "Start",
                              systemImage: isRunning ? "pause.fill" : "play.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    Button {
                        // Stop and restore the full duration.
                        isRunning = false
                        remainingSeconds = selectedMinutes * 60
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Timer")
            // FEATURE 7: react to each tick of the Combine publisher.
            .onReceive(timer) { _ in
                guard isRunning else { return }
                if remainingSeconds > 0 {
                    remainingSeconds -= 1
                } else {
                    // Session finished — stop and celebrate.
                    isRunning = false
                    showingDoneAlert = true
                }
            }
            // FEATURE 15: completion alert with a reset shortcut.
            .alert("Session Complete! 🎉", isPresented: $showingDoneAlert) {
                Button("New Session") {
                    remainingSeconds = selectedMinutes * 60
                }
                Button("OK", role: .cancel) {}
            } message: {
                Text("You finished your \(selectedMinutes)-minute session. Log it in the Workouts tab!")
            }
        }
    }
}

#Preview {
    TimerRingView()
}
