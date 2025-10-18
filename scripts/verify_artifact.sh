#!/usr/bin/env bash
set -euo pipefail
if [ $# -lt 3 ]; then
  echo "Usage: $0 <file> <signature-file> <cert-pem>"
  exit 1
fi

export OPENSSL_CONF="$(pwd)/configs/openssl-oqs.cnf"
OPENSSL_BIN=$(command -v openssl)
FILE="$1"
SIG="$2"
CERT="$3"

mkdir -p signatures
if [ ! -f "signatures/$(basename "$FILE").sha256.bin" ]; then
  $OPENSSL_BIN dgst -sha256 -binary "$FILE" > "signatures/$(basename "$FILE").sha256.bin"
fi

$OPENSSL_BIN x509 -in "$CERT" -pubkey -noout > /tmp/pqc_pubkey.pem
$OPENSSL_BIN pkeyutl -verify -pubin -inkey /tmp/pqc_pubkey.pem -in "signatures/$(basename "$FILE").sha256.bin" -sigfile "$SIG"
echo "[OK] Verification succeeded."
