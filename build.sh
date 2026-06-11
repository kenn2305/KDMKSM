#!/bin/bash

# OverImage Build Script for iOS 18

TWEAK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${TWEAK_DIR}/build"
PACKAGE_DIR="${TWEAK_DIR}/packages"

echo "===== OverImage Tweak Build ====="
echo "Building for iOS 18..."

# Clean previous builds
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
mkdir -p "${PACKAGE_DIR}"

# Change to tweak directory
cd "${TWEAK_DIR}"

# Build using Theos
if command -v make &> /dev/null; then
    make clean
    make package
    
    # Check for build success
    if [ $? -eq 0 ]; then
        echo "✓ Build successful!"
        echo "Package location: $(find . -name '*.deb' -type f)"
    else
        echo "✗ Build failed!"
        exit 1
    fi
else
    echo "Error: make command not found. Please install Theos."
    exit 1
fi

echo "===== Build Complete ====="
