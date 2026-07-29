// ============================================================
// ARQUIVO: screens/profile_screen.dart
// FUNÇÃO: Tela de perfil do usuário, exibindo foto, 
//         estatísticas e seus posts.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../providers/app_state.dart';
import '../widgets/post_card.dart';
import 'edit_profile_screen.dart';

// Tela de exibição de perfil do usuário.
class ProfileScreen extends StatelessWidget {
  // ID do usuário exibido nesta tela.
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.getUserById(userId);

    // Identifica o perfil atual para ocultar/mostrar botões específicos.
    final isMe = appState.currentUser?.id == userId;
    final isFollowing = appState.isFollowing(userId);
    final userPosts = appState.getPostsByUser(userId);

    return Scaffold(
      appBar: AppBar(title: Text(user.username)),

      body: Column(
        children: [
          // ── Seção superior: foto e informações ──────
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Foto de perfil
                CircleAvatar(
                  radius: 40,
                  backgroundImage: user.profileImage.startsWith('http')
                      ? NetworkImage(user.profileImage)
                      : FileImage(File(user.profileImage)) as ImageProvider,
                ),

                const SizedBox(width: 24),

                // Estatísticas e Botão de ação
                Expanded(
                  child: Column(
                    children: [
                      // Contadores
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn(context, 'Posts',      userPosts.length),
                          _buildStatColumn(context, 'Seguidores', user.followers),
                          _buildStatColumn(context, 'Seguindo',   user.following),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Botão Editar Perfil ou Seguir
                      isMe
                          ? OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const EditProfileScreen(),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(36),
                              ),
                              child: const Text('Editar Perfil'),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                appState.toggleFollow(userId);
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(36),
                              ),
                              child: Text(isFollowing ? 'Deixar de Seguir' : 'Seguir'),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Nome de exibição ─────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                user.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),

          const Divider(),

          // ── Lista de posts do usuário ────────────────────────
          Expanded(
            child: userPosts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.eco,
                          size: 60,
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum post ainda!',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: userPosts.length,
                    itemBuilder: (context, index) => PostCard(post: userPosts[index]),
                  ),
          ),
        ],
      ),
    );
  }

  // ── Método auxiliar: coluna de estatística ───────────────────
  Column _buildStatColumn(BuildContext context, String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          label, 
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
