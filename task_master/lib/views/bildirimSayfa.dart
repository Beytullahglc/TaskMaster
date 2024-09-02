import 'package:flutter/material.dart';

class BildirimSayfa extends StatefulWidget {
  const BildirimSayfa({super.key});

  @override
  State<BildirimSayfa> createState() => _BildirimSayfaState();
}

class _BildirimSayfaState extends State<BildirimSayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bildirimler",
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
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
