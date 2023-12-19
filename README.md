# BukuKu
![Markdown](https://build.appcenter.ms/v0.1/apps/6c513354-5490-4a91-98a2-c38ebe083294/branches/main/badge)

## Kelompok D01
- Oey Joshua Jodrian (2206041953)
- Kayzaa Nuur Azuraa (2206083211)
- Nabila Zavira (2206829383)
- Mahoga Aribowo Heryasa (2206025230)
- Brian Jonathan Loekito (2206826993)

## Tautan APK
https://install.appcenter.ms/orgs/d01/apps/bukuku/distribution_groups/d01

## Deskripsi Aplikasi
Aplikasi "BukuKu" terinspirasi dari kebutuhan akan platform online shop yang menjual berbagai kategori buku. Aplikasi ini menghadirkan beragam pilihan buku yang diminati oleh berbagai kalangan pembaca. Dengan mengelompokkan buku ke dalam kategori yang berbeda, BukuKu memudahkan pelanggan untuk menemukan buku yang sesuai dengan minat mereka tanpa harus melakukan pencarian manual. BukuKu juga memberikan pengalaman berbelanja buku yang lebih menyenangkan dengan rekomendasi buku berdasarkan preferensi pembaca, menjadikannya tujuan utama bagi pecinta buku lokal dan internasional.

## Daftar Modul
1. Login, Register, Logout (Semua) <br> 
2. Leaderboard Page (Jojo) <br>
Pada halaman ini, user dapat melihat peringkat buku dengan penjualan terbanyak berdasarkan banyak pembelian unik. 
3. Product Page (Kayzaa) <br>
Pada halaman ini, user dapat melihat detail produk yang spesifik,mencakup informasi seperti gambar produk, deskripsi, harga, dan opsi untuk menambahkannya ke keranjang belanja.
4. Cart Page (Hery) <br>
Pada halaman ini, user dapat melihat produk yang telah mereka tambahkan saat berbelanja, serta dapat mengatur kuantitas produk dan banyak produk yang akan di checkout.
6. Checkout Page (Bella) <br>
Pada halaman ini, user memasukkan informasi seperti nama, alamat pengiriman, email dan pop up informasi pembayaran. 
7. Review (Brian) <br>
Review merupakan fitur dimana user dapat menambahkan hasil review mereka terhadap sebuah buku yang kemudian akan ditampilkan dan bisa dilihat oleh user lain.

## Role User
Seseorang dengan role sebagai user bisa melakukan beberapa hal berikut, yakni masuk ke home page, melihat-lihat product di product page, memasukan produk ke dalam cart, melakukan checkout di checkout page, dan melihat leaderboard. Terdapat juga role sebagai admin dimana mereka memiliki otoritas lebih sehingga mereka bisa menambahkan produk, menghapus produk, mengubah deskripsi barang, dan mengubah harga barang.

## Alur Pengintegrasian dengan Web Service
1. Setup Autentikasi pada Django untuk Flutter
Pertama-tama membuat django-app bernama authentication pada project Django lalu menambahkan authentication ke `INSTALLED_APPS` pada main project `settings.py`. Lalu menjalankan `pip install django-cors-headers` untuk menginstal library yang dibutuhkan.
Setelah itu, menambahkan `corsheaders` ke `INSTALLED_APPS`, `corsheaders.middleware.CorsMiddleware`, dan beberapa variabel pada main project `settings.py`. Lalu membuat fungsi view untuk login dan register pada file `authentication/views.py`, lalu pada file `authentication/urls.py` dan menambahkan URL routing terhadap fungsi yang sudah dibuat.
2. Integrasi Sistem Autentikasi pada Flutter
Instal package, lalu menggunakan package tersebut dan modifikasi root widget untuk menyediakan CookieRequest library ke semua child widgets dengan menggunakan Provider. Setelah itu, membuat file `login.dart` dan `register.dart` pada folder `screens`.

## Tautan Berita Acara
https://1drv.ms/x/s!An0ktXnOv5G4nVvoaasFimsAZe9M?e=YJzF3S
