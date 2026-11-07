// ============================================================================
// Model Kendaraan dan Subclass
// Tugas Rutin 4: Pemrograman Mobile
// ============================================================================

/// Abstract class sebagai cetak biru (blueprint) seluruh jenis kendaraan.
abstract class Kendaraan {
  final String plat;
  final DateTime waktuMasuk;

  Kendaraan(this.plat, this.waktuMasuk);

  /// Getter abstrak yang wajib diimplementasikan oleh setiap subclass
  String get jenis;
  int get tarifPerJam;

  /// Menghitung biaya parkir berdasarkan selisih waktu masuk dan waktu keluar.
  /// Pembulatan dilakukan ke atas per jam, dengan durasi minimal 1 jam.
  int biaya(DateTime keluar) {
    final durasi = keluar.difference(waktuMasuk);
    // Menghitung jam dengan pembulatan ke atas (ceil)
    final jam = (durasi.inMinutes / 60.0).ceil();
    // Durasi minimal adalah 1 jam
    final totalJam = jam <= 0 ? 1 : jam;
    return totalJam * tarifPerJam;
  }
}

/// Mixin untuk kendaraan yang memiliki fasilitas langganan (diskon 50%).
mixin Berlangganan on Kendaraan {
  double get diskon => 0.50; // Diskon 50%

  @override
  int biaya(DateTime keluar) {
    final biayaNormal = super.biaya(keluar);
    return (biayaNormal * (1.0 - diskon)).round();
  }
}

/// Subclass untuk jenis kendaraan Motor
class Motor extends Kendaraan {
  Motor(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Motor';

  @override
  int get tarifPerJam => 2000; // Rp2.000 per jam
}

/// Subclass untuk jenis kendaraan Mobil
class Mobil extends Kendaraan {
  Mobil(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Mobil';

  @override
  int get tarifPerJam => 5000; // Rp5.000 per jam
}

/// Subclass untuk jenis kendaraan Truk
class Truk extends Kendaraan {
  Truk(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Truk';

  @override
  int get tarifPerJam => 8000; // Rp8.000 per jam
}

/// Subclass Mobil dengan status keanggotaan (member) menggunakan mixin Berlangganan
class MobilMember extends Mobil with Berlangganan {
  MobilMember(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Mobil (member)';
}
