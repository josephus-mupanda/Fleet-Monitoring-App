# 🚘 Fleet Monitoring App – Flutter + Google Maps

A mobile and web application to **track live car locations** in Kigali with Google Maps, status filters, and car details.  
Built in Flutter using real-time polling, state management (Provider for this case ), and REST APIs.

<div align="center">
  <img src="docs/banner.png" width="75%" alt="Fleet Monitoring Banner" />
</div>

---

## 🌐 Live Demo

👉 Try it on the web: [fleet-monitoring.vercel.app](https://fleet-monitoring.vercel.app)

---

## 📱 Key Features

| Feature                                        | Screenshot                        |
|------------------------------------------------|-----------------------------------|
| **Real-time Google Map** – See all cars on map | ![map](docs/map_live.png)         |
| **Search & Filter** – Parked / Moving          | ![filter](docs/filter_status.png) |
| **Vehicle Details** – Speed, location, status  | ![details](docs/car_detail.png)   |
| **Pull-to-Refresh** – With auto-polling        | ![refresh](docs/map_live.png)     |

---

## 🧠 How It Works

- **Frontend** built in **Flutter**
- **Backend API**: mock API (or live) returning car objects with geolocation
- **Location polling** every 5 seconds
- **State management** via Provider
- **Responsive UI** for Android, iOS & Web

---

## 🛠 Tech Stack

| Purpose | Package |
|-------|---------|
| Google Maps | `google_maps_flutter` |
| State Management | `provider` |
| Environment Configuration | `flutter_dotenv` |
| Local Storage | `shared_preferences` |
| Toasts & Alerts | `motion_toast` |
| Splash Screen | `flutter_native_splash` |
| Launcher Icon | `flutter_launcher_icons` |

📦 Screenshot of `pubspec.yaml`:
![pubspec](docs/pubspec_packages.png)

---

## 🗂 Project Structure

| Folder                                           | Screenshot |
|--------------------------------------------------|------------|
| `lib/core/` – config, layout,routes,themes,utils | ![core](docs/tree_core.png) |
| `lib/models/` – car model                        | ![models](docs/tree_models.png) |
| `lib/services/` – car service                    | ![services](docs/tree_services.png) |
| `lib/providers/` – car provider                  | ![providers](docs/tree_providers.png) |
| `lib/screens/` – UI views: home and car detail   | ![screens](docs/tree_screens.png) |

---

## 🔐 Environment Configuration

Sensitive data like API keys are stored in a `.env` file (for Android) and injected into:

- `android/local.properties`
- `ios/Runner/Info.plist` (visible for ios in this case)
- `web/index.html` (visible in frontend)

📷 Example `.env` config:
![env](docs/env_file.png)

---

## 🚀 Getting Started

```bash
git clone https://github.com/josephus-mupanda/fleet-monitoring.git
cd fleet-monitoring
flutter pub get
```
---
## For Android
📷 Example `.env` config:
echo "GOOGLE_MAPS_API_KEY=your_key" > .env
flutter run -d android

---

## For iOS
Make sure your key is in `Info.plist` then:
flutter run -d ios

---

## For Web
Make sure the key is injected into `web/index.html` then:
flutter run -d chrome

