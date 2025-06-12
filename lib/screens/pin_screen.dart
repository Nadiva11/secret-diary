import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final TextEditingController _pinController = TextEditingController();
  String? _errorText;

  Future<void> _checkPin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString('pin');

    if (_pinController.text == savedPin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      setState(() {
        _errorText = 'PIN salah, coba lagi';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Masukkan PIN',
          style: TextStyle(fontFamily: 'GingiesBubble'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'PIN',
                labelStyle: const TextStyle(fontFamily: 'ComingSans'),
                errorText: _errorText,
                errorStyle: const TextStyle(fontFamily: 'ComingSans'),
              ),
              style: const TextStyle(fontFamily: 'ComingSans'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkPin,
              child: const Text(
                'Masuk',
                style: TextStyle(fontFamily: 'ComingSans'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
