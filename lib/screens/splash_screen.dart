import 'package:flutter/material.dart';
import 'dart:async'; // Precisamos para o Timer
import 'home_screen.dart'; // Apenas importa a HomeScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Inicia um timer de 2 segundos. Depois, navega para a HomeScreen.
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          // Apenas chama a HomeScreen, SEM NENHUM PARÂMETRO
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Você pode colocar sua logo ou qualquer widget para a splash aqui
    return const Scaffold(
      backgroundColor: Color(0xFF121212), // Mesma cor de fundo do seu app
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}