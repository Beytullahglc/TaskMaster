//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SifreDegistirme extends StatefulWidget {
  const SifreDegistirme({super.key});

  @override
  State<SifreDegistirme> createState() => _SifreDegistirmeState();
}

class _SifreDegistirmeState extends State<SifreDegistirme> {
  final TextEditingController _kullaniciAdiController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();
  final TextEditingController _sifreTekrarController = TextEditingController();

 /* Future<void> _sifreyiDegistir() async {
    try {
      // Kullanıcının mevcut oturumunu al
      User? user = FirebaseAuth.instance.currentUser;

      // Yeni şifrelerin doğruluğunu kontrol et
      if (_sifreController.text == _sifreTekrarController.text) {
        // Yeni şifreleri güncelle
        await user!.updatePassword(_sifreController.text);

        // Kullanıcı adını güncelle (isteğe bağlı)
        if (_kullaniciAdiController.text.isNotEmpty) {
          await user.updateProfile(displayName: _kullaniciAdiController.text);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Şifre başarıyla değiştirildi.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Girilen şifreler eşleşmiyor.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }*/

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    double ekranYuksekligi = ekranBilgisi.size.height;
    double ekranGenisligi = ekranBilgisi.size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top:80, bottom: 15),
                child: SizedBox(
                  width: ekranGenisligi/2,
                  child: Image.asset("assets/TaskMaster.png", ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(ekranYuksekligi/35),
                child: SizedBox(
                  width: ekranGenisligi*4/5,
                  child: TextField(
                    controller: _kullaniciAdiController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "E mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(ekranYuksekligi/35),
                child: SizedBox(
                  width: ekranGenisligi*4/5,
                  child: TextField(
                    controller: _sifreController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Yeni Şifre",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(ekranYuksekligi/35),
                child: SizedBox(
                  width: ekranGenisligi*4/5,
                  child: TextField(
                    controller: _sifreTekrarController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Yeni Şifre (Tekrar)",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top:  ekranGenisligi/10),
                child: SizedBox(
                  width: ekranGenisligi/2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: (){},
                    child: Text("Değiştir", style: TextStyle(fontSize: ekranGenisligi/20, color: Colors.white),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
