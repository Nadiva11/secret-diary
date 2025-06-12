import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class SetPinPage extends StatefulWidget {
  final bool isChange;

  const SetPinPage({super.key, this.isChange = false});

  @override
  State<SetPinPage> createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  String? _errorText;

  Future<void> _savePin() async {
    if (_pinController.text != _confirmController.text) {
      setState(() {
        _errorText = 'PIN tidak cocok';
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin', _pinController.text);

    if (widget.isChange) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'PIN berhasil diubah',
            style: TextStyle(fontFamily: 'ComingSans'),
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isChange ? 'Ubah PIN' : 'Atur PIN',
          style: const TextStyle(fontFamily: 'GingiesBubble'),
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
              decoration: const InputDecoration(
                labelText: 'Masukkan PIN',
                labelStyle: TextStyle(fontFamily: 'ComingSans'),
              ),
              style: const TextStyle(fontFamily: 'ComingSans'),
            ),
            TextField(
              controller: _confirmController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Konfirmasi PIN',
                labelStyle: const TextStyle(fontFamily: 'ComingSans'),
                errorText: _errorText,
                errorStyle: const TextStyle(fontFamily: 'ComingSans'),
              ),
              style: const TextStyle(fontFamily: 'ComingSans'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePin,
              child: Text(
                widget.isChange ? 'Ubah PIN' : 'Simpan PIN',
                style: const TextStyle(fontFamily: 'ComingSans'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
