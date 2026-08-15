# CLAUDE.md — Kemika

This file orients a fresh Claude Code session working on this repo. Read
`CONSTITUTION.md` and `TODO.md` too — this file is "how to work here," those two are
"what this project is and what's left."

## What this is

A Flutter 2D mobile game (iOS + Android) teaching analytical chemistry through hands-on
lab interaction. Full context: `CONSTITUTION.md` § 1. Stack note: this started as a
Unity/C# scaffold and was rebuilt on Flutter/Dart before any real Unity work happened —
see `CONSTITUTION.md` § 3 for why. There is no Unity content left in this repo.

## The one rule that overrides every other design instinct

**Law 1 — "No result without action."** Before adding any feature that reveals a color,
precipitate, value, or piece of chemistry information to the player: trace exactly which
manual player action causes it. If you can't point to a drag/drip/pour/observe/record
action that directly and exclusively triggers it, the feature is wrong as designed, not
just as implemented. In Flutter this is easy to violate by accident with a
`TweenAnimationBuilder` that starts on `initState()` or a value that's just set from
`build()` — actively resist that. `PracticeModeController.addDrop()` and
`.recordObservation()` must stay the only paths that change reaction state, and both
must only ever be called from an actual gesture callback (`DragTarget`, a button's
`onPressed`), never automatically.

## Architecture map

See `CONSTITUTION.md` § 4 for the full breakdown. Short version:

- `lib/data/` — plain immutable data classes: `IonSpecies`, `Reagent`, `Reaction`.
- `lib/modes/` — `PracticeModeController` today. `ChallengeModeController` doesn't exist
  yet; don't add it before Practice Mode has real mastery-threshold tracking to gate it
  on (see `TODO.md`).
- `lib/l10n/` — `AppStrings`, a plain bilingual map (mirrors prayer-qibla-app's
  `app_strings.dart`). Add new UI text here, not as string literals in widget code.
- `lib/screens/` — `PracticeSliceScreen` is the only screen so far. It owns the
  `PracticeModeController` instance and calls `setState` from its callbacks — no
  external state management package, matching prayer-qibla-app's stated approach ("the
  app isn't big enough yet to justify one").

## Working conventions (mirrors prayer-qibla-app where applicable)

- **Repo docs (this file, `CONSTITUTION.md`, `TODO.md`, commit messages, code comments)
  are in English**, even if the working conversation with the user is in Arabic. Don't
  mix languages into project files. (User-facing in-game strings are the one deliberate
  exception — see `lib/l10n/app_strings.dart`.)
- **Git workflow: one branch per feature**, merged once verified (`flutter analyze` +
  `flutter test` green, CI passing on the PR). Don't commit directly to `main` as the
  default without the user asking for that explicitly.
- **Update `TODO.md` as soon as something is done** — move it into "Done," don't leave
  status ambiguous. Same for `CONSTITUTION.md` § "Settled feature decisions" whenever a
  design question gets resolved — don't make a future session re-litigate it.
- **Comments explain WHY, not WHAT.** A hidden constraint, a non-obvious Flutter gotcha,
  a workaround for a specific bug — not a restatement of the code.
- No default "AI-generated" look: no unexamined `Colors.deepPurple` seed color, no
  literal `Colors.black`/`Colors.white` text on backgrounds without checking contrast —
  same rule prayer-qibla-app enforces via `impeccable_flutter_lints` (not wired into
  this repo yet, see `CONSTITUTION.md` § Known gaps — apply the same standard by eye
  until it is). Placeholder art for the prototype is fine and expected (see
  `CONSTITUTION.md` § 7) — placeholder *copy* is not.
- **Before pushing**: `flutter analyze` must be clean (`flutter test` isn't run yet —
  see `CONSTITUTION.md` § 7, no test files exist). CI (`.github/workflows/build.yml`)
  re-runs analyze plus a debug APK build on every push/PR — catching problems locally
  first is still cheaper than waiting on CI.
- **Testing UI changes without a device**: this project has no dedicated run-skill yet
  (worth generating one via `/run-skill-generator` if you do this again). The working
  recipe: add the web platform if not already present (`flutter create --platforms=web
  .`), then `flutter build web --no-web-resources-cdn` (plain `flutter run -d
  web-server` still hits a CDN and will fail in a network-restricted sandbox — see
  `CONSTITUTION.md` § 8), serve `build/web/` with any static server, and drive it with
  Playwright by screen coordinates + screenshots (not text selectors — CanvasKit has no
  real DOM text). Full details and the exact gotchas hit doing this: `CONSTITUTION.md`
  § 8 "Learnt lessons".

## Environment notes

- **No local Android/iOS SDK needed for anything except `flutter build ... --release`
  signing.** Debug + release APKs are built by GitHub Actions on every push to `main`
  (see `.github/workflows/build.yml`) and uploaded as workflow run artifacts — same
  pattern as prayer-qibla-app. If you only have the Flutter SDK locally (no Android
  Studio), `flutter analyze` still works fully offline.
- If Flutter itself isn't installed locally and you don't want to install it either: any
  change can be made, analyzed, and pushed from a cloud Claude Code session the same way
  this repo was originally scaffolded — clone the `flutter` SDK repo
  (`git clone https://github.com/flutter/flutter.git -b stable --depth 1`) into a
  scratch location, add its `bin/` to `PATH`, and run `flutter analyze`/`flutter test`
  from there. No Android/iOS toolchain is needed for that — only for actually building
  a signed release artifact, which CI handles.
