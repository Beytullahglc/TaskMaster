import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_master/cubits/bildirimlerCubit.dart';
import 'package:task_master/entity/bildirimler.dart';

class BildirimlerSayfa extends StatefulWidget {
  const BildirimlerSayfa({super.key});

  @override
  _BildirimlerSayfaState createState() => _BildirimlerSayfaState();
}

class _BildirimlerSayfaState extends State<BildirimlerSayfa> {
  @override
  void initState() {
    super.initState();
    context.read<BildirimlerCubit>().bildirimleriYukle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirimler', style: TextStyle(color: Colors.white)),
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
      body: BlocBuilder<BildirimlerCubit, List<Bildirimler>>(
        builder: (context, bildirimler) {
          if (bildirimler.isEmpty) {
            return const Center(child: Text('Bildirim bulunamadı.'));
          }

          final dateFormat = DateFormat('dd/MM/yyyy');
          final timeFormat = DateFormat('HH:mm');

          return ListView(
            children: bildirimler.map((bildirim) {
              return Dismissible(
                key: Key(bildirim.bildirimId),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  context.read<BildirimlerCubit>().deleteBildirim(bildirim.bildirimId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${bildirim.baslik} bildirimi silindi.'),
                    ),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExpansionTile(
                      title: Text(
                        bildirim.baslik,
                        style: const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      iconColor: Colors.blue,
                      collapsedIconColor: Colors.blue,
                      subtitle: Text(
                        '${dateFormat.format(bildirim.tarih)} - ${timeFormat.format(bildirim.tarih)}',
                        style: const TextStyle(color: Colors.black54, fontSize: 15),
                      ),
                      children: [
                        ListTile(
                          title: Text(
                            'İçerik: ${bildirim.icerik}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
