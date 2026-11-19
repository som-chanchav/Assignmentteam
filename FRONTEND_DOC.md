# 📘 ឯកសារបច្ចេកទេស Frontend (Flutter Developer Specification)
## គម្រោង៖ កម្មវិធីស្វែងរក និងជួលផ្ទះ (Home Rental / Real Estate App)

---

> [!NOTE]
> ឯកសារនេះត្រូវបានបង្កើតឡើងសម្រាប់ Frontend Developers នៃក្រុមការងារ ដើម្បីងាយស្រួលបែងចែកការងារ សរសេរកូដតាមស្ដង់ដាររួម និងអនុវត្តតាម **Figma Design (12 Screens)** យ៉ាងសុក្រឹត ដោយប្រើប្រាស់ **Flutter** រួមជាមួយ **Cloud Firestore**។

---

## ១. ស្ថាបត្យកម្មគម្រោង (Project Architecture: MVC)

រចនាសម្ព័ន្ធ Folder ក្នុង `lib/` ត្រូវរៀបចំដូចខាងក្រោម ដើម្បីងាយស្រួល Teamwork និងមិនជាន់កូដគ្នា៖

```text
lib/
├── api/                  # សេវាកម្មទាក់ទង Firebase ឬ API ខាងក្រៅ
│   ├── firebase_service.dart
│   └── firestore_collections.dart
├── Controller/           # Business Logic និងគ្រប់គ្រង State
│   ├── auth_controller.dart
│   ├── house_controller.dart
│   ├── booking_controller.dart
│   └── favorite_controller.dart
├── models/               # Data Classes (JSON / Firestore Serialization)
│   ├── house_model.dart
│   ├── user_model.dart
│   └── booking_model.dart
├── View/                 # អេក្រង់ UI ទាំង ១២ តាម Figma
│   ├── onboarding/
│   │   ├── onboarding_screen.dart       # 01, 02, 03
│   ├── auth/
│   │   └── login_screen.dart             # 04 · ចូលគណនី
│   ├── home/
│   │   ├── home_screen.dart              # 06 · ទំព័រដើម
│   │   └── main_navigation_screen.dart   # Bottom Nav Bar
│   ├── drawer/
│   │   └── side_drawer.dart              # 05 · ម៉ឺនុយចំហៀង
│   ├── property/
│   │   ├── property_detail_screen.dart   # 07 · ព័ត៌មានលម្អិតផ្ទះ
│   │   └── rental_booking_screen.dart    # 08 · ស្នើសុំជួលផ្ទះ
│   ├── search/
│   │   └── search_screen.dart            # 09 · ស្វែងរកផ្ទះ
│   ├── favorites/
│   │   └── favorites_screen.dart         # 10 · ផ្ទះដែលពេញចិត្ត
│   ├── bookings/
│   │   └── my_bookings_screen.dart       # 11 · ការកក់របស់អ្នក
│   └── profile/
│       └── profile_screen.dart           # 12 · គណនីផ្ទាល់ខ្លួន
├── widgets/              # Reusable Components (ប្រើឡើងវិញច្រើនកន្លែង)
│   ├── house_card.dart
│   ├── custom_button.dart
│   ├── custom_text_field.dart
│   └── category_chip.dart
└── main.dart             # Entry Point & Theme Configuration
```

---

## ២. ប្រព័ន្ធ Design System & UI Tokens

| Token | តម្លៃ (Value) | ការប្រើប្រាស់ |
| :--- | :--- | :--- |
| **Primary Color** | `#163A35` (Deep Forest Green) | ប៊ូតុងគោល, Header, Selected Item |
| **Secondary Color** | `#D4A373` ឬ `#E59500` (Warm Amber/Gold) | Tag តម្លៃ, ផ្កាយ Rating, ប៊ូតុងពិសេស |
| **Background Color** | `#F9F9F7` (Soft Light Grey) | ផ្ទៃខាងក្រោយ App ទាំងមូល |
| **Card Background** | `#FFFFFF` (Pure White) | ផ្ទៃប្រអប់ព័ត៌មាន និង Form |
| **Text Primary** | `#1C1C1E` | ចំណងជើង និងអក្សរធំៗ |
| **Text Secondary** | `#7C7C80` | Subtitle, ទីតាំង, ព័ត៌មានបន្ទាប់បន្សំ |
| **Border Radius** | `12.0` - `16.0` | Cards, TextFields, Buttons |
| **Font Family** | Google Fonts (ឧ. `Kantumruy Pro` ឬ `Battambang`) | អក្សរខ្មែរមើលទៅស្អាត និងស្រឡះភ្នែក |

---

## ៣. ការរៀបចំទិន្នន័យ (Firestore Database Schema)

### ក. Collection: `houses` (បញ្ជីផ្ទះ)
```typescript
interface House {
  id: string;               // Auto ID
  title: string;            // ឈ្មោះផ្ទះ (ឧ. "វីឡាទំនើបនៅទួលគោក")
  type: string;             // ប្រភេទ (ផ្ទះ, ខុនដូ, វីឡា, អាផាតមិន)
  price: number;            // តម្លៃជួលប្រចាំខែ (ឧ. 1200)
  location: string;         // ទីតាំង (ឧ. "ទួលគោក, រាជធានីភ្នំពេញ")
  images: string[];         // URLs រូបភាព
  bedrooms: number;         // ចំនួនបន្ទប់គេង (ឧ. 3)
  bathrooms: number;        // ចំនួនបន្ទប់ទឹក (ឧ. 2)
  area: number;             // ទំហំផ្ទៃក្រឡា m² (ឧ. 120)
  description: string;      // ពិពណ៌នាលម្អិត
  rating: number;           // ពិន្ទុ (ឧ. 4.8)
  ownerName: string;        // ឈ្មោះម្ចាស់ផ្ទះ
  ownerPhone: string;       // លេខទូរស័ព្ទម្ចាស់ផ្ទះ
  isPopular: boolean;       // សម្រាប់បង្ហាញលើ Popular Section
  createdAt: Timestamp;
}
```

### ខ. Collection: `bookings` (ស្នើសុំជួលផ្ទះ)
```typescript
interface Booking {
  id: string;
  houseId: string;
  houseTitle: string;
  housePrice: number;
  houseImage: string;
  renterName: string;       // ឈ្មោះអ្នកស្នើសុំជួល
  renterPhone: string;      // លេខទូរស័ព្ទ
  rentDurationMonths: number; // រយៈពេលជួល (ខែ)
  startDate: Timestamp;     // ថ្ងៃចាប់ផ្តើមស្នាក់នៅ
  note: string;
  status: 'pending' | 'confirmed' | 'cancelled'; // ស្ថានភាពកក់
  createdAt: Timestamp;
}
```

---

## ៤. ការបែងចែកអេក្រង់ទាំង ១២ (Screen-by-Screen Implementation Guide)

### អេក្រង់ ០១, ០២, ០៣៖ Onboarding Flow
* **File:** `lib/View/onboarding/onboarding_screen.dart`
* **Widgets:** `PageView`, `SmoothPageIndicator`, `CustomButton`
* **មុខងារ:** 
  * បង្ហាញរូបភាពធំខាងលើ កាតពណ៌សកោងរាងខាងក្រោម
  * ចុច "បន្ទាប់" ដើម្បីរំកិលទៅ Screen បន្ទាប់ ឬចុច "រំលង" ដើម្បីទៅកាន់ Login

### អេក្រង់ ០៤៖ ចូលគណនី (Login Screen)
* **File:** `lib/View/auth/login_screen.dart`
* **Widgets:** `TextFormField` (Email/Phone, Password), Social Buttons (Google/Apple)
* **មុខងារ:** ពិនិត្យ Form Validation និងរុញទៅកាន់ `MainNavigationScreen`

### អេក្រង់ ០៥៖ ម៉ឺនុយចំហៀង (Side Drawer)
* **File:** `lib/View/drawer/side_drawer.dart`
* **Widgets:** `Drawer`, `UserAccountsDrawerHeader`, `ListTile`
* **មុខងារ:** បង្ហាញ Profile User ("Chang"), Link ទៅកាន់ ប្រវត្តិ, ការកក់, ការកំណត់ និងប៊ូតុងចាកចេញ

### អេក្រង់ ០៦៖ ទំព័រដើម (Home Screen)
* **File:** `lib/View/home/home_screen.dart`
* **Widgets:** 
  * Appbar ជាមួយប៊ូតុងបើក Drawer & Bell Icon
  * `CustomSearchBar` (ចុចទៅបើក Screen 09)
  * `BannerCarousel` (ប្រូម៉ូសិនបញ្ចុះតម្លៃ)
  * `CategoryChips` (ផ្ទះ, ខុនដូ, វីឡា)
  * `StreamBuilder<QuerySnapshot>` ទាញផ្ទះពី Firestore Collection `houses`
* **Bottom Navigation Bar:** ទំព័រដើម, ស្វែងរក, ការកក់, គណនី

### អេក្រង់ ០៧៖ ព័ត៌មានលម្អិតផ្ទះ (Property Detail Screen)
* **File:** `lib/View/property/property_detail_screen.dart`
* **Widgets:** Image Slider, Icon Row (បន្ទប់គេង, បន្ទប់ទឹក, ទំហំ), Owner Contact Card, Bottom Sticky Action Bar
* **មុខងារ:** ប៊ូតុង "ស្នើសុំជួល" នឹងបើកទៅកាន់ Screen 08

### អេក្រង់ ០៨៖ ស្នើសុំជួលផ្ទះ (Rental Booking Form)
* **File:** `lib/View/property/rental_booking_screen.dart`
* **Widgets:** Mini Property Card, Input Fields (ឈ្មោះ, លេខទូរស័ព្ទ, រយៈពេលជួល, កាលបរិច្ឆេទ)
* **មុខងារ:** ចុច "បញ្ជាក់ការស្នើសុំ" ដើម្បី Save ចូលទៅក្នុង Firestore Collection `bookings`

### អេក្រង់ ០៩៖ ស្វែងរកផ្ទះ (Search & Filter)
* **File:** `lib/View/search/search_screen.dart`
* **Widgets:** Filter Dialog / BottomSheet, Price Range Slider, Result GridView

### អេក្រង់ ១០៖ ផ្ទះដែលពេញចិត្ត (Favorites / Wishlist)
* **File:** `lib/View/favorites/favorites_screen.dart`
* **Widgets:** List of Saved Houses ជាមួយប៊ូតុងដោះ Heart ចេញ

### អេក្រង់ ១១៖ ការកក់របស់អ្នក (My Bookings)
* **File:** `lib/View/bookings/my_bookings_screen.dart`
* **Widgets:** `TabBar` (កំពុងរង់ចាំ / បានបញ្ជាក់ / ប្រវត្តិ), Booking Card ជាមួយ Status Badge

### អេក្រង់ ១២៖ គណនីផ្ទាល់ខ្លួន (User Profile)
* **File:** `lib/View/profile/profile_screen.dart`
* **Widgets:** User Avatar, Counters (ចំនួន Like, ការកក់), Settings Menu List

---

## ៥. ផែនការបែងចែកការងារក្នុងក្រុម (Task Assignment Guide)

| សមាជិក / តួនាទី | កិច្ចការដែលត្រូវទទួលខុសត្រូវ (Screens & Files) |
| :--- | :--- |
| **Dev 1 (Lead & Database)** | Setup Models, Firestore Controller, Main Navigation, Home Screen (06) |
| **Dev 2 (Property & Booking)** | Property Detail (07), Booking Form (08), My Bookings (11) |
| **Dev 3 (Auth & Profile)** | Onboarding (01-03), Login (04), Side Drawer (05), Profile (12) |
| **Dev 4 (Search & Favorites)** | Search & Filter (09), Favorites (10), Reusable Widgets |

---

## ៦. របៀប Git Workflow សម្រាប់ក្រុម
1. **Pull កូដចុងក្រោយជានិច្ច មុននឹងចាប់ផ្ដើមសរសេរកូដ៖**
   ```bash
   git pull origin main
   ```
2. **បង្កើត Branch សម្រាប់ Screen របស់ខ្លួន (ឧទាហរណ៍)៖**
   ```bash
   git checkout -b feature/home-screen
   ```
3. **Commit និង Push ទៅកាន់ GitHub៖**
   ```bash
   git add .
   git commit -m "Implement Home Screen UI matching Figma"
   git push origin feature/home-screen
   ```
