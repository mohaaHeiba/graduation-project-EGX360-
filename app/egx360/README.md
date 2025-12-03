# EGX 360

**EGX 360** is a comprehensive, feature-rich Flutter application designed for tracking the Egyptian Exchange (EGX). It combines real-time market data, advanced charting, and a vibrant social community to empower investors with the tools they need to make informed decisions.

## 🚀 Features


### 👥 Community & Social
-   **Social Feed**: A dynamic feed where users can share analysis, news, and thoughts.
-   **Rich Interactions**: Like, comment, and reply to posts to engage with the community.
-   **User Profiles**: customizable profiles showcasing user activity, followers, and following lists.
-   **Follow System**: Build your network by following other investors and influencers.

### � Authentication & Security
-   **Secure Login/Signup**: Robust authentication system using Supabase.
-   **Password Management**: Built-in flows for "Forgot Password" and "Create New Password".
-   **Google Sign-In**: Seamless social login integration.

### 🛠 Core Utilities
-   **Smart Search**: Quickly find stocks or other users with an optimized search experience.
-   **Settings**: Comprehensive app settings including theme toggles and notification preferences.
-   **Offline First**: Data caching with `Floor` ensures key features work even without an internet connection.

---

## 🏗 Architecture

This project is built using a **Feature-First Clean Architecture**, ensuring scalability, testability, and maintainability.

### Layers
-   **Presentation Layer**: Contains UI components (Pages, Widgets) and State Management (Controllers).
-   **Domain Layer**: Defines the business logic (Use Cases) and Entities.
-   **Data Layer**: Handles data retrieval (Repositories, Data Sources) and Models.

### Tech Stack
-   **State Management**: [GetX](https://pub.dev/packages/get) is used for reactive state management, dependency injection (`Bindings`), and route management (`AppPages`).
-   **Backend**: [Supabase](https://supabase.com/) provides the backend infrastructure for authentication, real-time database, and storage.
-   **Local Storage**: [Floor](https://pub.dev/packages/floor) provides a type-safe SQLite abstraction for caching data locally.
-   **Theming**: Fully dynamic theming system supporting Light and Dark modes (`AppTheme`, `AppGradients`).

### Key Services (`lib/core/services`)
-   `NetworkService`: Manages API calls and connectivity status.
-   `MediaService`: Handles image picking and compression.
-   `PermissionService`: Manages app permissions seamlessly.

---

## 📂 Project Structure

The codebase is organized to separate core utilities from feature-specific logic:

```
lib/
├── core/                  # Shared utilities and configuration
│   ├── bindings/          # Dependency injection bindings
│   ├── constants/         # App-wide constants
│   ├── routes/            # App navigation and route definitions
│   ├── services/          # Core services (Network, Media, etc.)
│   ├── theme/             # App theme and styling
│   └── utils/             # Helper functions
│
├── features/              # Feature modules
│   ├── auth/              # Authentication (Login, Signup, etc.)
│   ├── community/         # Social feed and interactions
│   ├── markets/           # Market data and charts
│   ├── post_details/      # Detailed view for posts
│   ├── profile/           # User profiles and connections
│   ├── stock_chat/        # Stock-specific chat rooms
│   └── ...
│
└── main.dart              # Application entry point
```

---

## 🏁 Getting Started

### Prerequisites
-   [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.9.2 or higher)
-   Dart SDK

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/egx360.git
    cd egx360
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Environment Setup:**
    Create a `.env` file in the root directory and add your keys:
    ```env
    SUPABASE_URL=your_supabase_url
    SUPABASE_ANON_KEY=your_supabase_anon_key
    ```

4.  **Run the app:**
    ```bash
    flutter run
    ```

## 📦 Key Dependencies

| Package | Purpose |
| :--- | :--- |
| `supabase_flutter` | Backend & Auth |
| `get` | State Management & Routing |
| `floor` | Local Database (SQLite) |
| `candle_stick` | Financial Charts |
| `cached_network_image` | Image Caching |
| `flutter_local_notifications` | Notifications |
| `google_sign_in` | Social Auth |

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
