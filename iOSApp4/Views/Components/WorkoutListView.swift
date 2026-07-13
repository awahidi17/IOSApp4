//
//  WorkoutListView.swift
//  iOSApp4
//
//  Created by Ahmad Wahidi on 2026-07-13.
//
//  The main workout log.
//
//  ★ FEATURE 2 — Searchable list (.searchable modifier).
//  ★ FEATURE 3 — Swipe actions (.swipeActions modifier).
//  ★ FEATURE 4 — Context menus (.contextMenu modifier).
//  ★ FEATURE 5 — Modal sheet presentation (.sheet, see AddWorkoutModalView).
//  (SwiftUI Cookbook chapters on Lists, Navigation & Modal Presentation.)
//

import SwiftUI

struct WorkoutListView: View {
    // Shared view model injected from iOSApp4App.
    @EnvironmentObject var viewModel: FitnessViewModel

    // FEATURE 2: text bound to the native search field.
    @State private var searchText = ""

    // FEATURE 5: controls presentation of the "log workout" sheet.
    @State private var showingAddModal = false

    /// Workouts filtered by the current search text — matches
    /// against title or workout type name, case-insensitively.
    private var filteredWorkouts: [Workout] {
        guard !searchText.isEmpty else { return viewModel.workouts }
        return viewModel.workouts.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.type.rawValue.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredWorkouts) { workout in
                    WorkoutRowCard(workout: workout)
                        // FEATURE 3: trailing swipe deletes,
                        // leading swipe toggles favorite.
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewModel.delete(workout)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                viewModel.toggleFavorite(workout)
                            } label: {
                                Label("Favorite", systemImage: "star")
                            }
                            .tint(Color.amber)
                        }
                        // FEATURE 4: long-press menu mirrors the swipe
                        // actions for discoverability.
                        .contextMenu {
                            Button {
                                viewModel.toggleFavorite(workout)
                            } label: {
                                Label(workout.isFavorite ? "Unfavorite" : "Favorite",
                                      systemImage: workout.isFavorite ? "star.slash" : "star")
                            }
                            Button(role: .destructive) {
                                viewModel.delete(workout)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .navigationTitle("Workouts")
            // FEATURE 2: native search bar attached to the list.
            .searchable(text: $searchText, prompt: "Search workouts")
            .toolbar {
                // "+" button opens the log-workout modal.
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddModal = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            // FEATURE 5: modal sheet containing an input Form.
            .sheet(isPresented: $showingAddModal) {
                AddWorkoutModalView()
            }
        }
    }
}

// MARK: - Row Card Component

/// A single row: themed icon, title, session details, favorite star.
struct WorkoutRowCard: View {
    let workout: Workout

    /// Per-type theme drives the icon gradient.
    private var theme: AppTheme { AppTheme.current(for: workout.type) }

    var body: some View {
        HStack(spacing: 12) {
            // Type icon inside a theme-gradient circle.
            Image(systemName: workout.type.symbol)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(Circle().fill(theme.iconGradient))

            VStack(alignment: .leading, spacing: 2) {
                Text(workout.title)
                    .font(.headline)
                Text("\(workout.type.rawValue) • \(workout.minutes) min • \(workout.calories) cal")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(workout.date, style: .date)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            // Star indicator for favorited sessions.
            if workout.isFavorite {
                Image(systemName: "star.fill")
                    // Explicit Color.amber — .foregroundStyle takes a generic
                    // ShapeStyle, so custom Color members need the full name.
                    .foregroundStyle(Color.amber)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    WorkoutListView()
        .environmentObject(FitnessViewModel())
}
