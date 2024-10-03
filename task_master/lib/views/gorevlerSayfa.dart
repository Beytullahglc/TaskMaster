import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_master/cubits/gorevlerCubit.dart';
import 'package:task_master/entity/gorevler.dart';
import 'package:intl/intl.dart';

class GorevlerSayfa extends StatefulWidget {
  const GorevlerSayfa({super.key});

  @override
  _GorevlerSayfaState createState() => _GorevlerSayfaState();
}

class _GorevlerSayfaState extends State<GorevlerSayfa> {
  bool aramaYapiliyorMu = false;
  String aramaSonucu = "";
  bool tamamlananGorevler = false;
  bool devamEdenGorevler = false;
  Set<String> secilenKategoriler = {};

  @override
  void initState() {
    super.initState();
    context.read<GorevlerCubit>().gorevleriYukle();
  }

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
        leading: IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white),
          onPressed: () {
            _showFilterDialog();
          },
        ),
        actions: [
          aramaYapiliyorMu
              ? IconButton(
                  color: Colors.black,
                  icon: const Icon(Icons.cancel_outlined, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      aramaYapiliyorMu = false;
                      aramaSonucu = "";
                    });
                  },
                )
              : IconButton(
                  color: Colors.black,
                  icon: const Icon(Icons.search, color: Colors.white),
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
          final filteredGorevler = gorevler.where((gorev) {
            final searchTerm = aramaSonucu.toLowerCase();
            final isMatch = gorev.gorevAdi.toLowerCase().contains(searchTerm) ||
                gorev.aciklama.toLowerCase().contains(searchTerm) ||
                gorev.kategori.toLowerCase().contains(searchTerm);
            final isCompleted = gorev.bittiMi;
            final isCategoryMatch = secilenKategoriler.isEmpty ||
                secilenKategoriler.contains(gorev.kategori);

            return isMatch &&
                isCategoryMatch &&
                ((tamamlananGorevler && isCompleted) ||
                    (devamEdenGorevler && !isCompleted) ||
                    (!tamamlananGorevler && !devamEdenGorevler));
          }).toList();

          if (filteredGorevler.isEmpty) {
            return const Center(child: Text('Görev bulunamadı.'));
          }

          final dateFormat = DateFormat('dd/MM/yyyy');
          final timeFormat = DateFormat('HH:mm');

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: filteredGorevler.map((gorev) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpansionTile(
                          title: Text(
                            gorev.gorevAdi,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                          ),
                          iconColor: Colors.blue,
                          collapsedIconColor: Colors.blue,
                          subtitle: Text(
                            gorev.kategori,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 15),
                          ),
                          children: [
                            ListTile(
                              title: Text(
                                'Açıklama: ${gorev.aciklama}',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Bitiş Tarihi: ${dateFormat.format(gorev.bitisTarihi.toLocal())} - Saat: ${timeFormat.format(gorev.bitisTarihi.toLocal())}',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                            ListTile(
                              title: Row(
                                children: [
                                  const Text(
                                    'Tamamlandı: ',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Checkbox(
                                    activeColor: Colors.blue,
                                    value: gorev.bittiMi,
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          gorev.bittiMi = value;
                                        });
                                        context
                                            .read<GorevlerCubit>()
                                            .updateGorev(gorev);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Görev Sil'),
                                    content: const Text(
                                        'Bu görevi silmek istediğinizden emin misiniz?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<GorevlerCubit>()
                                              .gorevSil(gorev.gorevId);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Evet'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Hayır'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtrele'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExpansionTile(
                    title: const Text("Tamamlanma Durumu"),
                    iconColor: Colors.blue,
                    collapsedIconColor: Colors.blue,
                    children: [
                      CheckboxListTile(
                        value: tamamlananGorevler,
                        title: const Text("Tamamlanan"),
                        activeColor: Colors.blue,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? veri) {
                          setDialogState(() {
                            tamamlananGorevler = veri!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        value: devamEdenGorevler,
                        title: const Text("Devam Eden"),
                        activeColor: Colors.blue,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? veri) {
                          setDialogState(() {
                            devamEdenGorevler = veri!;
                          });
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text("Kategoriler"),
                    iconColor: Colors.blue,
                    collapsedIconColor: Colors.blue,
                    children: [
                      ...['Kişisel', 'Çalışma', 'Öğrenim', 'Eğlence', 'Diğer']
                          .map((kategori) {
                        return CheckboxListTile(
                          value: secilenKategoriler.contains(kategori),
                          title: Text(kategori),
                          activeColor: Colors.blue,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (bool? veri) {
                            setDialogState(() {
                              if (veri == true) {
                                secilenKategoriler.add(kategori);
                              } else {
                                secilenKategoriler.remove(kategori);
                              }
                            });
                          },
                        );
                      }),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {}); // Ekranı günceller
              },
              child: const Text('Tamam', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}
