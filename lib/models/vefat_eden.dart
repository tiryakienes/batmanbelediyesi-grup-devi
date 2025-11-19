class VefatEden {
  final String vefatTarihi;
  final String isim;
  final String dogumTarihi;
  final String dogumYeri;
  final String definYeri;
  final String definTarihi;
  final TaziyeBilgileri? taziyeBilgileri;

  VefatEden({
    required this.vefatTarihi,
    required this.isim,
    required this.dogumTarihi,
    required this.dogumYeri,
    required this.definYeri,
    required this.definTarihi,
    this.taziyeBilgileri,
  });
}

class TaziyeBilgileri {
  final String cenazeYakini;
  final String cenazeYakiniTel;
  final String taziyeYeri;
  final String taziyeTarihi;

  TaziyeBilgileri({
    required this.cenazeYakini,
    required this.cenazeYakiniTel,
    required this.taziyeYeri,
    required this.taziyeTarihi,
  });
}

