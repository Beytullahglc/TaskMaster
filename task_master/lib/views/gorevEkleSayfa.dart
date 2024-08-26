import 'package:flutter/material.dart';

class GorevEkleSayfa extends StatefulWidget {
  const GorevEkleSayfa({super.key});

  @override
  State<GorevEkleSayfa> createState() => _GorevEkleSayfaState();
}

class _GorevEkleSayfaState extends State<GorevEkleSayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Görev Ekle"),
          ],
        ),
      ),
    );
  }
}
