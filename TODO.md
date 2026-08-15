# TODO — Kemika

Everything that needs doing, grouped by status. Update this file as soon as something is
done — move it into "Done" rather than leaving it ambiguous.

## Done ✅

- [x] Repo created (`ojgWeza/kemika`, public)
- [x] **Rebuilt on Flutter/Dart, replacing the initial Unity/C# scaffold**, before any
      real Unity work happened — the user doesn't want to install or personally operate
      a game-engine editor (limited local disk, prefers not to touch it directly), and
      already runs the exact same Flutter-with-no-local-Android-SDK-CI-builds-the-APK
      setup for `prayer-qibla-app`. See `CONSTITUTION.md` § 3 for the full reasoning.
      No Unity content remains in this repo.
- [x] Real Flutter project generated via `flutter create` (not hand-authored) —
      `pubspec.yaml`, `android/`, `ios/`, `analysis_options.yaml`, `.metadata` are all
      genuine Flutter-CLI output, so there's no fragile hand-guessed project config
      anywhere in this repo.
- [x] Core data model: `IonSpecies`, `Reagent`, `Reaction` (`lib/data/`)
- [x] `PracticeModeController` (`lib/modes/`) — drip → gradual reveal → record loop,
      enforces law 1 ("no result without action")
- [x] `AppStrings` (`lib/l10n/`) — bilingual AR/EN string map, same shape as
      prayer-qibla-app's `AppStrings`. Unlike the original Unity attempt, Arabic
      actually renders correctly here (Flutter has real bidi/RTL text shaping) — no
      follow-up work needed for that specifically.
- [x] **Vertical slice: chloride detection via AgNO3** (`lib/screens/practice_slice_screen.dart`).
      Drag the AgNO3 dropper onto the beaker 5 times (`Draggable`/`DragTarget`) → the
      beaker's color gradually lerps to white via `AnimatedContainer` → "Record
      Observation" button enables → a dialog with 4 multiple-choice descriptions
      (correct + 3 distractors) → correct choice reveals the balanced equation.
- [x] `flutter analyze` clean, no issues.
- [x] `.github/workflows/build.yml` — mirrors prayer-qibla-app's CI: `flutter analyze` +
      debug APK build on every push/PR, release APK build + upload on pushes to `main`.
      **You do not need Flutter, Android Studio, or an Android SDK installed anywhere to
      get a working APK out of this repo** — push to `main` (or open a PR) and download
      the built APK from that GitHub Actions run's artifacts.
- [x] Verified the CI build actually goes green on a real GitHub-hosted runner (not just
      locally): the first run failed because `flutter test` exits nonzero when `test/`
      has zero test files (git doesn't track empty directories, so the folder wasn't
      even present in the checkout) — removed the test step from CI rather than add a
      token test just to satisfy it, since "no tests yet" was a deliberate decision (see
      CONSTITUTION.md). Re-add the step when the first real test file lands.
- [x] `CLAUDE.md`, `CONSTITUTION.md`, `TODO.md`, `README.md` rewritten for the Flutter
      stack (all were originally written for Unity, before the pivot).

## In progress / needs attention right now 🔄

- [ ] Confirm the vertical slice actually feels right once played for real (drag
      responsiveness, gradual color reveal pacing, whether 5 drips is the right count).
      Since you don't want to install anything locally: either grab a built APK from the
      GitHub Actions artifacts and sideload it onto an Android phone, or ask a future
      session to make further adjustments based on your description of how it feels —
      this doesn't require you to run Flutter yourself either way.

## Not started yet 📋

### Before building past the vertical slice
- [ ] Confirm the vertical slice's feel is right (see above) before starting any of the
      below — per the agreed "one full lesson end-to-end before touching Kemidex,
      Challenge Mode, or other elements" approach.

### Core systems (deliberately deferred until the slice is validated)
- [ ] `StudentProfile` / `KemidexEntry` — persistent per-element progress stage, attempt
      history (the current `PracticeModeController.attempts` list is per-session/
      in-memory only, not persisted — prayer-qibla-app uses `SharedPreferences` via a
      `PrefsService` for its local persistence; the same approach fits here)
- [ ] Kemidex UI — 3-stage collectible card (Discovered / Mastered / Fully Mastered),
      visual-fidelity-as-reward system
- [ ] `ChallengeModeController` — timed recall mode, gated on a Practice Mode mastery
      threshold per ion (mastery threshold logic doesn't exist yet either)
- [ ] Protagonist system — both scripted-mistake moments (authored, tied to specific
      lessons) and ambient random incidents (untied to player performance). Two
      genuinely separate systems; don't conflate them.
- [ ] Social layer — opt-in profile/collection sharing, friend Kemidex comparison
- [ ] Real DOS-pixel art, replacing the current flat-color placeholder shapes
- [ ] More ions/reagents beyond chloride + AgNO3

### Known gaps to resolve before they block something
- [ ] `impeccable_flutter_lints` + `custom_lint` (prayer-qibla-app's "AI-slop UI"
      design-lint tooling) isn't wired into this repo's CI yet. Worth adding once the UI
      surface grows past one screen, for consistency with the sibling project.
- [ ] No real device testing yet — the "low-end-Android-friendly" device target is a
      stated goal, not yet verified against real hardware.

### Before any real release
- [ ] iOS build target: `flutter create` generated the `ios/` folder, but nothing
      iOS-specific has been tested or built (needs a macOS CI runner or a Mac; a Windows
      machine alone can't build/sign iOS apps — same constraint as any Flutter project)
- [ ] Real device testing on a low-end Android phone
- [ ] Decide on real backend infra for Challenge Mode's "vs friends" layer, once/if the
      local-mock version proves the feature is worth building for real
- [ ] Real app icon, app name/`applicationId` decision, Play Store listing — all still
      using Flutter's defaults from `flutter create`

## Notes

- Read `CONSTITUTION.md` before starting any new work — it has the project rules
  (especially law 1: "no result without action") and the known-gaps/decision log.
- Every item here should pass `flutter analyze` + `flutter test` before being considered
  done (no `custom_lint` yet — see Known Gaps above).
