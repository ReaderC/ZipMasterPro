#!/bin/bash

# ZipMaster Pro IPA Builder
# This script builds an unsigned IPA file for testing purposes

echo "🚀 Starting ZipMaster Pro IPA build process..."

# Check if xcodebuild is available
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: xcodebuild not found. Please install Xcode."
    exit 1
fi

# Set project variables
PROJECT_NAME="ZipMasterPro"
SCHEME_NAME="ZipMasterPro"
CONFIGURATION="Release"
BUILD_DIR="build"
IPA_DIR="ipa"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf "$BUILD_DIR"
rm -rf "$IPA_DIR"
rm -rf "${PROJECT_NAME}.xcarchive"

# Create directories
mkdir -p "$BUILD_DIR"
mkdir -p "$IPA_DIR"

# Build the app
echo "🔨 Building $PROJECT_NAME..."
xcodebuild -project "${PROJECT_NAME}.xcodeproj" \
    -scheme "$SCHEME_NAME" \
    -configuration "$CONFIGURATION" \
    -derivedDataPath "$BUILD_DIR" \
    -archivePath "${PROJECT_NAME}.xcarchive" \
    -sdk iphoneos \
    -allowProvisioningUpdates \
    archive

# Check if build was successful
if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

# Create IPA from archive
echo "📦 Creating IPA file..."
xcodebuild -exportArchive \
    -archivePath "${PROJECT_NAME}.xcarchive" \
    -exportPath "$IPA_DIR" \
    -exportOptionsPlist exportOptions.plist

# Check if IPA creation was successful
if [ $? -ne 0 ]; then
    echo "❌ IPA creation failed!"
    exit 1
fi

# Move and rename the IPA file
if [ -f "$IPA_DIR/$SCHEME_NAME.ipa" ]; then
    mv "$IPA_DIR/$SCHEME_NAME.ipa" "$IPA_DIR/${PROJECT_NAME}_unsigned.ipa"
    echo "✅ IPA file created successfully: $IPA_DIR/${PROJECT_NAME}_unsigned.ipa"
else
    echo "❌ IPA file not found!"
    exit 1
fi

# Display file size
IPA_SIZE=$(ls -lh "$IPA_DIR/${PROJECT_NAME}_unsigned.ipa" | awk '{print $5}')
echo "📊 IPA file size: $IPA_SIZE"

echo ""
echo "🎉 Build completed successfully!"
echo "📱 IPA file location: $IPA_DIR/${PROJECT_NAME}_unsigned.ipa"
echo ""
echo "🔧 Installation Instructions:"
echo "1. Use Xcode to install on device: Window -> Devices and Simulators"
echo "2. Or use third-party tools like AltStore, Sideloadly, or AppSync"
echo "3. The IPA is unsigned and for testing purposes only"
echo ""
echo "⚠️  Note: This is an unsigned IPA file for development/testing."
echo "   For App Store distribution, you need proper certificates and provisioning profiles."