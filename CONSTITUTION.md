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
   architectural constraint, not a suggestion. In code: `PracticeModeController.AddDrop()`
   and `.RecordObservation()` are the *only* places a reaction's state may change, and
   both only ever fire from a UI interaction handler (see `DropperDragHandler`) — never
   from a timer, `Start()`, or any other automatic trigger.
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

## 3. Architecture, briefly

```
Assets/_Project/Scripts/
  Data/          — Kemika.Data: IonSpecies, Reagent, Reaction (ScriptableObjects).
                    Design-time authorable in the Editor later; for the vertical slice
                    they're built in code via .Create(...) factory methods instead of
                    hand-authored .asset files.
  Interaction/   — Kemika.Interaction: DropperDragHandler — the only input path that can
                    advance a reaction (law 1).
  Modes/         — Kemika.Modes: PracticeModeController (built). ChallengeModeController
                    does not exist yet — do not add it before Practice Mode's mastery-
                    threshold logic exists to gate it, per principle 3.
  Localization/  — Kemika.Localization: LocalizedStrings, a plain Map (English/Arabic),
                    no code-gen, no ARB files — same pattern as prayer-qibla-app's
                    AppStrings. See "Known gaps" below re: Arabic rendering.
  Bootstrap/     — Kemika.Bootstrap: SliceBootstrap builds the entire vertical slice's
                    UI at runtime via [RuntimeInitializeOnLoadMethod], so no scene
                    authoring is required to press Play and see it work.
```

No `StudentProfile`/`KemidexEntry` classes exist yet. `PracticeModeController` keeps a
per-session `AttemptRecord` list (attempt number, correct/incorrect, drops used) as the
seed of that future system, but persistent profile/Kemidex storage is deliberately
deferred until after the vertical slice proves the core interaction feel — see TODO.md.

## 4. Known gaps (flag, don't silently paper over)

- **Arabic text rendering.** `LocalizedStrings` stores real Arabic strings, but Unity's
  built-in legacy `UI.Text` component does not shape/reorder Arabic glyphs (no bidi, no
  letter-joining) — Arabic text will render as disconnected, visually-wrong characters
  as-is. Needs either TextMeshPro + an Arabic shaping/RTL solution, or a runtime
  Arabic-reshaping library, before Arabic is actually shippable. Tracked in TODO.md.
  English renders fine with the current legacy Text setup.
- **No CLAUDE.md convention existed in prayer-qibla-app** (the sibling project this repo's
  conventions were copied from) — this repo's `CLAUDE.md` was written from scratch using
  Unity C# best judgment, not copied from a prior example.
- **No Unity Editor was used to create this scaffold.** `ProjectSettings/` and
  `Packages/manifest.json` are hand-authored minimal files, not Unity Hub output. Unity
  is expected to fill in any missing default `ProjectSettings/*.asset` files itself on
  first open. If Package Manager shows resolution warnings on first open, that's
  expected for a hand-written `manifest.json` — let it auto-resolve/update.

## 5. Open decisions

- Exact device floor for "low-end friendly" Android (needs profiling once the vertical
  slice is running on a real device).
- When to move Challenge Mode's "vs friends" layer off local mocks and onto real backend
  infra.

## 6. Settled feature decisions (don't re-litigate without new input)

- **Vertical slice first.** The chloride ion (Cl⁻) detected via AgNO3 (→ white AgCl
  precipitate) is the one fully-built lesson end-to-end before Kemidex, Challenge Mode,
  the protagonist system, or additional elements are touched.
- **Placeholder/programmer art for the prototype.** Beaker/dropper/precipitate are flat
  colored `UI.Image` rectangles, not real pixel art. Real DOS-pixel art is a later pass.
- **Bilingual (Arabic + English) from day one, architecturally** — even though Arabic
  rendering itself isn't solved yet (see Known gaps). The string-table shape is bilingual
  now so it isn't a retrofit later.
- **Low-end-Android-friendly** is the device baseline (Android 8+, low RAM/GPU); iOS is
  a secondary target. The DOS-pixel visual style is a deliberate hedge against this —
  minimal GPU/fill-rate cost.
- **Testing**: no automated EditMode/PlayMode tests yet — added once the vertical slice
  proves the interaction "feel" is right, not before.
