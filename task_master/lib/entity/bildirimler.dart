class Bildirimler {
  String bildirimId;
  String baslik;
  String icerik;
  DateTime tarih;

  Bildirimler({
    required this.bildirimId,
    required this.baslik,
    required this.icerik,
    DateTime? tarih,
  }) : tarih = tarih ?? DateTime.now();

  factory Bildirimler.fromJson(Map<dynamic, dynamic> json, String id) {
    return Bildirimler(
      bildirimId: id,
      baslik: json['baslik'] as String,
      icerik: json['icerik'] as String,
      tarih: DateTime.parse(json['tarih'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baslik': baslik,
      'icerik': icerik,
      'tarih': tarih.toIso8601String(),
    };
  }
}
