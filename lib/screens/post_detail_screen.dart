import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/post_card.dart';

class PostDetailScreen extends StatelessWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final post = appState.getPostById(postId);

    if (post == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Post')),
        body: const Center(child: Text('Post não encontrado.')),
      );
    }

    // Buscando as respostas a este post
    final replies = appState.posts.where((p) => p.parentPostId == postId).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: Column(
        children: [
          PostCard(post: post),
          const Divider(),
          if (replies.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: replies.length,
                itemBuilder: (context, index) {
                  return PostCard(post: replies[index]);
                },
              ),
            )
          else
            const Expanded(
              child: Center(child: Text('Nenhuma resposta ainda.')),
            ),
        ],
      ),
    );
  }
}
