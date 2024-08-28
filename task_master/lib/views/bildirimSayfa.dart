import 'package:flutter/material.dart';

class BildirimSayfa extends StatefulWidget {
  const BildirimSayfa({super.key});

  @override
  State<BildirimSayfa> createState() => _BildirimSayfaState();
}

class _BildirimSayfaState extends State<BildirimSayfa> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bildirimler"),
          ],
        ),
      ),
    );
  }
}
