#!/bin/bash

# Android Build Script for Pinokio
# This script builds the Android APK for Pinokio

set -e

echo "=========================================="
echo "Building Pinokio for Android"
echo "=========================================="

# Check if Android SDK is available
if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
    echo "ERROR: Android SDK not found!"
    echo "Please set ANDROID_HOME or ANDROID_SDK_ROOT environment variable."
    echo ""
    echo "To install Android SDK:"
    echo "  1. Install Android Studio from https://developer.android.com/studio"
    echo "  2. Set ANDROID_HOME environment variable to SDK location"
    echo "     Example: export ANDROID_HOME=$HOME/Android/Sdk"
    exit 1
fi

# Check if Java is available
if ! command -v java &> /dev/null; then
    echo "ERROR: Java not found!"
    echo "Please install Java JDK 17 or higher."
    echo ""
    echo "To install Java:"
    echo "  - Ubuntu/Debian: sudo apt-get install openjdk-17-jdk"
    echo "  - macOS: brew install openjdk@17"
    exit 1
fi

echo ""
echo "Step 1: Installing dependencies..."
npm install

echo ""
echo "Step 2: Syncing Capacitor Android platform..."
npm run android:sync

echo ""
echo "Step 3: Building Android APK..."
cd android
./gradlew assembleDebug
cd ..

echo ""
echo "=========================================="
echo "Build completed successfully!"
echo "=========================================="
echo ""
echo "APK Location:"
echo "  Debug APK: android/app/build/outputs/apk/debug/app-debug.apk"
echo ""
echo "To build a release APK:"
echo "  npm run android:build:release"
echo ""
echo "To install on connected device:"
echo "  npm run android:install"
echo ""
