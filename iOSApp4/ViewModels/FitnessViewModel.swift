//
//  FitnessViewModel.swift
//  iOSApp4
//
//  Created by Ahmad Wahidi on 2026-07-13.
//
//  MVVM view model: owns the workout list, exposes CRUD operations,
//  and persists everything as JSON in UserDefaults (mirrors the
//  SwiftUI Cookbook persistence pattern).
//

import Foundation
import Combine

class FitnessViewModel: ObservableObject {
    // MARK: - Published UI States

    /// Full list of logged workouts. Any mutation triggers
    /// an automatic save (didSet) and a UI refresh (@Published).
    @Published var workouts: [Workout] = [] {
        didSet { saveWorkouts() }
    }

    // MARK: - Internal Properties

    private let userDefaultsKey = "fitness_saved_workouts"

    init() {
        loadWorkouts()
    }

    // MARK: - CRUD Operations

    /// Insert a new workout at the top of the list.
    func add(_ workout: Workout) {
        workouts.insert(workout, at: 0)
    }

    /// Delete by id — swipe/context actions may operate on a *filtered*
    /// list, so index-based removal against the master array is unsafe.
    func delete(_ workout: Workout) {
        workouts.removeAll { $0.id == workout.id }
    }

    /// Toggle the favorite flag on a specific workout.
    func toggleFavorite(_ workout: Workout) {
        guard let index = workouts.firstIndex(where: { $0.id == workout.id }) else { return }
        workouts[index].isFavorite.toggle()
    }

    /// Wipe all logged data and restore the sample workouts.
    /// Called from Settings after the user confirms the reset dialog.
    func resetToSamples() {
        workouts = Workout.sampleData
    }

    // MARK: - Derived Stats (used by the Stats dashboard)

    /// Total minutes across all logged workouts.
    var totalMinutes: Int { workouts.reduce(0) { $0 + $1.minutes } }

    /// Total estimated calories across all logged workouts.
    var totalCalories: Int { workouts.reduce(0) { $0 + $1.calories } }

    /// Workouts from the last 7 days, oldest first — chart input.
    var lastWeek: [Workout] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -7, to: .now)!
        return workouts
            .filter { $0.date >= cutoff }
            .sorted { $0.date < $1.date }
    }

    // MARK: - Persistence (UserDefaults JSON serialization)

    /// Encode the array to JSON and store it in UserDefaults.
    private func saveWorkouts() {
        if let data = try? JSONEncoder().encode(workouts) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }

    /// Load saved workouts; fall back to sample data on first launch.
    private func loadWorkouts() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([Workout].self, from: data) {
            workouts = decoded
        } else {
            workouts = Workout.sampleData
        }
    }
}
