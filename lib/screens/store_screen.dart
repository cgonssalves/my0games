import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({Key? key}) : super(key: key);

  // Função para abrir a URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    // Tenta abrir o link no navegador externo
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Se não conseguir, pode mostrar um erro (opcional)
      debugPrint("Não foi possível abrir o link $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra no topo da página
      appBar: AppBar(
        title: const Text('Lojas'),
        centerTitle: true,
        // Deixa o appbar com a mesma cor do fundo
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Estica os widgets na horizontal
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20), // Um pequeno espaço
            
            // Retângulo azul clicável da Steam
            _buildStoreButton(
              'STEAM',
              const Color(0xFF1B2838), // Cor oficial da Steam
              () => _launchURL('https://store.steampowered.com'),
            ),

            // No futuro, para adicionar mais lojas aqui
            // Ex: _buildStoreButton('EPIC GAMES', Colors.grey.shade800, () => _launchURL('URL_DA_EPIC')),
          ],
        ),
      ),
    );
  }

  // Widget para criar os botões das lojas, para reutilizar o código
  Widget _buildStoreButton(String storeName, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        storeName,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
