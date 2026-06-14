# Phase 2 – Reader Experience

> **Type:** Feature spec
> **Status:** Not Started
> **Last Updated:** 2026-03-20
> **Parent:** [product-overview.md](product-overview.md)
> **Prerequisite:** Phase 1.5 complete and validated

---

## Goal

Allow users to read books inside the app. Deliver an in-app EPUB reader with progress saving and reader customization settings.

---

## Rules

R1. EPUB upload is restricted to admin users only during Phase 2.
R2. EPUB files are stored via Active Storage backed by an S3-compatible service — not on local disk in production.
R3. Reading progress is saved per user per book, storing a CFI string or percentage.
R4. Reader settings (font size, theme) are user-scoped and persisted across sessions.
R5. Reader theme options: light, dark, sepia.
R6. The reader must use EPUB.js for rendering.
R7. A book without an epub_file attachment is not readable in-app — reading button is hidden.

---

## Interfaces

### Data Model

#### Book (additions)
- `epub_file` — Active Storage attachment (one)

#### ReadingProgress
- `user_id` — foreign key
- `book_id` — foreign key
- `last_location` — string (CFI or percentage), nullable
- Unique index on [user_id, book_id]

#### UserReaderSettings (or stored on User)
- `font_size` — integer (px or step), default 16
- `theme` — enum: light | dark | sepia, default light

### UI Surfaces

- Book show page: "Read Now" button (visible only if epub_file attached)
- In-app reader page: `/books/:id/read`
- Reader toolbar: font size controls, theme switcher
- Admin book form: EPUB file upload field
- Reading progress auto-saved on page turn

### Infrastructure

- Active Storage configured with S3-compatible backend
- Signed URLs for serving EPUB files (do not expose raw S3 URLs)

---

## Edge Cases

E1. User navigates away mid-read — progress saved at last known CFI before unload.
E2. EPUB file is corrupted or unreadable by EPUB.js — show error message, do not crash.
E3. Non-admin user attempts to upload EPUB via URL manipulation — return 403.
E4. Book has no epub_file — "Read Now" button is absent from show page.
E5. ReadingProgress record doesn't exist yet for user+book — reader opens at beginning (CFI null treated as start).

---

## Acceptance Criteria

AC-1. Admin can upload an EPUB file when creating or editing a book.
AC-2. Non-admin users cannot upload EPUB files.
AC-3. A book with an attached EPUB shows a "Read Now" button on its show page.
AC-4. A book without an attached EPUB does not show a "Read Now" button.
AC-5. Clicking "Read Now" opens the in-app reader at the user's last saved position (or beginning if none).
AC-6. Reading progress is saved automatically as the user progresses through the book.
AC-7. User can change font size in the reader toolbar and the setting persists on next visit.
AC-8. User can switch between light, dark, and sepia themes; the setting persists on next visit.
AC-9. EPUB files are served via signed URLs, not raw S3 paths.
AC-10. A corrupted or unrenderable EPUB shows an error message rather than a blank/crashed reader.

---

## Acceptance Tests

AT1. Admin uploads EPUB to book → book.epub_file.attached? is true. Covers: R1, AC-1
AT2. Non-admin POST to book update with epub param → 403 response. Covers: R1, E3, AC-2
AT3. Book with epub_file → show page contains "Read Now" link. Covers: R7, AC-3
AT4. Book without epub_file → show page does not contain "Read Now" link. Covers: R7, E4, AC-4
AT5. User with saved CFI → reader opens at that CFI. Covers: R3, AC-5
AT6. User with no ReadingProgress → reader opens at beginning. Covers: E5, AC-5
AT7. Page turn event → ReadingProgress.last_location updated. Covers: R3, AC-6
AT8. User sets font_size=20 → persists on reader reload. Covers: R4, AC-7
AT9. User sets theme=dark → persists on reader reload. Covers: R4, R5, AC-8
AT10. Book served via signed URL (url does not contain raw bucket path). Covers: R2, AC-9
AT11. EPUB.js encounters bad file → reader shows error message, no 500. Covers: E2, AC-10

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
