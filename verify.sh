#!/usr/bin/env bash
set -euo pipefail
IWAD="${1:-demo/doom1.wad}"
DEMO="${2:-demo/mydemo.lmp}"

if [ ! -f "$IWAD" ]; then echo "IWAD not found: $IWAD"; exit 1; fi
if [ ! -f "$DEMO" ]; then echo "Demo not found: $DEMO"; exit 1; fi

ENGINE="./c-engine/build/src/chocolate-doom"
RUN1=$(mktemp)
RUN2=$(mktemp)

$ENGINE -iwad "$IWAD" -playdemo "$DEMO" > "$RUN1" 2>&1
$ENGINE -iwad "$IWAD" -playdemo "$DEMO" > "$RUN2" 2>&1

grep -v "zone memory" "$RUN1" > "${RUN1}.clean"
grep -v "zone memory" "$RUN2" > "${RUN2}.clean"

if diff "${RUN1}.clean" "${RUN2}.clean"; then
  echo "DETERMINISTIC — both runs produced identical output"
  rm -f "$RUN1" "$RUN2" "${RUN1}.clean" "${RUN2}.clean"
  exit 0
else
  echo "NON-DETERMINISTIC — output differs between runs"
  rm -f "$RUN1" "$RUN2" "${RUN1}.clean" "${RUN2}.clean"
  exit 1
fi
