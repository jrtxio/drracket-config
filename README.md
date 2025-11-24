# DrRacket Keybindings

Enhanced keybindings for DrRacket with Emacs-style REPL integration and modern navigation.

## Features

- 🔄 **Send code to REPL** - Emacs-style incremental evaluation

## Installation

1. Clone this repository:
```bash
git clone https://github.com/jrtxio/drracket-config.git
```

2. In DrRacket:
   - Go to **Edit** → **Keybindings** → **Add User-defined Keybindings...**
   - Select `drracket-keybindings.rkt` from the cloned directory
   - Restart DrRacket

## Keybindings

### Send to REPL

| Shortcut | Action |
|----------|--------|
| `Ctrl+C, Ctrl+E` | Send current expression to REPL |
| `Ctrl+C, Ctrl+R` | Send selected code to REPL |
| `Ctrl+C, Alt+E` | Send expression and focus REPL |
| `Ctrl+C, Alt+R` | Send selection and focus REPL |

**Usage:**
- Place cursor in or near an expression
- Press `Ctrl+C` then `Ctrl+E` to evaluate it in the REPL
- Or select code and press `Ctrl+C` then `Ctrl+R`

**Note:** Requires running the program at least once (F5) to initialize the REPL.

## Tips

- **View all active keybindings:** Edit → Keybindings → Show Active Keybindings

## Updating
```bash
cd /path/to/drracket-config
git pull
```

Then restart DrRacket.

## Requirements

- DrRacket 7.0 or later

## License

MIT License