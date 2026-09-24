# Flutter Demo APK

Simple Flutter Counter app ready to build APK online.

## Build APK Options

### 1. GitHub Actions (Recommended - Free)
1. Go to the **Actions** tab of this repository
2. Select **Build Android APK** workflow
3. Click **Run workflow** → **Run workflow**
4. Wait for the build to finish (usually 4-8 minutes)
5. Download the APK from the **Artifacts** section at the bottom of the workflow run

### 2. Codemagic
1. Go to [codemagic.io](https://codemagic.io)
2. Connect this GitHub repository
3. Select Flutter project
4. Start the Android workflow → Download APK

### 3. GitHub Codespaces
1. Click **Code** → **Codespaces** → **Create codespace on main**
2. In the terminal run:
   ```bash
   flutter pub get
   flutter build apk --release
   ```
3. Download the APK from `build/app/outputs/flutter-apk/app-release.apk`

## Notes
- Project uses Gradle 8.14 + AGP 8.11.1 (compatible with current Flutter stable)
- Java 17 is required
- Release APK is signed with debug keys (for testing only)
