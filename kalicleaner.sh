#!/bin/bash
#
# Kali Cache Cleaner
# Cleans APT, thumbnail, journal, trash, and old log caches on Kali/Debian systems.
#
# Usage:
#   ./kalicleaner.sh            Run cleanup
#   ./kalicleaner.sh --dry-run  Show what would be done, without deleting anything
#   ./kalicleaner.sh --days N   Set log/journal retention in days (default: 7)
#   ./kalicleaner.sh --help     Show usage
#
# Requires: apt, journalctl, find (standard on Kali/Debian)

set -euo pipefail

DRY_RUN=false
DAYS=7

usage() {
    grep '^#' "$0" | sed -e '1d' -e 's/^# \{0,1\}//'
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=true; shift ;;
        --days) DAYS="$2"; shift 2 ;;
        --help|-h) usage ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

run() {
    if $DRY_RUN; then
        echo "  [dry-run] $*"
    else
        eval "$@"
    fi
}

echo "[*] Starting cache cleanup process (dry-run: $DRY_RUN, retention: ${DAYS}d)..."

echo "[*] Cleaning APT cache..."
run "sudo apt clean"
run "sudo apt autoclean"
run "sudo apt autoremove -y"

echo "[*] Cleaning systemd journal logs older than ${DAYS} days..."
run "sudo journalctl --vacuum-time=${DAYS}d"

echo "[*] Cleaning thumbnail cache..."
run "rm -rf ~/.cache/thumbnails/*"

echo "[*] Emptying trash..."
run "shopt -s globstar 2>/dev/null; rm -rf ~/.local/share/Trash/*"

echo "[*] Removing log files older than ${DAYS} days..."
run "sudo find /var/log -type f -name '*.log' -mtime +${DAYS} -exec rm -f {} \\;"

echo "[+] Cache cleanup complete!"
