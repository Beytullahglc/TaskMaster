import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_master/cubits/gorevlerCubit.dart';
import 'package:task_master/entity/gorevler.dart';

class TakvimSayfa extends StatefulWidget {
  const TakvimSayfa({super.key});

  @override
  State<TakvimSayfa> createState() => _TakvimSayfaState();
}

class _TakvimSayfaState extends State<TakvimSayfa> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Gorevler>> gorevEvents = {};

  @override
  void initState() {
    super.initState();
    context.read<GorevlerCubit>().gorevleriYukle();
  }

  void _mapGorevlerToEvents(List<Gorevler> gorevler) {
    gorevEvents.clear();
    for (var gorev in gorevler) {
      DateTime tarih = DateTime(gorev.bitisTarihi.year, gorev.bitisTarihi.month, gorev.bitisTarihi.day);

      if (gorevEvents[tarih] != null) {
        gorevEvents[tarih]!.add(gorev);
      } else {
        gorevEvents[tarih] = [gorev];
      }
    }
  }

  void _showGorevlerSheet(List<Gorevler> gorevler, DateTime selectedDay) {
    String formattedDate = DateFormat('d MMMM').format(selectedDay); // Tarihi formatlamak için

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 300,
          child: Column(
            children: [
              Text(
                "$formattedDate tarihindeki görevler", // Dinamik başlık
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: gorevler.isNotEmpty
                    ? ListView.builder(
                  itemCount: gorevler.length,
                  itemBuilder: (context, index) {
                    Gorevler gorev = gorevler[index];
                    return ListTile(
                      title: Text(gorev.gorevAdi),
                      subtitle: Text(gorev.aciklama),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            gorev.bittiMi ? 'Tamamlandı' : 'Tamamlanmadı',
                            style: TextStyle(
                              color: gorev.bittiMi ? Colors.green : Colors.red,
                            ),
                          ),
                          const SizedBox(width: 8), // İkon ve yazı arasına boşluk ekler
                          Icon(
                            gorev.bittiMi ? Icons.check : Icons.close,
                            color: gorev.bittiMi ? Colors.green : Colors.red,
                          ),
                        ],
                      ),
                    );
                  },
                )
                    : const Center(
                  child: Text("Bu tarihte görev bulunmuyor."),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Takvim",
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
      body: BlocBuilder<GorevlerCubit, List<Gorevler>>(
        builder: (context, gorevler) {
          _mapGorevlerToEvents(gorevler);

          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });

                  List<Gorevler> selectedGorevler = gorevEvents[DateTime(selectedDay.year, selectedDay.month, selectedDay.day)] ?? [];
                  _showGorevlerSheet(selectedGorevler, selectedDay);
                },
                eventLoader: (day) {
                  DateTime selectedDayWithoutTime = DateTime(day.year, day.month, day.day);
                  return gorevEvents[selectedDayWithoutTime] ?? [];
                },
                calendarStyle: const CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    shape: BoxShape.circle,
                  ),
                  markersMaxCount: 1,
                  markerDecoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  formatButtonShowsNext: false,
                  //titleTextStyle: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
