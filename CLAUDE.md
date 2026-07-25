# CLAUDE.md

Context for working on **scastiel.dev** — a minimal, static **Jekyll** site. It was
migrated from a Next.js site (`~/dev/scastiel.dev`, the source of truth for original
content). It is served from the custom domain **https://scastiel.dev** and is now
fully designed (see Design below) — the early "intentionally unstyled" phase is over.

## Git workflow

Always update `main` with **rebase, not merge** (`git pull --rebase`, and rebase
feature branches onto `main` rather than merging `main` in). Keep history linear — no
merge commits.

## Toolchain (important)

The macOS **system Ruby (2.6) is broken** on this machine — use Homebrew Ruby:

```sh
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"   # ruby 3.3.x, bundler 2.5.x
bundle install
bundle exec jekyll serve      # local dev at http://127.0.0.1:4000
bundle exec jekyll build      # outputs to _site/ (gitignored)
```

`baseurl` is `""`, so local dev is at the root (`http://127.0.0.1:4000/`), matching
production. Add `--port N` if 4000 is already taken by another checkout/worktree.

## Content model

- `_articles/` — blog posts. **Custom collection, not `_posts`**, so filenames are
  `<slug>.md` with **no date prefix**; the date lives in front matter. URL = `/<slug>/`.
  Some articles are **cross-posted** from other blogs (Between the Prompts, Spliit,
  Vasco Engineering). Those set three front-matter fields: `canonical_url` (the original
  post URL — drives `<link rel="canonical">` + `og:url` in `head.html`), `source_name`
  (display name), and `source_url`. `post.html` shows an "Originally published on …"
  note and `article-list.html` shows a source badge in the card rail. Their images were
  localised into `assets/posts/<slug>/` as WebP like any other post.
- `_books/` — the 4 books that have their own page (`gumroadId` books). URL = `/<slug>/`.
  Their bodies were **scraped from the live site's Gumroad-rendered descriptions**.
- `_data/books.yml` — full 6-book listing that drives `/books` (`has_page` flags which
  4 link to a page).
- `_projects/` — projects (`output: false`, listing-only, no individual pages). The
  external project URL is in the **`link`** front-matter field, NOT `url` (a collection
  doc's `.url` is its own output URL and would shadow it).
- Pages: `index.html` (home), `articles.md`, `books.md`, `projects.md`, `me.md`,
  `talks.md`, `contact.md`, `3dbook.html` (interactive 3D-book CSS generator,
  vanilla-JS port of the old React tool), plus "under construction" stubs
  `github-card.md`, `github-stars.md`.
- `_layouts/` (default, post, book, page) + `_includes/` (head, header, footer,
  article-list, book-list, project-list, talk-list).

## URLs & redirects

- Posts and books share one flat root namespace: `/<slug>/` (no `/blog/` or `/posts/`).
- Article bodies use `render_with_liquid: false` (they contain `{{ }}`/JSX in code
  fences that would break Liquid). This is a Jekyll 4 feature — see Deploy.
- Old URLs are static redirect stubs via **jekyll-redirect-from** (`redirect_from:` in
  front matter): `/about-me`→`/me`, `/books/<slug>`→`/<slug>`, `/posts`→`/articles`,
  and legacy dated `/posts/00N-*.html` post URLs.

## Design

One hand-written stylesheet: **`assets/css/main.css`** (no framework, no build step,
no Sass). Everything hangs off design tokens in `:root` — fonts, `--measure` (reading
width), colours. Prefer reusing a token over a literal value.

- **Theming.** Light by default; dark tokens apply via `@media (prefers-color-scheme:
  dark)` *and* an explicit `[data-theme]` toggle in the header. Rules are written so
  either path wins correctly — when adding colours, add both variants rather than
  hard-coding a hex. A small inline script in `head.html` applies the stored theme
  before paint and sets a `.js` class on `<html>`; the theme toggle and the mobile nav
  hamburger live in `footer.html`. That plus Plausible is all the JS on the site, and
  it degrades gracefully — with JS off, dark mode still follows system preference and
  the nav stays expanded instead of collapsing behind the hamburger.
- **Fonts.** Source Serif 4 (body), Hanken Grotesk (`--font-head`, UI/headings),
  JetBrains Mono (code) — from Google Fonts, loaded async with a `<noscript>` fallback.
- **Article content** is styled under the **`.post-body`** wrapper, so content files
  stay plain markdown and carry no classes of their own. Keep it that way: put the CSS
  in `main.css`, not in the article.
  - Exception: kramdown IALs are fine for genuinely presentational bits. The timeline
    cross-posts tag their date kickers with `{: .eyebrow}` on the line after the text,
    which reuses the site-wide `.eyebrow` treatment and binds it to the heading below.

## Assets

All media lives under **`assets/`** (`assets/posts/<slug>/`, `assets/book-covers/`,
`assets/projects/`). References are absolute (`/assets/...`). Only `favicon.ico`,
`icon.png`, `apple-icon.png`, and `robots.txt` stay at the root. Every file in
`assets/` is currently referenced — keep it that way.

## Deploy

GitHub Pages via **GitHub Actions** (`.github/workflows/pages.yml`), NOT the classic
branch build — the site needs Jekyll 4 (`render_with_liquid`, `jekyll-feed` collections)
which the pinned `github-pages` gem (Jekyll 3.x) can't build.

Served from the **custom domain** `https://scastiel.dev` (root `CNAME` file), so
`url: "https://scastiel.dev"` and `baseurl: ""` in `_config.yml`. It previously ran as
a project page at `scastiel.github.io/newscastieldev/`; **`_plugins/prepend_baseurl.rb`**
is the leftover from that setup — with an empty baseurl it's a **no-op**, kept only so
the site could move back under a path without touching content. Content and templates
are root-absolute (`/assets/...`), which is what makes either mode work.

## migrate.mjs (one-time script — handle with care)

`migrate.mjs` regenerated `_articles`, `_projects`, `_data/books.yml`, and `assets/`
from the old repo. **Do NOT blindly re-run it**: it would overwrite the `_books/*.md`
bodies, which were hand-scraped from the live Gumroad descriptions (not present in the
old repo). It needs `npm install` (gray-matter). Node ≥ 18.

## Follow-ups (not done)

- RSS (`/feed/rss.xml`) and JSON (`/feed/feed.json`) feed variants (only Atom at
  `/feed/feed.xml` exists).

## Image optimization (done)

Raster images were downscaled to **max 1600px** (longest side, shrink-only) and
converted to **WebP q82** in place (`magick … -resize '1600x1600>' -quality 82`),
cutting `assets/` from ~81 MB to ~13 MB. Originals were deleted and every
reference (markdown, front-matter `cover:`, `_data/books.yml`) rewritten to `.webp`.
Left as-is: animated GIFs (`cwebp` can't do them, and they're tiny), SVG/PDF, root
icons, and a few small PNGs where WebP came out larger. When adding a new post
image, resize + convert it the same way rather than committing a raw multi-MB file.
(Note: the pre-existing broken ref `assets/blog/hello-world/robot.jpg` predates this.)
