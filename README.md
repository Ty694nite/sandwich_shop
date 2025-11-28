# Sandwich Shop

A modern Flutter app for ordering delicious sandwiches online. Designed for web browsers, this app provides a simple, intuitive interface for users to browse, customize, and order sandwiches.

## Key Features

- Browse a menu of sandwiches
- Customize ingredients and options
- Add items to cart and place orders
- Responsive UI for desktop and mobile browsers
- Built with Flutter and Dart

---

## Installation and Setup

### Prerequisites

- **Operating System:** macOS, Windows, or Linux
- **Flutter SDK:** [Install instructions](https://docs.flutter.dev/get-started/install)
- **Git:** [Download](https://git-scm.com/downloads)
- **Visual Studio Code:** [Download](https://code.visualstudio.com/)
- **Package Manager:** Homebrew (macOS) or Chocolatey (Windows) recommended

### Step-by-Step Guide

1. **Terminal**:

    - **macOS** – use the built-in Terminal app by pressing **⌘ + Space**, typing **Terminal**, and pressing **Return**.
    - **Windows** – open the start menu using the **Windows** key. Then enter **cmd** to open the **Command Prompt**. Alternatively, you can use **Windows PowerShell** or **Windows Terminal**.

2. **Git** – verify that you have `git` installed by entering `git --version` in the terminal. If missing, download from [Git's official site](https://git-scm.com/downloads).

3. **Package managers**:

    - **Homebrew** (macOS): `brew --version`
    - **Chocolatey** (Windows): `choco --version`

4. **Flutter SDK** – verify with `flutter doctor`; if missing, install:

    - **macOS**: `brew install --cask flutter`
    - **Windows**: `choco install flutter`

5. **Visual Studio Code** – verify with `code --version`; if missing, install:

    - **macOS**: `brew install --cask visual-studio-code`
    - **Windows**: `choco install vscode`

### Clone the Repository

```bash
git clone --branch 3 https://github.com/monfi/sandwich_shop
cd sandwich_shop
code .
```

### Switch Branch (if already cloned)

```bash
git fetch origin
git checkout 3
```

### Run the App

Open the integrated terminal in Visual Studio Code (**⌘ + Shift + P** on macOS or **Ctrl + Shift + P** on Windows, then "Terminal: Create New Terminal").

```bash
flutter pub get
flutter run
```

---

## Usage Instructions

- **Browse Menu:** View available sandwiches on the home screen.
- **Customize Order:** Select a sandwich, choose ingredients, and add extras.
- **Add to Cart:** Click "Add to Cart" to save your selection.
- **Checkout:** Review your cart and place your order.

### Running Tests

```bash
flutter test
```

### Configuration

No special configuration is required for basic usage. For advanced settings, see `analysis_options.yaml` and `pubspec.yaml`.


---

## Project Structure & Technologies

```
lib/           # Main app source code
test/          # Unit and widget tests
web/           # Web entrypoint
android/       # Android platform files
ios/           # iOS platform files
linux/, macos/, windows/ # Desktop platform files
pubspec.yaml   # Dependencies and metadata
```

- **Key Files:**
    - `lib/main.dart`: App entry point
    - `lib/`: UI, models, and business logic
    - `test/`: Automated tests

- **Technologies:**
    - Flutter, Dart
    - Visual Studio Code
    - Git

---

## Known Issues & Future Improvements

- Some features may not be fully optimized for mobile browsers.
- Planned improvements: user authentication, order history, payment integration.

### Contributions

Pull requests and suggestions are welcome! Please open an issue or submit a PR.

---

## Contact Information

**Author:** [Taiyeb Ahmed]  
**Email:** [up2274842@myport.ac.uk]  
**GitHub:** [ty694nite](https://github.com/ty694nite)


---