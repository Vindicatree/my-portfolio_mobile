# MyPortfolio Mobile

Aplikasi portofolio pribadi sederhana yang dibuat dengan Flutter. Halaman utama menampilkan identitas pemilik serta tiga kartu aksi: **Lihat Proyek**, **Tambah Proyek**, dan **Logout**. Menekan kartu menampilkan `SnackBar` dengan nama aksi tersebut.

## Menjalankan proyek

Pastikan Flutter SDK terpasang dan perangkat atau emulator sudah tersedia. Dari folder proyek, jalankan:

```bash
flutter pub get
flutter run
```

Untuk memeriksa masalah statis pada kode, jalankan:

```bash
flutter analyze
```

## Struktur kode

- `lib/main.dart` menginisialisasi aplikasi, tema, dan `MaterialApp`.
- `lib/menu.dart` berisi halaman utama, kartu identitas (`InfoCard`), model data aksi (`ItemHomepage`), dan kartu aksi (`ItemCard`).

## Tugas 7

1. **Widget tree dan hubungan parent-child**

   Widget tree adalah susunan widget yang membentuk antarmuka Flutter. Widget parent menempatkan atau mengatur widget child; child dapat menjadi bagian dari layout parent dan menerima informasi seperti batas ukuran serta `BuildContext`. Contohnya, `MaterialApp` menjadi akar aplikasi, `Scaffold` mengatur `AppBar` dan `body`, lalu `Column` menyusun `Row`, kartu identitas, teks sambutan, dan grid aksi. Perubahan pada susunan parent dapat memengaruhi posisi dan ukuran child.

2. **Widget yang digunakan dan fungsinya**

   `MaterialApp` menyediakan struktur aplikasi Material, tema, dan halaman awal. `Scaffold` menyediakan kerangka halaman; `AppBar` menampilkan bilah atas. `Padding` memberi jarak, `Column` menyusun isi vertikal, `Row` menyusun kartu identitas horizontal, dan `Expanded` membagi lebar baris. `SizedBox` memberi jarak, `Center` memusatkan isi, dan `GridView.count` menyusun kartu aksi dalam grid. `Card` membungkus informasi profil, sedangkan `Container` mengatur isi dan padding. `Text` menampilkan judul, identitas, sambutan, dan label. `Material` memberi latar kartu aksi, sementara `InkWell` menangani sentuhan dan efek interaksi. `Icon` menampilkan ikon aksi, dan `SnackBar` memberi umpan balik setelah kartu ditekan. `InfoCard` dan `ItemCard` adalah widget buatan proyek untuk menampilkan kartu profil dan aksi; `MyApp` dan `MyHomePage` menyusun aplikasi dan halaman utamanya.

3. **Fungsi `MaterialApp`**

   `MaterialApp` menyiapkan fitur dasar aplikasi bergaya Material, seperti tema, navigasi, dan konfigurasi halaman. Widget ini umum dipakai sebagai root agar pengaturan tersebut tersedia bagi widget di bawahnya. Dalam proyek ini, `MyApp` mengembalikan `MaterialApp` yang mengatur tema dan membuka `MyHomePage`.

4. **`StatelessWidget` dan `StatefulWidget`**

   `StatelessWidget` cocok ketika tampilan hanya bergantung pada konfigurasi yang diberikan dan tidak menyimpan state yang berubah selama widget hidup. `StatefulWidget` digunakan ketika ada state yang berubah dan perubahan itu perlu membangun ulang tampilan, misalnya nilai penghitung setelah tombol ditekan. Halaman proyek ini memakai `StatelessWidget` karena data identitas dan daftar kartu ditetapkan saat halaman dibuat; `InkWell` hanya meminta `ScaffoldMessenger` menampilkan `SnackBar`, tanpa menyimpan state halaman.

5. **`BuildContext`**

   `BuildContext` menunjukkan posisi sebuah widget di dalam widget tree. Flutter memakainya untuk menemukan informasi atau layanan dari ancestor, misalnya mengambil warna tema dengan `Theme.of(context)` atau menampilkan `SnackBar` melalui `ScaffoldMessenger.of(context)`. Parameter `context` pada `build` membuat widget dapat mengakses informasi tersebut dari posisinya di tree.

6. **Hot reload dan hot restart**

   Hot reload menerapkan perubahan kode ke aplikasi yang sedang berjalan dan mempertahankan state yang ada; proses ini tidak menjalankan ulang `main()` atau `initState()`. Hot restart memulai ulang aplikasi dari `main()`, sehingga state di memori dibuat kembali. Gunakan hot restart saat perubahan bergantung pada inisialisasi awal yang tidak diulang oleh hot reload. Jika perubahan menyentuh konfigurasi native atau proses build, aplikasi mungkin perlu dihentikan lalu dijalankan kembali dengan full restart.

## Penggunaan AI

Proyek ini berangkat dari aplikasi Tutorial 08. Saya menggunakan OpenAI Codex sebagai alat bantu untuk membandingkan implementasi dengan checklist Tugas 7, membahas perbaikan yang diperlukan, dan menyusun draf dokumentasi. Atas arahan saya, Codex membantu menerapkan perubahan terbatas pada data kartu profil, warna kartu aksi, dan batas baris nama. Struktur dan fitur dasar aplikasi tetap dikembangkan dari proyek Tutorial 08; Codex tidak membangun seluruh aplikasi dari awal.

