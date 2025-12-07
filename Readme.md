# BistroApp – Customer Restaurant iOS App  
**Developer Setup Guide for macOS**

---

## Overview

This guide provides step-by-step instructions for setting up, building, and running the **BistroApp** iOS customer application on a **MacBook**. The app is built with **SwiftUI**, powered by **Firebase** (Authentication, Firestore, Cloud Messaging), and follows modern iOS development best practices.

> ✅ **Target Platform**: iOS 16.0+  
> ✅ **Required OS**: macOS 13 (Ventura) or later  
> ✅ **Primary IDE**: Xcode 15+

---

## Prerequisites

Before you begin, ensure your development environment is ready:

### 1. **Hardware & Software**
- **MacBook** with Apple Silicon (M1/M2/M3) or Intel (macOS 13+)
- **Xcode 15.2 or later**  
  → Install from the [Mac App Store](https://apps.apple.com/us/app/xcode/id497799835)
- **Apple Developer Account** (free tier is sufficient for development and testing)

### 2. **Firebase Project**
- A **Firebase project** with the following services enabled:
  - **Authentication** (Email/Password + Sign in with Apple)
  - **Firestore Database**
  - **Cloud Messaging** (optional for push notifications)

> 🌐 Go to [Firebase Console](https://console.firebase.google.com/) to create a project.

---

## Step 1: Clone the Repository

Open **Terminal** and run:

```bash
git clone https://github.com/elonmasai7/bistroapp-ios.git
cd bistroapp-ios
```


---

## Step 2: Set Up Firebase

### 2.1 Register Your iOS App in Firebase
1. In the [Firebase Console](https://console.firebase.google.com/), open your project.
2. Click the **iOS icon** (📱) to add a new app.
3. Enter your **Bundle Identifier** (e.g., `com.yourcompany.BistroApp`).
   > 💡 You can find or set this in Xcode later under **Target → General → Bundle Identifier**.
4. Enter an **App Nickname** (e.g., `BistroApp - Dev`).
5. Click **Register app**.

### 2.2 Download Configuration File
1. Click **Download GoogleService-Info.plist**.
2. **Drag this file** into your Xcode project:
   - Drop it into the root folder (same level as `ContentView.swift`)
   - ✅ **Check “Copy items if needed”**
   - ✅ **Add to your main app target**

> ⚠️ **Never commit `GoogleService-Info.plist` to public repositories.**  
> Add it to your `.gitignore`:
> ```bash
> echo "GoogleService-Info.plist" >> .gitignore
> ```

---

## Step 3: Install Dependencies

This project uses **Swift Package Manager (SPM)** — no CocoaPods needed.

### 3.1 Open in Xcode
```bash
open BistroApp.xcodeproj
```

> If you see a `.xcworkspace`, use that instead (unlikely with SPM-only projects).

### 3.2 Add Firebase via SPM (if not auto-detected)
1. In Xcode, go to **File → Add Package Dependencies...**
2. Paste this URL:
   ```
   https://github.com/firebase/firebase-ios-sdk
   ```
3. Set **Dependency Rule** to **“Up to next major version”**
4. Select the following libraries:
   - `FirebaseAuth`
   - `FirebaseFirestore`
   - `FirebaseStorage` (for menu images)
   - `FirebaseMessaging` (for push notifications)
5. Click **Add Package**

> ✅ Xcode will resolve and download dependencies automatically.

---

## Step 4: Configure Xcode Project

### 4.1 Set Bundle Identifier
1. In Xcode, select the top-level project (blue icon).
2. Under **Targets**, select `BistroApp`.
3. Go to **Signing & Capabilities**.
4. Set **Bundle Identifier** to match what you registered in Firebase (e.g., `com.yourcompany.BistroApp`).

### 4.2 Enable Capabilities
In **Signing & Capabilities**, click **+ Capability** and add:
- **Sign in with Apple** → Required for App Store compliance
- **Push Notifications** → For order status alerts
- **Background Modes** → Check **“Remote notifications”**

---

## Step 5: Add Sample Data to Firestore

To avoid a blank menu, seed your database:

### 5.1 Enable Firestore in Test Mode (Temporary)
> ⚠️ Only for development! Switch to production rules before launch.

1. In Firebase Console, go to **Firestore Database**.
2. Click **Create Database**.
3. Start in **“Test mode”** → Click **Next** → Select location (e.g., `us-central1`) → **Enable**.

### 5.2 Add a Menu Item
1. In Firestore, create a collection named `menu`.
2. Add a document with these fields:

| Field | Type | Value |
|------|------|-------|
| `name` | string | `"Truffle Pasta"` |
| `description` | string | `"Wild mushrooms, truffle oil, parmesan"` |
| `price` | number | `18.99` |
| `category` | string | `"Mains"` |
| `isVegan` | boolean | `false` |
| `isGlutenFree` | boolean | `false` |
| `imageURL` | string | `"https://example.com/pasta.jpg"` *(use a real image URL)* |

> 🔁 Repeat to add more items.

---

## Step 6: Build and Run

### 6.1 On Simulator (Quick Test)
1. In Xcode toolbar, select an iPhone simulator (e.g., **iPhone 15**).
2. Click **▶️ Run** (or press `Cmd + R`).
3. The app will launch with **Sign in with Apple**.

> ✅ You can test menu browsing, cart, and checkout flow without a real device.

### 6.2 On a Physical iPhone (Recommended)
1. Connect your iPhone via USB.
2. Unlock your phone and **trust the computer** if prompted.
3. In Xcode, select your device from the scheme menu.
4. Click **▶️ Run**.

> 🔐 First-time setup:
> - Go to **Settings → Privacy & Security → Developer Mode** → Enable it.
> - Go to **Settings → General → VPN & Device Management** → Trust your developer profile.

---

## Step 7: Verify Key Integrations

### ✅ Firebase Authentication
- After signing in with Apple, check Firebase Console → **Authentication** → **Users**. You should see your account.

### ✅ Firestore Read
- The menu should load your sample items. If blank, check:
  - Bundle ID matches Firebase registration
  - `GoogleService-Info.plist` is in the correct target
  - No typos in collection name (`menu`)

### ✅ Cart & Order Placement
- Add an item → Customize → Checkout → Place Order.
- Check Firebase Console → **Firestore** → `orders` collection for a new document.

---

## Troubleshooting

| Issue | Solution |
|------|--------|
| **“No such module Firebase”** | Clean build: **Product → Clean Build Folder** (`Shift + Cmd + K`) |
| **White screen on launch** | Ensure `FirebaseApp.configure()` is called in `AppDelegate` |
| **Apple Sign In fails** | Verify **“Sign in with Apple”** is added in **Signing & Capabilities** |
| **Firestore permission denied** | Temporarily use **test mode rules**:<br>`rules_version = '2'; service cloud.firestore { match /databases/{database}/documents { match /{document=**} { allow read, write: if true; } } }` |
| **App crashes on image load** | Replace placeholder `imageURL` with a valid HTTPS image URL |

---

## Project Structure

```
BistroApp/
├── BistroApp.swift          # App entry point + Firebase setup
├── Models/
│   └── Models.swift         # Data structures (MenuItem, Order, etc.)
├── Services/
│   └── FirebaseService.swift # Firebase Auth/Firestore logic
├── Views/
│   ├── ContentView.swift    # Main router (auth vs. app)
│   ├── MenuView.swift       # Menu browsing
│   ├── CartView.swift       # Cart & checkout
│   └── ProfileView.swift    # Order history & loyalty
└── GoogleService-Info.plist # Firebase config (ignored in git)
```

---

## Next Steps for Development

1. **Replace test Firestore rules** with secure production rules.
2. **Add CI/CD** with GitHub Actions or Fastlane.
3. **Integrate Apple Pay** for seamless checkout.
4. **Write unit tests** for `FirebaseService`.
5. **Localize** for multiple languages.

---

## Need Help?

- Firebase Docs: [https://firebase.google.com/docs/ios/setup](https://firebase.google.com/docs/ios/setup)
- Apple Developer Forum: [https://developer.apple.com/forums/](https://developer.apple.com/forums/)
- File an issue in the GitHub repo

---

**Happy coding!** 🍽️📱  
*Built with SwiftUI, Firebase, and ❤️ for restaurant customers.*