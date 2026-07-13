//
//  AppRootView.swift
//  iOSApp4
//
//  Created by Ahmad Wahidi on 2026-07-13.
//
//  Master layout container.
//
//  ★ FEATURE 1 — TabView navigation (SwiftUI Cookbook: "Tab Bars").
//  Three tabs form the app's top-level structure: the workout log,
//  a stats dashboard, and an interval timer.
//

import SwiftUI

struct AppRootView: View {
    var body: some View {
        TabView {
            // Tab 1: searchable list of logged workouts
            WorkoutListView()
                .tabItem {
                    Label("Workouts", systemImage: "list.bullet")
                }

            // Tab 2: Swift Charts dashboard summarizing activity
            StatsDashboardView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }

            // Tab 3: countdown timer with animated progress ring
            TimerRingView()
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
        }
    }
}

#Preview {
    AppRootView()
        .environmentObject(FitnessViewModel())
}
