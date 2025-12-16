# BistroApp – Customer Restaurant iOS App

**Developer Setup Guide for macOS**

---

## Overview

**BistroApp** is a modern iOS customer-facing restaurant application built with **SwiftUI** and powered by **Firebase**. It enables users to browse menus, manage carts, place orders, and receive real-time updates.

The project follows current iOS development best practices and uses **Swift Package Manager (SPM)** for dependency management.

**Target Platform**

* iOS 16.0+
* macOS 13 (Ventura)+
* Xcode 15+

---

## Technology Stack

* **Language:** Swift 5.9+
* **UI Framework:** SwiftUI
* **Backend:** Firebase
* **Dependency Manager:** Swift Package Manager (SPM)
* **Architecture:** MVVM
* **Authentication:** Sign in with Apple, Email/Password
* **Database:** Firestore
* **Push Notifications:** Firebase Cloud Messaging (optional)

---

## Prerequisites

### Hardware & Software

* macOS 13+ (Apple Silicon or Intel)
* Xcode 15.2 or later
* Apple Developer Account (free tier is sufficient)

### Firebase Requirements

A Firebase project with the following enabled:

* Authentication

  * Email/Password
  * Sign in with Apple
* Firestore Database
* Cloud Messaging (optional)

Firebase Console:
[https://console.firebase.google.com/](https://console.firebase.google.com/)

---

## Step 1: Clone the Repository

```bash
git clone https://github.com/elonmasai7/bistroapp-ios.git
cd bistroapp-ios
```

---

## Step 2: Dependencies

This project uses **Swift Package Manager (SPM)**.
**CocoaPods is NOT required.**

### Included Dependencies

| Dependency          | Purpose                     |
| ------------------- | --------------------------- |
| FirebaseAuth        | User authentication         |
| FirebaseFirestore   | Menu, orders, and user data |
| FirebaseStorage     | Menu images                 |
| FirebaseMessaging   | Push notifications          |
| FirebaseCrashlytics | Crash reporting (optional)  |

### Firebase SDK (SPM)

**Repository URL**

```
https://github.com/firebase/firebase-ios-sdk
```

**Dependency Rule**

* Up to Next Major Version

### Adding Dependencies Manually (If Needed)

1. Open the project in Xcode:

   ```bash
   open BistroApp.xcodeproj
   ```

2. Go to **File → Add Package Dependencies…**

3. Paste:

   ```
   https://github.com/firebase/firebase-ios-sdk
   ```

4. Select only the required products:

   * FirebaseAuth
   * FirebaseFirestore
   * FirebaseStorage
   * FirebaseMessaging
   * FirebaseCrashlytics

5. Click **Add Package**

Xcode will resolve and link dependencies automatically.

---

## Step 3: Firebase Configuration

### Register iOS App

1. Open Firebase Console
2. Add a new iOS app
3. Use a bundle ID such as:

   ```
   com.yourcompany.BistroApp
   ```

### Configuration File

1. Download `GoogleService-Info.plist`
2. Drag it into the Xcode project root
3. Ensure:

   * “Copy items if needed” is checked
   * Added to the main app target

**Important:**
Do not commit this file to version control.

```bash
echo "GoogleService-Info.plist" >> .gitignore
```

---

## Step 4: Xcode Project Setup

### Bundle Identifier

* Target → Signing & Capabilities
* Match the bundle ID used in Firebase

### Required Capabilities

Add the following:

* Sign in with Apple
* Push Notifications
* Background Modes → Remote Notifications

---

## Step 5: Firestore Sample Data

### Enable Firestore (Development Only)

* Create database
* Start in **Test Mode**
* Choose region (e.g., `us-central1`)

### Sample Menu Document

Collection: `menu`

| Field        | Type    | Example                     |
| ------------ | ------- | --------------------------- |
| name         | string  | Truffle Pasta               |
| description  | string  | Wild mushrooms, truffle oil |
| price        | number  | 18.99                       |
| category     | string  | Mains                       |
| isVegan      | boolean | false                       |
| isGlutenFree | boolean | false                       |
| imageURL     | string  | HTTPS image URL             |

---

## Step 6: Build & Run

### Simulator

* Select iPhone 15 (or newer)
* Run with `Cmd + R`

### Physical Device

* Connect iPhone
* Enable Developer Mode
* Trust developer profile
* Run from Xcode

---

## Verification Checklist

* Authentication users appear in Firebase Console
* Menu loads from Firestore
* Orders create documents in `orders` collection
* Push notifications register successfully (if enabled)

---

## Troubleshooting

| Issue                       | Resolution                               |
| --------------------------- | ---------------------------------------- |
| No such module Firebase     | Clean build folder                       |
| Blank screen on launch      | Ensure FirebaseApp.configure() is called |
| Apple Sign In fails         | Capability missing                       |
| Firestore permission denied | Use test rules for development           |
| Image crash                 | Ensure HTTPS image URLs                  |

---

## Project Structure

```
BistroApp/
├── BistroApp.swift
├── Models/
├── Services/
├── Views/
├── Assets.xcassets
└── GoogleService-Info.plist (ignored)
```

---

## Next Steps

* Replace test Firestore rules
* Add CI/CD (GitHub Actions or Fastlane)
* Integrate Apple Pay
* Add unit and UI tests
* Localize the app

---

## Support & Resources

* Firebase iOS Docs
  [https://firebase.google.com/docs/ios/setup](https://firebase.google.com/docs/ios/setup)
* Apple Developer Forums
  [https://developer.apple.com/forums/](https://developer.apple.com/forums/)
* GitHub Issues (project repo)

---

**BistroApp**
Built with SwiftUI and Firebase for a modern restaurant experience.

---

