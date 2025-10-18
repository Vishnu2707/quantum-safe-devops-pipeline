#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required. Install from https://brew.sh and rerun."
  exit 1
fi

brew update
brew install cmake llvm coreutils git pkg-config python@3.12 openssl@3 wget

OPENSSL_PREFIX="$(brew --prefix openssl@3)"
export PATH="$OPENSSL_PREFIX/bin:$PATH"
export LDFLAGS="-L$OPENSSL_PREFIX/lib"
export CPPFLAGS="-I$OPENSSL_PREFIX/include"

mkdir -p deps && cd deps

if [ ! -d liboqs ]; then
  git clone https://github.com/open-quantum-safe/liboqs.git
fi
cd liboqs && mkdir -p build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DOQS_USE_OPENSSL=OFF ..
make -j$(sysctl -n hw.ncpu)
sudo make install
cd ../../

if [ ! -d oqs-provider ]; then
  git clone https://github.com/open-quantum-safe/oqs-provider.git
fi
cd oqs-provider && mkdir -p build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DOPENSSL_ROOT_DIR="$OPENSSL_PREFIX" ..
make -j$(sysctl -n hw.ncpu)
sudo make install

echo "[OK] liboqs + oqs-provider installed on macOS."
