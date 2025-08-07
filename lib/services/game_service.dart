import 'dart:convert';
import 'package:http/http.dart' as http;

class Game {
  final int id;
  final String name;
  final String imageUrl;

  Game({required this.id, required this.name, required this.imageUrl});

  // Métodos para salvar e carregar o jogo da memória do celular
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      imageUrl: json['background_image'] ?? '', 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}


class GameService {
  final String _apiKey = 'ab7212e032af4985883bddabb6d95c72';
  final String _baseUrl = 'https://api.rawg.io/api';

  Future<List<Game>> searchGames(String query) async {
    // Se a busca estiver vazia, retorna uma lista vazia
    if (query.isEmpty) {
      return [];
    }

    final url = Uri.parse('$_baseUrl/games?key=$_apiKey&search=$query&page_size=10');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];
        
        // Converte os resultados da API para a nossa classe Game
        return results.map((e) => Game.fromJson(e)).toList();
      } else {
        // Se deu erro na busca, mostra no console
        print('Erro na API: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erro na requisição: $e');
      return [];
    }
  }
}