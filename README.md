# Tugas Rutin 4: Sistem Parkir Kampus 
---

## A. Identitas Mahasiswa
- **Nama:** M. Gali Almhadi
- **NIM:** 4243250042
- **Kelas:** PSIK 24 D  2024
---

## B. Diagram Kelas (Class Diagram)

Berikut adalah struktur hierarki kelas dan relasi antar komponen dalam sistem parkir:

```mermaid
classDiagram
    class Kendaraan {
        <<abstract>>
        +String plat
        +DateTime waktuMasuk
        +String jenis*
        +int tarifPerJam*
        +int biaya(DateTime keluar)
    }

    class Berlangganan {
        <<mixin>>
        +double diskon
        +int biaya(DateTime keluar)
    }

    class Motor {
        +String jenis = "Motor"
        +int tarifPerJam = 2000
    }

    class Mobil {
        +String jenis = "Mobil"
        +int tarifPerJam = 5000
    }

    class Truk {
        +String jenis = "Truk"
        +int tarifPerJam = 8000
    }

    class MobilMember {
        +String jenis = "Mobil (member)"
    }

    class Parkiran {
        +int kapasitas
        -List~Kendaraan~ _daftarKendaraan
        -int _pendapatan
        -StreamController~String~ _eventController
        +int sisa
        +int pendapatan
        +Stream~String~ eventStream
        +List~Kendaraan~ daftarKendaraan
        +Future~void~ masuk(Kendaraan k)
        +Future~int~ keluar(String plat, DateTime? waktuKeluar)
        +Future~void~ tutup()
    }

    class ParkirPenuh {
        <<Exception>>
        +String pesan
        +String toString()
    }

    Kendaraan <|-- Motor : extends
    Kendaraan <|-- Mobil : extends
    Kendaraan <|-- Truk : extends
    Mobil <|-- MobilMember : extends
    Berlangganan <|.. MobilMember : with
    Parkiran o-- Kendaraan : mengelola
    Parkiran ..> ParkirPenuh : melempar saat penuh
```

---

## C. Tangkapan Layar Keluaran Program (Output Console)

Hasil eksekusi program `bin/main.dart`:

![Tangkapan Layar output](Screenshots/output_program.png)

Hasil Analyz :

![Tangkapan Layar output](Screenshots/output_analyze.png)

---

## D. Penjelasan Penerapan Konsep

Pada program sistem parkir ini, ketiga konsep utama diterapkan secara terstruktur:

1. **Enkapsulasi (Encapsulation):**  
   Diterapkan pada kelas Parkiran dengan menyembunyikan data internal menggunakan awalan garis bawah (`_daftarKendaraan`, `_pendapatan`, dan `_eventController`). Akses terhadap data ini dikendalikan melalui *getter* publik seperti `sisa`, `pendapatan`, dan `daftarKendaraan` (menggunakan `List.unmodifiable`) sehingga mencegah modifikasi langsung yang tidak sah dari luar kelas.

2. **Polimorfisme (Polymorphism):**  
   Diterapkan melalui tipe dasar `Kendaraan` yang menaungi berbagai turunan spesifik (`Motor`, `Mobil`, `Truk`, dan `MobilMember`). Koleksi kendaraan disimpan dalam satu `List<Kendaraan>`. Ketika method `biaya(DateTime keluar)` dipanggil, Dart mengeksekusi implementasi sesuai objek konkretnya, termasuk `MobilMember` yang menerapkan mixin `Berlangganan` untuk memotong biaya sebesar 50%.

3. **Pemrograman Asinkron (Async Programming):**  
   Diterapkan pada method `masuk()` dan `keluar()` yang menggunakan kata kunci `async`, `await`, dan `Future<void>.delayed` guna mensimulasikan waktu buka/tutup palang otomatis secara non-blocking. Selain itu, notifikasi pos jaga dipancarkan secara *real-time* memanfaatkan `StreamController<String>.broadcast()` yang dikonsumsi oleh listener event stream di `main()`.

---

## E. Pernyataan Penggunaan AI
asisten AI membantu perancangan diagram Mermaid, verifikasi static analysis (`dart analyze`), serta penyusunan dokumentasi tugas sesuai standar rubrik penilaian Modul Ajar Pemrograman Mobile. 
---
