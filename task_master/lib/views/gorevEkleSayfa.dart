import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_master/cubits/gorevlerCubit.dart';
import 'package:task_master/entity/gorevler.dart';

class GorevEkleSayfa extends StatefulWidget {
  const GorevEkleSayfa({super.key});

  @override
  State<GorevEkleSayfa> createState() => _GorevEkleSayfaState();
}

class _GorevEkleSayfaState extends State<GorevEkleSayfa> {
  final TextEditingController gorevAdiController = TextEditingController();
  final TextEditingController aciklamaController = TextEditingController();
  final TextEditingController bitisTarihiController = TextEditingController();
  String? selectedKategori;
  bool isCompleted = false;

  final List<String> kategoriler = [
    'Kişisel',
    'Çalışma',
    'Öğrenim',
    'Eğlence',
    'Diğer'
  ];

  DateTime? selectedDateTime;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Görev Ekle',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  // Görev Adı Bölümü
                  buildExpansionTile(
                    index: 0,
                    title: 'Görev Adı',
                    child: TextField(
                      controller: gorevAdiController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),

                  // Açıklama Bölümü
                  buildExpansionTile(
                    index: 1,
                    title: 'Açıklama',
                    child: TextField(
                      controller: aciklamaController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      maxLines: 3,
                    ),
                  ),

                  // Kategori Seçimi Bölümü
                  buildExpansionTile(
                    index: 2,
                    title: 'Kategori',
                    child: Column(
                      children: kategoriler.map((kategori) {
                        return ListTile(
                          title: Text(kategori),
                          leading: Radio<String>(
                            value: kategori,
                            groupValue: selectedKategori,
                            onChanged: (value) {
                              setState(() {
                                selectedKategori = value!;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Bitiş Tarihi ve Saati Bölümü
                  buildExpansionTile(
                    index: 3,
                    title: 'Bitiş Tarihi ve Saati',
                    child: TextField(
                      controller: bitisTarihiController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null && pickedDate != selectedDateTime) {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              selectedDateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                              bitisTarihiController.text =
                                  selectedDateTime!.toIso8601String();
                            });
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 230,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Ekle",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    if (gorevAdiController.text.isEmpty ||
                        aciklamaController.text.isEmpty ||
                        selectedKategori == null ||
                        bitisTarihiController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Lütfen tüm alanları doldurun.'),
                        ),
                      );
                      return;
                    }

                    DateTime? bitisTarihi;
                    try {
                      bitisTarihi = DateTime.parse(bitisTarihiController.text);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Geçersiz tarih formatı.'),
                        ),
                      );
                      return;
                    }

                    final yeniGorev = Gorevler(
                      gorevId: '',
                      gorevAdi: gorevAdiController.text,
                      aciklama: aciklamaController.text,
                      kategori: selectedKategori!,
                      bitisTarihi: bitisTarihi,
                      bittiMi: isCompleted,
                    );

                    context.read<GorevlerCubit>().gorevEkle(yeniGorev);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Görev başarıyla eklendi.'),
                      ),
                    );

                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildExpansionTile({
    required int index,
    required String title,
    required Widget child,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          iconColor: Colors.blue,
          collapsedIconColor: Colors.blue,
          initiallyExpanded: selectedIndex == index,
          onExpansionChanged: (isOpen) {
            setState(() {
              // Eğer önceki açık olan tile kapatıldıysa, önceki tile'ın indeksini null yap
              if (isOpen) {
                selectedIndex = (selectedIndex == index) ? null : index;
              } else if (selectedIndex == index) {
                selectedIndex = null;
              }
            });
          },
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
