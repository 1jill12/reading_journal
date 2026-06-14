# Phase 3 – Author Platform

> **Type:** Feature spec
> **Status:** Not Started
> **Last Updated:** 2026-03-20
> **Parent:** [product-overview.md](product-overview.md)
> **Prerequisite:** Phase 2 complete and validated

---

## Goal

Enable indie authors to upload and distribute their books directly on the platform. Introduce author accounts, book upload flows, author profiles, and a manual moderation step before books go live.

---

## Rules

R1. Author accounts are a distinct role from reader accounts — a user may hold both roles.
R2. Authors can upload: one EPUB file, one cover image, and book metadata (title, description, tropes, spice level).
R3. Every author-uploaded book must pass manual admin approval before becoming visible to readers.
R4. Unapproved books are only visible to the uploading author and admins.
R5. Approved authors receive a "Founding Author" badge displayed on their profile if they joined before the founding author cutoff date.
R6. Authors can edit their book's metadata at any time; edits to the EPUB file reset approval status to pending.
R7. Admins can approve, reject, or request changes on a submitted book.

---

## Interfaces

### Data Model

#### User (additions)
- `role` — enum: reader | author | admin (or separate boolean flags)
- `founding_author` — boolean, default false
- `author_bio` — text, nullable

#### Book (additions)
- `uploaded_by_author` — boolean, default false
- `approval_status` — enum: pending | approved | rejected | changes_requested, default pending for author uploads
- `author_notes` — text (for admin→author feedback)

### UI Surfaces

- Author onboarding flow: `/become-author`
- Author book upload form: `/books/new` (author variant with EPUB + cover + metadata)
- Author profile page: `/authors/:id` — bio, badge, published books
- Admin moderation queue: `/admin/books/pending`
- Admin review UI: approve / reject / request changes with note

---

## Edge Cases

E1. Author uploads a revised EPUB to an already-approved book — approval_status resets to pending.
E2. Author attempts to view another author's unapproved book — returns 404.
E3. Admin rejects a book — author sees rejection reason on their dashboard.
E4. Founding author cutoff date passes — no new founding author badges awarded after that date.
E5. Author deletes their account — their published (approved) books remain visible; their pending books are removed.

---

## Acceptance Criteria

AC-1. A user can apply to become an author via the onboarding flow.
AC-2. An author can upload a book with EPUB file, cover image, title, description, tropes, and spice level.
AC-3. A newly uploaded author book has approval_status = pending and is not visible to readers.
AC-4. An admin can approve a pending book, making it visible to all readers.
AC-5. An admin can reject a book with a reason; the author can see the rejection reason.
AC-6. An admin can request changes with a note; the book remains in a non-public state.
AC-7. When an author uploads a new EPUB to an already-approved book, approval_status resets to pending.
AC-8. Author profiles display the author's bio, their published books, and the "Founding Author" badge if eligible.
AC-9. Authors with founding_author=true display a "Founding Author" badge on their profile.
AC-10. Non-author users cannot access the author book upload form.

---

## Acceptance Tests

AT1. User completes onboarding → user.role includes author. Covers: R1, AC-1
AT2. Author submits book with all fields → book created with approval_status=pending. Covers: R3, AC-2, AC-3
AT3. Reader requests /books/:id for pending book → 404. Covers: R4, AC-3
AT4. Admin approves book → approval_status=approved, book visible in reader index. Covers: R3, R7, AC-4
AT5. Admin rejects with reason → author sees reason on dashboard. Covers: R7, E3, AC-5
AT6. Admin requests changes with note → book.approval_status=changes_requested, note visible to author. Covers: R7, AC-6
AT7. Author re-uploads EPUB to approved book → approval_status resets to pending. Covers: R6, E1, AC-7
AT8. Author profile page shows bio, published books, and badge if founding_author=true. Covers: R5, AC-8, AC-9
AT9. Reader attempts GET /books/new (author variant) → redirected or 403. Covers: R2, AC-10

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
