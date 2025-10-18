#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="${1:-pqc-demo:latest}"
export OPENSSL_CONF="$(pwd)/configs/openssl-oqs.cnf"
OPENSSL_BIN=$(command -v openssl)

if [ ! -f keys/falcon_key.pem ]; then
  echo "Missing keys/falcon_key.pem. Run scripts/pqc_generate_keys.sh first."
  exit 1
fi

echo "[*] Building minimal image..."
cat > /tmp/Dockerfile.pqc <<'EOF'
FROM busybox:latest
RUN echo "hello from pqc demo" > /hello.txt
CMD ["cat","/hello.txt"]
EOF

docker build -t "$IMAGE_NAME" -f /tmp/Dockerfile.pqc /tmp

echo "[*] Saving image to tar and hashing..."
mkdir -p signatures
docker save "$IMAGE_NAME" | openssl dgst -sha256 -binary > "signatures/${IMAGE_NAME//[:\/]/_}.tar.sha256.bin"

echo "[*] Signing tar digest with Falcon-512..."
$OPENSSL_BIN pkeyutl -sign -inkey keys/falcon_key.pem \
  -in "signatures/${IMAGE_NAME//[:\/]/_}.tar.sha256.bin" \
  -out "signatures/${IMAGE_NAME//[:\/]/_}.tar.sig"

echo "[OK] Image tar digest signed: signatures/${IMAGE_NAME//[:\/]/_}.tar.sig"
