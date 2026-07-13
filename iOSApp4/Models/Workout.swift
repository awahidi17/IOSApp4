//
//  Workout.swift
//  iOSApp4
//
//  Created by Ahmad Wahidi on 2026-07-13.
//
//  Data entities: the WorkoutType category enum and the Workout
//  session struct, plus sample data used to seed the app on
//  first launch so lists, search, and charts render immediately.
//

import Foundation

// MARK: - Workout Category

/// The categories of exercise a user can log.
/// CaseIterable lets Pickers enumerate all cases automatically.
enum WorkoutType: String, Codable, CaseIterable, Identifiable {
    case running = "Running"
    case cycling = "Cycling"
    case strength = "Strength"
    case yoga = "Yoga"
    case swimming = "Swimming"

    var id: String { rawValue }

    /// SF Symbol used for this type throughout the UI.
    var symbol: String {
        switch self {
        case .running:  return "figure.run"
        case .cycling:  return "bicycle"
        case .strength: return "dumbbell"
        case .yoga:     return "figure.mind.and.body"
        case .swimming: return "figure.pool.swim"
        }
    }
}

// MARK: - Workout Session Entity

/// One logged workout session.
/// - Identifiable: required for SwiftUI Lists/ForEach.
/// - Codable: enables JSON persistence via UserDefaults.
struct Workout: Identifiable, Codable, Equatable {
    var id = UUID()
    var type: WorkoutType
    var title: String
    var minutes: Int          // session duration
    var calories: Int         // estimated calories burned
    var date: Date
    var isFavorite: Bool = false

    /// Seed data for first launch.
    static let sampleData: [Workout] = [
        Workout(type: .running, title: "Morning 5K", minutes: 28, calories: 320,
                date: .now),
        Workout(type: .strength, title: "Upper Body Push", minutes: 45, calories: 280,
                date: .now.addingTimeInterval(-86400 * 1)),
        Workout(type: .yoga, title: "Sunrise Flow", minutes: 30, calories: 110,
                date: .now.addingTimeInterval(-86400 * 2), isFavorite: true),
        Workout(type: .cycling, title: "River Trail Ride", minutes: 60, calories: 540,
                date: .now.addingTimeInterval(-86400 * 3)),
        Workout(type: .swimming, title: "Lap Swim", minutes: 40, calories: 380,
                date: .now.addingTimeInterval(-86400 * 4)),
        Workout(type: .running, title: "Interval Sprints", minutes: 22, calories: 290,
                date: .now.addingTimeInterval(-86400 * 5), isFavorite: true),
        Workout(type: .strength, title: "Leg Day", minutes: 50, calories: 330,
                date: .now.addingTimeInterval(-86400 * 6))
    ]
}
