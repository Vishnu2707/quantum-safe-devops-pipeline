#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="${1:-pqc-demo:latest}"
CERT="${2:-keys/pqc_cert.pem}"
export OPENSSL_CONF="$(pwd)/configs/openssl-oqs.cnf"
OPENSSL_BIN=$(command -v openssl)

if [ ! -f "$CERT" ]; then
  echo "Certificate not found: $CERT"
  exit 1
fi

mkdir -p signatures
docker save "$IMAGE_NAME" | openssl dgst -sha256 -binary > "signatures/${IMAGE_NAME//[:\/]/_}.tar.sha256.bin"

$OPENSSL_BIN x509 -in "$CERT" -pubkey -noout > /tmp/pqc_pubkey.pem
$OPENSSL_BIN pkeyutl -verify -pubin -inkey /tmp/pqc_pubkey.pem \
  -in "signatures/${IMAGE_NAME//[:\/]/_}.tar.sha256.bin" \
  -sigfile "signatures/${IMAGE_NAME//[:\/]/_}.tar.sig"

echo "[OK] Image signature verified."
