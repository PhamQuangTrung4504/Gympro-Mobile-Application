# GymPro Mobile Application

## Project Summary

GymPro is a multi-platform fitness management application that digitizes day-to-day gym operations and improves the member experience in one unified product.

The system serves three user groups:

- Members: register, buy memberships, follow workout plans, check in with QR, read news, and buy fitness products.
- Admins: manage users, memberships, content, products, orders, schedules, and reporting.
- Personal Trainers (PT): manage rental requests and training sessions.

This project demonstrates end-to-end product delivery across business design, real-time data operations, payment flow, content management, and AI-assisted health guidance.

## 1. Product Goals

### Business Problem

- Many gyms still rely on fragmented workflows (manual notes, chat threads, spreadsheets), which makes operations and revenue tracking difficult.
- Members expect a modern digital journey: membership purchase, workout tracking, fast consultation, and commerce.

### GymPro Objectives

- Centralize the full member journey in one app.
- Standardize operations for Admin and PT workflows with real-time data.
- Increase retention with personalized experiences (workout plans plus AI guidance).

## 2. Core Value

- Combines multiple domains in one app: memberships, workout planning, PT rental, product commerce, news, and QR access control.
- Real-time data workflow with Firebase services.
- Built-in AI Chat using local fitness datasets for BMI, BMR, TDEE, workout, and nutrition guidance.
- Modular source organization for easier domain-based extension.

## 3. User-Facing Features

### 3.1 Member Features

- Authentication: sign up, sign in, forgot password, profile update, avatar update, account changes.
- Memberships: browse plans, checkout, payment status tracking, and purchased membership history.
- Workout schedules: choose preset plans, track progress, pause, resume, and complete sessions.
- News: list and details view.
- Shopping: browse products, manage cart, shipping address, place orders, review order history.
- PT rental: create requests, track status, and review session history.
- QR check-in and check-out: entry and exit validation.
- AI Chat: quick Q and A for body metrics, training, and nutrition.

### 3.2 Admin Features

- User and role management.
- Exercise catalog management.
- Membership plan management and purchase operations.
- Workout template management and member schedule operations.
- News management (create, edit, delete, publish).
- Product, inventory, and order management.
- Check-in and check-out operations.
- Reporting dashboard: revenue, transactions, membership distribution, PT revenue, and product revenue.

### 3.3 PT Features

- PT dashboard and schedule management.
- PT rental request processing and status updates.
- Session tracking for active rentals.

## 4. Main Workflows

### 4.1 App Startup and Routing

- The app initializes Vietnamese locale data and Firebase in the entrypoint.
- Startup flow checks session state.
- Role-aware routing:
- Not logged in: login screen.
- Logged in as member: member home.
- Logged in as PT: PT dashboard.

### 4.2 Membership Purchase Flow

- Member selects a membership plan.
- The app creates a payment transaction in pending state.
- Payment methods include transfer flow (VietQR style) and pay-at-gym process.
- On successful payment, an active membership record is created with plan validity.

### 4.3 Product Commerce Flow

- Member adds products to cart.
- Order is created with shipping and payment details.
- Inventory is updated after order placement.
- Member tracks or cancels orders based on current order state.

### 4.4 QR Check-In Flow

- The app generates a user-specific QR payload.
- Backend logic validates QR and membership validity.
- Successful validation writes check-in or check-out records to Firestore.

### 4.5 AI Chat Flow

- AI Chat processes Vietnamese prompts with intent matching.
- It reads local JSON datasets for fitness context.
- Responses are generated using current conversation context and follow-up intent.

## 5. Technical Architecture

### 5.1 Platform and Architecture Style

- Frontend: Flutter and Dart.
- App architecture: feature-driven MVC/MVVM hybrid with clear separation:
- Model: domain entities and Firestore mapping.
- Controller: business orchestration and state transitions.
- Service: data access and external integration.
- View: UI and interaction layer.
- State management and routing: GetX.

### 5.2 Backend and Data Layer

- Firebase Authentication for account identity.
- Cloud Firestore for transactional and real-time business data.
- Firebase Storage for media assets.
- Firebase configuration and rules files are included:
- firebase.json
- firestore.rules
- firestore.indexes.json
- storage.rules

### 5.3 Libraries and Packages in Use

- UI and UX: google_fonts, lottie, intl.
- State and navigation: get.
- Networking: dio, http.
- Charts and analytics visualization: fl_chart.
- Media and device: camera, camera_web, image_picker, permission_handler.
- QR and scanning: qr_flutter, mobile_scanner.
- Video playback: youtube_player_flutter.
- Persistence and cache: shared_preferences, cached_network_image.
- Utility: path, url_launcher.

### 5.4 Tooling and Build Systems

- Flutter SDK and Dart SDK.
- Android build toolchain: Gradle (Kotlin DSL in android/\*.kts).
- iOS build toolchain: Xcode project and workspace under ios/.
- Desktop targets: Linux and Windows CMake runner files.
- Linting and static checks: flutter_lints via analysis_options.yaml.
- VS Code task support: Flutter Run task is available in this workspace.

### 5.5 Optional Node.js Utilities

- package.json includes Node dependencies: express, cors, qrcode, uuid, concurrently.
- Current repository contains helper files mock-server.js and simple-server.js (both are currently empty).
- Current npm script backend points to backend/production-server.js, which does not exist in this repository state.

## 6. Source Code Organization

- Entry and app shell: lib/main.dart, lib/app.dart.
- Routing: lib/routes/.
- Business logic: lib/controllers/.
- Integrations and workflows: lib/services/.
- Domain models: lib/models/.
- UI layer: lib/views/, lib/screens/, lib/widgets/.
- Feature module example: lib/features/ai_chat/.
- Platform folders: android/, ios/, web/, linux/, windows/.

## 7. Firestore Data Model

Primary collections:

- users: profile, role, and account metadata.
- membership_cards: membership plan definitions.
- membership_purchases and user_memberships: purchase history and activation status.
- workout_schedules and user_schedules: templates and user progress.
- trainers and trainer_rentals: PT profile and rental workflow.
- products and orders: commerce and fulfillment records.
- news: content records.
- payment_transactions: payment lifecycle tracking.
- check_ins: QR attendance logs.

## 8. Environment and Setup

### Requirements

- Flutter stable SDK.
- Dart SDK (provided with Flutter).
- Android Studio and Android SDK for Android builds.
- Xcode for iOS builds.
- A configured Firebase project matching firebase_options.
- Node.js and npm only if Node helper scripts are required.

### Environment Check

```bash
flutter --version
flutter doctor
```

### Install Dependencies

```bash
flutter pub get
```

## 9. Run Instructions

### Standard Run

```bash
flutter run
```

### Platform-Specific Run

```bash
flutter run -d android
flutter run -d ios
flutter run -d chrome
flutter run -d windows
```

### VS Code Task

- Use the available task: Flutter Run.

## 10. Short Conclusion

GymPro is a practical, production-style fitness platform project that demonstrates complete product engineering capability:

- Multi-role business design for members, admins, and PTs.
- Modular and scalable source architecture.
- Real integration of payments, commerce, scheduling, AI assistant behavior, and QR access control.

This project is suitable for evaluating full-cycle product development skills, from business thinking to implementation and deployment readiness.
