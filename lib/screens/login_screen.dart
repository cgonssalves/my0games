import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_nameController.text.isNotEmpty && _passwordController.text.length >= 8) {
      // Acessa a caixinha de preferências
      final prefs = await SharedPreferences.getInstance();
      
      // Salva os dados do usuário
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('gamerName', _nameController.text);

      // Garante que o widget ainda está montado antes de navegar
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen()),
);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha o nome e uma senha com no mínimo 8 caracteres.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFormValid = _nameController.text.isNotEmpty && _passwordController.text.length >= 8;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'My 0 Games',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Bem-vindo(a) de volta, gamer!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 50),

              // Campo de Nome
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Digite seu 'gamer name'",
                  prefixIcon: Icon(Icons.person_outline, color: Colors.white54),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 20),

              // Campo de Senha
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Digite sua 'gamer senha'",
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.white54),
                  // ícone para mostrar/esconder a senha
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white54,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 40),

              // Botão de Entrar
              ElevatedButton(
                onPressed: isFormValid ? _login : null,
                style: ElevatedButton.styleFrom(
                  // Desabilitar o botão visualmente quando o formulário é inválido
                  backgroundColor: isFormValid ? Colors.green : Colors.grey.shade800,
                ),
                child: const Text('Entrar', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}