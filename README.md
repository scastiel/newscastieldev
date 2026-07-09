# scastiel.dev (Jekyll)

Static rebuild of [scastiel.dev](https://scastiel.dev), migrated from the previous
Next.js site. Minimal/unstyled by design — styling is intentionally deferred.

## Content

- `_articles/` — blog posts (custom collection; URL `/<slug>/`, no date in the URL).
- `_books/` — the 4 books that have their own page (URL `/<slug>/`).
- `_projects/` — projects (listing only, no individual pages).
- `_data/books.yml` — full book listing (drives `/books`).
- `assets/` — all media (images, videos, PDFs). Post images live in
  `assets/posts/<slug>/`, book covers in `assets/book-covers/`, project logos in
  `assets/projects/`. Only `favicon.ico`/`icon.png`/`apple-icon.png` and `CNAME`/
  `robots.txt` stay at the site root.

## Develop

Requires a modern Ruby (the macOS system Ruby 2.6 is too old — use Homebrew's):

```sh
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
bundle install
bundle exec jekyll serve
```

The site is served from a GitHub project page, so it lives under a subpath —
locally that's **http://127.0.0.1:4000/newscastieldev/** (`baseurl` in `_config.yml`).
Content uses root-absolute URLs; `_plugins/prepend_baseurl.rb` prepends the baseurl
to `href`/`src` at build time. Moving to a root domain later just means setting
`url` to the domain and `baseurl` to `""`.

## Deploy (GitHub Pages)

Deployment is via **GitHub Actions** (`.github/workflows/pages.yml`), not the
classic branch build — the site uses Jekyll 4 features (`render_with_liquid`,
`jekyll-feed` collections) that the pinned `github-pages` gem (Jekyll 3.x) can't build.

1. Push to `main`.
2. In the repo: **Settings → Pages → Build and deployment → Source: GitHub Actions**.
3. The workflow builds with the real `Gemfile` and deploys.

No custom domain is configured yet. To use one, add a `CNAME` file (e.g.
`scastiel.dev`) and set the domain in Settings → Pages. If you deploy to a project
page instead, set `baseurl`/`url` in `_config.yml` accordingly.

### Redirects

All old URLs are static redirect stubs via `jekyll-redirect-from` (GitHub Pages has
no server-side redirect config). Covered: `/about-me` → `/me`, `/books/<slug>` →
`/<slug>`, `/posts` → `/articles`, and the legacy dated `/posts/00N-*.html` post URLs
(from each post's `redirect_from` front matter). GitHub Pages resolves the
extensionless requests (e.g. `/about-me`) to the generated `.html` stubs.

## Migration

`migrate.mjs` is the one-time script that generated the content from the old
Next.js repo (`../scastiel.dev`). It is not needed to build the site.

```sh
npm install && node migrate.mjs
```

## Follow-ups (not yet done)

- Optional RSS (`/feed/rss.xml`) and JSON (`/feed/feed.json`) feed variants
  (only the Atom feed at `/feed/feed.xml` is generated).
- Design/styling.
