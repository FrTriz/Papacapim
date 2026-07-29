// ============================================================
// ARQUIVO: models/user.dart
// FUNÇÃO: Modelo de dados de um Usuário no app.
// ============================================================

// Classe que define os dados de um usuário.
class User {
  // Identificador único (imutável).
  final String id;

  // Nome de exibição do usuário (mutável).
  String name;

  // Nome de login (username), sem espaços.
  String username;

  // Senha do usuário.
  String password;

  // URL ou caminho local da foto de perfil.
  String profileImage;

  // Número de seguidores.
  int followers;

  // Número de pessoas que o usuário segue.
  int following;

  // ── Construtor ──────────────────────────────────────────────
  // Inicializa um novo usuário com os dados obrigatórios.
  User({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.profileImage,
    required this.followers,
    required this.following,
  });
}
