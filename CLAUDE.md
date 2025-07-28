# 📱 Flutter Application 1

แอปพลิเคชันมือถือ Flutter ที่มีระบบ Login และการจัดการ Assets รูปภาพ พัฒนาด้วย Material Design และรองรับการพัฒนาทั้งบน Emulator และอุปกรณ์จริงผ่าน ADB/scrcpy

## 🚀 คู่มือเริ่มต้นฉบับเร่งรัด (Quick Start Guide)

คู่มือสำหรับนักพัฒนาใหม่ในการตั้งค่าโปรเจคและรันแอปพลิเคชันครั้งแรก

### 1. ข้อกำหนดเบื้องต้น (Prerequisites)
- **Flutter SDK version:** `3.32.6` (หรือสูงกว่า)
- **Dart SDK version:** `3.5.x` (หรือสูงกว่า)
- **IDE:** Visual Studio Code หรือ Android Studio
- **VS Code Extensions ที่แนะนำ:** `Dart`, `Flutter`, `Awesome Flutter Snippets`
- **Android Studio:** พร้อม Android SDK และ Device Manager
- **Git:** สำหรับ Version Control
- **USB Debugging:** เปิดใช้งานบนอุปกรณ์ Android
- **scrcpy:** สำหรับ device mirroring (ไม่บังคับ)

### 2. การตั้งค่าโปรเจค
1. **Clone repository:**
   ```bash
   git clone [your-repository-url]
   cd flutter_application_1
   ```

2. **ตรวจสอบ Flutter Environment:**
   ```bash
   flutter doctor
   ```

3. **Install Dependencies:**
   ```bash
   flutter clean
   flutter pub get
   ```

4. **ตรวจสอบ Connected Devices:**
   ```bash
   flutter devices
   ```

5. **เชื่อมต่ออุปกรณ์ Android และรันแอป:**
   ```bash
   flutter run -d 634916d5
   ```

6. **เปิด scrcpy สำหรับ screen mirroring:**
   ```bash
   C:\scrcpy\scrcpy.exe -s 634916d5
   ```

## 💻 การพัฒนา (Development)

คำสั่งและเครื่องมือที่ใช้ในการพัฒนาโปรเจคนี้

### 📱 คำสั่งที่ใช้บ่อย (Common Commands)

#### การรันแอปพลิเคชัน

- **รันแอปบนมือถือ (Debug Mode):**
  ใช้คำสั่งนี้เพื่อรันแอปบนอุปกรณ์ที่เชื่อมต่ออยู่ (รหัสเครื่อง `634916d5`)
  ```bash
  flutter run -d 634916d5
  ```

- **รันแอปบน Emulator:**
  ```bash
  flutter run
  # หรือระบุ emulator เฉพาะ
  flutter run -d emulator-5554
  ```

- **รันแบบ Release Mode:**
  ```bash
  flutter run --release -d 634916d5
  ```

#### การ Build APK

- **สร้าง Debug APK (สำหรับการพัฒนา):**
  ```bash
  flutter build apk --debug
  # Output: build/app/outputs/flutter-apk/app-debug.apk
  ```

- **สร้าง Release APK (สำหรับ Distribution):**
  ```bash
  flutter build apk --release
  # Output: build/app/outputs/flutter-apk/app-release.apk
  ```

- **สร้าง APK แยกตาม Architecture:**
  ```bash
  flutter build apk --split-per-abi
  ```

#### การติดตั้งแอป

- **ติดตั้งผ่าน Flutter:**
  ```bash
  flutter install
  # เลือกอุปกรณ์จากรายการ
  ```

- **ติดตั้งผ่าน ADB:**
  ```bash
  # ใช้ Debug APK
  adb install build/app/outputs/flutter-apk/app-debug.apk
  
  # ใช้ Release APK
  adb install build/app/outputs/flutter-apk/app-release.apk
  ```

### 🔧 Development Tools

#### Hot Reload & Hot Restart
- **Hot Reload:** กด `r` ใน terminal ขณะ `flutter run`
- **Hot Restart:** กด `R` ใน terminal ขณะ `flutter run`
- **Quit:** กด `q` เพื่อออกจาก flutter run

#### Code Analysis
```bash
# ตรวจสอบ Code Quality
flutter analyze

# แก้ไข Code Formatting
flutter format .

# อัพเดท Dependencies
flutter pub upgrade
```

## 🔌 ADB & Device Management

การจัดการอุปกรณ์และการใช้งาน Android Debug Bridge

### การตั้งค่าอุปกรณ์ Android

1. **เปิด Developer Options:**
   - Settings → About Phone → แตะ "Build Number" 7 ครั้ง

2. **เปิด USB Debugging:**
   - Settings → Developer Options → เปิด "USB Debugging"
   - Settings → Developer Options → เปิด "Install via USB"
   - Settings → Developer Options → เปิด "Stay awake" (แนะนำ)

3. **รับอนุญาต USB Debugging:**
   - เชื่อมต่อ USB และอนุญาตเมื่อมือถือถาม

### คำสั่ง ADB ที่สำคัญ

```bash
# แสดงรายการอุปกรณ์ที่เชื่อมต่อ
adb devices

# ติดตั้งแอป
adb install path/to/app.apk

# ถอนการติดตั้งแอป
adb uninstall com.example.flutter_application_1

# ดู Log ของแอป
adb logcat | grep flutter

# Shell เข้าอุปกรณ์
adb shell

# Screenshot
adb shell screencap /sdcard/screenshot.png
adb pull /sdcard/screenshot.png

# รีสตาร์ท ADB Server
adb kill-server
adb start-server
```

### ใช้ ADB แบบ Full Path (ถ้าไม่มีใน PATH)
```bash
"%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe" devices
```

## 📺 scrcpy - Screen Mirroring

การใช้งาน scrcpy สำหรับแสดงหน้าจอมือถือบน PC

### การติดตั้ง scrcpy

1. **ดาวน์โหลดจาก GitHub:**
   - https://github.com/Genymobile/scrcpy/releases
   - ดาวน์โหลด `scrcpy-win64-vX.X.X.zip`

2. **แตกไฟล์และตั้งค่า:**
   ```bash
   # แตกไฟล์ไปที่ C:\scrcpy
   # เพิ่ม PATH (ใน Command Prompt)
   setx PATH "%PATH%;C:\scrcpy"
   ```

### คำสั่ง scrcpy

```bash
# การใช้งานพื้นฐาน
C:\scrcpy\scrcpy.exe -s 634916d5

# แสดงเต็มจอ
C:\scrcpy\scrcpy.exe -s 634916d5 -f

# กำหนด Resolution (1080p)
C:\scrcpy\scrcpy.exe -s 634916d5 -m 1080

# บันทึกหน้าจอ
C:\scrcpy\scrcpy.exe -s 634916d5 --record=recording.mp4

# แสดงอย่างเดียว ไม่ให้ควบคุม
C:\scrcpy\scrcpy.exe -s 634916d5 --no-control

# ปิดเสียง
C:\scrcpy\scrcpy.exe -s 634916d5 --no-audio

# แสดงเฉพาะ Portrait
C:\scrcpy\scrcpy.exe -s 634916d5 --lock-video-orientation=0
```

### Keyboard Shortcuts ใน scrcpy
- **Ctrl+C:** Copy
- **Ctrl+V:** Paste  
- **Ctrl+Shift+V:** Paste as keystrokes
- **Ctrl+S:** Screenshot
- **Ctrl+O:** Turn screen off
- **Ctrl+Shift+O:** Turn screen on
- **Ctrl+R:** Rotate screen

## 🏗️ โครงสร้างโปรเจค (Project Structure)

```
flutter_application_1/
├── 📁 lib/                          # Source code หลัก
│   ├── 📄 main.dart                 # Entry point ของแอป
│   └── 📁 pages/
│       └── 📄 login.dart            # หน้า Login
├── 📁 assets/                       # ไฟล์ Assets
│   └── 📁 images/
│       ├── 🖼️ flowers.jpg          # รูปดอกไม้
│       └── 🖼️ travel-logo.jpg      # โลโก้
├── 📁 android/                      # การตั้งค่า Android
│   ├── 📄 build.gradle             # Project-level Gradle
│   ├── 📁 app/
│   │   └── 📄 build.gradle         # App-level Gradle
│   ├── 📄 settings.gradle          # Gradle Settings
│   ├── 📄 gradle.properties        # Gradle Properties
│   └── 📁 gradle/wrapper/
│       └── 📄 gradle-wrapper.properties
├── 📁 ios/                         # การตั้งค่า iOS
├── 📁 test/                        # Unit Tests
├── 📄 pubspec.yaml                 # Dependencies & Assets
├── 📄 README.md                    # คำอธิบายโปรเจค
└── 📄 CLAUDE.md                    # เอกสารนี้
```

## ⚙️ การตั้งค่า (Configuration)

### ข้อมูลอุปกรณ์ทดสอบ

#### Physical Device (Primary)
- **Device ID:** `634916d5`
- **Model:** `2109119DG`
- **Android Version:** `12 (API 31)`
- **Architecture:** `arm64`
- **Status:** ✅ Configured และพร้อมใช้งาน

#### Emulator
- **Device ID:** `emulator-5554`
- **API Level:** `34`
- **Architecture:** `x86_64`
- **Status:** ✅ Available

### Android Build Configuration

#### Current Setup
- **Compile SDK:** `flutter.compileSdkVersion`
- **Target SDK:** `flutter.targetSdkVersion`
- **Min SDK:** `flutter.minSdkVersion`
- **Java Version:** `17`
- **Kotlin Version:** `1.9.20`
- **Android Gradle Plugin:** `8.3.0`
- **Gradle Version:** `8.4`

#### Key Configuration Files

**android/app/build.gradle:**
```gradle
android {
    namespace = "com.example.flutter_application_1"
    compileSdk = flutter.compileSdkVersion
    
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }
    
    defaultConfig {
        applicationId = "com.example.flutter_application_1"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
}
```

**android/gradle.properties:**
```properties
org.gradle.jvmargs=-Xmx2G -XX:+HeapDumpOnOutOfMemoryError -XX:+UseParallelGC
android.useAndroidX=true
android.enableJetifier=true
android.enableR8=true
```

### Application Information
- **Package Name:** `com.example.flutter_application_1`
- **App Name:** `flutter_application_1`
- **Version:** `1.0.0+1`
- **Main Features:** Login functionality, Image assets
- **Supported Platforms:** Android (iOS support available)

### Assets
Images are stored in `assets/images/` and configured in `pubspec.yaml`:
- `flowers.jpg` - รูปดอกไม้
- `travel-logo.jpg` - โลโก้แอปพลิเคชัน

### Main Dependencies
See `pubspec.yaml` for complete dependency list. Main dependencies include:
- `flutter/material` - UI framework
- `flutter_lints` - Code analysis และ linting rules

## 🧪 การทดสอบ (Testing)

### Unit Testing
```bash
# รัน Unit Tests ทั้งหมด
flutter test

# รัน Test เฉพาะไฟล์
flutter test test/widget_test.dart

# รัน Test พร้อม Coverage
flutter test --coverage

# ดู Coverage Report (ต้องติดตั้ง lcov)
genhtml coverage/lcov.info -o coverage/html
```

### Integration Testing
```bash
# รัน Integration Tests บนอุปกรณ์
flutter drive --target=test_driver/app.dart -d 634916d5
```

### Widget Testing
```dart
// ตัวอย่างใน test/widget_test.dart
testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  expect(find.text('0'), findsOneWidget);
  expect(find.text('1'), findsNothing);
  
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  
  expect(find.text('0'), findsNothing);
  expect(find.text('1'), findsOneWidget);
});
```

## 🚀 Deployment

### Build สำหรับ Production

#### Android APK
```bash
# สร้าง Release APK
flutter build apk --release

# สร้าง AAB (สำหรับ Google Play Store)
flutter build appbundle --release
```

#### iOS (บน macOS)
```bash
# สร้าง iOS Build
flutter build ios --release
```

### การลงนาม APK (Code Signing)

1. **สร้าง Keystore:**
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. **สร้างไฟล์ android/key.properties:**
   ```properties
   storePassword=myStorePassword
   keyPassword=myKeyPassword
   keyAlias=upload
   storeFile=~/upload-keystore.jks
   ```

3. **อัพเดท android/app/build.gradle:**
   ```gradle
   android {
       ...
       signingConfigs {
           release {
               keyAlias keystoreProperties['keyAlias']
               keyPassword keystoreProperties['keyPassword']
               storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
               storePassword keystoreProperties['storePassword']
           }
       }
       buildTypes {
           release {
               signingConfig signingConfigs.release
           }
       }
   }
   ```

## 🐛 การแก้ปัญหา (Troubleshooting)

### ปัญหาที่พบบ่อยและวิธีแก้ไข

#### 1. Java Version Compatibility
**ปัญหา:** Build ล้มเหลวเนื่องจาก Java version ไม่ตรงกัน

**วิธีแก้:**
```bash
# ตรวจสอบ Java version
java -version

# อัพเดท Java version ใน android/app/build.gradle
compileOptions {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}
```

#### 2. Gradle Build Issues
**ปัญหา:** Gradle build ล้มเหลว

**วิธีแก้:**
```bash
# ล้าง Gradle cache
cd android
./gradlew clean

# ล้าง Flutter cache
cd ..
flutter clean
flutter pub get

# รีบิลด์
flutter build apk --debug
```

#### 3. USB Debugging Issues
**ปัญหา:** `INSTALL_FAILED_USER_RESTRICTED`

**วิธีแก้:**
1. ยกเลิก USB debugging authorizations ใน Developer Options
2. เปิด "Install via USB" ใน Developer Options
3. ถอดสายแล้วเสียบใหม่
4. อนุญาตเมื่อมือถือถาม "Allow USB debugging?"

#### 4. Device Not Found
**ปัญหา:** `adb devices` ไม่เจออุปกรณ์

**วิธีแก้:**
```bash
# รีสตาร์ท ADB Server
adb kill-server
adb start-server

# ตรวจสอบ USB Driver (Windows)
# ตรวจสอบ USB Cable และ Port

# ตรวจสอบ Developer Options
```

#### 5. INSTALL_FAILED_USER_RESTRICTED
**ปัญหา:** ติดตั้งแอปไม่ได้เนื่องจาก User restrictions

**วิธีแก้:**
1. ยกเลิก USB debugging authorizations ใน Developer Options
2. เปิด "Install via USB" ใน Developer Options  
3. ถอดสายแล้วเสียบใหม่
4. อนุญาตเมื่อมือถือถาม "Allow USB debugging?"

#### 6. AndroidManifest Issues
**ปัญหา:** HardcodedDebugMode error

**วิธีแก้:**
- ลบ `android:debuggable` attribute ออกจาก AndroidManifest.xml
- ให้ระบบจัดการ debug/release mode อัตโนมัติ

#### 5. Flutter Doctor Issues
**ปัญหา:** flutter doctor แสดง warning หรือ error

**วิธีแก้:**
```bash
# ดูรายละเอียด
flutter doctor -v

# แก้ไข Android licenses
flutter doctor --android-licenses

# อัพเดท Flutter
flutter upgrade
```

### คำสั่งเมื่อเจอปัญหา
```bash
# ล้างทุกอย่างและเริ่มใหม่
flutter clean
flutter pub get
cd android
./gradlew clean
cd ..
flutter build apk --debug

# ตรวจสอบ dependencies
flutter pub deps

# ตรวจสอบ outdated packages
flutter pub outdated
```

## 👥 การทำงานร่วมกันเป็นทีม (Team Collaboration)

### Git Workflow

#### Branch Strategy
```bash
# Main branches
main/master          # Production-ready code
develop             # Integration branch
feature/[feature-name]  # Feature development
hotfix/[issue-name]    # Critical bug fixes
```

#### การทำงานกับ Feature Branch
```bash
# สร้าง feature branch จาก develop
git checkout develop
git pull origin develop
git checkout -b feature/login-page

# Commit changes
git add .
git commit -m "feat: implement login page UI"

# Push และสร้าง Pull Request
git push origin feature/login-page
```

#### Commit Message Convention
```
feat: เพิ่มฟีเจอร์ใหม่
fix: แก้ไข bug
docs: อัพเดทเอกสาร
style: แก้ไข code style (ไม่เปลี่ยน logic)
refactor: ปรับปรุงโค้ดโดยไม่เปลี่ยนการทำงาน
test: เพิ่มหรือแก้ไข tests
chore: งานซ่อมบำรุง (dependencies, build scripts)
```

### Code Review Guidelines

#### สิ่งที่ต้องตรวจสอบ
- [ ] โค้ดทำงานถูกต้องและไม่มี bug
- [ ] โค้ดตาม coding standards และ best practices
- [ ] มี unit tests ครอบคลุม
- [ ] Performance ดี
- [ ] UI/UX ตาม design spec
- [ ] Security considerations
- [ ] Documentation อัพเดท

### Development Standards

#### Code Style
```bash
# ใช้ dart format
flutter format .

# ตรวจสอบด้วย analyzer
flutter analyze

# กำหนด line length = 80
```

#### Naming Conventions
```dart
// Classes: PascalCase
class UserProfile {}

// Variables & Functions: camelCase
String userName = 'john';
void getUserData() {}

// Constants: SCREAMING_SNAKE_CASE
static const String API_BASE_URL = 'https://api.example.com';

// Files: snake_case
user_profile.dart
api_service.dart
```

## 📚 Resources & References

### Documentation
- [Flutter Official Docs](https://docs.flutter.dev/)
- [Dart Language Guide](https://dart.dev/guides)
- [Material Design Guidelines](https://material.io/design)
- [Android Developer Guide](https://developer.android.com/)
- [scrcpy GitHub](https://github.com/Genymobile/scrcpy)

### Tools & Setup
- **scrcpy Installation Path:** `C:\scrcpy\scrcpy.exe`
- **ADB Path:** `%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe`
- **Primary Test Device:** 634916d5 (2109119DG)

### Current Project Dependencies
ตาม `pubspec.yaml` ปัจจุบัน:
```yaml
# Core
flutter:
  sdk: flutter

# Development
flutter_test:
  sdk: flutter
flutter_lints: ^3.0.2

# Assets
flutter:
  assets:
    - assets/images/
```

### Useful Packages สำหรับการพัฒนาต่อ
```yaml
# State Management
provider: ^6.0.0
bloc: ^8.0.0

# HTTP Requests
http: ^0.13.0
dio: ^5.0.0

# Local Storage
shared_preferences: ^2.0.0
sqflite: ^2.0.0

# Navigation
go_router: ^10.0.0

# UI Components
flutter_svg: ^2.0.0
cached_network_image: ^3.0.0
```

### Tools & Extensions

#### VS Code Extensions
- Dart
- Flutter
- Awesome Flutter Snippets
- Flutter Widget Snippets
- GitLens
- Error Lens

#### Useful Websites
- [pub.dev](https://pub.dev/) - Dart packages
- [Flutter Gallery](https://gallery.flutter.dev/) - UI examples
- [FlutterFire](https://firebase.flutter.dev/) - Firebase integration

## 🔄 Regular Maintenance

### Weekly Tasks
- [ ] รัน `flutter pub outdated` เพื่อตรวจสอบ package updates
- [ ] รัน `flutter analyze` เพื่อตรวจสอบ code quality
- [ ] รัน tests และตรวจสอบ coverage
- [ ] อัพเดท documentation หากมีการเปลี่ยนแปลง

### Monthly Tasks
- [ ] อัพเกรด Flutter SDK (`flutter upgrade`)
- [ ] อัพเดท dependencies (`flutter pub upgrade`)
- [ ] ทบทวน security vulnerabilities
- [ ] ทำความสะอาด unused code และ assets

---

## 📞 ติดต่อและสนับสนุน

### Team Contacts
- **Project Lead:** [ชื่อ] - [email]
- **Senior Developer:** [ชื่อ] - [email]
- **DevOps:** [ชื่อ] - [email]

### Emergency Contacts
- **Production Issues:** [emergency-contact]
- **Security Issues:** [security-contact]

---

**📝 เอกสารนี้อัพเดทล่าสุด:** [วันที่]  
**🔄 ครั้งต่อไปที่ต้อง Review:** [วันที่]

---
*📖 เอกสารนี้เป็น Single Source of Truth สำหรับโปรเจค Flutter Application 1*  
*💡 Generated with Claude Code assistance*