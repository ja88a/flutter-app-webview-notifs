# Flutter Mobile Web App Shell

## General

A mobile app shell to display fullscreen mobile-friendly web sites, from its entry point URL.

A Flutter-based hybrid mobile web app for running on Android & iOS.

Expected features:
* Hybrid web mobile app: fullscreen web view
* Support for FCM push notifications: background & foreground
* Support for interacting with 3rd party mobile apps
* Mobile Apps packaging: app store based distribution; icons, labels & splash screen config

STATUS: *IN PROGRESS - Experimental*

Dev project initiated in March 2022.


## Requirements

### Tools

* Dart 2.16+
* Flutter SDK &amp; CLI 2.10+
* Android SDK &amp;, Studio and/or CLI dev tools
* VTx Emulators and/or hardware test devices
* Apple Xcode dev tools, iOS emulator (macos) or ios devices
* Firebase project
* Gradle 7.2+ &amp; Java JDK


### Firebase Cloud Messaging

The integration is done through the [flutter firebase plugin](https://pub.dev/packages/firebase_messaging).

Follow [these](https://pub.dev/packages/firebase_messaging) instructions depending on which platform you use.


## Main Actions

### Init
```
flutter pub get
flutter doctor
```

### Run locally
```
flutter run
```

### Build packages
```
flutter build
```


## Resources

### Flutter - Getting Started

A few resources to get you started with a Flutter application project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view their
[online documentation](https://flutter.dev/docs): tutorials, samples, guidance on mobile development, and a full API reference.


### Firebase Account

Create a Google Firebase account &amp; a Cloud Firebase Messaging (CFM) project from [here](https://firebase.google.com/docs/cloud-messaging)

### Setup iOS

To run the app on iOS you need to install this on a Mac:

* Flutter & Flutter SDK
* Xcode + Apple Developer account
* iOS simulator and/or hardware device

Follow [these](https://flutter.dev/docs/get-started/install/macos) instructions.


### Setup Android

To run the app on Android you need to install:

* Flutter & proper SDK
* Android Studio + Google [Developer] account
* Simulator and/or hardware device (USB or WiFi pairing)

Follow [these](https://flutter.dev/docs/get-started/install) instructions.
