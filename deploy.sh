#!/bin/bash
# Deployment script for OverImage tweak

DEVICE_IP="${1:-localhost}"
DEVICE_PORT="${2:-2222}"
DEVICE_USER="${3:-root}"
DEVICE_PASS="${4:-alpine}"

echo "===== OverImage Deployment Script ====="
echo "Target Device: $DEVICE_IP:$DEVICE_PORT"
echo ""

# Build package
echo "[1/4] Building package..."
make clean
make package

if [ $? -ne 0 ]; then
    echo "✗ Build failed!"
    exit 1
fi

# Find the .deb file
DEB_FILE=$(find . -name "*.deb" -type f | head -1)

if [ -z "$DEB_FILE" ]; then
    echo "✗ No .deb file found!"
    exit 1
fi

echo "✓ Package built: $DEB_FILE"
echo ""

# Copy to device
echo "[2/4] Copying to device..."
scp -P $DEVICE_PORT "$DEB_FILE" "$DEVICE_USER@$DEVICE_IP:/var/mobile/Media/"

if [ $? -ne 0 ]; then
    echo "✗ Copy failed!"
    exit 1
fi

echo "✓ File copied"
echo ""

# Install on device
echo "[3/4] Installing on device..."
ssh -p $DEVICE_PORT "$DEVICE_USER@$DEVICE_IP" "dpkg -i /var/mobile/Media/$(basename $DEB_FILE)"

if [ $? -ne 0 ]; then
    echo "✗ Installation failed!"
    exit 1
fi

echo "✓ Installation complete"
echo ""

# Restart SpringBoard
echo "[4/4] Restarting SpringBoard..."
ssh -p $DEVICE_PORT "$DEVICE_USER@$DEVICE_IP" "killall -9 SpringBoard"

sleep 2
echo "✓ SpringBoard restarted"
echo ""
echo "===== Deployment Complete ====="
echo "Tweak is now active on your device!"
