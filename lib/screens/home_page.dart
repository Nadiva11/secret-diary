import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/diary_model.dart';
import '../storage/diary_storage.dart';
import 'diary_page.dart';
import 'diary_detail_page.dart';
import 'calendar_page.dart';
import 'set_pin_page.dart';
import '../constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DiaryModel> diaries = [];
  String selectedBackground = 'roses';

  @override
  void initState() {
    super.initState();
    _loadDiaries();
    _loadBackground();
  }

  Future<void> _loadDiaries() async {
    diaries = await DiaryStorage.loadDiaryEntries();
    setState(() {});
  }

  Future<void> _loadBackground() async {
    final box = await Hive.openBox('diaryBox');
    setState(() {
      selectedBackground = box.get('selectedBackground', defaultValue: 'roses');
    });
  }

  Future<void> _saveBackground(String bg) async {
    final box = Hive.box('diaryBox');
    await box.put('selectedBackground', bg);
    setState(() {
      selectedBackground = bg;
    });
  }

  Future<void> refreshList() async {
    diaries = await DiaryStorage.loadDiaryEntries();
    setState(() {});
  }

  Color getDominantColor(String theme) {
    switch (theme) {
      case 'roses':
        return const Color(0xFFFFE4E1);
      case 'jellyfish':
        return const Color(0xFFD0E8F2);
      case 'sunset':
        return const Color(0xFFFFD6C0);
      case 'cozy':
        return const Color(0xFFFFE8D6);
      case 'sunflower':
        return const Color(0xFFFFF4B2);
      case 'autumn':
        return const Color(0xFFFFD6A5);
      case 'moonlight':
        return const Color(0xFFB9CBEF);
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    String bgAsset;
    switch (selectedBackground) {
      case 'roses':
        bgAsset = 'assets/images/garden.jpg';
        break;
      case 'jellyfish':
        bgAsset = 'assets/images/jellyfish.jpg';
        break;
      case 'sunset':
        bgAsset = 'assets/images/sunset.jpg';
        break;
      case 'cozy':
        bgAsset = 'assets/images/cozy.jpg';
        break;
      case 'sunflower':
        bgAsset = 'assets/images/sunflower.jpg';
        break;
      case 'autumn':
        bgAsset = 'assets/images/autumn.jpg';
        break;
      case 'moonlight':
        bgAsset = 'assets/images/night.jpg';
        break;
      default:
        bgAsset = 'assets/images/garden.jpg';
    }

    final backgroundColor = getDominantColor(selectedBackground);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Buku Harian',
          style: TextStyle(
            fontFamily: 'GingiesBubble',
            fontSize: 26,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Ubah Tema',
            onPressed: () {
              _openSettings(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.lock_outline),
            tooltip: 'Ubah PIN',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SetPinPage(isChange: true)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: 'Kalender',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bgAsset),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: diaries.isEmpty
                  ? const Center(
                child: Text(
                  'Belum ada catatan.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'ComingSans',
                    fontSize: 16,
                  ),
                ),
              )
                  : AnimationLimiter(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: diaries.length,
                  itemBuilder: (context, index) {
                    final diary = diaries[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 300),
                      child: SlideAnimation(
                        verticalOffset: 50,
                        child: FadeInAnimation(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    diary.time.substring(0, 2),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'ComingSans',
                                    ),
                                  ),
                                  Text(
                                    diary.time.substring(3, 6),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'ComingSans',
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(
                                diary.title,
                                style: const TextStyle(
                                  fontFamily: 'ComingSans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                diary.time.substring(6),
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontFamily: 'ComingSans',
                                ),
                              ),
                              trailing: Image.asset(
                                moodEmojiPaths[diary.mood],
                                width: 32,
                                height: 32,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DiaryDetailPage(diary: diary),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DiaryPage()),
          );
          if (result == true) {
            await refreshList();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeTile("🌸 Garden of Roses", 'roses', Colors.pink),
            _buildThemeTile("🐙 Ocean Glow", 'jellyfish', Colors.purple),
            _buildThemeTile("🌅 Sunset Serenity", 'sunset', Colors.orange),
            _buildThemeTile("☕ Cozy Capybara", 'cozy', Colors.brown),
            _buildThemeTile("🌻 Sunflower Bliss", 'sunflower', Colors.yellow),
            _buildThemeTile("🍂 Autumn Path", 'autumn', Colors.deepOrange),
            _buildThemeTile("🌌 Moonlight Lake", 'moonlight', Colors.indigo),
          ],
        );
      },
    );
  }

  ListTile _buildThemeTile(String title, String key, Color color) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontFamily: 'ComingSans'),
      ),
      trailing: selectedBackground == key ? Icon(Icons.check, color: color) : null,
      onTap: () {
        _saveBackground(key);
        Navigator.pop(context);
      },
    );
  }
}
