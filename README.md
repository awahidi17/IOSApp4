# FitTrack — Personal Fitness Tracker 🏃‍♂️📊

A native iOS application built with **SwiftUI** for logging workouts, visualizing weekly activity, and running interval timer sessions. Built as a progressive prototype following a modular **MVVM Layout Architecture**.

---

## ✨ SwiftUI Cookbook Features Implemented

Six+ new features from the *SwiftUI Cookbook* (Wenderlich, 2021, Kodeco) were applied to this custom app:

1. **TabView Navigation** (`AppRootView.swift`) — Three-tab layout (Workouts / Stats / Timer) forming the app's top-level structure.
2. **Searchable List** (`WorkoutListView.swift`) — `.searchable` modifier attaches a native search bar that filters workouts by title or type in real time.
3. **Swipe Actions** (`WorkoutListView.swift`) — Leading swipe toggles favorite, trailing swipe deletes, via `.swipeActions` on list rows.
4. **Context Menus** (`WorkoutListView.swift`) — Long-press any row for a `.contextMenu` mirroring the swipe actions.
5. **Modal Sheet + Form Controls** (`AddWorkoutModalView.swift`) — `.sheet` presentation containing a `Form` with `TextField`, `Picker`, `DatePicker`, and `Stepper` controls plus validation.
6. **Swift Charts** (`StatsDashboardView.swift`) — `BarMark` chart of the last 7 days, stacked and colored by workout type, switchable between minutes/calories with a segmented Picker.
7. **Combine Timer Publisher** (`TimerRingView.swift`) — `Timer.publish().autoconnect()` drives a live countdown via `.onReceive`.
8. **Custom Animated Progress Ring** (`TimerRingView.swift`) — `Circle().trim()` with an `AngularGradient` stroke, animated with implicit `.animation` on progress changes.

Data is persisted between launches via **UserDefaults JSON serialization** in the view model layer.

---

## 📂 Project Directory Roadmap

```text
📂 Core/
│   └── 📂 Extensions/
│       └── Theme.swift              # Per-workout-type themes & custom color palette
📂 Models/
│   └── Workout.swift                # WorkoutType enum + Workout entity + sample data
📂 ViewModels/
│   └── FitnessViewModel.swift       # CRUD operations, derived stats, JSON persistence
📂 Views/
│   ├── AppRootView.swift            # Master TabView layout container
│   ├── 📂 Components/
│   │   ├── WorkoutListView.swift    # Searchable log with swipe actions & context menus
│   │   ├── StatsDashboardView.swift # Swift Charts weekly activity dashboard
│   │   └── TimerRingView.swift      # Combine timer + animated gradient progress ring
│   └── 📂 Modals/
│       └── AddWorkoutModalView.swift # Sheet-presented input form
```

---

## ⚙️ Requirements & Installation

- Development Environment: Xcode 15+ / Swift 5.9+
- Deployment Target: iOS 17.0+
- Dependencies: Fully standalone — native SwiftUI, Charts, and Combine frameworks only.

Clone, open `iOSApp4.xcodeproj`, and run on any iPhone simulator.
