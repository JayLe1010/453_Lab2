# Art Space

A Flutter app that showcases a small digital art collection. The screen is
split into three sections, as suggested by the lab prompt:

- **Artwork wall** — a framed panel that displays the current piece
  (`ArtworkWall` in `lib/main.dart`). Each piece is a small generative
  composition (waves, triangles, circles, stripes) drawn with a
  `CustomPainter`, so the app has no external image dependencies.
- **Artwork descriptor** — the title, artist, and year of the piece on the
  wall (`ArtworkDescriptor`).
- **Display controller** — "Previous" and "Next" buttons that cycle through
  the four artworks in the collection (`DisplayController`).

All of the app's logic lives in `lib/main.dart`.

## Getting started

This repository only tracks the Dart source (`lib/`, `test/`, `pubspec.yaml`)
so the platform folders (`android/`, `ios/`, etc.) aren't checked in. To run
the app locally:

```bash
flutter create .   # backfills android/, ios/, and other platform folders
flutter pub get
flutter run
```

## Tests

```bash
flutter test
```

`test/widget_test.dart` verifies that the Next/Previous controls cycle
through the artwork collection correctly, including wrap-around at both
ends.
