# Phase 1.5 – Engagement Layer

> **Type:** Feature spec
> **Status:** In Progress
> **Last Updated:** 2026-03-22
> **Parent:** [product-overview.md](product-overview.md)

---

## Goal

Make the book tracker addictive and valuable enough to retain users. Introduce spice ratings, trope tagging, reviews, and a stats dashboard so readers have a reason to return weekly.

---

## Implementation Status Summary

| Feature | Status | Notes |
|---------|--------|-------|
| Spice rating on Book | Implemented | Column is `spice_rating` (not `spice_level`) |
| Trope tagging | Partially Implemented | Currently a PostgreSQL array field; **migrating to join table** (see AC-11–AC-13) |
| Stats dashboard | Implemented | `/stats` with streaks, monthly charts, reading speed, ETAs |
| Review model | Not Started | `Reflection` exists for notes; standalone `Review` model still needed |
| Seed data (romantasy books) | Not Started | Seeds currently only populate bingo cards |

---

## Rules

R1. Every book may have a spice level between 1 and 5 (inclusive). Null is allowed (unrated). The DB column is `spice_rating`.
R2. Tropes are stored as records in the `tropes` table; books are associated via the `book_tropes` join table. Users tag books from existing tropes — they cannot create new tropes from the book form.
R3. A book may have zero or more tropes.
R4. A user may write one review per book. A review may include a rating, spice level, and free-text recap. This is separate from `Reflection` (which remains a freeform note).
R5. The stats dashboard is per-user and private (only visible to the authenticated user).
R6. Stats must include: books read per month, most common tropes (top 5), and average spice level across read books.
R7. The database must be seeded with 20–50 popular romantasy books with tropes and spice levels pre-populated.
R8. Spice level on Book (`spice_rating`) is the book's default level; a user's `Review.spice_level` is their personal rating.
R9. Trope migration must preserve all existing trope associations from the `books.tropes` array before the column is removed.
R10. After migration, the `books.tropes` array column is removed from the schema.

---

## Interfaces

### Data Model

#### Book (existing columns, no additions needed for tropes)
- `spice_rating` — integer, 1–5, nullable *(already exists)*
- `rating` — float, nullable *(already exists)*
- `description` — text, nullable *(already exists)*
- `tropes` array column — **to be removed after migration** (R9, R10)
- `tropes` association — `has_many :tropes, through: :book_tropes` *(new)*

#### Trope *(new model)*
- `id` — primary key
- `name` — string, unique, not null (e.g. "Enemies to Lovers", "Fated Mates", "Slow Burn")

#### BookTrope *(new join table)*
- `book_id` — foreign key, not null
- `trope_id` — foreign key, not null
- Unique index on `[book_id, trope_id]`

#### Review *(new model)*
- `user_id` — foreign key, not null
- `book_id` — foreign key, not null
- `rating` — float, nullable
- `spice_level` — integer 1–5, nullable
- `review_text` — text, nullable
- Unique index on `[user_id, book_id]`

### UI Surfaces

- Book form: trope multi-select (from `Trope` records), spice rating selector (1–5)
- Book show page: display spice level (or "Unrated"), all associated tropes, and current user's review
- Stats dashboard: `/stats` — already has books/month and top tropes; add avg spice from `Review` records
- Seed data: `rails db:seed` populates ≥20 romantasy books with tropes and spice levels

---

## Edge Cases

E1. A user submits a review with no rating, no spice level, and no text — allow it (empty review is valid to record intent).
E2. A book has no tropes — display "No tropes tagged yet."
E3. A book has no spice rating — display as "Unrated", not as 0.
E4. Stats dashboard with zero read books — show empty state with prompt to log a book.
E5. Duplicate trope association attempt — rejected by unique index; model validates uniqueness and surfaces a friendly error.
E6. During trope migration, a book's array contains a trope name not in the `tropes` seed list — create a new `Trope` record for it rather than dropping the data.
E7. Stats top-tropes query with fewer than 5 distinct tropes — return however many exist (do not pad or error).

---

## Acceptance Criteria

### Trope Join Table Migration
AC-11. A `tropes` table exists with unique `name` records seeded from the existing 34-trope list.
AC-12. A `book_tropes` join table exists with a unique index on `[book_id, trope_id]`.
AC-13. All existing trope associations from `books.tropes` array are preserved in `book_tropes` after migration.
AC-14. The `books.tropes` array column is removed after successful migration.
AC-15. Tropes can be associated with a book via a multi-select on the book form (sourced from `Trope` records).

### Review Model
AC-1. A book can be saved with a spice_rating of 1–5 or with no spice_rating. *(Already implemented — verify naming)*
AC-2. The book show page displays spice rating (or "Unrated") and all associated tropes.
AC-3. A user can write a review for a book, including optional rating, spice level, and recap text.
AC-4. A user cannot submit two reviews for the same book (uniqueness enforced at model and DB level).

### Stats
AC-5. The stats dashboard displays books read per month for the current user. *(Already implemented)*
AC-6. The stats dashboard displays the user's top 5 most-read tropes (sourced from `book_tropes`).
AC-7. The stats dashboard displays the user's average spice level across their reviews.
AC-8. Empty stats state renders without error and shows a prompt to log a book. *(Already implemented)*

### Seed Data
AC-9. `rails db:seed` populates at least 20 romantasy books with tropes (via `book_tropes`) and spice levels.
AC-10. Seeded books include a variety of tropes spanning the 34-trope list.

---

## Acceptance Tests

AT1. Save book with spice_rating=3 → `book.spice_rating == 3`. Covers: R1, AC-1
AT2. Save book with no spice_rating → `book.spice_rating` is nil, displayed as "Unrated". Covers: R1, E3, AC-1
AT3. Associate tropes ["Enemies to Lovers", "Slow Burn"] via book form → `book.tropes.map(&:name)` includes both. Covers: R2, R3, AC-15
AT4. Book with zero tropes shows "No tropes tagged yet" on show page. Covers: E2, AC-2
AT5. User creates review with rating=4, spice_level=3, text="Great book" → review persisted. Covers: R4, AC-3
AT6. User attempts second review for same book → validation error raised. Covers: R4, AC-4
AT7. Stats page top tropes returns correct counts sourced from `book_tropes`. Covers: R6, AC-6
AT8. Stats page avg spice calculated correctly across user's `Review` records. Covers: R6, AC-7
AT9. `rails db:seed` → `Book.count >= 20`, all seeded books have at least one `BookTrope`. Covers: R7, AC-9, AC-10
AT10. Stats page with no read books renders empty state without 500 error. Covers: E4, AC-8
AT11. Duplicate trope association attempt → `BookTrope` count unchanged, friendly error surfaced. Covers: E5, AC-12
AT12. Migration: book with `tropes: ["Enemies to Lovers"]` array → `book.tropes.first.name == "Enemies to Lovers"` post-migration. Covers: R9, AC-13
AT13. Post-migration: `books` table has no `tropes` column. Covers: R10, AC-14
AT14. Trope name not in seed list encountered during migration → new `Trope` record created, not dropped. Covers: E6, AC-13

---

## Acceptance Criteria Coverage Matrix

| AC ID | Description | Task | PR | Status |
|-------|-------------|------|----|--------|
| AC-1 | Spice rating saves correctly | — | — | Implemented |
| AC-2 | Book show displays spice + tropes | — | — | Implemented |
| AC-3 | User can write a review | — | — | Implemented |
| AC-4 | One review per user per book enforced | — | — | Implemented |
| AC-5 | Stats: books per month | — | — | Implemented |
| AC-6 | Stats: top 5 tropes from join table | — | — | Implemented |
| AC-7 | Stats: avg spice from reviews | — | — | Implemented |
| AC-8 | Stats: empty state | — | — | Implemented |
| AC-9 | Seed ≥20 romantasy books | — | — | Implemented |
| AC-10 | Seeded books have varied tropes | — | — | Implemented |
| AC-11 | `tropes` table created and seeded | — | — | Implemented |
| AC-12 | `book_tropes` join table created | — | — | Implemented |
| AC-13 | Existing array data migrated | — | — | Implemented |
| AC-14 | `books.tropes` array column removed | — | — | Implemented |
| AC-15 | Book form uses Trope records | — | — | Implemented |

---

## Change Log

| Date | Change | Affected IDs | Rationale |
|------|--------|-------------|-----------|
| 2026-03-22 | Migrated trope model from array field to join table (Trope + BookTrope) | AC-2, AC-11–AC-15, R2, R9, R10 | Proper relational model needed for discovery engine (Phase 4) and top-trope stats |
| 2026-03-22 | Corrected spice column name from `spice_level` to `spice_rating` to match actual schema | R1, R8, AC-1 | Schema audit revealed naming mismatch |
| 2026-03-22 | Marked AC-1, AC-5, AC-8 as Implemented based on codebase audit | AC-1, AC-5, AC-8 | Stats dashboard and spice_rating already built |
| 2026-03-22 | Clarified Review vs Reflection distinction | R4, R8 | Reflection is freeform notes; Review is structured per-user rating |
