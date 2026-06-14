# Phase 4 – Discovery Engine

> **Type:** Feature spec
> **Status:** Not Started
> **Last Updated:** 2026-03-20
> **Parent:** [product-overview.md](product-overview.md)
> **Prerequisite:** Phase 3 complete and meaningful book catalog exists

---

## Goal

Use metadata (tropes, spice, ratings) to power better discovery than existing platforms. Let readers find books by feeling, not just genre.

---

## Rules

R1. Readers can filter the book catalog by trope, spice level, and/or rating.
R2. Filters are combinable (e.g. spice ≥ 3 AND trope = "Enemies to Lovers").
R3. Search supports "vibe queries" — plain language input that maps to trope + spice combinations.
R4. The recommendation system suggests books using a "users who liked this also liked" model based on shared tropes and ratings.
R5. Recommendations are only shown when sufficient data exists (minimum 5 books with overlapping tropes/ratings in the system).
R6. Filter and search results must be paginated.
R7. Discovery features must perform acceptably with up to 10,000 books in the catalog (no N+1 queries).

---

## Interfaces

### UI Surfaces

- Book index with filter panel: trope multi-select, spice slider (1–5), min rating
- Search bar with vibe mode: `/books/search?q=high+spice+enemies+to+lovers`
- Book show page: "Readers who liked this also liked…" section (min 3 recommendations)
- Empty filter results: friendly message with suggestion to broaden filters

### Vibe Query Mapping (initial set)

| Phrase | Tropes | Spice |
|--------|--------|-------|
| "high spice" | any | ≥ 4 |
| "slow burn" | Slow Burn | any |
| "enemies to lovers" | Enemies to Lovers | any |
| "fated mates high spice" | Fated Mates | ≥ 4 |
| "cozy fantasy romance" | any | ≤ 2 |

---

## Edge Cases

E1. All filters applied return zero results — show empty state, not error.
E2. Vibe query contains no matching keywords — fall back to standard full-text search.
E3. Book has no tropes or rating — still appears in unfiltered results; excluded from trope/rating-filtered results.
E4. Recommendation engine has insufficient data (< 5 overlapping books) — hide recommendations section entirely.
E5. User searches for a trope that exists but has no books — "No books tagged with this trope yet."

---

## Acceptance Criteria

AC-1. User can filter books by one or more tropes and see only matching books.
AC-2. User can filter books by spice level range and see only matching books.
AC-3. User can filter books by minimum rating.
AC-4. Filters are combinable; combined filters return the intersection of matching books.
AC-5. Search bar accepts vibe queries and returns relevant results based on trope/spice mapping.
AC-6. Book show page displays "also liked" recommendations when sufficient data exists.
AC-7. Recommendations are hidden when insufficient data exists (< 5 overlapping books).
AC-8. All filtered/search result pages are paginated.
AC-9. Filter results with zero matches show a friendly empty state.
AC-10. Discovery queries do not produce N+1 query patterns (verified by query count in tests).

---

## Acceptance Tests

AT1. Filter by trope "Slow Burn" → all returned books have that trope. Covers: R1, AC-1
AT2. Filter by spice ≥ 3 → all returned books have spice_level ≥ 3. Covers: R1, AC-2
AT3. Filter by rating ≥ 4 → all returned books have rating ≥ 4. Covers: R1, AC-3
AT4. Filter trope + spice → returns only books matching both. Covers: R2, AC-4
AT5. Vibe query "high spice enemies to lovers" → results have spice ≥ 4 and Enemies to Lovers trope. Covers: R3, AC-5
AT6. Book show with ≥ 5 overlapping books → recommendations section present. Covers: R4, R5, AC-6
AT7. Book show with < 5 overlapping books → recommendations section absent. Covers: R5, E4, AC-7
AT8. Filter results page has pagination controls. Covers: R6, AC-8
AT9. Filter returning zero results shows empty state message, no 500. Covers: E1, AC-9
AT10. Request /books with trope filter → query count ≤ expected (no N+1). Covers: R7, AC-10

---

## Acceptance Criteria Coverage Matrix

| AC ID | Task | PR | Status |
|-------|------|----|--------|
| AC-1 | — | — | Not Started |
| AC-2 | — | — | Not Started |
| AC-3 | — | — | Not Started |
| AC-4 | — | — | Not Started |
| AC-5 | — | — | Not Started |
| AC-6 | — | — | Not Started |
| AC-7 | — | — | Not Started |
| AC-8 | — | — | Not Started |
| AC-9 | — | — | Not Started |
| AC-10 | — | — | Not Started |
