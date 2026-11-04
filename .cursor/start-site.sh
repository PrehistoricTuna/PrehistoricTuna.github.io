#!/usr/bin/env bash
# Idempotent per-boot static site server for Cloud Agents.
set -u
LOG=/tmp/site-server.log
touch "$LOG"

if curl -fsS -o /dev/null http://127.0.0.1:8080/ 2>/dev/null; then
  echo "Site already listening on http://127.0.0.1:8080/"
  exit 0
fi

nohup python3 -m http.server 8080 --bind 0.0.0.0 >>"$LOG" 2>&1 &
echo $! >/tmp/site-server.pid

for _ in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
  if curl -fsS -o /dev/null http://127.0.0.1:8080/ 2>/dev/null; then
    echo "Site ready on http://127.0.0.1:8080/"
    exit 0
  fi
  sleep 0.25
done

echo "Site failed to become ready on port 8080" >&2
cat "$LOG" >&2 || true
exit 1
