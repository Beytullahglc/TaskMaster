import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_master/entity/bildirimler.dart';


class BildirimlerCubit extends Cubit<List<Bildirimler>> {
  final DatabaseReference refBildirimler = FirebaseDatabase.instance.ref().child("bildirimler_tablo");

  BildirimlerCubit() : super([]);

  Future<void> bildirimEkle(Bildirimler bildirim) async {
    try {
      final newBildirimRef = refBildirimler.push();
      await newBildirimRef.set(bildirim.toJson());
      print('Bildirim başarıyla kaydedildi.');
    } catch (e) {
      print('Bildirim eklenirken hata oluştu: $e');
    }
  }

  // Bildirimleri dinlemek ve state'i güncellemek için bir işlev ekleyebilirsin
  Future<void> bildirimleriYukle() async {
    refBildirimler.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        final tasks = snapshot.value as Map<dynamic, dynamic>;
        final bildirimler = tasks.entries.map((entry) {
          final bildirimJson = Map<String, dynamic>.from(entry.value);
          return Bildirimler.fromJson(bildirimJson, entry.key as String);
        }).toList();
        emit(bildirimler);
      } else {
        emit([]);
      }
    });
  }

  Future<void> deleteBildirim(String bildirimId) async {
    try {
      await refBildirimler.child(bildirimId).remove();
      // Başarıyla silindikten sonra, bildirimleri tekrar yükleyin
      bildirimleriYukle();
    } catch (e) {
      // Hata durumunda, uygun bir hata yönetimi yapabilirsiniz
      print('Bildirim silme hatası: $e');
    }
  }
}