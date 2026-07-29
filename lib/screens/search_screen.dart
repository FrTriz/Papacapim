// ============================================================
// ARQUIVO: screens/search_screen.dart
// FUNÇÃO: Tela de busca em tempo real para usuários e posts.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/post_card.dart';
import '../widgets/user_tile.dart';

// Tela de busca com abas.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Query de busca atual.
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    // ── Filtragem de usuários ─────────────────────────────────
    final filteredUsers = appState.users.where(
      (u) => u.username.toLowerCase().contains(_query.toLowerCase()),
    ).toList();

    // ── Filtragem de posts ────────────────────────────────────
    final filteredPosts = appState.posts.where(
      (p) => p.content.toLowerCase().contains(_query.toLowerCase()),
    ).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // ── Barra superior com campo de busca ─────────────────
        appBar: AppBar(
          title: TextField(
            decoration: const InputDecoration(
              hintText: 'Buscar...',
            ),
            onChanged: (val) {
              setState(() {
                _query = val;
              });
            },
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Usuários'),
              Tab(text: 'Posts'),
            ],
          ),
        ),

        // ── Conteúdo das abas ─────────────────────────────────
        body: TabBarView(
          children: [
            // Aba "Usuários"
            filteredUsers.isEmpty && _query.isNotEmpty
                ? Center(
                    child: Text('Nenhum usuário encontrado.',
                        style: Theme.of(context).textTheme.bodyLarge),
                  )
                : ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) => UserTile(user: filteredUsers[index]),
                  ),

            // Aba "Posts"
            filteredPosts.isEmpty && _query.isNotEmpty
                ? Center(
                    child: Text('Nenhum post encontrado.',
                        style: Theme.of(context).textTheme.bodyLarge),
                  )
                : ListView.builder(
                    itemCount: filteredPosts.length,
                    itemBuilder: (context, index) => PostCard(post: filteredPosts[index]),
                  ),
          ],
        ),
      ),
    );
  }
}
