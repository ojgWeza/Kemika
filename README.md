# Kemika

A mobile educational game teaching Analytical Chemistry — aligned with the Egyptian
Thanaweya Amma curriculum, but built as a complete standalone learning tool. Students
learn qualitative/quantitative analytical chemistry by *doing* lab actions themselves
(dragging reagents, dripping titrant, observing gradual color/precipitate changes)
instead of memorizing result tables.

Read `CONSTITUTION.md` before making any design decisions, and `TODO.md` for current
status — especially the "First local setup" section if this is your first time opening
the project.

## Status

Early prototype. One vertical slice exists end-to-end (chloride ion detection via
AgNO3), built to validate the core "no result without action" interaction loop before
any other systems (Kemidex, Challenge Mode, protagonist, additional elements) are built
on top of it.

## Tech

- Unity 6 LTS, 2D, targeting Android first (low-end-friendly) and iOS second
- No backend for the prototype — everything runs locally
- Bilingual (Arabic/English) string architecture from day one; see `CONSTITUTION.md`
  "Known gaps" for the current state of Arabic rendering specifically
