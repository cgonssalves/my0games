import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my0games/screens/login_screen.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _gamerName = 'Carregando...';
  String? _selectedPlatform;
  final List<String> _platforms = ['PC', 'Xbox', 'Playstation', 'Nintendo'];

  @override
  void initState() {
    super.initState();
    _loadGamerName();
    _loadPlatform();
  }

  Future<void> _loadGamerName() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _gamerName = prefs.getString('gamerName') ?? 'Jogador';
      });
    }
  }

  Future<void> _savePlatform(String platform) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedPlatform', platform);
  }

  Future<void> _loadPlatform() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _selectedPlatform = prefs.getString('selectedPlatform');
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: const Color(0xFF1E1E1E), 
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0), // Padding geral
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20), 
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white24,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'),
            ),
            const SizedBox(height: 20),
            Text(
              _gamerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30), // Espaço antes do dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.white24)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedPlatform,
                  hint: const Text( 'Selecionar plataforma', style: TextStyle(color: Colors.white70),),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  dropdownColor: const Color(0xFF1E1E1E),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  items: _platforms.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue == null) return;
                    setState(() { _selectedPlatform = newValue; });
                    _savePlatform(newValue);
                  },
                ),
              ),
            ),

            const SizedBox(height: 30), // espaço antes da nova seção


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Biblioteca',
                  style: TextStyle( color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    print('Botão Adicionar Game clicado!');
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Adicionar Game'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey[800],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),


            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(top: 4.0, bottom: 20.0), // Adiciona um respiro
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('Capa', style: TextStyle(color: Colors.white54)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}