// ============================================================================
// Program Utama Sistem Parkir Kampus FMIPA
// Tugas Rutin 4: Pemrograman Mobile
// ============================================================================

import '../lib/kendaraan.dart';
import '../lib/parkiran.dart';

Future<void> main() async {
  // 1. Inisialisasi sistem parkiran dengan kapasitas maksimum 3 kendaraan
  final parkiran = Parkiran(3);

  // 2. Berlangganan (listen) ke event stream untuk menampilkan log kejadian di pos jaga
  parkiran.eventStream.listen((event) {
    print(event);
  });

  // Waktu simulasi: kendaraan masuk 3 jam yang lalu
  final waktuKeluar = DateTime.now();
  final waktuMasuk = waktuKeluar.subtract(const Duration(hours: 3));

  // 3. Demonstrasi Polimorfisme:
  // List bertipe List<Kendaraan> berisi objek subclass yang berbeda-beda
  final List<Kendaraan> antreanMasuk = [
    Motor('BK 1234 AB', waktuMasuk),
    Mobil('BK 88 UN', waktuMasuk),
    MobilMember('BK 7 MIPA', waktuMasuk),
  ];

  // Memasukkan kendaraan secara asinkron
  for (final kendaraan in antreanMasuk) {
    await parkiran.masuk(kendaraan);
  }

  // 4. Demonstrasi Kapasitas Penuh:
  // Mencoba memasukkan kendaraan ke-4 saat kapasitas sudah 3
  try {
    final truk = Truk('BK 9999 XX', waktuMasuk);
    await parkiran.masuk(truk);
  } on ParkirPenuh catch (e) {
    print(e);
  }

  // 5. Demonstrasi Kendaraan Keluar dan Pembayaran Biaya Parkir
  await parkiran.keluar('BK 1234 AB', waktuKeluar: waktuKeluar);
  await parkiran.keluar('BK 88 UN', waktuKeluar: waktuKeluar);
  await parkiran.keluar('BK 7 MIPA', waktuKeluar: waktuKeluar);

  // 6. Menampilkan Total Pendapatan Parkir
  // Berikan jeda mikro agar seluruh event stream selesai dicetak oleh listener
  await Future<void>.delayed(Duration.zero);
  print('Pendapatan: Rp${parkiran.pendapatan}');

  // 7. Menutup StreamController setelah seluruh proses selesai
  await parkiran.tutup();
}
