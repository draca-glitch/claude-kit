# claude-kit

Two small things that make Claude Code feel less stateless:

1. **`hooks/time.sh`** — injects current server time on every user prompt so Claude has temporal cohesion across your messages. Without it, Claude sees all your messages as "now" and can't tell whether you replied in 10 seconds or 10 hours.
2. **`hooks/statusline.sh`** — always-on status line showing host, load, memory, disk, uptime. Lives at the bottom of Claude Code. Useful for knowing what your machine is actually doing while you chat.

That's the whole kit. Intentionally small.

## Status line

```
user@host | load 0.42 | mem 15G/63G | disk 82% | up 7d
```

Refreshes every 5 seconds (configurable). No external dependencies beyond standard coreutils (`awk`, `free`, `df`, `uptime` via `/proc`). Works on any Linux; macOS users will need to adjust `free` → `vm_stat` parsing.

## Quick start

```bash
# 1. Copy the hooks
mkdir -p ~/.claude/hooks
cp hooks/time.sh hooks/statusline.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh

# 2. Merge the UserPromptSubmit entry and statusLine config from
#    templates/settings.json into your ~/.claude/settings.json.
#    Don't overwrite — you probably have other hooks and permissions.

# 3. Restart Claude Code or open /hooks once so the watcher picks it up.
```

Verify live: next message to Claude should arrive with something like `2026-04-17 23:55:18 CEST` prepended as a system reminder, and the status line should appear at the bottom of the UI.

## Why

### Time hook

Claude, by default, **lacks temporal cohesion**. A new message from you looks identical whether you wrote it 10 seconds or 10 hours after the previous one. From Claude's side, there's no "between" — each turn is a fresh forward pass. The gap doesn't exist.

This hook fixes it by prepending the current server time to every user prompt as a system reminder. With a timestamp on every turn, Claude can compute the delta and adjust:

- "You just wrote 30 seconds ago, stay terse"
- "You've been away 6 hours, catch me up"
- "It's late evening, you're probably wrapping up — tighten the thread"

**Yes, it costs tokens.** About 20 per prompt (the timestamp string plus a short system-reminder framing). Over a busy day that's maybe 2-3k tokens of overhead. In Opus 4.7 pricing, a few cents. Not nothing, but trivial compared to the quality gain.

**Is it worth it?** Yes. The difference between "Claude responds to what I typed" and "Claude responds to what I typed knowing I've been away at dinner and might need context re-loaded" is surprisingly large. It makes the conversation feel continuous instead of a series of cold starts. For anything that looks like an ongoing collaboration (vs one-shot tasks), the token cost is paid back in fewer misfires per turn.

### Status line

Sometimes you want to know if your server is about to OOM in the middle of a build without alt-tabbing. Visible at a glance, updates every 5 seconds, zero extra cost (the script runs locally, not through the model).

## Companion

- **[claude-hud](https://github.com/jarrodwatts/claude-hud)** — richer status bar plugin with live view of current tool calls, token usage, and session context. Runs alongside or replaces `statusline.sh`. Enable via `enabledPlugins`.

## License

MIT.
