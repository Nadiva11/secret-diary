import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../storage/diary_storage.dart';
import '../models/diary_model.dart';
import '../constants.dart';
import 'diary_detail_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, DiaryModel> _moodByDate = {};

  @override
  void initState() {
    super.initState();
    _loadDiaryEntries();
  }

  Future<void> _loadDiaryEntries() async {
    final entries = await DiaryStorage.loadDiaryEntries();

    final Map<DateTime, DiaryModel> moodMap = {};
    for (var entry in entries) {
      final dateOnly = DateTime(entry.date.year, entry.date.month, entry.date.day);
      moodMap[dateOnly] = entry;
    }

    setState(() {
      _moodByDate = moodMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F6),
      appBar: AppBar(
        title: const Text(
          'Calendar View',
          style: TextStyle(fontFamily: 'GingiesBubble'),
        ),
        backgroundColor: Colors.pinkAccent.shade100,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });

            final entry = _moodByDate[DateTime(selectedDay.year, selectedDay.month, selectedDay.day)];

            if (entry != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DiaryDetailPage(diary: entry),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Belum ada catatan di tanggal ini.",
                    style: TextStyle(fontFamily: 'ComingSans'),
                  ),
                ),
              );
            }
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.pink[200],
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.deepPurpleAccent.shade100,
              shape: BoxShape.circle,
            ),
            weekendTextStyle: const TextStyle(
              color: Colors.pinkAccent,
              fontFamily: 'ComingSans',
            ),
            selectedTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'ComingSans',
            ),
            todayTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'ComingSans',
            ),
            defaultTextStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'ComingSans',
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: const TextStyle(
              color: Colors.pink,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'ComingSans',
            ),
            leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.pink),
            rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.pink),
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              final moodEntry = _moodByDate[DateTime(day.year, day.month, day.day)];
              if (moodEntry != null) {
                return Center(
                  child: Image.asset(
                    moodEmojiPaths[moodEntry.mood],
                    width: 22,
                    height: 22,
                  ),
                );
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
