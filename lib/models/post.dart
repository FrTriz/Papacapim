// ============================================================
// ARQUIVO: models/post.dart
// FUNÇÃO: Modelo de dados de uma publicação no app.
// ============================================================

class Post {
  // Identificador único do post (imutável).
  final String id;

  // ID do usuário autor da postagem.
  final String userId;

  // Texto da publicação.
  final String content;

  // Quantidade de curtidas (mutável).
  int likes;

  // Data e hora de criação do post.
  final DateTime createdAt;

  // ID do post original, caso esta publicação seja uma resposta.
  final String? parentPostId;

  // ── Construtor ──────────────────────────────────────────────
  // Inicializa o Post. parentPostId é opcional.
  Post({
    required this.id,
    required this.userId,
    required this.content,
    required this.likes,
    required this.createdAt,
    this.parentPostId,
  });
}
