import 'package:flutter/material.dart';

class TakvimSayfa extends StatefulWidget {
  const TakvimSayfa({super.key});

  @override
  State<TakvimSayfa> createState() => _TakvimSayfaState();
}

class _TakvimSayfaState extends State<TakvimSayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Takvim"),
          ],
        ),
      ),
    );
  }
}
