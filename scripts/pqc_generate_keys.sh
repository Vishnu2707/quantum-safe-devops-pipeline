#!/usr/bin/env bash
set -euo pipefail
mkdir -p keys
export OPENSSL_CONF="$(pwd)/configs/openssl-oqs.cnf"
OPENSSL_BIN=$(command -v openssl)

echo "[*] Generating Falcon-512 private key..."
$OPENSSL_BIN genpkey -algorithm falcon512 -out keys/falcon_key.pem

echo "[*] Creating self-signed certificate (CN=pqc-local)..."
$OPENSSL_BIN req -x509 -new -key keys/falcon_key.pem -subj "/CN=pqc-local" -days 365 -out keys/pqc_cert.pem

echo "[OK] Keys in ./keys"
