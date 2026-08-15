# TODO — Kemika

Everything that needs doing, grouped by status. Update this file as soon as something is
done — move it into "Done" rather than leaving it ambiguous.

## Done ✅

- [x] Repo created (`ojgWeza/kemika`, public), scaffolded from a remote/cloud session
      with no access to a local Unity install or `D:\hcode` — see "First local setup"
      below for the one-time step this leaves for you.
- [x] `.gitignore` for Unity (Library/, Temp/, Obj/, Build/, *.csproj, etc.)
- [x] Minimal `ProjectSettings/ProjectVersion.txt` (targets Unity 6 LTS) and
      `Packages/manifest.json` (hand-written, minimal — see Known Gaps in
      `CONSTITUTION.md`)
- [x] Core data model: `IonSpecies`, `Reagent`, `Reaction` (`Kemika.Data`, all
      `ScriptableObject`s)
- [x] `DropperDragHandler` (`Kemika.Interaction`) — drag-and-release-over-target
      mechanic, the only input path that can register a "drip"
- [x] `PracticeModeController` (`Kemika.Modes`) — drip → gradual reveal → record loop,
      enforces law 1 ("no result without action")
- [x] `LocalizedStrings` (`Kemika.Localization`) — bilingual AR/EN string map, same
      shape as prayer-qibla-app's `AppStrings`
- [x] **Vertical slice: chloride detection via AgNO3.** `SliceBootstrap` builds the whole
      thing procedurally at runtime (no scene authoring needed): a beaker, a draggable
      AgNO3 dropper, gradual white-precipitate color reveal over 5 drips, a
      Record Observation step with 4 multiple-choice descriptions (correct + 3
      distractors), and a feedback banner showing the balanced equation once answered
      correctly.
- [x] `CLAUDE.md`, `CONSTITUTION.md`, `TODO.md` created (prayer-qibla-app had
      `CONSTITUTION.md`/`TODO.md` in this same shape; it did **not** have a `CLAUDE.md`
      to copy — this one was written from scratch using Unity C# best judgment, flagged
      per instructions)

## First local setup (do this once, before anything else) 🔧

- [ ] **Clone the repo** to `D:\hcode\kemika` (if not already there):
      `git clone https://github.com/ojgWeza/kemika D:\hcode\kemika`
- [ ] **Install Unity Hub** if you don't have it, then install **Unity 6 LTS**
      (whatever exact patch Hub offers as the current LTS — `ProjectSettings/ProjectVersion.txt`
      will just update itself to match on first open, that's normal)
- [ ] **Open the project**: Unity Hub → "Open" → browse to `D:\hcode\kemika` → select it.
      Unity will generate the missing `Library/`, and may show a Package Manager
      resolution prompt for the hand-written `manifest.json` — accept/let it resolve.
- [ ] Unity will show an empty Hierarchy/no scene the very first time (this repo has no
      `.unity` scene file — hand-authoring one outside the Editor is too fragile to be
      worth the risk, see `CONSTITUTION.md`). Do this **once**: `File → New Scene` →
      `Ctrl+S` → save it as `Assets/_Project/Scenes/Bootstrap.unity`. That's it — no
      GameObjects need to be added, nothing needs to be wired up by hand.
- [ ] **Press Play.** The chloride/AgNO3 vertical slice should build itself and be fully
      playable: drag the dropper onto the beaker 5 times, watch it turn white, tap
      "Record Observation," pick the matching description.
- [ ] If dragging doesn't respond to input: `Edit → Project Settings → Player → Active
      Input Handling` — set to "Input Manager (Old)" or "Both." (The scaffold uses the
      legacy `StandaloneInputModule`; a project defaulting to "Input System Package
      (New)" only would need this.)

## In progress / needs attention right now 🔄

- [ ] Verify the vertical slice actually feels right once played for real (drag
      responsiveness, gradual color reveal pacing, whether 5 drips is the right count)
      — this is the actual point of building it first, per the agreed prototype-first
      approach. Adjust `requiredDripCount` / drag sensitivity based on real feedback
      before building anything else on top.

## Not started yet 📋

### Before building past the vertical slice
- [ ] Confirm the vertical slice's feel is right (see above) before starting any of the
      below — per the agreed "one full lesson end-to-end before touching Kemidex,
      Challenge Mode, or other elements" approach.

### Core systems (deliberately deferred until the slice is validated)
- [ ] `StudentProfile` / `KemidexEntry` — persistent per-element progress stage, attempt
      history (the current `PracticeModeController.AttemptRecord` list is per-session
      only, not persisted)
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
- [ ] **Arabic text rendering.** Legacy `UI.Text` doesn't shape Arabic correctly (no
      bidi/glyph joining). Needs TextMeshPro + an RTL/shaping solution, or a runtime
      Arabic-reshaping library, before Arabic is actually usable — not just stored as
      strings. See `CONSTITUTION.md` § Known gaps.
- [ ] `Packages/manifest.json` was hand-written outside the Editor with a minimal
      package set — revisit once real 2D/sprite/animation packages are needed (e.g.
      `com.unity.2d.sprite` for real pixel art import), since those weren't included to
      avoid guessing at registry version numbers that might not resolve.
- [ ] No `.unity` scene is committed yet — the first local setup step above has you
      create one. Once created, commit it (and its `.meta` file) so future clones don't
      need to repeat that step.

### Before any real release
- [ ] iOS build target setup (currently Android is the only concretely-planned/tested
      target; iOS was in original scope but nothing iOS-specific has been touched)
- [ ] Real device testing on a low-end Android phone (device floor is a stated goal, not
      yet verified against real hardware)
- [ ] Decide on real backend infra for Challenge Mode's "vs friends" layer, once/if the
      local-mock version proves the feature is worth building for real

## Notes

- Read `CONSTITUTION.md` before starting any new work — it has the project rules
  (especially law 1: "no result without action") and the known-gaps/decision log.
- This repo has no CI yet (prayer-qibla-app's GitHub Actions APK-build pattern hasn't
  been ported here) — add one once there's a real build target worth automating.
