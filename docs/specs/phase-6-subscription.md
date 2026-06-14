# Phase 6 – Subscription Model

> **Type:** Feature spec
> **Status:** Not Started — Long-term, do not approach until Phase 5 validated
> **Last Updated:** 2026-03-20
> **Parent:** [product-overview.md](product-overview.md)
> **Prerequisite:** Phase 5 complete, large content library, active engaged reader base, engagement tracking in place

---

## Goal

Offer an optional monthly subscription (similar to Kindle Unlimited) that gives readers access to a select catalog of books, while distributing a payout pool to authors based on engagement.

---

## Constraints (from Product Overview R1, R2, R3)

**This phase must not begin until:**
- A large content library exists
- An active, returning reader base is established
- Engagement tracking (reads, progress, ratings) is reliable
- Phase 5 monetization has been validated and is generating revenue
- An author payout model has been legally and financially reviewed

---

## Rules

R1. Subscription grants access to all books marked as included in the subscription catalog.
R2. Subscription is monthly and auto-renews until cancelled.
R3. Authors opt their books into the subscription catalog voluntarily.
R4. A monthly author payout pool is distributed proportionally based on reader engagement (pages read, completions).
R5. Subscribers retain access to subscription books only while their subscription is active.
R6. When a subscription lapses, previously accessed subscription books become inaccessible until resubscribed.
R7. Books available via subscription may also be available for individual purchase; purchase grants permanent access.
R8. Subscription billing uses the same payment provider as Phase 5 (no raw card storage).

---

## Interfaces

### Data Model

#### Subscription
- `user_id` — foreign key
- `status` — enum: active | cancelled | lapsed
- `current_period_start` — datetime
- `current_period_end` — datetime
- `payment_provider_ref` — string (Stripe subscription ID)

#### EngagementEvent
- `user_id` — foreign key
- `book_id` — foreign key
- `event_type` — enum: page_read | book_completed
- `occurred_at` — datetime

#### AuthorPayout
- `author_id` — foreign key
- `period` — string (e.g. "2027-01")
- `amount_cents` — integer
- `paid_at` — datetime, nullable

#### Book (additions)
- `in_subscription_catalog` — boolean, default false

### UI Surfaces

- Subscription landing page: `/subscribe`
- Subscriber dashboard: active subscription status, renewal date
- Author dashboard addition: engagement stats, payout history
- Admin: payout pool management, catalog curation

---

## Edge Cases

E1. Subscription lapses mid-read — user loses access; reading progress is preserved for when they resubscribe.
E2. Author removes book from catalog mid-subscription period — book remains accessible to active subscribers until period ends.
E3. Author has zero engagement in a payout period — receives $0 payout; no error.
E4. User has both a purchase and an active subscription for the same book — access granted via either path.
E5. Payment provider webhook is delayed — subscription status must not flip to lapsed until grace period (e.g. 3 days) elapses.

---

## Acceptance Criteria

AC-1. A user can subscribe via the subscription landing page.
AC-2. An active subscriber can read any book in the subscription catalog.
AC-3. A lapsed subscriber cannot read subscription catalog books (but can still read purchased books).
AC-4. Subscription auto-renews monthly via the payment provider.
AC-5. Authors can opt their books into or out of the subscription catalog.
AC-6. Engagement events (page reads, completions) are recorded for subscribed readers.
AC-7. Author payouts are calculated monthly based on engagement share.
AC-8. Reading progress is preserved when a subscription lapses, restored on resubscription.
AC-9. A book available via subscription can also be purchased for permanent access.
AC-10. Subscription billing does not store raw card data on platform servers.

---

## Acceptance Tests

AT1. User subscribes → Subscription record created with status=active. Covers: R2, AC-1
AT2. Active subscriber reads subscription-catalog book → 200 response. Covers: R1, AC-2
AT3. Lapsed subscriber reads subscription-catalog book → redirected/403. Covers: R5, R6, E1, AC-3
AT4. Stripe renewal webhook → subscription period extended, status remains active. Covers: R2, R8, AC-4
AT5. Author toggles in_subscription_catalog → book appears/disappears from subscriber catalog. Covers: R3, AC-5
AT6. Subscriber reads page → EngagementEvent created. Covers: R4, AC-6
AT7. Monthly payout job → AuthorPayout records created proportional to engagement. Covers: R4, AC-7
AT8. Subscription lapses → ReadingProgress records preserved; after resubscribe, reader returns to saved position. Covers: E1, AC-8
AT9. User with purchase and active subscription reads book → 200 (access via either path). Covers: R7, E4, AC-9
AT10. Subscription record has no raw card fields. Covers: R8, AC-10

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
