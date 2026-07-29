// ============================================================
// ARQUIVO: providers/app_state.dart
// FUNÇÃO: Gerencia o estado global do aplicativo, armazenando
//         dados (usuários, posts, sessão) e fornecendo métodos
//         para manipulá-los. Notifica as telas sobre mudanças.
// ============================================================

// Importa o ChangeNotifier e modelos de dados.
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../models/post.dart';

// Importa os dados fictícios que simulam o banco de dados.
import '../mock_data/mocks.dart';

// ── Classe AppState ───────────────────────────────────────────
// Herda ChangeNotifier para notificar telas sobre mudanças.
class AppState extends ChangeNotifier {
  // ── Dados centrais do app ─────────────────────────────────────
  // Cópias locais dos dados mockados.
  List<User> users = List.from(mockUsers);

  // Lista de posts do aplicativo.
  List<Post> posts = List.from(mockPosts);

  // Usuário autenticado no momento (null se deslogado).
  User? currentUser;

  // ============================================================
  // SEÇÃO: AUTENTICAÇÃO (Login, Logout, Cadastro)
  // ============================================================

  // ── Login ─────────────────────────────────────────────────────
  // Tenta autenticar o usuário com as credenciais informadas.
  // Retorna true em caso de sucesso.
  bool login(String username, String password) {
    try {
      // Busca usuário correspondente ou lança exceção.
      final user = users.firstWhere(
        (u) => u.username == username && u.password == password,
      );
      currentUser = user;
      notifyListeners();
      return true; // Sucesso
    } catch (e) {
      return false; // Usuário não encontrado ou senha errada
    }
  }

  // ── Logout ────────────────────────────────────────────────────
  // Encerra a sessão atual.
  void logout() {
    currentUser = null;
    notifyListeners();
  }

  // ── Cadastro ──────────────────────────────────────────────────
  // Registra um novo usuário no sistema. Retorna false se o username já existir.
  bool register(String name, String username, String password) {
    // Verifica se o username já está em uso.
    if (users.any((u) => u.username == username)) {
      return false;
    }

    // Cria e insere o novo usuário.
    final newUser = User(
      id: 'u${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      username: username,
      password: password,
      // Avatar gerado a partir do nome.
      profileImage: 'https://ui-avatars.com/api/?name=${name.replaceAll(' ', '+')}&background=random',
      followers: 0,
      following: 0,
    );

    users.add(newUser);
    currentUser = newUser; // Autentica automaticamente
    notifyListeners();
    return true;
  }

  // ============================================================
  // SEÇÃO: OPERAÇÕES DE POST (Criar, Deletar, Curtir)
  // ============================================================

  // ── Criar post ────────────────────────────────────────────────
  // Cria uma nova publicação para o usuário atual.
  // "parentPostId" é opcional: se fornecido, o post é uma resposta
  // a outro post. O "{}" em torno do parâmetro indica que ele é nomeado
  // e opcional.
  void createPost(String content, {String? parentPostId}) {
    // Segurança: não faz nada se ninguém estiver logado.
    if (currentUser == null) return;

    // Monta o objeto Post com os dados da nova publicação.
    final newPost = Post(
      // ID único gerado com o timestamp atual (mesmo truque do cadastro).
      id: 'p${DateTime.now().millisecondsSinceEpoch}',
      userId: currentUser!.id, // "!" indica que temos certeza que não é null aqui
      content: content,
      likes: 0,               // Post novo começa com 0 curtidas
      createdAt: DateTime.now(),
      parentPostId: parentPostId, // null se for post normal; ID do pai se for resposta
    );

    // Insere no INÍCIO da lista (índice 0) para que o post mais novo
    // apareça primeiro no feed — como em redes sociais reais.
    posts.insert(0, newPost);

    notifyListeners(); // Atualiza a tela do feed
  }

  // ── Deletar post ──────────────────────────────────────────────
  // Remove um post da lista através do seu ID.
  void deletePost(String postId) {
    posts.removeWhere((p) => p.id == postId);
    notifyListeners();
  }

  // ── Curtidas ──────────────────────────────────────────────────
  // Conjunto de IDs dos posts curtidos pelo usuário atual.
  Set<String> likedPostIds = {};

  // Alterna a curtida de um post.
  void toggleLike(String postId) {
    final post = posts.firstWhere((p) => p.id == postId);

    if (likedPostIds.contains(postId)) {
      likedPostIds.remove(postId);
      post.likes--;
    } else {
      likedPostIds.add(postId);
      post.likes++;
    }

    notifyListeners();
  }

  // Verifica se o usuário atual curtiu o post.
  bool isLiked(String postId) {
    return likedPostIds.contains(postId);
  }

  // ============================================================
  // SEÇÃO: OPERAÇÕES DE USUÁRIO (Seguir, Editar, Deletar)
  // ============================================================

  // IDs dos usuários que o currentUser está seguindo.
  Set<String> followingUserIds = {'u2', 'u3', 'u4'};

  // ── Seguir / Deixar de seguir ─────────────────────────────────
  // Alterna o status de seguir um usuário.
  void toggleFollow(String targetUserId) {
    if (currentUser == null) return;

    final target = users.firstWhere((u) => u.id == targetUserId);

    if (followingUserIds.contains(targetUserId)) {
      followingUserIds.remove(targetUserId);
      if (target.followers > 0) target.followers--;
      if (currentUser!.following > 0) currentUser!.following--;
    } else {
      followingUserIds.add(targetUserId);
      target.followers++;
      currentUser!.following++;
    }

    notifyListeners();
  }

  // Verifica se o usuário atual segue determinado usuário.
  bool isFollowing(String userId) {
    return followingUserIds.contains(userId);
  }

  // ── Editar perfil ─────────────────────────────────────────────
  // Atualiza os dados do perfil do usuário logado.
  void updateProfile(String name, String password, String? imagePath) {
    if (currentUser == null) return;

    currentUser!.name = name;
    currentUser!.password = password;

    if (imagePath != null) {
      currentUser!.profileImage = imagePath;
    }

    notifyListeners();
  }

  // ── Excluir conta ─────────────────────────────────────────────
  // Remove permanentemente o usuário atual e seus posts.
  void deleteProfile() {
    if (currentUser == null) return;

    users.removeWhere((u) => u.id == currentUser!.id);
    posts.removeWhere((p) => p.userId == currentUser!.id);

    currentUser = null;
    notifyListeners();
  }

  // ============================================================
  // SEÇÃO: CONSULTAS (Getters)
  // ============================================================

  // ── Feed Geral ────────────────────────────────────────────────
  // Retorna todos os posts.
  List<Post> get generalFeedPosts {
    return posts.toList();
  }

  // ── Feed "Seguindo" ───────────────────────────────────────────
  // Retorna posts dos usuários seguidos e do próprio usuário.
  List<Post> get followingFeedPosts {
    if (currentUser == null) return [];

    return posts.where((p) =>
      followingUserIds.contains(p.userId) || p.userId == currentUser!.id
    ).toList();
  }

  // ── Posts por usuário ─────────────────────────────────────────
  // Retorna todos os posts de um usuário específico.
  List<Post> getPostsByUser(String userId) {
    return posts.where((p) => p.userId == userId).toList();
  }

  // ── Buscar post por ID ─────────────────────────────────────
  // Retorna um post pelo seu ID ou null se não encontrado.
  Post? getPostById(String id) {
    try {
      return posts.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // ── Buscar usuário por ID ─────────────────────────────────────
  // Retorna um usuário pelo seu ID.
  User getUserById(String id) {
    return users.firstWhere((u) => u.id == id);
  }
}
