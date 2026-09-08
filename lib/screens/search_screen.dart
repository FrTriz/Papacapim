// ============================================================
// ARQUIVO: screens/search_screen.dart
// FUNÇÃO: Tela de busca em tempo real para usuários e posts
//         consumindo os endpoints GET /users?search= e GET /posts?search=.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../models/user.dart';
import '../models/post.dart';
import '../providers/app_state.dart';
import '../widgets/post_card.dart';
import '../widgets/user_tile.dart';

// Tela de busca com abas integradas à API.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Query de busca atual.
  String _query = '';

  // Resultados retornados pela API
  List<User> _foundUsers = [];
  List<Post> _foundPosts = [];

  // Estado de carregamento
  bool _isLoading = false;

  // Timer para debounce na digitação
  Timer? _debounce;

  // ── Função: executar busca na API ────────────────────────────
  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _query = query;

    if (query.trim().isEmpty) {
      setState(() {
        _foundUsers = [];
        _foundPosts = [];
        _isLoading = false;
      });
      return;
    }

    // Debounce de 400ms para evitar requisições excessivas enquanto digita
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      setState(() => _isLoading = true);

      final appState = Provider.of<AppState>(context, listen: false);
      final usersFuture = appState.searchUsers(query.trim());
      final postsFuture = appState.searchPosts(query.trim());

      final results = await Future.wait([usersFuture, postsFuture]);

      if (!mounted) return;
      setState(() {
        _foundUsers = results[0] as List<User>;
        _foundPosts = results[1] as List<Post>;
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // ── Barra superior com campo de busca ─────────────────
        appBar: AppBar(
          title: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Buscar na rede...',
              border: InputBorder.none,
            ),
            onChanged: _onSearchChanged,
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Usuários'),
              Tab(text: 'Posts'),
            ],
          ),
        ),

        // ── Conteúdo das abas ─────────────────────────────────
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  // Aba "Usuários"
                  _foundUsers.isEmpty && _query.isNotEmpty
                      ? Center(
                          child: Text(
                            'Nenhum usuário encontrado.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                      : _query.isEmpty
                          ? Center(
                              child: Text(
                                'Digite para buscar usuários.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _foundUsers.length,
                              itemBuilder: (context, index) =>
                                  UserTile(user: _foundUsers[index]),
                            ),

                  // Aba "Posts"
                  _foundPosts.isEmpty && _query.isNotEmpty
                      ? Center(
                          child: Text(
                            'Nenhum post encontrado.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                      : _query.isEmpty
                          ? Center(
                              child: Text(
                                'Digite para buscar postagens.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _foundPosts.length,
                              itemBuilder: (context, index) =>
                                  PostCard(post: _foundPosts[index]),
                            ),
                ],
              ),
      ),
    );
  }
}
