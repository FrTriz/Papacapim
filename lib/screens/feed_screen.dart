// ============================================================
// ARQUIVO: screens/feed_screen.dart
// FUNÇÃO: Tela principal que exibe o feed de publicações em
//         duas abas: "Seguindo" e "Geral".
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/post_card.dart';
import 'create_post_screen.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

// Tela principal com abas de navegação.
class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Inicializa o controlador com 2 abas.
    _tabController = TabController(length: 2, vsync: this);
  }

  // ── Construção da interface visual ───────────────────────────
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    
    // Obtém as listas de posts para as abas.
    final followingPosts = appState.followingFeedPosts;
    final generalPosts   = appState.generalFeedPosts;

    return Scaffold(
      // ── Barra superior (AppBar) ──────────────────────────────
      appBar: AppBar(
        title: const Text('Papacapim'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Seguindo'),
            Tab(text: 'Geral'),
          ],
        ),
        actions: [
          // ── Botão de logout (Mantido no topo) ────────────────
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              appState.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),

      // ── Área de conteúdo (as duas abas) ─────────────────────
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFeed(followingPosts),
          _buildFeed(generalPosts),
        ],
      ),

      // ── Botão para criar novo post ─────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),

      // ── Barra de Navegação Inferior (Mobile Style) ──
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Sempre na Home quando nesta tela
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          } else if (index == 2) {
            if (appState.currentUser != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(userId: appState.currentUser!.id),
                ),
              );
            }
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  // ── Método auxiliar: constrói a lista de posts ───────────────
  Widget _buildFeed(List posts) {
    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets, // Ícone lúdico para remeter a animais/pássaro
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Nada por aqui ainda!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Que tal criar o primeiro post?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostCard(post: posts[index]);
      },
    );
  }
}
