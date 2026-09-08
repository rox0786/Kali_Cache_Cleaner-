# Kali Cache Cleaner

A small Bash script to clean up common cache and log clutter on Kali Linux (or any Debian-based system): APT cache, systemd journal logs, thumbnail cache, trash, and old log files.

## What it cleans

| Target | Action |
|---|---|
| APT cache | `apt clean`, `apt autoclean`, `apt autoremove -y` |
| systemd journal | Vacuums logs older than N days |
| Thumbnail cache | Deletes `~/.cache/thumbnails/*` |
| Trash | Empties `~/.local/share/Trash/*` |
| `/var/log/*.log` | Deletes log files older than N days |

## Usage

```bash
git clone https://github.com/rox0786/Kali_Cache_Cleaner-.git
cd kali-cache-cleaner
chmod +x kalicleaner.sh
./kalicleaner.sh
```

### Options

| Flag | Description |
|---|---|
| `--dry-run` | Show what would be deleted without actually deleting anything |
| `--days N` | Set retention period for logs/journal (default: 7 days) |
| `--help` | Show usage |

Example — preview a cleanup with a 14-day retention window:

```bash
./kalicleaner.sh --dry-run --days 14
```

## Requirements

- Kali Linux or any Debian/Ubuntu-based system
- `sudo` privileges (for APT, journal, and `/var/log` cleanup)
- Standard tools: `apt`, `journalctl`, `find`

## Notes

- Always try `--dry-run` first if you're unsure what will be removed.
- The script uses `set -euo pipefail`, so it stops immediately on any unexpected error rather than continuing partway through a cleanup.
- Log/journal retention is configurable via `--days`; everything else runs unconditionally when the script is invoked.

## License

MIT — see [LICENSE](LICENSE).

## Contributing

Issues and pull requests welcome. If you add a new cleanup target, please gate it behind a flag rather than making it run by default, so users keep control over what gets deleted.
