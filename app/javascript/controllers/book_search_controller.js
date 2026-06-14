import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "input", "results", "preview",
    "title", "author", "genre", "pages", "coverUrl", "coverPreview"
  ]

  connect() {
    this._debounceTimer = null
  }

  search() {
    clearTimeout(this._debounceTimer)
    const q = this.inputTarget.value.trim()

    if (q.length < 2) {
      this.resultsTarget.innerHTML = ""
      this.resultsTarget.classList.add("hidden")
      return
    }

    this._debounceTimer = setTimeout(() => this._fetch(q), 350)
  }

  async _fetch(q) {
    const url = `/books/search.json?q=${encodeURIComponent(q)}`
    const res  = await fetch(url, { headers: { "Accept": "application/json" } })
    const data = await res.json()
    this._render(data)
  }

  _render(books) {
    if (!books.length) {
      this.resultsTarget.innerHTML = `<p class="px-4 py-3 text-sm" style="color: var(--theme-text-muted);">No results found.</p>`
      this.resultsTarget.classList.remove("hidden")
      return
    }

    this.resultsTarget.innerHTML = books.slice(0, 8).map(b => `
      <button type="button"
              class="w-full flex items-center gap-3 px-4 py-3 text-left hover:opacity-80 transition border-b"
              style="border-color: var(--theme-border);"
              data-action="click->book-search#pick"
              data-title="${this._esc(b.title)}"
              data-author="${this._esc(b.author)}"
              data-pages="${b.pages || ''}"
              data-cover="${this._esc(b.cover_url || '')}"
              data-genre="${this._esc(b.genre || '')}">
        ${b.cover_url
          ? `<img src="${b.cover_url}" class="w-9 h-12 object-cover rounded flex-shrink-0" alt="">`
          : `<div class="w-9 h-12 rounded flex-shrink-0" style="background-color: var(--theme-border);"></div>`
        }
        <div class="min-w-0">
          <p class="text-sm font-medium truncate" style="color: var(--theme-text-primary);">${this._esc(b.title)}</p>
          <p class="text-xs truncate" style="color: var(--theme-text-muted);">${this._esc(b.author)}</p>
        </div>
      </button>
    `).join("")

    this.resultsTarget.classList.remove("hidden")
  }

  pick(e) {
    const btn = e.currentTarget
    const title  = btn.dataset.title
    const author = btn.dataset.author
    const pages  = btn.dataset.pages
    const cover  = btn.dataset.cover
    const genre  = btn.dataset.genre

    this.titleTarget.value    = title
    this.authorTarget.value   = author
    this.pagesTarget.value    = pages
    this.coverUrlTarget.value = cover
    if (this.hasGenreTarget && genre) this.genreTarget.value = genre

    if (cover) {
      this.coverPreviewTarget.src = cover
      this.coverPreviewTarget.classList.remove("hidden")
    } else {
      this.coverPreviewTarget.classList.add("hidden")
    }

    this.inputTarget.value = title
    this.resultsTarget.classList.add("hidden")
    this.resultsTarget.innerHTML = ""
  }

  close(e) {
    if (!this.element.contains(e.relatedTarget)) {
      this.resultsTarget.classList.add("hidden")
    }
  }

  _esc(str) {
    return String(str ?? "")
      .replace(/&/g, "&amp;")
      .replace(/"/g, "&quot;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
  }
}
