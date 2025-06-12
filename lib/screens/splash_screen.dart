import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pin_screen.dart';
import 'set_pin_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _buttonController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool showButton = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeOut,
    ));

    _fadeController.forward();

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        showButton = true;
        _buttonController.forward();
      });
    });
  }

  Future<void> _handleStart() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString('pin');

    if (savedPin != null && savedPin.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PinScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SetPinPage()),
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.jpeg',
                    width: 300,
                    height: 300,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Secret Diary',
                    style: TextStyle(
                      fontFamily: 'GreatVibes',
                      fontSize: 48,
                      color: Color(0xFFC599B6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            if (showButton)
              SlideTransition(
                position: _slideAnimation,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEADDE4),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),

                  ),
                  onPressed: _handleStart,
                  child: const Text(
                    'Mulai',
                    style: TextStyle(
                      fontFamily: 'ComingSans',
                      color: Color(0xFFC599B6),
                      fontWeight: FontWeight.bold,
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
