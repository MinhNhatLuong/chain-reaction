# Chain Reaction

A strategic, turn-based board game built with Flutter. Chain Reaction is a game of strategy where players place orbs on a grid. When a cell reaches its capacity, it explodes, sending orbs to adjacent cells and potentially causing a chain reaction that converts opponent orbs to your color.

## 🚀 Features

- **Local Multiplayer**: Play with friends on the same device (2-8 players).
- **Vs Computer**: Test your strategies against an AI opponent.
- **Customizable Board**: Choose different grid sizes (5x5, 6x10, etc.) to vary the difficulty.
- **Theming**: Dark and Light mode support with a modern, clean UI.
- **Multi-language Support**: Internationalization support (English and more).
- **Responsive Design**: Optimized for both mobile phones and tablets.

## 🛠️ Installation & Setup

### Prerequisites

Before you begin, ensure you have the following installed:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Stable channel)
- [Dart SDK](https://dart.dev/get-started/sdk)
- Android Studio / VS Code with Flutter extensions
- A physical device or emulator (Android/iOS)

### Step-by-Step Guide

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/chain-reaction.git
   cd chain-reaction
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate Localization files (Important):**
   The app uses `flutter_localizations`. Run this command to generate the necessary translation files:
   ```bash
   flutter gen-l10n
   ```

4. **Run the app:**
   Connect your device and run:
   ```bash
   flutter run
   ```

## 🎮 How to Play

The objective of Chain Reaction is to take control of the entire board by eliminating your opponents' orbs.

1. **The Grid**: The game is played on a grid. Each cell has a "critical mass" based on its location:
   - **Corners**: 2 orbs (explodes on the 2nd orb).
   - **Edges**: 3 orbs (explodes on the 3rd orb).
   - **Center**: 4 orbs (explodes on the 4th orb).

2. **Your Turn**: On your turn, tap an empty cell or a cell that already contains your color to add one orb.

3. **Explosions & Chain Reactions**: When a cell reaches its critical mass, it explodes. The orbs move to adjacent cells, claiming them for the player. if an adjacent cell also reaches its critical mass, it explodes too, creating a chain reaction.

4. **Winning**: A player is eliminated when they lose all their orbs after they have had at least one turn. The last player standing wins!

## 🏗️ Project Structure

- `lib/core`: Shared utilities, constants, and themes.
- `lib/features`: Modular features of the app (home, game, settings).
- `lib/l10n`: Localization files and ARB templates.