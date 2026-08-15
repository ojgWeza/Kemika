# Project Constitution — Kemika

Read this file first before doing any work on this project. Its purpose is to stop us
from re-learning the same lessons or re-litigating decisions that are already settled.

## 1. What this app is

A mobile educational game (2D, iOS + Android) teaching **Analytical Chemistry**, aligned
with the Egyptian Thanaweya Amma curriculum but designed as a **complete standalone
learning tool** usable by anyone. Students learn qualitative/quantitative analytical
chemistry by *doing* lab actions themselves — dragging reagents, dripping titrant,
observing gradual color/precipitate changes — instead of memorizing result tables.

Curriculum alignment is the marketing/credibility entry point, not a scope limiter.
Content depth should not be artificially capped to match the syllabus.

## 2. Non-negotiable principles

1. **Law 1 — "No result without action."** No chemical result, color, precipitate, or
   piece of information may ever be revealed to the player except as the direct
   consequence of a manual action they performed (dragging a reagent, pouring,
   dripping/titrating, observing, recording an observation). This is a hard
   architectural constraint, not a suggestion. In code: `PracticeModeController.addDrop()`
   and `.recordObservation()` are the *only* places a reaction's state may change, and
   both only ever fire from a UI interaction (a `DragTarget.onAcceptWithDetails` or a
   button press) — never from a `Timer`, `initState()`, or any other automatic trigger.
2. **The protagonist is not a teacher.** An ordinary person of deliberately unclear
   identity/profession, who learns alongside the player, not above them.
   - **Scripted mode**: at specific, pre-planned curriculum moments, the protagonist
     makes an intentional "mistake" that reveals an important exceptional reaction or
     edge case, then learns from it on-screen alongside the player. Authored content
     tied to specific lessons. **Not built yet** — see TODO.md.
   - **Ambient mode**: separate, unrelated random comedic incidents (small
     explosions/mishaps) with NO scientific explanation and NO connection to player
     performance. Purely tonal ("everyone messes up, even me"). Must never be triggered
     by or reference player error. **Not built yet** — see TODO.md.
3. **Two distinct difficulty layers.**
   - **Practice Mode**: no score, full manual interaction loop (drag/pour/drip/observe/
     record). This is where actual learning happens.
   - **Challenge Mode**: timed, competitive (vs self / vs friends), built strictly on
     top of Practice Mode — an element/ion must hit a mastery threshold in Practice Mode
     before it unlocks in Challenge Mode. Tests fast recall, not new learning; reuses
     fast-recognition assets (e.g. a still image of the finished reaction) rather than
     the full slow interaction loop.
4. **Visual identity: DOS-like / deliberately primitive pixel art.** Visual fidelity of
   art assets improves incrementally as the player progresses/spends time — visual
   polish is itself a reward system, separate from any point score.
5. **Progression: the "Kemidex."** Each element/ion gets a collectible card with 3
   stages — Discovered (first Practice encounter, faded/sketch state), Mastered (only
   after passing Challenge Mode, full color — never just from exposure), and optionally
   Fully Mastered (recognized correctly in mixed/confounding contexts). Each card
   includes the ion's visual signature and a personal attempt log ("first discovered on
   attempt #4"). Social layer: opt-in profile/collection sharing and friend comparison.
   **Not built yet** — see TODO.md.
6. **No backend requirement for the prototype.** Challenge Mode's "vs friends" layer is
   mocked/local for now — no real multiplayer/leaderboard infra until the core loop is
   proven.

## 3. Tech stack (revised — read this if you remember an earlier Unity version)

This project was originally scaffolded on Unity/C#, then rebuilt on **Flutter/Dart**
before any real Unity work happened, because the user doesn't want to install or operate
a game-engine editor locally (limited disk, and prefers not to touch it directly) and
already has the exact Flutter toolchain set up for `prayer-qibla-app` (no local Android
SDK there either — CI builds the APK). Flutter also solves, for free, a real gap the
Unity version had: Unity's built-in UI `Text` component doesn't shape Arabic correctly,
while Flutter already renders Arabic/RTL correctly (proven in `prayer-qibla-app`). There
is no residual Unity content in this repo — the switch was total, not a dual-stack setup.

## 4. Architecture, briefly

```
lib/
  main.dart               — entry point, MaterialApp
  l10n/
    app_strings.dart       — bilingual (EN/AR) string map, same shape as
                              prayer-qibla-app's AppStrings: a plain Map, no code-gen
  data/
    ion_species.dart        — IonSpecies (id, names, category)
    reagent.dart             — Reagent (id, names, dropper tint color)
    reaction.dart             — Reaction (ion + reagent + required drip count + result +
                                 distractor descriptions for the record step)
  modes/
    practice_mode_controller.dart — PracticeModeController: drip -> gradual reveal ->
                                 record loop, enforces law 1. ChallengeModeController
                                 does not exist yet -- see TODO.md.
  screens/
    practice_slice_screen.dart — the vertical slice UI: Draggable dropper + DragTarget
                                 beaker (gradual color lerp via AnimatedContainer),
                                 record button, and a dialog-based multiple-choice
                                 observation picker
```

No external state management library (Provider/Riverpod/Bloc) — matches
prayer-qibla-app's stated reasoning: the app isn't big enough yet to justify one.
`PracticeModeController` exposes plain callbacks (`onProgressChanged`,
`onReadyToRecord`, `onAttemptRecorded`); the owning screen calls `setState` from them,
same shape as prayer-qibla-app's `home_shell.dart` owning state and passing it down.

No `StudentProfile`/`KemidexEntry` classes exist yet. `PracticeModeController` keeps a
per-session `AttemptRecord` list (attempt number, correct/incorrect, drops used) as the
seed of that future system, but persistent profile/Kemidex storage is deliberately
deferred until after the vertical slice proves the core interaction feel — see TODO.md.

## 5. Known gaps (flag, don't silently paper over)

- **No CLAUDE.md convention existed in prayer-qibla-app** (the sibling project this
  repo's conventions were copied from) — this repo's `CLAUDE.md` was written from
  scratch using Flutter/Dart best judgment, not copied from a prior example.
- **No `impeccable_flutter_lints`/`custom_lint`** (prayer-qibla-app's "AI-slop UI"
  design-lint tooling) is wired in here yet — not added since it wasn't explicitly
  asked for and this is still a single-screen prototype. Worth adopting once the UI
  surface grows, for consistency with the sibling project.
- **No real device testing yet.** The "low-end-Android-friendly" device target is a
  stated goal, not yet verified against real hardware — see TODO.md.

## 6. Open decisions

- Exact device floor for "low-end friendly" Android (needs profiling once the vertical
  slice is running on a real device).
- When to move Challenge Mode's "vs friends" layer off local mocks and onto real backend
  infra.

## 7. Settled feature decisions (don't re-litigate without new input)

- **Flutter/Dart, not Unity.** Settled after the initial Unity scaffold, before any real
  Unity work happened — see § 3 above for why. Do not suggest reverting to Unity without
  new input from the user.
- **Vertical slice first.** The chloride ion (Cl⁻) detected via AgNO3 (→ white AgCl
  precipitate) is the one fully-built lesson end-to-end before Kemidex, Challenge Mode,
  the protagonist system, or additional elements are touched.
- **Placeholder/programmer art for the prototype — but deliberately DOS/terminal-styled,
  not generic Material.** Beaker/dropper/precipitate are still flat `Container`/
  `AnimatedContainer` shapes (no real pixel art yet), but styled via
  `lib/theme/terminal_theme.dart`: black background, phosphor green, monospace,
  sharp corners, bracket-style buttons (`[ RECORD OBSERVATION ]`). The first version of
  this screen used default Material (rounded corners, default theme colors) and read as
  "unfinished placeholder" rather than "intentionally retro" — principle 4 calls for the
  DOS look on purpose, not by omission. Real pixel art replaces this incrementally
  later; reuse the `Terminal*` widgets for anything new in the meantime.
- **Bilingual (Arabic + English) from day one, architecturally, with a real in-app
  toggle** (the app bar's `[EN]`/`[AR]` chips in `PracticeSliceScreen`) — this isn't just
  stored strings anymore, it's actually switchable. Toggling also flips the whole
  layout's `Directionality` (RTL for Arabic), not just text alignment. Unlike the
  earlier Unity attempt, the underlying Flutter engine renders Arabic correctly (proven
  on a real device by prayer-qibla-app) — but see § 8 for a testing-environment caveat:
  this hasn't been visually confirmed shaped-correctly (vs. tofu boxes) from *this*
  repo's own sandbox yet, only asserted from the sibling project's precedent.
- **Low-end-Android-friendly** is the device baseline (Android 8+, low RAM/GPU); iOS is
  a secondary target. The DOS-pixel visual style (once real art lands) is a deliberate
  hedge against this — minimal GPU/fill-rate cost.
- **Testing**: no automated tests yet — added once the vertical slice proves the
  interaction "feel" is right, not before. CI (`flutter analyze` + debug APK build) is
  wired up regardless, so regressions in what does exist are still caught. `flutter
  test` is deliberately *not* in CI yet — it exits nonzero with zero test files present
  (confirmed the hard way: the first CI run failed on exactly this), so it goes back in
  the moment the first real test file lands, not before.
- **CI builds the APK, not your machine** — same as prayer-qibla-app. You don't need
  Android Studio, an Android SDK, or even a local Flutter install to get a working APK
  out of this repo; push to `main` (or open a PR) and download it from the GitHub
  Actions run's artifacts.

## 8. Learnt lessons

A living log. Add to this whenever something costs real time to figure out, so the next
session doesn't pay the same cost.

- **Testing a Flutter *web* build in a network-restricted/sandboxed environment**:
  `flutter build web` fetches CanvasKit and web fonts from `gstatic.com` by default
  (`--web-resources-cdn` defaults to on). If outbound requests to that CDN are blocked,
  the app never renders past a blank canvas (`ERR_TUNNEL_CONNECTION_FAILED` /
  "Failed to fetch dynamically imported module"). Fix: `flutter build web
  --no-web-resources-cdn`, which bundles CanvasKit locally (confirms via
  `"useLocalCanvasKit":true` in the emitted `flutter_bootstrap.js`) — then serve
  `build/web/` with any static file server. `flutter run -d web-server` does *not* avoid
  this; it still points at the CDN, so use a full `build web` instead for
  headless/offline testing. (Fonts still fail to fetch if genuinely offline — that's
  cosmetic only, doesn't block rendering.)
- **Driving a CanvasKit-rendered Flutter web app with Playwright**: there are no real
  DOM text nodes — Flutter's accessibility/semantics tree is off by default, so
  `page.getByText(...)`-style selectors find nothing even though the text is clearly
  visible on screen. Drive by screen coordinates (`page.mouse.move/down/up` for drags,
  `page.mouse.click(x, y)` for taps) and verify by screenshot instead.
- **The chloride/AgNO3 vertical slice's "gradual color reveal" was invisible on
  screen**, caught only by actually driving the app end-to-end (not by reading the
  code): the beaker's starting color and the AgCl precipitate's result color were both
  `Colors.white`, so `Color.lerp(white, white, progress)` never visibly changes no
  matter how many drips are delivered — even though the underlying `progress`/
  `dropCount` state was advancing correctly the whole time. Fixed by giving the empty
  "unknown solution" a distinct pale-blue starting color (`practice_slice_screen.dart`,
  `_emptySolutionColor`) so the transition to opaque white is actually visible. Lesson:
  for any future reaction whose result color is white (or matches whatever the "empty"
  state uses), explicitly pick a starting color with contrast — don't assume `lerp` is
  enough on its own.
- **Special/non-Latin glyphs render as tofu boxes in this sandbox's headless-browser
  testing** — both the ⁺/⁻/↓ superscript characters in the equation feedback and Arabic
  script after toggling `[AR]`. Root cause is specific to *this testing setup*, not the
  app: `flutter build web --no-web-resources-cdn` (see above) stops CanvasKit fetching
  from the CDN, but web fonts (Roboto etc.) still try to fetch from `fonts.gstatic.com`
  and fail in a network-restricted sandbox, so the browser falls back to whatever glyphs
  its local system fonts happen to have — which may be none for Arabic shaping. This is
  a *Flutter web* + *sandboxed testing* combination specifically; real Android/iOS
  builds don't fetch fonts over the network at all (bundled in the APK/IPA, falling back
  to the OS's own font manager for glyphs the bundled font lacks) — the same mechanism
  prayer-qibla-app already relies on for its correct Arabic rendering on a real device.
  Net effect: don't read a tofu-box screenshot from this sandbox as "Arabic is broken" —
  it isn't verified either way from here. Confirming real shaping needs either a real
  device/emulator, or a local Chromium with Arabic-capable fonts installed (there's a
  Noto Naskh Arabic font bundled inside the Flutter engine's own test assets at
  `<flutter-sdk>/engine/src/flutter/txt/third_party/fonts/NotoNaskhArabic-Regular.ttf`,
  unexplored as a fix — CanvasKit fonts aren't loaded through the browser's normal font
  stack, so getting it recognized isn't a simple system-font install).
