# 🔍 KhojMitra

AI-Powered Lost & Found Management Platform for Educational Institutions

## 📌 Overview

KhojMitra is a smart Lost & Found platform designed for colleges, universities, and campuses. The application helps students report lost or found items, discover potential matches using AI-powered similarity detection, and earn reward points for helping others recover belongings.

The platform provides a centralized and efficient way to manage lost and found items while encouraging community participation through a reward system.

---

## 🚀 Features

### 👤 Authentication

* Firebase Authentication
* Email & Password Login
* Secure User Sessions
* Logout Functionality

### 📦 Lost & Found Management

* Report Lost Items
* Report Found Items
* Upload Item Images
* Item Categorization
* Location Tracking
* Detailed Item Information

### 🤖 AI Matching System

* Similarity Detection Between Items
* Match Confidence Score
* Automated Match Suggestions
* Real-Time Analysis

### 🏆 Reward System

* Earn Points for Reporting Items
* Bonus Points for Successful Returns
* User Reward Tracking
* Community Engagement

### 📊 User Dashboard

* View Uploaded Items
* Track Returned Items
* Monitor Reward Points
* Manage Profile Information

### ☁️ Firebase Integration

* Cloud Firestore Database
* Firebase Authentication
* Firebase Storage
* Real-Time Data Updates

---

## 🛠️ Tech Stack

### Frontend

* Flutter
* Dart

### Backend & Cloud

* Firebase Authentication
* Cloud Firestore
* Firebase Storage

### State Management

* StreamBuilder
* Firebase Streams

### Additional Packages

* cached_network_image
* firebase_auth
* cloud_firestore
* firebase_storage
* image_picker

---

## 📂 Project Structure

```text
lib/
│
├── models/
│   └── item_model.dart
│
├── screens/
│   ├── login_screen.dart
│   ├── profile_screen.dart
│   ├── item_detail_screen.dart
│   └── home_screen.dart
│
├── services/
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   └── ai_matching_service.dart
│
├── widgets/
│   └── common_widgets.dart
│
├── utils/
│   └── theme.dart
│
└── main.dart
```

---

## ⚙️ Installation

### 1. Clone Repository

```bash
git clone https://github.com/prachikumari850/khojmitra.git
cd khojmitra
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

Add your Firebase configuration files:

#### Android

```text
android/app/google-services.json
```

#### Web

```text
lib/firebase_options.dart
```

Generate using:

```bash
flutterfire configure
```

### 4. Run Application

```bash
flutter run
```

For Web:

```bash
flutter run -d chrome
```

---

## 🔥 Firestore Collections

### users

```json
{
  "uid": "user_id",
  "name": "User Name",
  "email": "user@example.com",
  "rewardPoints": 100
}
```

### items

```json
{
  "id": "item_id",
  "title": "Lost Wallet",
  "description": "Black leather wallet",
  "category": "Accessories",
  "status": "lost",
  "location": "Library",
  "userId": "owner_id",
  "confidenceScore": 85,
  "isReturned": false
}
```

---

## 🏅 Reward Rules

| Action                     | Points |
| -------------------------- | ------ |
| Report Lost Item           | +10    |
| Report Found Item          | +10    |
| AI Match Success           | +20    |
| Item Successfully Returned | +30    |

---

## 📸 Screens

* Login Screen
* Home Dashboard
* Item Detail Screen
* Profile Screen
* AI Match Analysis
* Reward Dashboard

---

## 🎯 Future Enhancements

* QR Code Based Item Tracking
* WhatsApp Integration
* Push Notifications
* AI Image Recognition
* College Admin Dashboard
* Leaderboard System
* Chat Support

---

## 👩‍💻 Developed By

**Team UNFAZED X**

B.Tech Computer Science (AI)

ABESIT Group of Institutions

---

## 📄 License

This project is developed for educational and innovation purposes.

Feel free to use, modify, and enhance the project.
