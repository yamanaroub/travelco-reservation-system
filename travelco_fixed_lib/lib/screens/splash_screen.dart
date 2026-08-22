import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/travelco_logo.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F4C81), Color(0xFF19A7A0)],
          ),
        ),
        child: const SafeArea(
          child: Column(
            children: [
              Spacer(),
              TravelcoLogo(size: 96, light: true),
              SizedBox(height: 16),
              Text(
                'Book your journey with confidence',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
