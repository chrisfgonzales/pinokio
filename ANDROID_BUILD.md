# Android Build Guide for Pinokio

This guide provides detailed instructions for building the Android version of Pinokio.

## Overview

The Android version of Pinokio is built using [Capacitor](https://capacitorjs.com/), which wraps the web-based Pinokio interface in a native Android application. The app connects to the Pinokio server running on `localhost:42000`.

## Prerequisites

### Required Software

1. **Android Studio**
   - Download from: https://developer.android.com/studio
   - Includes Android SDK and emulator

2. **Java Development Kit (JDK)**
   - Version: JDK 17 or higher
   - Ubuntu/Debian: `sudo apt-get install openjdk-17-jdk`
   - macOS: `brew install openjdk@17`

3. **Node.js and npm**
   - Version: Node.js 14.x or higher
   - Download from: https://nodejs.org/

### Environment Setup

1. **Install Android Studio** and complete the setup wizard

2. **Configure Android SDK** via Android Studio:
   - Open Android Studio → Settings/Preferences → Appearance & Behavior → System Settings → Android SDK
   - Install Android SDK Platform 33 (or latest)
   - Install Android SDK Build-Tools
   - Install Android Emulator

3. **Set Environment Variables**:
   ```bash
   # Linux/macOS - Add to ~/.bashrc or ~/.zshrc
   export ANDROID_HOME=$HOME/Android/Sdk
   export PATH=$PATH:$ANDROID_HOME/emulator
   export PATH=$PATH:$ANDROID_HOME/platform-tools
   export PATH=$PATH:$ANDROID_HOME/tools
   export PATH=$PATH:$ANDROID_HOME/tools/bin
   
   # Windows - Add to System Environment Variables
   ANDROID_HOME=C:\Users\YourUsername\AppData\Local\Android\Sdk
   ```

4. **Verify Installation**:
   ```bash
   java -version
   android --version
   adb version
   ```

## Building the Android App

### Method 1: Using the Build Script (Recommended)

The easiest way to build the Android app:

```bash
./android_build.sh
```

This will:
1. Install npm dependencies
2. Sync Capacitor Android platform
3. Build a debug APK

Output: `android/app/build/outputs/apk/debug/app-debug.apk`

### Method 2: Using npm Scripts

```bash
# Install dependencies (first time only)
npm install

# Sync web assets to Android project
npm run android:sync

# Build debug APK
npm run android:build

# Build release APK (requires signing configuration)
npm run android:build:release

# Install APK on connected device/emulator
npm run android:install

# Run app on emulator/device
npm run android:run
```

### Method 3: Using Android Studio

1. Open Android project in Android Studio:
   ```bash
   npm run android:open
   ```

2. In Android Studio:
   - Select Build → Build Bundle(s) / APK(s) → Build APK(s)
   - Or click the Run button to build and install on emulator/device

## Testing the App

### Using an Emulator

1. Create an Android Virtual Device (AVD) in Android Studio:
   - Tools → Device Manager → Create Device
   - Choose a device definition (e.g., Pixel 5)
   - Select a system image (API 33 recommended)
   - Finish setup

2. Start the emulator:
   - From Android Studio: Tools → Device Manager → Launch emulator
   - From command line: `emulator -avd Pixel_5_API_33`

3. Install and run the app:
   ```bash
   npm run android:install
   ```

### Using a Physical Device

1. Enable Developer Options on your Android device:
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
   - Go back to Settings → Developer Options
   - Enable "USB Debugging"

2. Connect device via USB

3. Verify connection:
   ```bash
   adb devices
   ```

4. Install the app:
   ```bash
   npm run android:install
   ```

## Release Build

To create a signed release APK for distribution:

### 1. Generate a Keystore

```bash
keytool -genkey -v -keystore pinokio-release.keystore \
  -alias pinokio \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

Follow the prompts to set passwords and enter certificate information.

### 2. Configure Signing

Create `android/keystore.properties`:

```properties
storeFile=/absolute/path/to/pinokio-release.keystore
storePassword=your_store_password
keyAlias=pinokio
keyPassword=your_key_password
```

Update `android/app/build.gradle` to use the keystore:

```gradle
android {
    ...
    signingConfigs {
        release {
            def keystorePropertiesFile = rootProject.file("keystore.properties")
            if (keystorePropertiesFile.exists()) {
                def keystoreProperties = new Properties()
                keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
                
                storeFile file(keystoreProperties['storeFile'])
                storePassword keystoreProperties['storePassword']
                keyAlias keystoreProperties['keyAlias']
                keyPassword keystoreProperties['keyPassword']
            }
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 3. Build Release APK

```bash
npm run android:build:release
```

Output: `android/app/build/outputs/apk/release/app-release.apk`

## Troubleshooting

### Common Issues

**Problem**: `ANDROID_HOME not set`
- **Solution**: Set the ANDROID_HOME environment variable as described above

**Problem**: `SDK location not found`
- **Solution**: Create `android/local.properties` with:
  ```properties
  sdk.dir=/path/to/Android/Sdk
  ```

**Problem**: Gradle build fails
- **Solution**: Ensure you have internet connection for Gradle to download dependencies
- Try: `cd android && ./gradlew clean`

**Problem**: App crashes on startup
- **Solution**: Make sure the Pinokio server is running on localhost:42000
- Check logs: `adb logcat | grep -i pinokio`

**Problem**: "Unable to connect to server" error
- **Solution**: The app requires a local Pinokio server. This is currently designed for development/testing
- Future versions may include embedded server functionality

### Viewing Logs

```bash
# View all logs
adb logcat

# Filter for Pinokio app
adb logcat | grep -i pinokio

# Clear logs
adb logcat -c

# View Chrome DevTools (for WebView debugging)
# Open chrome://inspect in Chrome browser while app is running
```

## Architecture

### How It Works

1. **Capacitor Wrapper**: The Android app is a native wrapper around a WebView
2. **Web Assets**: Located in `www/` directory, synced to `android/app/src/main/assets/public`
3. **Server Connection**: The app loads an iframe pointing to `http://localhost:42000`
4. **Native Bridge**: Capacitor provides APIs to access native Android features

### Project Structure

```
pinokio/
├── android/                      # Native Android project
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml
│   │   │   ├── java/computer/pinokio/MainActivity.java
│   │   │   └── res/             # Android resources (icons, etc.)
│   │   └── build.gradle         # App-level build config
│   ├── build.gradle              # Project-level build config
│   └── gradlew                   # Gradle wrapper script
├── www/                          # Web assets for Android
│   ├── index.html                # App launcher page
│   └── icon.png                  # App icon
├── capacitor.config.ts           # Capacitor configuration
├── android_build.sh              # Build script
└── package.json                  # Android npm scripts

```

### Configuration Files

- **capacitor.config.ts**: Main Capacitor configuration
- **android/app/build.gradle**: Android app build configuration
- **android/app/src/main/AndroidManifest.xml**: Android app manifest
- **www/index.html**: Web app entry point

## Next Steps

After building successfully:

1. Test the app on different Android versions
2. Optimize app size and performance
3. Add app signing for release builds
4. Configure ProGuard for code obfuscation
5. Submit to Google Play Store (if desired)

## Resources

- [Capacitor Documentation](https://capacitorjs.com/docs)
- [Android Developer Guide](https://developer.android.com/guide)
- [Pinokio Official Website](https://pinokio.co)

## Support

For issues specific to the Android build, please open an issue on the GitHub repository with:
- Android version
- Device/emulator details
- Build logs
- Error messages
