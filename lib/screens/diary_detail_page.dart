import 'package:flutter/material.dart';
import '../models/diary_model.dart';
import '../constants.dart';

class DiaryDetailPage extends StatelessWidget {
  final DiaryModel diary;

  const DiaryDetailPage({super.key, required this.diary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: moodColors[diary.mood],
      appBar: AppBar(
        title: const Text(
          'Detail Catatan',
          style: TextStyle(fontFamily: 'GingiesBubble'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: diary.mood < moodEmojiPaths.length
                  ? Image.asset(
                moodEmojiPaths[diary.mood],
                width: 100,
                height: 100,
              )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),
            Text(
              diary.title,
              style: const TextStyle(
                fontFamily: 'GingiesBubble',
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              diary.time,
              style: const TextStyle(
                fontFamily: 'ComingSans',
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  diary.note,
                  style: const TextStyle(
                    fontFamily: 'ComingSans',
                    fontSize: 18,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
