# Feed Posts – Reading Updates with Photos

> **Type:** Feature spec
> **Status:** Not Started
> **Last Updated:** 2026-03-22
> **Parent:** [product-overview.md](product-overview.md)
> **Phase:** 1.5 (Engagement Layer extension)

---

## Goal

Expand the activity feed so users can create standalone reading update posts — freeform text with an optional photo and optional book link. Inspired by Fable's social feed. Existing activity events (book added, book finished, etc.) continue unchanged alongside new posts.

---

## Rules

R1. A `Post` is a user-created record distinct from auto-generated `Activity` events.
R2. A post must have at least one of: body text or a photo. A post with neither is invalid.
R3. A post may optionally be linked to one book.
R4. A post may have at most one photo (Phase 1; architecture must support up to 4 photos in a future iteration without a destructive migration).
R5. Photos are stored via Active Storage. Accepted formats: JPEG, PNG, WebP. Max file size: 10 MB.
R6. Posts appear in the feeds of the author's followers, ordered chronologically (newest first), interleaved with activity events.
R7. Posts are visible on the author's public profile page (subject to `private_profile`).
R8. A user can only delete their own posts.
R9. Posts are not editable after creation (delete and re-post to correct).
R10. The feed renders posts and activity events in a unified chronological stream — no separate tab for posts vs. activities.

---

## Interfaces

### Data Model

#### Post
- `id` — primary key
- `user_id` — foreign key, not null
- `book_id` — foreign key, nullable
- `body` — text, nullable
- `photos` — Active Storage `has_many_attached :photos` *(supports up to 4 in future; Phase 1 UI limits to 1)*
- timestamps

Validations:
- At least one of `body` or `photos` must be present (R2)
- `photos` count ≤ 1 in Phase 1 (R4)
- Photo content type: image/jpeg, image/png, image/webp (R5)
- Photo file size ≤ 10 MB (R5)

#### User (no additions needed)
- Existing `has_many :activities` unchanged
- Add `has_many :posts, dependent: :destroy`

#### Book (no additions needed)
- Add `has_many :posts` (optional, for post→book display)

### Feed Query

The feed index merges two collections for the current user's followed users:
- `Activity.where(user: following_ids)`
- `Post.where(user: following_ids)`

Both are unioned/sorted by `created_at DESC`, paginated (20 items per page).

The current user's own posts also appear in their own feed.

### UI Surfaces

**Feed (`/feed`)**
- Unified stream of `Activity` events and `Post` records
- New "Create Post" button/form at top of feed
- Post card displays: avatar, username, timestamp, body text, photo (if present), linked book cover + title (if present)
- Activity cards unchanged from current design
- Delete button on own posts (with confirmation)

**Post Create Form**
- Textarea for body (optional, placeholder: "What are you reading?")
- Photo upload (single image picker, optional)
- Book search/link field (optional, reuses existing Google Books search)
- Submit button

**User Profile (`/users/:id`)**
- Posts appear in user's activity section (interleaved with activities or in a combined "Updates" section)

---

## Edge Cases

E1. User submits post with no body and no photo — validation error: "Add some text or a photo to share."
E2. User uploads a file that is not an image (e.g. PDF) — validation error: "Only JPEG, PNG, and WebP images are allowed."
E3. User uploads an image over 10 MB — validation error: "Photo must be under 10 MB."
E4. User attempts to delete another user's post via URL manipulation — returns 403.
E5. Book linked to a post is later deleted — post remains; book link displays as "[Book removed]" or is hidden gracefully.
E6. User with no followers creates a post — post is visible on their own profile but appears in no one else's feed.
E7. Feed with a mix of posts and activities from many followed users — pagination must not duplicate or skip items across pages.
E8. Photo upload fails at storage level — post is not created; user sees a storage error message.

---

## Acceptance Criteria

AC-1. A user can create a post with body text only (no photo, no book link).
AC-2. A user can create a post with a photo only (no body text, no book link).
AC-3. A user can create a post with body text, a photo, and a linked book.
AC-4. A post with no body and no photo cannot be submitted; a validation error is shown.
AC-5. Only one photo can be attached to a post in Phase 1.
AC-6. Photos must be JPEG, PNG, or WebP; other formats are rejected with a validation error.
AC-7. Photos over 10 MB are rejected with a validation error.
AC-8. Posts from followed users appear in the feed, interleaved with activity events, ordered newest first.
AC-9. The current user's own posts appear in their own feed.
AC-10. Posts appear on the author's public profile page.
AC-11. A user can delete their own post.
AC-12. A user cannot delete another user's post (403 returned).
AC-13. Posts are not editable after creation (no edit action exposed).
AC-14. The feed is paginated (20 items per page).
AC-15. If a linked book is deleted, the post renders without error.

---

## Acceptance Tests

AT1. POST /posts with body="Great read" → post created, appears in feed. Covers: R1, AC-1
AT2. POST /posts with photo only (valid JPEG, no body) → post created. Covers: R2, AC-2
AT3. POST /posts with body + photo + book_id → post created with all fields. Covers: R3, AC-3
AT4. POST /posts with no body and no photo → 422, validation error message shown. Covers: R2, E1, AC-4
AT5. POST /posts with 1 photo in Phase 1 → success; POST with 2 photos → validation error. Covers: R4, AC-5
AT6. POST /posts with PDF attachment → validation error "only JPEG, PNG, and WebP". Covers: R5, E2, AC-6
AT7. POST /posts with 11 MB image → validation error "must be under 10 MB". Covers: R5, E3, AC-7
AT8. Feed for user A (follows user B) includes user B's post in chronological stream. Covers: R6, R10, AC-8
AT9. Feed for current user includes their own posts. Covers: R6, AC-9
AT10. GET /users/:id → posts visible on profile page. Covers: R7, AC-10
AT11. DELETE /posts/:id (own post) → 200, post removed from feed. Covers: R8, AC-11
AT12. DELETE /posts/:id (other user's post) → 403. Covers: R8, E4, AC-12
AT13. No PATCH/PUT route exists for posts. Covers: R9, AC-13
AT14. Feed page 1 and page 2 return 20 items each with no duplicates. Covers: R10, E7, AC-14
AT15. Post linked to deleted book → feed renders without 500 error. Covers: E5, AC-15

---

## Future Considerations (Phase 2+ — not in scope now)

- **Multiple photos (up to 4):** The `has_many_attached :photos` model is already in place. Phase 2 lifts the count validation from 1 → 4 and adds a photo carousel UI. No migration needed.
- **Post likes / reactions**
- **Post comments**
- **Post sharing / reposting**

---

## Acceptance Criteria Coverage Matrix

| AC ID | Description | Task | PR | Status |
|-------|-------------|------|----|--------|
| AC-1 | Create post with text only | — | — | Not Started |
| AC-2 | Create post with photo only | — | — | Not Started |
| AC-3 | Create post with text + photo + book | — | — | Not Started |
| AC-4 | Empty post rejected | — | — | Not Started |
| AC-5 | Single photo limit (Phase 1) | — | — | Not Started |
| AC-6 | Invalid file type rejected | — | — | Not Started |
| AC-7 | Oversized photo rejected | — | — | Not Started |
| AC-8 | Posts in followers' feeds | — | — | Not Started |
| AC-9 | Own posts in own feed | — | — | Not Started |
| AC-10 | Posts on profile page | — | — | Not Started |
| AC-11 | User deletes own post | — | — | Not Started |
| AC-12 | Cannot delete others' posts | — | — | Not Started |
| AC-13 | No edit action | — | — | Not Started |
| AC-14 | Feed paginated 20/page | — | — | Not Started |
| AC-15 | Deleted book link handled gracefully | — | — | Not Started |
