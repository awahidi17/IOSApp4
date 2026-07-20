# AI Reflection — Assignment 8

## 1. How Did You Use AI in This Assignment?

- I used Claude to write the first version of most new features, but I treated it like a starting point, not a finished product. Nothing it gave me went into the repo until I had built it, run it, and understood what each part was doing.
- The prompt that worked best for me: instead of just asking "add 6 SwiftUI Cookbook features," I gave it my Assignment 7 project and told it to follow my existing structure (Models, ViewModels, Views/Components, Views/Modals). The first suggestion it gave me used a different folder layout and file naming, so I made it redo everything to match my MVVM setup. That kept the app feeling like one project instead of two glued together.
- One thing I chose NOT to use: it originally saved workouts to a JSON file with FileManager. I swapped that for UserDefaults JSON encoding because that's the pattern I already knew from my previous app and it's simpler for the small amount of data I'm storing.
- `Gauge` and `ShareLink` weren't covered in class yet, so before keeping them I read the relevant Cookbook sections and Apple's docs. For Gauge I wanted to know what `currentValueLabel` and the min/max labels actually control, because at first the AI code just looked like a magic block of closures to me.

## 2. How Did You Understand, Verify, and Adapt the Code?

- My verification loop was: build (Cmd+B), run on the iPhone 17 Pro simulator, then physically use the feature. I searched the list, swiped rows both directions, let the timer run to 0:00 to check the alert fires, toggled "show calories" in Settings and switched back to the Workouts tab to confirm the rows updated live.
- Both build failures this week were mine to figure out, and they taught me real things:
  - `autoconnect()` failed with "not available due to missing import of defining module 'Combine'". I assumed `import SwiftUI` covered timers — it doesn't. `Timer.publish` is a Combine API, so the file needs `import Combine`. Easy fix, but now I know SwiftUI and Combine are separate frameworks.
  - "Type 'ShapeStyle' has no member 'amber'" confused me because `.amber` worked fine in other places. Turns out `.foregroundStyle()` accepts any ShapeStyle, so Swift can't guess my custom color from `.amber` shorthand — it needed `Color.amber` spelled out. That one actually taught me something about how Swift's type inference resolves those dot-shorthand members.
- To understand data flow, I traced how the one `FitnessViewModel` gets created in `iOSApp4App` and injected with `.environmentObject()`, and why every tab, sheet, and pushed detail view can grab it with `@EnvironmentObject` without me passing it through initializers.

## 3. What Did You Learn or Get Better At Through This Work?

- The biggest thing that clicked: when to use which kind of state. This app ended up using all three side by side — `@State` for throwaway view stuff (search text, whether the sheet is open), `@AppStorage` for small settings that should survive relaunch (my name, the weekly goal), and `@Published` in the view model for the shared workout data. Before this I kind of guessed; now I can actually justify the choice.
- I got noticeably better at reading compiler errors instead of just googling the whole message. Both errors this week literally contained the answer once I slowed down and read them.
- What went well: keeping the MVVM structure consistent meant adding 7 features didn't turn the project into spaghetti, and the cross-feature stuff (Settings toggle changing the list rows) worked first try.
- What went badly: I typo'd a path, my `cd` silently failed, and I ran `git init` + `git add .` in my home directory — it started staging my entire computer. Nothing got committed, but I had to delete the stray `.git` folder. New personal rule: `pwd` before any git command, and actually read the output of `cd`.
