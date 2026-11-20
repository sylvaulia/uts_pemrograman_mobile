# KULAKAN

Prototipe aplikasi kasir, stok, dan catatan utang untuk warung.

## Menjalankan aplikasi Flutter

```powershell
flutter pub get
flutter run -d chrome
```

Untuk membuat APK Android:

```powershell
flutter build apk
```

APK release tersimpan di `build/app/outputs/flutter-apk/app-release.apk`.

## Preview HTML

- Buka `kulakan.html` langsung di browser untuk mencoba versi HTML mandiri.
- Preview publik: https://3a8c7e6a.ht-ml.app/

Keduanya memakai data demo lokal. Transaksi dan perubahan stok belum tersambung ke backend.

## Susunan utama

- `lib/main.dart` — aplikasi Flutter Kulakan.
- `test/widget_test.dart` — tes widget Flutter.
- `kulakan.html` — preview mandiri satu file.
- `artifacts/preview/` — screenshot hasil verifikasi browser.
- `private/` — kunci pembaruan preview publik; tidak ikut Git.
- `flutterfun/` — proyek Flutter latihan yang terpisah.
- `build/` dan `.dart_tool/` — artefak hasil generate Flutter.
