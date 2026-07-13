//
//  StatsDashboardView.swift
//  iOSApp4
//
//  Created by Ahmad Wahidi on 2026-07-13.
//
//  Activity dashboard.
//
//  ★ FEATURE 6 — Swift Charts (SwiftUI Cookbook: "Charts" chapter).
//  A BarMark chart of the last 7 days, switchable between minutes
//  and calories with a segmented Picker.
//

import SwiftUI
import Charts

struct StatsDashboardView: View {
    @EnvironmentObject var viewModel: FitnessViewModel

    /// Which metric the chart displays.
    enum Metric: String, CaseIterable, Identifiable {
        case minutes = "Minutes"
        case calories = "Calories"
        var id: String { rawValue }
    }

    @State private var metric: Metric = .minutes

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Summary cards for lifetime totals.
                    HStack(spacing: 16) {
                        SummaryCard(title: "Total Minutes",
                                    value: "\(viewModel.totalMinutes)",
                                    symbol: "clock.fill",
                                    color: .sky)
                        SummaryCard(title: "Total Calories",
                                    value: "\(viewModel.totalCalories)",
                                    symbol: "flame.fill",
                                    color: .coral)
                    }

                    // Segmented control to switch the charted metric.
                    Picker("Metric", selection: $metric) {
                        ForEach(Metric.allCases) { metric in
                            Text(metric.rawValue).tag(metric)
                        }
                    }
                    .pickerStyle(.segmented)

                    // FEATURE 6: bar chart of the last 7 days.
                    // Each bar is colored by workout type, producing
                    // stacked bars and an automatic legend.
                    Chart(viewModel.lastWeek) { workout in
                        BarMark(
                            x: .value("Day", workout.date, unit: .day),
                            y: .value(metric.rawValue,
                                      metric == .minutes ? workout.minutes : workout.calories)
                        )
                        .foregroundStyle(by: .value("Type", workout.type.rawValue))
                        .cornerRadius(4)
                    }
                    // Show weekday initials on the x-axis.
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { _ in
                            AxisGridLine()
                            AxisValueLabel(format: .dateTime.weekday(.narrow))
                        }
                    }
                    .frame(height: 240)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.secondarySystemBackground)))
                }
                .padding()
            }
            .navigationTitle("Stats")
        }
    }
}

// MARK: - Summary Card Component

/// Small stat tile showing a lifetime total with icon.
struct SummaryCard: View {
    let title: String
    let value: String
    let symbol: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: symbol)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.title.bold())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(RoundedRectangle(cornerRadius: 16)
            .fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    StatsDashboardView()
        .environmentObject(FitnessViewModel())
}
