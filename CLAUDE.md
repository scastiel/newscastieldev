# CLAUDE.md

Context for working on **scastiel.dev** — a minimal, static **Jekyll** site. It was
migrated from a Next.js site (`~/dev/scastiel.dev`, the source of truth for original
content). The site is intentionally **unstyled** (plain semantic HTML, no CSS) — design
is a later, separate pass. Don't add styling unless asked.

## Toolchain (important)

The macOS **system Ruby (2.6) is broken** on this machine — use Homebrew Ruby:

```sh
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"   # ruby 3.3.x, bundler 2.5.x
bundle install
bundle exec jekyll serve      # local dev at http://127.0.0.1:4000
bundle exec jekyll build      # outputs to _site/ (gitignored)
```

## Content model

- `_articles/` — blog posts. **Custom collection, not `_posts`**, so filenames are
  `<slug>.md` with **no date prefix**; the date lives in front matter. URL = `/<slug>/`.
- `_books/` — the 4 books that have their own page (`gumroadId` books). URL = `/<slug>/`.
  Their bodies were **scraped from the live site's Gumroad-rendered descriptions**.
- `_data/books.yml` — full 6-book listing that drives `/books` (`has_page` flags which
  4 link to a page).
- `_projects/` — projects (`output: false`, listing-only, no individual pages). The
  external project URL is in the **`link`** front-matter field, NOT `url` (a collection
  doc's `.url` is its own output URL and would shadow it).
- Pages: `index.html` (home), `articles.md`, `books.md`, `projects.md`, `me.md`,
  `talks.md`, `contact.md`, plus "under construction" stubs `github-card.md`,
  `3dbook.md`, `github-stars.md`.
- `_layouts/` (default, post, book, page) + `_includes/` (head, header, footer,
  article-list, book-list, project-list).

## URLs & redirects

- Posts and books share one flat root namespace: `/<slug>/` (no `/blog/` or `/posts/`).
- Article bodies use `render_with_liquid: false` (they contain `{{ }}`/JSX in code
  fences that would break Liquid). This is a Jekyll 4 feature — see Deploy.
- Old URLs are static redirect stubs via **jekyll-redirect-from** (`redirect_from:` in
  front matter): `/about-me`→`/me`, `/books/<slug>`→`/<slug>`, `/posts`→`/articles`,
  and legacy dated `/posts/00N-*.html` post URLs.

## Assets

All media lives under **`assets/`** (`assets/posts/<slug>/`, `assets/book-covers/`,
`assets/projects/`). References are absolute (`/assets/...`). Only `favicon.ico`,
`icon.png`, `apple-icon.png`, and `robots.txt` stay at the root. Every file in
`assets/` is currently referenced — keep it that way.

## Deploy

GitHub Pages via **GitHub Actions** (`.github/workflows/pages.yml`), NOT the classic
branch build — the site needs Jekyll 4 (`render_with_liquid`, `jekyll-feed` collections)
which the pinned `github-pages` gem (Jekyll 3.x) can't build.

Currently served from a **project page**: `https://scastiel.github.io/newscastieldev/`,
so `baseurl: /newscastieldev` in `_config.yml`. Content/templates stay root-absolute
(portable); **`_plugins/prepend_baseurl.rb`** injects the baseurl into href/src of the
final HTML at build time (jekyll-feed/sitemap/redirect-from already handle baseurl
themselves). Local `jekyll serve` therefore runs at `http://127.0.0.1:4000/newscastieldev/`.
To move to a root domain later: set `url` to the domain, `baseurl` to `""`, add a
`CNAME` — nothing else changes (the plugin becomes a no-op).

## migrate.mjs (one-time script — handle with care)

`migrate.mjs` regenerated `_articles`, `_projects`, `_data/books.yml`, and `assets/`
from the old repo. **Do NOT blindly re-run it**: it would overwrite the `_books/*.md`
bodies, which were hand-scraped from the live Gumroad descriptions (not present in the
old repo). It needs `npm install` (gray-matter). Node ≥ 18.

## Follow-ups (not done)

- RSS (`/feed/rss.xml`) and JSON (`/feed/feed.json`) feed variants (only Atom at
  `/feed/feed.xml` exists).
- Custom domain / CNAME.
- Design/styling.

## Image optimization (done)

Raster images were downscaled to **max 1600px** (longest side, shrink-only) and
converted to **WebP q82** in place (`magick … -resize '1600x1600>' -quality 82`),
cutting `assets/` from ~81 MB to ~13 MB. Originals were deleted and every
reference (markdown, front-matter `cover:`, `_data/books.yml`) rewritten to `.webp`.
Left as-is: animated GIFs (`cwebp` can't do them, and they're tiny), SVG/PDF, root
icons, and a few small PNGs where WebP came out larger. When adding a new post
image, resize + convert it the same way rather than committing a raw multi-MB file.
(Note: the pre-existing broken ref `assets/blog/hello-world/robot.jpg` predates this.)
