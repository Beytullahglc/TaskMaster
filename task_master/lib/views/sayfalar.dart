import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:task_master/views/bildirimlerSayfa.dart';
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
  int _page = 1; // Varsayılan olarak Görevler sayfası seçili

  final List<Widget> _sayfaListesi = [
    const TakvimSayfa(),
    const GorevlerSayfa(),
    const SizedBox(), // Boş bir container yerine SizedBox
    const BildirimlerSayfa(),
    const ProfilSayfa(),
  ];

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _sayfaListesi[_page],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        items: <Widget>[
          Icon(
            _page == 0 ? Icons.calendar_month : Icons.calendar_month_outlined,
            size: 30,
            color: _page == 0 ? Colors.blueAccent : Colors.black,
          ),
          Icon(
            _page == 1 ? Icons.task : Icons.task_outlined,
            size: 30,
            color: _page == 1 ? Colors.blueAccent : Colors.black,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
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
                  setState(() {
                    _page = 1; // Görevler sayfasını seçili yap
                  });
                });
              },
            ),
          ),
          Icon(
            _page == 3 ? Icons.notifications : Icons.notifications_outlined,
            size: 30,
            color: _page == 3 ? Colors.blueAccent : Colors.black,
          ),
          Icon(
            _page == 4 ? Icons.person : Icons.person_outline,
            size: 30,
            color: _page == 4 ? Colors.blueAccent : Colors.black,
          ),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (int index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GorevEkleSayfa()),
            ).then((_) {
              setState(() {
                _page = 1; // Görevler sayfasını seçili yap
              });
            });
          } else {
            setState(() {
              _page = index;
            });
          }
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
