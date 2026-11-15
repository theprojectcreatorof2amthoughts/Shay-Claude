#!/bin/sh
set -eu

REPOSITORY="theprojectcreatorof2amthoughts/Shay"
ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
LOCK_FILE="$ROOT_DIR/toolchain.lock"

if [ -n "${SHAY_REF:-}" ]; then
    SHAY_REF=$SHAY_REF
else
    SHAY_REF=$(sed -n 's/^SHAY_COMMIT=//p' "$LOCK_FILE" | head -n 1)
fi

if [ -z "$SHAY_REF" ]; then
    echo "install.sh: SHAY_COMMIT is missing from toolchain.lock" >&2
    exit 1
fi

PREFIX=${SHAY_PREFIX:-"$HOME/.local"}
BINDIR="$PREFIX/bin"
SHAREDIR="$PREFIX/share/shay"
TMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/shay-install.XXXXXX")
trap 'rm -rf "$TMP_DIR"' EXIT HUP INT TERM

ARCHIVE_URL="https://github.com/$REPOSITORY/archive/$SHAY_REF.tar.gz"
ARCHIVE="$TMP_DIR/shay.tar.gz"
SOURCE_DIR="$TMP_DIR/source"

echo "Downloading Shay revision $SHAY_REF..."
if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$ARCHIVE_URL" -o "$ARCHIVE"
elif command -v wget >/dev/null 2>&1; then
    wget -q "$ARCHIVE_URL" -O "$ARCHIVE"
else
    echo "install.sh: curl or wget is required" >&2
    exit 1
fi

mkdir -p "$SOURCE_DIR"
tar -xzf "$ARCHIVE" --strip-components=1 -C "$SOURCE_DIR"

if ! command -v make >/dev/null 2>&1; then
    echo "install.sh: GNU Make is required to build Shay" >&2
    exit 1
fi

echo "Building and testing Shay..."
make -C "$SOURCE_DIR" test

echo "Installing Shay into $PREFIX..."
make -C "$SOURCE_DIR" install PREFIX="$PREFIX" BINDIR="$BINDIR" SHAREDIR="$SHAREDIR"

echo
echo "Shay is installed."
echo "Ensure $BINDIR is on your PATH."
echo "For standard-library imports, set:"
echo "  export SHAY_STDLIB=\"$SHAREDIR/siil\""
echo
echo "Verify with:"
echo "  gshai --version"
echo "  shaii --version"
