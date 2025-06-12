class DiaryModel {
  final String title;
  final String note;
  final int mood;
  final String time;
  final DateTime date;

  DiaryModel({
    required this.title,
    required this.note,
    required this.mood,
    required this.time,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'note': note,
      'mood': mood,
      'time': time,
      'date': date.toIso8601String(),
    };
  }

  factory DiaryModel.fromMap(Map<String, dynamic> map) {
    return DiaryModel(
      title: map['title'],
      note: map['note'],
      mood: map['mood'],
      time: map['time'],
      date: DateTime.parse(map['date']),
    );
  }
}

