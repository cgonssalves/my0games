import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_search_screen.dart';
import '../database/database.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppDatabase _database;
  late Stream<List<Game>> _gamesStream;
  String _gamerName = "Carregando...";

  // --- MUDANÇA 1: De String para Lista de Strings ---
  // Agora guardamos uma lista das plataformas selecionadas pelo usuário
  List<String> _selectedPlatforms = []; 

  // Lista com todas as plataformas possíveis para seleção
  final List<String> _allPlatforms = ['Steam', 'Epic', 'Playstation', 'Xbox', 'Nintendo'];

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
    _loadUserData();
    _updateGamesStream(); // Chama o método para iniciar o stream
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if(mounted) {
      setState(() {
        _gamerName = prefs.getString('gamerName') ?? 'Gamer';
        // TODO: No futuro, você pode salvar e carregar as plataformas do SharedPreferences também
      });
    }
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }
  
  // Atualiza o stream de jogos com base na LISTA de plataformas
  void _updateGamesStream() {
    setState(() {
      _gamesStream = _database.gamesDao.watchGamesByPlatforms(_selectedPlatforms);
    });
  }

  // ... (As funções _navigateToGameSearch, _logout e _showDeleteConfirmationDialog continuam as mesmas)
  void _navigateToGameSearch() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GameSearchScreen(gamesDao: _database.gamesDao),
    ));
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _database.gamesDao.clearAllDataForLogout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _showDeleteConfirmationDialog(Game game) {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirmar Exclusão"),
        content: Text("Deseja remover '${game.name}'?"),
        actions: [
          TextButton(child: const Text("Cancelar"), onPressed: () => Navigator.of(context).pop()),
          TextButton(
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
            onPressed: () {
              _database.gamesDao.deleteGame(game);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }


  // --- MUDANÇA 2: Janela para Selecionar Plataformas ---
  void _showPlatformSelectionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Em qual plataforma você joga?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              // O Wrap organiza os botões e quebra a linha se não couberem
              Wrap(
                spacing: 8.0, // Espaço horizontal entre os botões
                runSpacing: 8.0, // Espaço vertical entre as linhas
                alignment: WrapAlignment.center,
                children: _allPlatforms.map((platform) {
                  // Checa se a plataforma já foi selecionada para desabilitar o botão
                  final isSelected = _selectedPlatforms.contains(platform);
                  return ElevatedButton(
                    onPressed: isSelected ? null : () {
                      setState(() {
                        _selectedPlatforms.add(platform);
                        _updateGamesStream(); // Atualiza a biblioteca com o novo filtro
                      });
                      Navigator.pop(context); // Fecha a janela
                    },
                    child: Text(platform),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [ IconButton(icon: const Icon(Icons.logout), onPressed: _logout) ],
                  ),
                ),
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage('https://i.imgur.com/8soQJkH.png'), 
                ),
                const SizedBox(height: 8),
                Text(
                  _gamerName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // --- MUDANÇA 3: O Novo Seletor de Plataforma Visual ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildPlatformSelector(),
                ),
                const SizedBox(height: 24),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Biblioteca", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text("Adicionar"),
                        onPressed: _navigateToGameSearch,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _buildGameLibraryList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // WIDGET que constrói o novo seletor com os chips e o botão '+'
  Widget _buildPlatformSelector() {
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        spacing: 8.0, // Espaço horizontal
        runSpacing: 8.0, // Espaço vertical (caso quebre a linha)
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Mapeia a lista de plataformas selecionadas para criar os 'chips'
          ..._selectedPlatforms.map((platform) {
            return Chip(
              label: Text(platform),
              onDeleted: () {
                setState(() {
                  _selectedPlatforms.remove(platform);
                  _updateGamesStream(); // Atualiza o filtro da biblioteca
                });
              },
            );
          }).toList(),

          // O botão de adicionar
          InkWell(
            onTap: _showPlatformSelectionSheet,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  // ... (O método _buildGameLibraryList continua o mesmo)
  Widget _buildGameLibraryList() {
    return StreamBuilder<List<Game>>(
      stream: _gamesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
        }
        final games = snapshot.data ?? [];
        if (games.isEmpty && _selectedPlatforms.isNotEmpty) {
          return SizedBox(height: 200, child: Center(child: Text("Nenhum jogo encontrado para as plataformas selecionadas.")));
        }
        if(games.isEmpty && _selectedPlatforms.isEmpty) {
          return SizedBox(height: 200, child: Center(child: Text("Sua biblioteca está vazia.")));
        }
        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: games.length,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemBuilder: (context, index) {
              final game = games[index];
              return InkWell(
                onLongPress: () => _showDeleteConfirmationDialog(game),
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 10),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: GridTile(
                      footer: GridTileBar(
                        backgroundColor: Colors.black54,
                        title: Text(game.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                      ),
                      child: Image.network(game.coverUrl, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.broken_image)),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}