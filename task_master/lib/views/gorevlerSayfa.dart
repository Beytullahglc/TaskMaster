import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_master/cubits/gorevlerCubit.dart';
import 'package:task_master/entity/gorevler.dart';

class GorevlerSayfa extends StatefulWidget {
  @override
  _GorevlerSayfaState createState() => _GorevlerSayfaState();
}

class _GorevlerSayfaState extends State<GorevlerSayfa> {
  @override
  void initState() {
    super.initState();
    context.read<GorevlerCubit>().gorevleriYukle(); // Görevleri yükle
  }

  bool aramaYapiliyorMu = false;
  String aramaSonucu = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: aramaYapiliyorMu
            ? TextField(
          decoration: const InputDecoration(
            hintText: "Ara",
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              aramaSonucu = value;
              print('Arama Sonucu: $aramaSonucu'); // Debugging
            });
          },
        )
            : const Text(
          'Görevler',
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
        actions: [
          aramaYapiliyorMu
              ? IconButton(
            color: Colors.black,
            icon: const Icon(Icons.cancel_outlined, color: Colors.white,),
            onPressed: () {
              setState(() {
                aramaYapiliyorMu = false;
                aramaSonucu = "";
              });
            },
          )
              : IconButton(
            color: Colors.black,
            icon: const Icon(Icons.search, color: Colors.white,),
            onPressed: () {
              setState(() {
                aramaYapiliyorMu = true;
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<GorevlerCubit, List<Gorevler>>(
        builder: (context, gorevler) {
          // Arama sonucununa göre görevleri filtrele
          final filteredGorevler = gorevler.where((gorev) {
            final searchTerm = aramaSonucu.toLowerCase();
            return gorev.gorevAdi.toLowerCase().contains(searchTerm) ||
                gorev.aciklama.toLowerCase().contains(searchTerm) ||
                gorev.kategori.toLowerCase().contains(searchTerm);
          }).toList();

          if (filteredGorevler.isEmpty) {
            return Center(child: Text('Görev bulunamadı.'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: filteredGorevler.map((gorev) {
                    return ExpansionTile(
                      title: Text(gorev.gorevAdi),
                      subtitle: Text(gorev.kategori),
                      children: [
                        ListTile(
                          title: Text('Açıklama: ${gorev.aciklama}'),
                        ),
                        ListTile(
                          title: Text('Bitiş Tarihi: ${gorev.bitisTarihi.toLocal().toString().split(' ')[0]}'),
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              Text('Tamamlandı: '),
                              Checkbox(
                                value: gorev.bittiMi,
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      gorev.bittiMi = value;
                                    });
                                    context.read<GorevlerCubit>().updateGorev(gorev);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            context.read<GorevlerCubit>().gorevSil(gorev.gorevId);
                          },
                          icon: Icon(Icons.delete, color: Colors.red,),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
