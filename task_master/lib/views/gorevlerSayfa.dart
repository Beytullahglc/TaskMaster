import 'package:flutter/material.dart';

class GorevlerSayfa extends StatefulWidget {
  const GorevlerSayfa({super.key});

  @override
  State<GorevlerSayfa> createState() => _GorevlerSayfaState();
}

class _GorevlerSayfaState extends State<GorevlerSayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Görevler"),
          ],
        ),
      ),
    );
  }
}
