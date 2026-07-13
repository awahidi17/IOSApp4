//
//  iOSApp4App.swift
//  iOSApp4
//
//  Created by Ahmad Wahidi on 2026-07-13.
//
//  App entry point. Creates the shared FitnessViewModel and injects it
//  into the environment so every view down the hierarchy can read and
//  mutate workout state without manual prop-drilling.
//

import SwiftUI

@main
struct iOSApp4: App {
    // Single source of truth for all workout data.
    // @StateObject keeps the view model alive for the app's lifetime.
    @StateObject private var viewModel = FitnessViewModel()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(viewModel)
        }
    }
}
