// ============================================================================
// Layanan Sistem Parkiran Kampus
// Tugas Rutin 4: Pemrograman Mobile
// ============================================================================

import 'dart:async';
import 'kendaraan.dart';

/// Exception khusus jika area parkir sudah mencapai batas kapasitas maksimum.
class ParkirPenuh implements Exception {
  final String pesan;
  ParkirPenuh([this.pesan = 'Parkiran penuh']);

  @override
  String toString() => 'Ditolak: $pesan';
}

/// Kelas untuk mengelola sistem parkir, mencakup pencatatan masuk,
/// keluar, kapasitas, dan pelaporan pendapatan.
class Parkiran {
  final int kapasitas;

  // Enkapsulasi: field diawali underscore (_) bersifat privat
  final List<Kendaraan> _daftarKendaraan = [];
  int _pendapatan = 0;
  final StreamController<String> _eventController =
      StreamController<String>.broadcast();

  Parkiran(this.kapasitas);

  /// Getter publik untuk membaca sisa slot parkir
  int get sisa => kapasitas - _daftarKendaraan.length;

  /// Getter publik untuk membaca total pendapatan parkir
  int get pendapatan => _pendapatan;

  /// Getter publik untuk mendengarkan aliran kejadian (event stream) di pos jaga
  Stream<String> get eventStream => _eventController.stream;

  /// Getter publik untuk membaca daftar kendaraan secara aman (read-only)
  List<Kendaraan> get daftarKendaraan => List.unmodifiable(_daftarKendaraan);

  /// Memproses kendaraan masuk ke area parkir secara asinkron.
  /// Mensimulasikan deteksi dan pembukaan palang dengan Future.delayed.
  Future<void> masuk(Kendaraan k) async {
    // Simulasi respons palang otomatis (300 ms)
    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (_daftarKendaraan.length >= kapasitas) {
      throw ParkirPenuh('Parkiran penuh (kapasitas $kapasitas)');
    }

    _daftarKendaraan.add(k);
    _eventController.add('MASUK ${k.jenis} ${k.plat} (sisa $sisa)');
  }

  /// Memproses kendaraan keluar dari area parkir secara asinkron.
  /// Menghitung biaya parkir, menambahkan ke total pendapatan, dan membuka palang.
  Future<int> keluar(String plat, {DateTime? waktuKeluar}) async {
    // Simulasi respons palang otomatis (300 ms)
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final index = _daftarKendaraan.indexWhere((k) => k.plat == plat);
    if (index == -1) {
      throw Exception('Kendaraan dengan plat $plat tidak ditemukan di parkiran.');
    }

    final k = _daftarKendaraan[index];
    final jamKeluar = waktuKeluar ?? DateTime.now();
    final biayaParkir = k.biaya(jamKeluar);

    _pendapatan += biayaParkir;
    _daftarKendaraan.removeAt(index);
    _eventController.add('KELUAR ${k.jenis} ${k.plat} bayar Rp$biayaParkir');

    return biayaParkir;
  }

  /// Menutup stream log aktivitas ketika sistem parkiran selesai digunakan
  Future<void> tutup() => _eventController.close();
}
