# Design brief for scastiel.dev (feature/requirements spec)

You're designing the visual layer for **scastiel.dev**, the personal site of Sebastien
Castiel — a Montreal-based developer, writer, and indie hacker. The site is a **static
Jekyll site** that is currently **completely unstyled** (plain semantic HTML, no CSS).
Your job is to give it a design. This brief tells you **every feature, page, and content
type the design must accommodate** — not the aesthetic direction, which is yours to
propose.

## Hard technical constraints (the design must fit these)

- **Static Jekyll 4 site**, deployed to GitHub Pages via Actions. No client-side
  framework, no build step for CSS beyond what Jekyll offers. Prefer **plain CSS** (Sass
  is available via Jekyll if you want it). Keep **JavaScript minimal or zero** — the site
  should work without it.
- **Served from a project subpath** today (`baseurl: /newscastieldev`), moving to a root
  domain later. **All asset/link references must be root-absolute** (`/assets/...`,
  `/articles`) — a build plugin injects the baseurl automatically. Never hardcode the
  domain, and don't use paths that assume the site is at root.
- **Article and book bodies have `render_with_liquid: false`** (they contain `{{ }}` and
  JSX in code fences). Do all templating/styling in **layouts and includes**, not inside
  content files.
- Implementation surface you'll touch: `_layouts/` (`default`, `page`, `post`, `book`),
  `_includes/` (`head`, `header`, `footer`, `article-list`, `book-list`,
  `project-list`). Content in `_articles/`, `_books/`, `_projects/`, `_data/books.yml`,
  and the page files stays as-is.
- **Toolchain note:** system Ruby is broken on this machine; use Homebrew Ruby
  (`export PATH="/opt/homebrew/opt/ruby/bin:$PATH"`), then `bundle exec jekyll serve`.

## Pages the design must cover

1. **Home** (`index.html`) — intro paragraph, a highlighted announcement/callout ("just
   released…" `<aside>`), then three teaser sections (Latest articles ×4, Latest books
   ×4, Current projects ×4), each with a "See all →" link.
2. **Articles index** (`/articles`) — full list of **42 posts**.
3. **Article detail** (post layout) — see rich-content requirements below.
4. **Books index** (`/books`) — 6 books, 4 of which link to their own page.
5. **Book detail** (book layout) — cover, scraped long description, "Get the book"
   purchase links.
6. **Projects index** (`/projects`) — listing only, no detail pages.
7. **Talks** (`/talks`) — upcoming + past talks, each with venue/date/slides/video/source
   links and a description.
8. **About** (`/me`) and **Contact** (`/contact`) — short text pages.
9. **Generic page layout** — used by the above and by three "under construction" stubs
   (`github-card`, `3dbook`, `github-stars`).
10. **Global chrome:** header with site title + nav (Articles · Books · Projects · Talks
    · About · Contact), and footer with social links (LinkedIn, GitHub, YouTube, Twitter)
    + a Creative Commons license line.

## Content types and the fields the design must render

- **Article (list item):** title, date, excerpt. **(detail):** title, posted-date,
  optional cover image, full body. Metadata available and worth surfacing: **language
  (EN/FR)** — 26 EN, 5 FR, mixed collection — and **tags** (`dev` / `life`). The design
  should have a plan for indicating language and/or tags.
- **Article body content the design MUST style:** headings, paragraphs, **fenced code
  blocks with syntax highlighting** (Rouge/kramdown GFM — you'll need to supply a code
  theme via CSS classes; 24 of 42 posts have code), inline images (27 posts; some are
  multi-MB — handle responsive sizing), blockquotes, ordered/unordered lists, links, and
  the occasional **YouTube/iframe embed**. No tables currently, but style them
  defensively.
- **Book (list item):** title (linked only if it has a page), year, description, and a
  row of store links (Amazon/Gumroad/GitHub). **(detail):** cover, long description body,
  "Get the book" link list.
- **Project (list item only):** name (linked to external URL via the `link` field), start
  year, optional **"sold" badge**, description, a **tech-stack list** (e.g.
  React/Next.js/TypeScript), an optional **logo**, and an expandable **"More info…"**
  (`<details>`) with extra body content.
- **Talk item:** title, then an inline meta row of icon-prefixed links (📍 venue · 🗓️
  date · 🎞️ slides · 📺 video · ⚙️ source), plus a description and occasional "given in
  French" note.

## Cross-cutting requirements

- **Responsive / mobile-first.** Must read well on phone and desktop.
- **Accessible:** sufficient contrast, focus states, semantic headings, alt text already
  present on images.
- **Light/dark theme:** strongly desired (the owner literally wrote a blog post on
  dark-mode hooks). Prefer a CSS-only `prefers-color-scheme` approach; a manual toggle is
  optional.
- **Reading comfort** on article pages: comfortable measure/line-length, clear
  typographic hierarchy for a text-heavy blog.
- **Consistent card/list treatment** reused across the home teasers and the three index
  pages (articles, books, projects share the same list includes).
- **`<head>`/SEO:** design should account for page `<title>`, meta description,
  favicon/apple-touch-icon (already wired), and the Atom feed link. **Open Graph /
  social-share meta and per-post OG images are not yet implemented** — propose how the
  design would incorporate them.

## Out of scope (don't change)

Content itself, URL structure, the redirect stubs, the collection/data model, and the
deploy pipeline. Don't re-run the migration script.

## Deliverable

Propose an aesthetic direction, then implement it in the Jekyll layouts/includes with CSS
under `/assets/`. Verify it builds and renders locally with `bundle exec jekyll serve`
across all page types above (home, an article with code + images, a book detail, the
projects list with an expanded "More info", talks, and a plain page).
