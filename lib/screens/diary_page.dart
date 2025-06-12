import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../models/diary_model.dart';
import '../storage/diary_storage.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  int? selectedMood;

  final List<String> dailyPrompts = [
    "🌞 Apa hal kecil yang membuatmu tersenyum hari ini?",
    "💖 Apa hal yang paling kamu syukuri saat ini?",
    "📸 Momen apa yang ingin kamu kenang dari hari ini?",
    "🎯 Apa satu hal yang berhasil kamu capai hari ini?",
    "🔄 Jika bisa mengulang hari ini, apa yang ingin kamu lakukan berbeda?",
    "🧠 Pelajaran berharga apa yang kamu dapatkan hari ini?",
    "💬 Apa kata-kata yang paling berkesan hari ini?",
    "🫶 Siapa yang membuat harimu lebih indah hari ini?",
    "🎨 Bagaimana kamu mengekspresikan perasaanmu hari ini?",
    "🌱 Apa satu langkah kecil yang membawamu lebih dekat ke impianmu?",
  ];

  String getTodayPrompt() {
    final today = DateTime.now();
    final index = today.day % dailyPrompts.length;
    return dailyPrompts[index];
  }

  void _saveDiary() async {
    if (_titleController.text.isEmpty ||
        _noteController.text.isEmpty ||
        selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Semua kolom harus diisi!',
            style: TextStyle(fontFamily: 'ComingSans'),
          ),
        ),
      );
      return;
    }

    final diary = DiaryModel(
      title: _titleController.text,
      note: _noteController.text,
      mood: selectedMood!,
      time: DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
      date: DateTime.now(),
    );

    List<DiaryModel> diaries = await DiaryStorage.loadDiaryEntries();
    diaries.add(diary);
    await DiaryStorage.saveDiaryEntries(diaries);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Catatan berhasil disimpan!',
          style: TextStyle(fontFamily: 'ComingSans'),
        ),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: selectedMood != null
          ? moodColors[selectedMood!]
          : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Buat Catatan',
          style: TextStyle(
            fontFamily: 'GingiesBubble',
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(moodEmojiPaths.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMood = index;
                    });
                  },
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: selectedMood == index
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                    child: Image.asset(
                      moodEmojiPaths[index],
                      width: 32,
                      height: 32,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Daily Prompt",
                  style: TextStyle(
                    fontFamily: 'GingiesBubble',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4F4F4F), // abu-abu gelap
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    getTodayPrompt(),
                    style: const TextStyle(
                      fontFamily: 'ComingSans',
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Judul catatan',
                hintStyle: TextStyle(fontFamily: 'GingiesBubble'),
              ),
              style: const TextStyle(fontFamily: 'GingiesBubble'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _noteController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'Isi catatan...',
                  hintStyle: TextStyle(fontFamily: 'ComingSans'),
                ),
                style: const TextStyle(fontFamily: 'ComingSans'),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveDiary,
              child: const Text(
                'Simpan',
                style: TextStyle(
                  fontFamily: 'ComingSans',
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
