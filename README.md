# Flutter Demo APK

Simple Flutter Counter app ready to build APK online.

## Build APK Options

### 1. GitHub Actions (Recommended - Free)
1. Go to the **Actions** tab of this repository
2. Select **Build Android APK** workflow
3. Click **Run workflow**
4. Wait for the build to finish
5. Download the APK from the **Artifacts** section

### 2. Codemagic
1. Go to [codemagic.io](https://codemagic.io)
2. Connect this GitHub repository
3. Select Flutter project
4. Start build → Download APK

### 3. GitHub Codespaces
1. Click **Code** → **Codespaces** → **Create codespace**
2. In the terminal run:
   ```bash
   flutter pub get
   flutter build apk --release
   ```
3. Download the APK from `build/app/outputs/flutter-apk/app-release.apk`

## Local build (if you have Flutter)
```bash
flutter pub get
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`
