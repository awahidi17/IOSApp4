//
//  WorkoutDetailView.swift
//  iOSApp4
//
//  Created by Ahmad Wahidi on 2026-07-13.
//
//  Detail screen for a single workout, pushed from the list.
//
//  ★ FEATURE 9  — NavigationLink push navigation (SwiftUI Cookbook:
//    "Navigation" chapter). Opened by tapping a row in WorkoutListView.
//  ★ FEATURE 10 — LazyVGrid layout (SwiftUI Cookbook: "Grids" chapter).
//    A two-column grid of metric tiles.
//  ★ FEATURE 11 — ShareLink (SwiftUI Cookbook: sharing content).
//    Shares a text summary of the workout via the system share sheet.
//

import SwiftUI

struct WorkoutDetailView: View {
    @EnvironmentObject var viewModel: FitnessViewModel

    let workout: Workout

    /// Per-type theme for the header icon and accents.
    private var theme: AppTheme { AppTheme.current(for: workout.type) }

    /// FEATURE 10: two flexible columns for the metrics grid.
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    /// FEATURE 11: plain-text summary handed to the share sheet.
    private var shareSummary: String {
        "\(workout.title) — \(workout.type.rawValue), \(workout.minutes) min, " +
        "\(workout.calories) cal on \(workout.date.formatted(date: .abbreviated, time: .omitted)) 💪"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Large themed header icon.
                Image(systemName: workout.type.symbol)
                    .font(.system(size: 56))
                    .foregroundStyle(.white)
                    .frame(width: 120, height: 120)
                    .background(Circle().fill(theme.iconGradient))
                    .padding(.top)

                // Title + theme badge.
                VStack(spacing: 6) {
                    Text(workout.title)
                        .font(.title.bold())
                    Text(theme.name)
                        .font(.caption.bold())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(theme.badgeBg))
                        .foregroundStyle(theme.accentColor)
                }

                // FEATURE 10: metric tiles laid out in a LazyVGrid.
                LazyVGrid(columns: columns, spacing: 16) {
                    MetricTile(symbol: "clock.fill", label: "Duration",
                               value: "\(workout.minutes) min", color: .sky)
                    MetricTile(symbol: "flame.fill", label: "Calories",
                               value: "\(workout.calories) cal", color: .coral)
                    MetricTile(symbol: "calendar", label: "Date",
                               value: workout.date.formatted(date: .abbreviated, time: .omitted),
                               color: .emerald)
                    MetricTile(symbol: workout.isFavorite ? "star.fill" : "star",
                               label: "Favorite",
                               value: workout.isFavorite ? "Yes" : "No", color: .amber)
                }
                .padding(.horizontal)

                // Toggle favorite from the detail screen too.
                Button {
                    viewModel.toggleFavorite(workout)
                } label: {
                    Label(workout.isFavorite ? "Remove Favorite" : "Mark as Favorite",
                          systemImage: workout.isFavorite ? "star.slash" : "star")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .padding(.horizontal)

                Spacer()
            }
        }
        .navigationTitle(workout.type.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // FEATURE 11: system share sheet with the workout summary.
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: shareSummary) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
}

// MARK: - Metric Tile Component

/// One tile in the detail metrics grid.
struct MetricTile: View {
    let symbol: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: symbol)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 16)
            .fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    NavigationStack {
        WorkoutDetailView(workout: Workout.sampleData[0])
            .environmentObject(FitnessViewModel())
    }
}
