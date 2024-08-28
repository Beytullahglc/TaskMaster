class Gorevler {
  String gorevId;
  String gorevAdi;
  String aciklama;
  String kategori;
  DateTime bitisTarihi;
  bool bittiMi;

  Gorevler({
    required this.gorevId,
    required this.gorevAdi,
    required this.aciklama,
    required this.kategori,
    required this.bitisTarihi,
     this.bittiMi = false,
  });

  // JSON'dan `Gorevler` nesnesi oluşturmak için bir fabrika metodu
  factory Gorevler.fromJson(String key, Map<dynamic, dynamic> json) {
    return Gorevler(
      gorevId: key,
      gorevAdi: json['gorevAdi'] ?? '',
      aciklama: json['aciklama'] ?? '',
      kategori: json['kategori'] ?? '',
      bitisTarihi: DateTime.parse(json['bitisTarihi'] ?? DateTime.now().toIso8601String()),
      bittiMi: json['bittiMi'] ?? false,
    );
  }

  // `Gorevler` nesnesini JSON formatına dönüştürmek için bir metod
  Map<String, dynamic> toJson() {
    return {
      'gorevId': gorevId,
      'gorevAdi': gorevAdi,
      'aciklama': aciklama,
      'kategori': kategori,
      'bitisTarihi': bitisTarihi.toIso8601String(),
      'bittiMi': bittiMi,
    };
  }
}
