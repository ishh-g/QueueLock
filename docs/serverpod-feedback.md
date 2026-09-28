# Serverpod feedback

Friction found while working with Serverpod 4.0.3, with repros. Feeds the
hackathon's feedback prize.

## 1. `serverpod create` reports `flutter create .` failure, but platform files exist

- What: `serverpod create -n queuelock --ide opencode --no-interactive`
  printed `Creating Flutter app platform files.... failed. (2.2s)` with
  `ERROR: Failed to run 'flutter create .' in .../queuelock_flutter`, plus
  `Updating Flutter app MacOS entitlements.... failed.`
- Yet `queuelock_flutter/` contains `android/`, `ios/`, `web/`, `windows/`,
  `linux/`, `macos/` — so the step partially succeeded or a retry inside the
  CLI succeeded silently.
- The error gives no underlying flutter output, so it is impossible to tell
  whether the project is broken without manually inspecting the directory.
- Environment: Windows 11, Flutter 3.47.5 on PATH, Serverpod CLI 4.0.3.

## 2. Winget Dart SDK install does not put `dart` on PATH

- What: `winget install Google.DartSDK` (portable zip installer) reported
  `Command line alias added: "dart"`, but no `dart` was reachable in new
  shells. Installing the Flutter SDK (which bundles Dart) worked first time.
- Minor: only matters for the `dart install serverpod_cli` step when Flutter
  is not installed yet.

## 3. `serverpod.bat` requires `dart` on PATH with an unclear error

- What: running the installed `serverpod.bat` without Dart on PATH prints
  `ERROR: Failed to run serverpod. You need to have dart installed and in
  your $PATH` — on Windows the variable is `%PATH%`/`$env:Path`, and the
  message does not say which Dart (the Flutter-bundled one is fine).
