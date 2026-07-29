// ============================================================
// ARQUIVO: widgets/post_card.dart
// FUNÇÃO: Widget de exibição de um post no feed.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../models/post.dart';
import '../models/user.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../screens/profile_screen.dart';
import '../screens/create_post_screen.dart';
import '../screens/post_detail_screen.dart';

// Widget sem estado para exibir os dados de um post.
class PostCard extends StatelessWidget {
  // Post a ser exibido.
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    
    // Obtém dados do autor e verifica o estado do post.
    final user    = appState.getUserById(post.userId);
    final isMe    = appState.currentUser?.id == post.userId;
    final isLiked = appState.isLiked(post.id);

    // Cartão macio para cada post (sem margens laterais no feed dá mais cara de mobile)
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Cabeçalho do post ──
            Row(
              children: [
                // Avatar (navega para o perfil ao tocar)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(userId: user.id),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: user.profileImage.startsWith('http')
                        ? NetworkImage(user.profileImage)
                        : FileImage(File(user.profileImage)) as ImageProvider,
                  ),
                ),

                const SizedBox(width: 12),

                // Nome e @username do autor
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '@${user.username}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                        ),
                      ),
                      // Indica se é uma resposta a outro post
                      if (post.parentPostId != null)
                        Builder(
                          builder: (context) {
                            final parentPost = appState.getPostById(post.parentPostId!);
                            String? repliedToUsername;
                            if (parentPost != null) {
                              try {
                                repliedToUsername = appState.getUserById(parentPost.userId).username;
                              } catch (e) {
                                // Usuário não encontrado
                              }
                            }
                            if (repliedToUsername != null) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PostDetailScreen(postId: parentPost!.id),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Em resposta a @$repliedToUsername',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }
                        ),
                    ],
                  ),
                ),

                // Botão de deletar (apenas para o próprio autor)
                if (isMe)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppTheme.softCoral),
                    onPressed: () {
                      appState.deletePost(post.id);
                    },
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Texto do post
            Text(
              post.content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 12),

            // ── Interações (Curtir e Responder) ──
            Row(
              children: [
                // Botão de curtir
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? AppTheme.softCoral : Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    appState.toggleLike(post.id);
                  },
                ),
                Text('${post.likes}'),

                const SizedBox(width: 16),

                // Botão de responder
                IconButton(
                  icon: Icon(Icons.chat_bubble_outline, color: Theme.of(context).colorScheme.primary),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreatePostScreen(parentPostId: post.id),
                      ),
                    );
                  },
                ),

                Text(
                  'Responder',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
