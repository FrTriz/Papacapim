// ============================================================
// ARQUIVO: screens/post_detail_screen.dart
// FUNÇÃO: Tela de detalhes de um post exibindo respostas via API.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../providers/app_state.dart';
import '../widgets/post_card.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  List<Post> _replies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReplies();
  }

  // ── Busca as respostas ao post na API (GET /posts/{id}/replies) ──
  Future<void> _loadReplies() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final replies = await appState.fetchPostReplies(widget.postId);

    if (!mounted) return;
    setState(() {
      _replies = replies;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final post = appState.getPostById(widget.postId);

    if (post == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Post')),
        body: const Center(child: Text('Post não encontrado.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadReplies,
        child: Column(
          children: [
            PostCard(post: post),
            const Divider(),
            _isLoading
                ? const Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: _replies.isNotEmpty
                        ? ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: _replies.length,
                            itemBuilder: (context, index) {
                              return PostCard(post: _replies[index]);
                            },
                          )
                        : ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(height: 60),
                              Center(child: Text('Nenhuma resposta ainda.')),
                            ],
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
