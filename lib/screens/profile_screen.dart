import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    final bool isPasswordValid = _passwordController.text.length >= 8;

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Fundo escuro (tema dark)
      body: Stack(
        children: [
          Center(
            child: _isLoggedIn
                ? Text(
                    'Bem vindo ao My 0 Games, ${_nameController.text}',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Digite seu 'gamer name'",
                            hintStyle: TextStyle(color: Colors.white54),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText: "Digite sua 'gamer senha'",
                            hintStyle: TextStyle(color: Colors.white54),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: isPasswordValid
                              ? () {
                                  setState(() {
                                    _isLoggedIn = true;
                                  });
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isPasswordValid
                                ? Colors.green
                                : Colors.grey[400], // Cinza claro
                          ),
                          child: const Text('Entrar'),
                        ),
                      ],
                    ),
                  ),
          ),

          // Janela flutuante de boas-vindas
          if (!_isLoggedIn)
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 400),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'Bem vindo ao My 0 Games',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
        ],
      ),
    );
  }
}