import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_master/entity/gorevler.dart';

class GorevlerCubit extends Cubit<List<Gorevler>> {
  GorevlerCubit() : super([]);

  var refGorevler = FirebaseDatabase.instance.ref().child("gorevler_tablo");

  Future<void> gorevleriYukle() async {
    refGorevler.onValue.listen((event) {
      var gelenDegerler = event.snapshot.value;
      print('Gelen veri: $gelenDegerler');

      if (gelenDegerler != null && gelenDegerler is Map<dynamic, dynamic>) {
        final gorevListesi = gelenDegerler.entries
            .map((entry) => Gorevler.fromJson(entry.key, entry.value))
            .toList();
        emit(gorevListesi);
      } else {
        print("Gelen değerler null: Veritabanında görev yok veya erişim hatası var.");
      }
    });
  }

  Future<void> updateGorev(Gorevler gorev) async {
    await refGorevler.child(gorev.gorevId).update(gorev.toJson());
  }

  Future<void> gorevSil(String gorevId) async {
    await refGorevler.child(gorevId).remove();
  }

  Future<void> gorevEkle(Gorevler gorev) async {
    try {
      // Yeni görev eklerken benzersiz bir ID oluşturur
      final newRef = refGorevler.push();
      gorev.gorevId = newRef.key ?? ""; // Elde edilen ID'yi göreve ekle

      await newRef.set(gorev.toJson());
      print('Görev başarıyla eklendi: ${gorev.gorevAdi}');
    } catch (e) {
      print('Görev ekleme hatası: $e');
    }
  }
}
