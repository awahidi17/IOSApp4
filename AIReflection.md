# AI Reflection — Assignment 8

## 1. How Did You Use AI in This Assignment?

- I used AI (Claude) to generate most of the starting code for the new features, then reviewed and built it in Xcode myself. I kept the overall structure but had to fix and adjust things to get it compiling and working.
- Example prompt/process: I gave the AI my Assignment 7 project structure and asked it to add new SwiftUI Cookbook features "using similar code structure" so the new files would match my existing MVVM folders (Models / ViewModels / Views/Components / Views/Modals).
- Something I hit that wasn't covered in class yet: `Gauge` and `ShareLink`. I looked them up in the SwiftUI Cookbook chapters and Apple's docs to understand what the parameters (like `currentValueLabel` in Gauge) actually do before keeping them in my app.

## 2. How Did You Understand, Verify, and Adapt the Code?

- I verified everything by building and running in Xcode on the iPhone simulator after each change, and by actually using each feature (searching, swiping rows, running the timer to zero to trigger the alert, flipping the Settings toggle to see the list update).
- Two real fixes I had to make:
  - The timer view failed to build with "Instance method 'autoconnect()' is not available due to missing import of defining module 'Combine'" — I learned `Timer.publish` comes from the Combine framework, so I added `import Combine`.
  - "Type 'ShapeStyle' has no member 'amber'" — my custom color from `Theme.swift` couldn't be used with dot-shorthand in `.foregroundStyle()` because that modifier takes a generic `ShapeStyle`. Writing `Color.amber` explicitly fixed it, which taught me how Swift's type inference works with those shorthand members.
- I also traced how the `@EnvironmentObject` view model flows from the App struct into every tab so I understood why the sheet and detail views can access the same data without passing it manually.

## 3. What Did You Learn or Get Better At Through This Work?

- Biggest level-up: understanding how state flows in SwiftUI — the difference between `@State` (local view state like the search text), `@AppStorage` (small persisted settings), and an `ObservableObject` view model with `@Published` (shared app data). Seeing all three used side by side in one app finally made it click when to use which.
- I also got more comfortable reading compiler errors instead of panicking — both build failures this week were one-line fixes once I actually read what the error was saying.
- What went well: matching the new features into my existing MVVM structure went smoothly, and the app stayed organized as it grew.
- What didn't: I accidentally ran `git init` in my home folder instead of the project folder because the path was wrong, which almost staged my entire computer into a repo. Lesson learned — check `cd` actually worked (and what folder I'm in with `pwd`) before running git commands.
