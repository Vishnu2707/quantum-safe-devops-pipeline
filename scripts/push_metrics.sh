#!/usr/bin/env bash
set -euo pipefail
# Usage: push_metrics.sh <metric_name> <value> "job=secure_ci,stage=sign" [pushgateway_url]
# Default pushgateway_url: http://localhost:9091

METRIC="$1"
VALUE="$2"
LABELS="${3:-job=manual}"
PUSH_URL="${4:-http://localhost:9091}"

tmpfile=$(mktemp)
echo "# TYPE ${METRIC} gauge" > "$tmpfile"
echo "${METRIC}{${LABELS}} ${VALUE}" >> "$tmpfile"

curl -s --data-binary @"$tmpfile" "${PUSH_URL}/metrics/job/${METRIC}" >/dev/null
rm -f "$tmpfile"
echo "[OK] Pushed ${METRIC}=${VALUE} with labels {${LABELS}} to ${PUSH_URL}."
