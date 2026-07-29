// ============================================================
// ARQUIVO: widgets/user_tile.dart
// FUNÇÃO: Widget de item de lista para exibir um usuário (ex: na busca).
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../models/user.dart';
import '../providers/app_state.dart';
import '../screens/profile_screen.dart';

// Widget sem estado que exibe os dados do usuário.
class UserTile extends StatelessWidget {
  // Usuário exibido neste tile.
  final User user;

  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    
    // Verifica se é o próprio usuário para ocultar o botão de seguir.
    final isMe = appState.currentUser?.id == user.id;

    // Verifica se já segue este usuário.
    final isFollowing = appState.isFollowing(user.id);

    // Componente de lista padrão do Flutter.
    return ListTile(
      // ── Avatar ───────────────────────────────
      leading: CircleAvatar(
        // Verifica se a imagem é URL da web ou arquivo local.
        backgroundImage: user.profileImage.startsWith('http')
            ? NetworkImage(user.profileImage)
            : FileImage(File(user.profileImage)) as ImageProvider,
      ),

      // ── Nome e username ────────────────────
      title: Text(
        user.name,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        '@${user.username}',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
        ),
      ),

      // ── Botão Seguir/Deixar de Seguir ──
      trailing: !isMe
          ? TextButton(
              onPressed: () {
                appState.toggleFollow(user.id);
              },
              child: Text(isFollowing ? 'Deixar de Seguir' : 'Seguir'),
            )
          : const SizedBox.shrink(),

      // ── Ação de toque (navegar para perfil) ──
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(userId: user.id),
          ),
        );
      },
    );
  }
}
