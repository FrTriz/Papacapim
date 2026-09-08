// ============================================================
// ARQUIVO: widgets/user_tile.dart
// FUNÇÃO: Widget de item de lista para exibir um usuário na busca
//         com botão de seguir/deixar de seguir integrado à API.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final isMe = appState.currentUser?.login == user.login ||
                 appState.currentUser?.id == user.login;

    // Verifica se já segue este usuário.
    final isFollowing = user.youFollow || appState.isFollowing(user.login);

    // Componente de lista padrão do Flutter.
    return ListTile(
      // ── Avatar ───────────────────────────────
      leading: CircleAvatar(
        // Verifica se a imagem é URL da web ou arquivo local.
        backgroundImage: user.avatarProvider,
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

      // ── Botão Seguir/Deixar de Seguir (POST /users/{login}/followers e DELETE /users/{login}/followers/me) ──
      trailing: !isMe
          ? TextButton(
              onPressed: () {
                appState.toggleFollow(user.login);
              },
              child: Text(isFollowing ? 'Deixar de Seguir' : 'Seguir'),
            )
          : const SizedBox.shrink(),

      // ── Ação de toque (navegar para perfil) ──
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(userId: user.login),
          ),
        );
      },
    );
  }
}
