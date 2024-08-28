import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:task_master/views/bildirimSayfa.dart';
import 'package:task_master/views/gorevEkleSayfa.dart';
import 'package:task_master/views/gorevlerSayfa.dart';
import 'package:task_master/views/profilSayfa.dart';
import 'package:task_master/views/takvimSayfa.dart';

class Sayfalar extends StatefulWidget {
  const Sayfalar({super.key});

  @override
  State<Sayfalar> createState() => _SayfalarState();
}

class _SayfalarState extends State<Sayfalar> {
  int page = 1; // Varsayılan olarak Görevler sayfası seçili

  var sayfaListesi = [
    const TakvimSayfa(),
     GorevlerSayfa(),
    const GorevEkleSayfa(), // Burada sayfa gösterimi yapılmıyor
    const BildirimSayfa(),
    const ProfilSayfa(),
  ];

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sayfaListesi[page],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: page,
        items: <Widget>[
          Icon(
             page ==0? Icons.calendar_month : Icons.calendar_month_outlined,
            size: 30,
            color: page == 0 ? Colors.blueAccent : Colors.black,
          ),
          Icon(
             page == 1? Icons.task : Icons.task_outlined,
            size: 30,
            color: page == 1 ? Colors.blueAccent : Colors.black,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.blueAccent, // Arka plan rengini mavi yapıyoruz
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GorevEkleSayfa()),
                ).then((_) {
                  // Geri dönüldüğünde sayfa ve ikon güncellenir
                  setState(() {
                    page = 1; // Görevler sayfasını seçili yap
                  });
                });
              },
            ),
          ),
          Icon(
            page == 3? Icons.notifications : Icons.notifications_outlined,
            size: 30,
            color: page == 3 ? Colors.blueAccent : Colors.black,
          ),
          Icon(
            page == 4? Icons.person : Icons.person_outline,
            size: 30,
            color: page == 4 ? Colors.blueAccent : Colors.black,
          ),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.transparent, // Arka plan rengi şeffaf
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (int index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GorevEkleSayfa()),
            ).then((_) {
              // Geri dönüldüğünde sayfa ve ikon güncellenir
              setState(() {
                page = 1; // Görevler sayfasını seçili yap
              });
            });
          } else {
            setState(() {
              page = index;
            });
          }
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
