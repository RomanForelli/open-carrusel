# Open Carrusel

> AI-powered Instagram carousel builder. Chat with Claude to design slides; export as PNGs at exact Instagram dimensions. Runs entirely on your machine — no accounts, no cloud.

## Quickstart (one command)

1. Install [Claude Code](https://docs.anthropic.com/en/docs/claude-code) and authenticate.
2. Clone and open in Claude Code:
   ```bash
   git clone https://github.com/Hainrixz/open-carrusel.git
   cd open-carrusel
   claude
   ```
3. In the Claude Code prompt, type:
   ```
   /start
   ```

That's it. Dependencies install, the local dev server boots, and your browser opens to the app. First run takes 1–2 minutes (Puppeteer downloads ~300 MB Chromium for PNG export); subsequent runs are seconds.

## Requirements

- **Node.js 20+**
- **Claude Code** with an active Claude account (the in-app AI agent is a Claude CLI subprocess)
- **~500 MB free disk** (Puppeteer's Chromium)
- macOS, Linux, or Windows (WSL recommended on Windows)

If you don't have Claude Code yet, you can still verify your environment with `npm run doctor` after cloning.

## What it does

- **Three-panel editor**: chat (left), live slide preview (center), drag-reorderable slide filmstrip (bottom)
- **Slides are HTML/CSS** — Claude generates them, you tweak in chat, sandboxed iframe renders them safely
- **Export the full carousel** as a ZIP of PNGs at 1080×1080 (square), 1080×1350 (portrait), or 1080×1920 (story)
- **Brand config + templates** so the AI matches your style automatically
- **Reference images** you upload influence the AI's design decisions
- All data lives locally as JSON in `/data/`. Nothing leaves your machine except the AI calls Claude makes.

## Commands (in Claude Code)

| Command   | What it does |
|-----------|--------------|
| `/start [port]` | Install + seed + run + open browser. Idempotent. Optional port arg defaults to 3000. |
| `/stop`   | Kill the dev server on :3000. |
| `/reset`  | Wipe local carousels, uploads, exports, and re-seed defaults. Asks first. |
| `/doctor` | Run setup diagnostics (Node, Claude CLI, deps, data, port). |

You can also run them outside Claude Code: `npm run setup`, `npm run dev`, `npm run doctor`.

## Architecture (short)

- **Frontend**: Next.js 16 + React 19 + Tailwind v4, three-panel editor at `localhost:3000`
- **AI agent**: Claude CLI spawned as a subprocess from `/api/chat`, streams responses via SSE
- **Storage**: JSON files in `/data/` with `async-mutex` locking and atomic writes
- **Export**: Puppeteer screenshots the same HTML the preview renders, at exact Instagram pixel dimensions
- **Slides**: full HTML documents wrapped by `wrapSlideHtml()` in `src/lib/slide-html.ts` — the shared rendering contract between preview and export

See [CLAUDE.md](./CLAUDE.md) for the full architecture, file map, and conventions.

## Optional: extend the in-app AI agent

The in-app agent already has `WebFetch` for basic web research. If you also want it to drive a real browser (logged-in pages, multi-step navigation, screenshots), install the [playwright-cli skill](https://docs.anthropic.com/en/docs/claude-code/skills) at the user level — its commands then become available to the agent automatically.

For UI/animation contributions, the project follows [Emil Kowalski's design-engineering philosophy](https://animations.dev). The skill is optional:
```bash
npx skills add emilkowalski/skill
```

These add-ons are not required to use the app.

## Contributing

PRs welcome. The animation system uses CSS-first transitions with `@starting-style` and Emil-style easings (see `src/app/globals.css`). Keep slides themselves untouched — `src/lib/slide-html.ts` and the iframe sandbox are the export contract.

Run the diagnostic before opening a PR: `npm run doctor` and `npm run build` should both pass cleanly.

## License

MIT — see [LICENSE](./LICENSE).
