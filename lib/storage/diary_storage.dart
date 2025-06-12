import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/diary_model.dart';

class DiaryStorage {
  static const String diaryKey = 'diary_entries';

  // Fungsi untuk memuat semua catatan dari SharedPreferences
  static Future<List<DiaryModel>> loadDiaryEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final diaryData = prefs.getString(diaryKey);

    if (diaryData != null) {
      try {
        final List<dynamic> decodedData = jsonDecode(diaryData);
        return decodedData
            .map((entry) => DiaryModel.fromMap(entry))
            .whereType<DiaryModel>()
            .toList();
      } catch (e) {
        print('❌ Gagal memuat data diary: $e');
        return [];
      }
    } else {
      return [];
    }
  }

  // Fungsi untuk menyimpan semua catatan ke SharedPreferences
  static Future<void> saveDiaryEntries(List<DiaryModel> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = jsonEncode(entries.map((e) => e.toMap()).toList());
    await prefs.setString(diaryKey, encodedData);
    print('✅ Catatan berhasil disimpan (${entries.length} entri)');
  }

  // Optional: Fungsi untuk menghapus semua catatan
  static Future<void> clearAllEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(diaryKey);
    print('🧹 Semua catatan telah dihapus!');
  }
}
