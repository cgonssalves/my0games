import 'package:flutter/material.dart';
import 'game_search_screen.dart';
import '../database/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppDatabase _database;

  // Variáveis de estado para a UI que você já tinha
  final List<String> _platforms = ['PC', 'Xbox', 'Playstation', 'Nintendo'];
  String? _selectedPlatform = 'PC'; // Definindo um valor inicial

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  void _navigateToAddGameScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GameSearchScreen(gamesDao: _database.gamesDao),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Game game) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar Exclusão"),
          content: Text(
              "Você tem certeza que deseja remover '${game.name}' da sua biblioteca?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Excluir", style: TextStyle(color: Colors.red)),
              onPressed: () {
                _database.gamesDao.deleteGame(game);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Mantém o título do seu design original
        title: Text("Meu Perfil"),
        actions: [
          // Botão de logout que você tinha
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              // TODO: Adicionar sua lógica de logout aqui
            },
          ),
        ],
      ),
      // Usamos uma Column para empilhar os widgets verticalmente
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // --- SEÇÃO DO PERFIL ---
            const CircleAvatar(
              radius: 50,
              // Coloque sua imagem de perfil aqui
              backgroundImage: NetworkImage('https://i.imgur.com/example.jpg'), // URL de exemplo
            ),
            const SizedBox(height: 12),
            const Text(
              "nome de usuario", // Coloque o nome do usuário aqui
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // --- SELETOR DE PLATAFORMA ---
            DropdownButtonFormField<String>(
              value: _selectedPlatform,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: _platforms.map((String platform) {
                return DropdownMenuItem<String>(
                  value: platform,
                  child: Text(platform),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPlatform = newValue;
                });
              },
            ),
            const SizedBox(height: 24),

            // --- TÍTULO DA BIBLIOTECA E BOTÃO DE ADICIONAR ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Biblioteca",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.add, size: 18),
                  label: Text("Adicionar Game"),
                  onPressed: _navigateToAddGameScreen,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- GRADE DE JOGOS (COM EXPANDED) ---
            // O Expanded é CRUCIAL aqui. Ele diz para a grade de jogos
            // ocupar todo o espaço vertical que sobrou na tela.
            Expanded(
              child: _buildGameLibraryGrid(),
            ),
          ],
        ),
      ),
    );
  }

  // Separei a lógica da grade em um widget para organizar melhor
  Widget _buildGameLibraryGrid() {
    return StreamBuilder<List<Game>>(
      stream: _database.gamesDao.watchAllGames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final games = snapshot.data ?? [];

        if (games.isEmpty) {
          return Center(child: Text("Sua biblioteca está vazia."));
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: 0.75,
          ),
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            return InkWell(
              onLongPress: () => _showDeleteConfirmationDialog(game),
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 4.0,
                child: GridTile(
                  footer: GridTileBar(
                    backgroundColor: Colors.black54,
                    title: Text(game.name, textAlign: TextAlign.center),
                  ),
                  child: Image.network(
                    game.coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Icon(Icons.broken_image, color: Colors.grey));
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}