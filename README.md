# 💰 Fluxx

A complete **personal finance management** app focused on organizing monthly expenses, tracking spending by category, managing credit cards, and analyzing how much of your income you have used. Built with **Flutter**, the app offers a practical and intuitive experience for keeping track of your financial life with clarity, with all data stored locally on the device.

## 🚀 Features

- ✅ Create, edit, and delete **expenses** (regular bills)
- 📷 Add a bill by **scanning the QR Code on the receipt** (NFC-e): name, amount, date, and items come from the receipt, and you only choose the category and income source during review (available for São Paulo receipts, requires internet)
- 🔁 Repeat bills over several months (installments or recurring)
- 📆 Organize expenses and income by **month** and **year**
- 📊 View **spending by category** and the usage of each income source
- 🧾 Create **custom categories**, monthly or one-time
- 💼 Manage **income sources**, monthly or one-time
- 🔄 Link expenses to specific payment sources
- 💳 Register **credit cards**, with automatic billing cycle calculation based on the closing day
- 🛍️ Card purchases paid in full or in installments, automatically posted to the correct statement each month
- 💵 Statement payment linked to an available income source
- 📈 Progress bar showing how much of your income has been used, and the recommended card usage limit
- 🔔 New version notice with **in-app update** (Android, via Play Store)

## 📸 Screenshots (examples)

> ### Home Screen
<img src="assets/screenshots/tela_inicial.png" alt="Home Screen" width="250"/> <img src="assets/screenshots/tela_home_drawer.png" alt="Home Drawer" width="250"/> <img src="assets/screenshots/tela_home_bottomsheet_de_add_contas.png" alt="Add Bill Options" width="250"/>

> ### Statistics Screen
<img src="assets/screenshots/tela_estatisticas.png" alt="Statistics Screen" width="250"/>

> ### Month List Screen
<img src="assets/screenshots/lista_meses.png" alt="Month List Screen" width="250"/>

> ### Bills Screen
<img src="assets/screenshots/lista_contas.png" alt="Bills Screen" width="250"/>

> ### Bill Details Screen
<img src="assets/screenshots/tela_detalhes_conta.png" alt="Bill Details Screen" width="250"/>

## 🛠️ Technologies Used

- **Flutter** with Dart
- **flutter_bloc** (Cubit) for state management
- **get_it** for dependency injection
- **sqflite** (SQLite) for local persistence
- **shared_preferences** for simple preferences (dismissal date of the update notice)
- **intl** for date and value formatting (pt_BR locale)
- **mobile_scanner** and **permission_handler** for QR Code scanning and camera permission
- **http** and **html** to fetch and parse the receipt from the SEFAZ portal
- **in_app_update** for in-app updates via the Play Store
- **animated_toggle_switch**, **flashy_flushbar**, **loading_animation_widget**, **percent_indicator** for UI components
- **flutter_masked_text2** for currency value masks
- **image_picker** for profile picture
- **uuid** for identifier generation

## 📌 Notes

The app focuses on real expense control, not on simulations.

You can create custom categories and income sources to fit your reality.

The income usage progress system helps you see how much of your income has already been used in the month, both for regular bills and credit card statements.

All data is stored locally on the device. There is no cloud sync and no backend. The only external request is the receipt lookup, made when scanning the QR Code.

📄 License
This project is licensed under the MIT License.
