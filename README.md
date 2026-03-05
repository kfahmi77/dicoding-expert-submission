# Ditonton Flutter Expert Submission

[![Flutter CI](https://github.com/kfahmi77/dicoding-expert-submission/actions/workflows/flutter_ci.yml/badge.svg)](https://github.com/kfahmi77/dicoding-expert-submission/actions/workflows/flutter_ci.yml)

Aplikasi katalog movie dan TV series berbasis Flutter untuk submission Dicoding Flutter Expert.

## Implementasi Kriteria Wajib

- Continuous Integration dengan GitHub Actions (`push` dan `pull_request`).
- Migrasi state management dari Provider ke BLoC/Cubit (`flutter_bloc`).
- SSL Pinning pada koneksi TMDB dengan sertifikat yang dipasang di HTTP client.
- Integrasi Firebase Analytics dan Crashlytics pada bootstrap aplikasi.

## Menjalankan Proyek

```bash
flutter pub get
flutter run
```

## Menjalankan Pengujian

```bash
flutter test --coverage
```

## Catatan Firebase

Tambahkan konfigurasi Firebase proyek Anda sendiri untuk Android/iOS agar data Analytics dan Crashlytics tercatat ke Firebase Console.
