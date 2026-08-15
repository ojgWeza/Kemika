# Kemika

A mobile educational game teaching Analytical Chemistry — aligned with the Egyptian
Thanaweya Amma curriculum, but built as a complete standalone learning tool. Students
learn qualitative/quantitative analytical chemistry by *doing* lab actions themselves
(dragging reagents, dripping titrant, observing gradual color/precipitate changes)
instead of memorizing result tables.

Read `CONSTITUTION.md` before making any design decisions, and `TODO.md` for current
status.

## Status

Early prototype. One vertical slice exists end-to-end (chloride ion detection via
AgNO3), built to validate the core "no result without action" interaction loop before
any other systems (Kemidex, Challenge Mode, protagonist, additional elements) are built
on top of it.

## Tech

- **Flutter/Dart**, targeting Android first (low-end-friendly) and iOS second
- No backend for the prototype — everything runs locally
- Bilingual (Arabic/English) from day one — see `lib/l10n/app_strings.dart`
- No local Android/iOS SDK required: GitHub Actions builds the APK on every push to
  `main` (see `.github/workflows/build.yml`) and uploads it as a workflow artifact,
  same pattern as this project's sibling, `prayer-qibla-app`

## Getting started (optional — CI can build this without any local setup)

```
flutter pub get
flutter run
```
