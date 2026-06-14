# Phase 5 – Monetization

> **Type:** Feature spec
> **Status:** Not Started — DO NOT implement until user base is established
> **Last Updated:** 2026-03-20
> **Parent:** [product-overview.md](product-overview.md)
> **Prerequisite:** Phase 4 complete, active reader base validated, author content library exists

---

## Goal

Introduce optional paid content to generate revenue once a meaningful user base and content library exists. Do not optimize for monetization before engagement and retention are proven.

---

## Constraint (from Product Overview R1, R2)

**This phase must not begin until:**
- Engagement and retention metrics are consistently positive
- A content library of sufficient size exists to justify paid access
- At least one monetization model has been validated with a small cohort

---

## Rules

R1. Paid books are unlocked per-user via a one-time purchase.
R2. Paid chapters allow per-chapter unlocks as an alternative to full-book purchase.
R3. Author tips/donations are voluntary and go directly to the author minus platform fee.
R4. Free books remain free regardless of monetization being active.
R5. A user who has purchased a book retains access permanently (no expiry on one-time purchases).
R6. Payment processing must use a third-party provider (e.g. Stripe) — no storing raw card data.
R7. Authors set their own price within platform-defined min/max bounds.

---

## Interfaces

### Data Model

#### Purchase
- `user_id` — foreign key
- `purchasable_type` — polymorphic (Book | Chapter)
- `purchasable_id` — foreign key
- `amount_cents` — integer
- `payment_provider_ref` — string (Stripe charge/payment intent ID)
- `purchased_at` — datetime

#### Book (additions)
- `price_cents` — integer, nullable (null = free)
- `paid` — boolean, default false

### UI Surfaces

- Book show page: purchase button for paid books
- Reader: chapter unlock prompt if chapter is paid and not yet purchased
- Author dashboard: earnings summary, price setting per book
- Tip jar: on author profile page

---

## Edge Cases

E1. User attempts to access paid book without purchasing → redirect to purchase page.
E2. Payment fails at provider → purchase not recorded, user shown error.
E3. Author sets price below platform minimum → validation error.
E4. Free book is accidentally marked paid → admin override restores free status.
E5. User requests refund → handled manually by admin; Purchase record flagged.

---

## Acceptance Criteria

AC-1. A paid book displays a purchase button to users who have not bought it.
AC-2. A paid book is readable by users who have purchased it.
AC-3. A free book is readable by all authenticated users regardless of monetization state.
AC-4. Purchasing a book creates a Purchase record linked to the user and book.
AC-5. Failed payments do not create Purchase records.
AC-6. Authors can set a price for their book within allowed bounds.
AC-7. Author earnings are summarized on their dashboard.
AC-8. Users can leave optional tips on author profile pages.
AC-9. Raw payment card data is never stored on platform servers.
AC-10. A purchased book's access does not expire.

---

## Acceptance Tests

AT1. Unauthenticated or non-purchasing user GET /books/:id/read for paid book → redirect to purchase. Covers: R1, E1, AC-1
AT2. User with matching Purchase record reads paid book → 200 response. Covers: R1, R5, AC-2
AT3. Free book accessible without purchase. Covers: R4, AC-3
AT4. Stripe success webhook → Purchase record created. Covers: R6, AC-4
AT5. Stripe failure webhook → no Purchase record created. Covers: E2, AC-5
AT6. Author sets price below min → validation error. Covers: R7, E3, AC-6
AT7. Author dashboard shows sum of Purchase amounts for their books. Covers: AC-7
AT8. Tip form submission → Tip record created for author. Covers: R3, AC-8
AT9. Purchase record has no raw card fields. Covers: R6, AC-9
AT10. Purchase record has no expiry field; access check uses existence only. Covers: R5, AC-10

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
