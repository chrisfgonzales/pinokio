# Android Quick Start Guide

Quick reference for building Pinokio for Android.

## Prerequisites Checklist

- [ ] Android Studio installed
- [ ] Java JDK 17+ installed  
- [ ] Node.js and npm installed
- [ ] `ANDROID_HOME` environment variable set
- [ ] Android SDK Platform 33+ installed

## Quick Build

### Option 1: One-Line Build (Easiest)

```bash
./android_build.sh
```

### Option 2: Step-by-Step

```bash
# 1. Install dependencies
npm install

# 2. Sync and build
npm run android:build
```

### Option 3: Using Android Studio

```bash
# Open in Android Studio
npm run android:open

# Then: Build → Build Bundle(s) / APK(s) → Build APK(s)
```

## Output Location

Debug APK: `android/app/build/outputs/apk/debug/app-debug.apk`

## Testing

### Install on Device/Emulator

```bash
npm run android:install
```

### Run on Device/Emulator

```bash
npm run android:run
```

## Common Commands

```bash
# Sync web assets to Android
npm run android:sync

# Build debug APK
npm run android:build

# Build release APK
npm run android:build:release

# Install on connected device
npm run android:install

# Run app
npm run android:run

# Open in Android Studio
npm run android:open
```

## Troubleshooting

### ANDROID_HOME not set
```bash
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

### Check connected devices
```bash
adb devices
```

### View logs
```bash
adb logcat | grep -i pinokio
```

## Next Steps

For detailed instructions, see [ANDROID_BUILD.md](ANDROID_BUILD.md)

For questions or issues, please open a GitHub issue.
