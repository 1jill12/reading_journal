# Romantasy Reader Platform – Product Overview Spec

> **Type:** High-level product spec
> **Status:** Active
> **Last Updated:** 2026-03-22

---

## Vision

A niche reading ecosystem focused on **romantasy (romance + fantasy)** readers that combines book tracking, trope/spice-based discovery, in-app reading, and eventual indie author publishing. This is NOT a generic book tracker or general ebook store — it is a romantasy-focused ecosystem built around tropes, spice, and emotional reading experience.

---

## Phased Roadmap

| Phase | Name | Priority | Status |
|-------|------|----------|--------|
| 1 | Core Tracker | Done | Complete |
| 1.5 | Engagement Layer | Immediate | In Progress |
| 2 | Reader Experience | Next | Not Started |
| 3 | Author Platform | Future | Not Started |
| 4 | Discovery Engine | Future | Not Started |
| 5 | Monetization | Later | Not Started |
| 6 | Subscription Model | Long-term | Not Started |

---

## Constraints (Non-Negotiable)

R1. Do NOT build the subscription model before a meaningful user base exists.
R2. Do NOT overbuild before validating engagement and retention.
R3. Prioritize in this order: Engagement → Retention → Content → Monetization.
R4. All paid content must use private files and signed URLs for access control.
R5. Author uploads are admin-approved only until the moderation system is mature.

---

## Domain Model (Full System)

### Book
- title
- author
- description
- cover_url *(actual column name)*
- spice_rating (integer, 1–5) *(actual column name)*
- rating (float)
- genre, format, pages, status, started_at, finished_at
- epub_file (Active Storage, Phase 2+)

### Trope *(Phase 1.5 — migrating from books.tropes array)*
- id
- name (e.g. "Enemies to Lovers", "Fated Mates") — unique

### BookTrope (join table) *(Phase 1.5)*
- book_id
- trope_id
- Unique index on [book_id, trope_id]

### Review *(Phase 1.5)*
- user_id
- book_id
- rating
- spice_level
- review_text
- Unique index on [user_id, book_id]

### Post *(Phase 1.5 — feed posts with photos)*
- user_id
- book_id (optional)
- body (text, optional)
- photos — Active Storage has_many_attached (1 in Phase 1, up to 4 in Phase 2)

### ReadingProgress (Phase 2+)
- user_id
- book_id
- last_location (CFI string or percentage)

### AZChallengeEntry
- user_id
- letter
- book_id

### BingoCard / BingoSquare / UserBingoCard / UserBingoSquare
- See Phase 1.5 spec for details

### Follow / Activity
- Already implemented — see codebase

---

## Success Criteria (Short-Term)

- Users actively logging books
- Users returning weekly
- Users interacting with tropes and spice ratings

## Success Criteria (Medium-Term)

- 10–25 highly engaged readers in beta
- 5–10 indie authors onboarded

---

## Phase Specs Index

| Spec File | Phase |
|-----------|-------|
| [phase-1.5-engagement-layer.md](phase-1.5-engagement-layer.md) | 1.5 |
| [feed-posts.md](feed-posts.md) | 1.5 |
| [phase-2-reader-experience.md](phase-2-reader-experience.md) | 2 |
| [phase-3-author-platform.md](phase-3-author-platform.md) | 3 |
| [phase-4-discovery-engine.md](phase-4-discovery-engine.md) | 4 |
| [phase-5-monetization.md](phase-5-monetization.md) | 5 |
| [phase-6-subscription.md](phase-6-subscription.md) | 6 |
