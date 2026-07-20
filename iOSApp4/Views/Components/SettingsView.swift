//
//  SettingsView.swift
//  iOSApp4
//
//  Created by Ahmad Wahidi on 2026-07-13.
//
//  User preferences and weekly goal tracking.
//
//  ★ FEATURE 12 — @AppStorage persistence (SwiftUI Cookbook: "UserDefaults
//    & AppStorage"). Name, weekly goal, and display toggle survive
//    app relaunches automatically.
//  ★ FEATURE 13 — Gauge view (SwiftUI Cookbook: progress indicators).
//    Shows this week's minutes against the weekly goal.
//  ★ FEATURE 14 — Confirmation dialog (.confirmationDialog) guarding
//    the destructive "reset all data" action.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: FitnessViewModel

    // FEATURE 12: values stored directly in UserDefaults —
    // no manual save/load code needed.
    @AppStorage("user_name") private var userName = ""
    @AppStorage("weekly_goal_minutes") private var weeklyGoal = 150.0
    @AppStorage("show_calories") private var showCalories = true

    // FEATURE 14: controls the confirmation dialog's visibility.
    @State private var showingResetDialog = false

    /// Minutes logged in the last 7 days (from the view model).
    private var weekMinutes: Double {
        Double(viewModel.lastWeek.reduce(0) { $0 + $1.minutes })
    }

    var body: some View {
        NavigationStack {
            Form {
                // MARK: Profile
                Section("Profile") {
                    TextField("Your name", text: $userName)

                    // FEATURE 12: toggle persisted via @AppStorage;
                    // WorkoutRowCard reads it to show/hide calories.
                    Toggle("Show calories in list", isOn: $showCalories)
                }

                // MARK: Weekly Goal
                Section("Weekly Goal") {
                    // Goal slider: 30 min – 10 h per week.
                    VStack(alignment: .leading) {
                        Text("Target: \(Int(weeklyGoal)) min / week")
                            .font(.subheadline)
                        Slider(value: $weeklyGoal, in: 30...600, step: 15)
                    }

                    // FEATURE 13: gauge visualizing weekly progress.
                    Gauge(value: min(weekMinutes, weeklyGoal), in: 0...weeklyGoal) {
                        Text("Progress")
                    } currentValueLabel: {
                        Text("\(Int(weekMinutes)) min")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("\(Int(weeklyGoal))")
                    }
                    .tint(weekMinutes >= weeklyGoal ? Color.emerald : Color.sky)

                    // Friendly status line under the gauge.
                    Text(weekMinutes >= weeklyGoal
                         ? "Goal reached — nice work\(userName.isEmpty ? "" : ", \(userName)")! 🎉"
                         : "\(Int(weeklyGoal - weekMinutes)) min to go this week.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                // MARK: Data
                Section("Data") {
                    // FEATURE 14: destructive action guarded by a dialog.
                    Button("Reset All Data", role: .destructive) {
                        showingResetDialog = true
                    }
                    .confirmationDialog("Reset all workout data?",
                                        isPresented: $showingResetDialog,
                                        titleVisibility: .visible) {
                        Button("Restore Sample Workouts", role: .destructive) {
                            viewModel.resetToSamples()
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("This replaces all logged workouts with the sample data. This cannot be undone.")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(FitnessViewModel())
}
