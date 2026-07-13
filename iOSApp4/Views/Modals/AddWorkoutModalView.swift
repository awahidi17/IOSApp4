//
//  AddWorkoutModalView.swift
//  iOSApp4
//
//  Created by Ahmad Wahidi on 2026-07-13.
//
//  Modal input form for logging a new workout.
//
//  ★ FEATURE 5 (continued) — Sheet + Form with Picker, Stepper and
//  DatePicker controls (SwiftUI Cookbook: "Modal Presentation" and
//  "Forms & Controls" chapters).
//

import SwiftUI

struct AddWorkoutModalView: View {
    @EnvironmentObject var viewModel: FitnessViewModel

    // Dismisses the sheet from code (Save / Cancel buttons).
    @Environment(\.dismiss) private var dismiss

    // MARK: - Local Form State
    @State private var title = ""
    @State private var type: WorkoutType = .running
    @State private var minutes = 30
    @State private var calories = 250
    @State private var date = Date()

    /// Disable Save until the user has entered a title.
    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    // Free-text session name.
                    TextField("Title (e.g. Morning 5K)", text: $title)

                    // Picker built automatically from WorkoutType.allCases.
                    Picker("Type", selection: $type) {
                        ForEach(WorkoutType.allCases) { type in
                            Label(type.rawValue, systemImage: type.symbol)
                                .tag(type)
                        }
                    }

                    // Session date/time.
                    DatePicker("Date", selection: $date)
                }

                Section("Effort") {
                    // Steppers for duration and calories.
                    Stepper("Duration: \(minutes) min", value: $minutes, in: 5...240, step: 5)
                    Stepper("Calories: \(calories) cal", value: $calories, in: 50...2000, step: 25)
                }
            }
            .navigationTitle("Log Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // Build the entity and hand it to the view model.
                        viewModel.add(Workout(type: type, title: title,
                                              minutes: minutes, calories: calories,
                                              date: date))
                        dismiss()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
}

#Preview {
    AddWorkoutModalView()
        .environmentObject(FitnessViewModel())
}
