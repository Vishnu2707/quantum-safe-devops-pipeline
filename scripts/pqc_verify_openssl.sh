#!/usr/bin/env bash
set -euo pipefail

OPENSSL_BIN=$(command -v openssl || true)
if [ -z "${OPENSSL_BIN}" ]; then
  echo "OpenSSL not found. Install openssl@3 and put it in PATH."
  exit 1
fi

mkdir -p configs
cat > configs/openssl-oqs.cnf <<'EOF'
openssl_conf = openssl_init

[openssl_init]
providers = provider_sect

[provider_sect]
default = default_sect
oqsprovider = oqsprovider_sect

[default_sect]
activate = 1

[oqsprovider_sect]
activate = 1
EOF

export OPENSSL_CONF="$(pwd)/configs/openssl-oqs.cnf"

echo "[*] Algorithms available (look for dilithium/falcon):"
"$OPENSSL_BIN" list -signature-algorithms || true

echo "[*] Speed test (Dilithium3):"
"$OPENSSL_BIN" speed dilithium3 || true
