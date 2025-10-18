#!/usr/bin/env bash
set -euo pipefail
if [ $# -lt 1 ]; then
  echo "Usage: $0 <file-to-sign>"
  exit 1
fi

export OPENSSL_CONF="$(pwd)/configs/openssl-oqs.cnf"
OPENSSL_BIN=$(command -v openssl)
FILE="$1"
mkdir -p signatures

if [ ! -f keys/falcon_key.pem ]; then
  echo "Missing keys/falcon_key.pem. Run scripts/pqc_generate_keys.sh first."
  exit 1
fi

$OPENSSL_BIN dgst -sha256 -binary "$FILE" > "signatures/$(basename "$FILE").sha256.bin"
$OPENSSL_BIN pkeyutl -sign -inkey keys/falcon_key.pem -in "signatures/$(basename "$FILE").sha256.bin" -out "signatures/$(basename "$FILE").sig"
echo "[OK] Signature: signatures/$(basename "$FILE").sig"
