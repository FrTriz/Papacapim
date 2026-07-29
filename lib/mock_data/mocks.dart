// ============================================================
// ARQUIVO: mock_data/mocks.dart
// FUNÇÃO: Dados fictícios (mocks) para simular um banco de
//         dados real durante o desenvolvimento do app.
// ============================================================

// Importa os modelos para poder criar objetos do tipo User e Post.
import '../models/user.dart';
import '../models/post.dart';

// ── Lista de usuários fictícios ───────────────────────────────
// Lista imutável (final) contendo objetos do tipo User.
final List<User> mockUsers = [
  // Criação dos usuários. A imagem de perfil é gerada automaticamente
  // pela API "ui-avatars.com" usando as iniciais do nome.
  User(id: 'u1', name: 'Beatriz Silva',  username: 'beatriz',   password: '123', profileImage: 'https://ui-avatars.com/api/?name=Beatriz+Silva&background=random',  followers: 150,  following: 30),
  User(id: 'u2', name: 'João Souza',     username: 'joaosouza', password: '123', profileImage: 'https://ui-avatars.com/api/?name=Joao+Souza&background=random',     followers: 200,  following: 100),
  User(id: 'u3', name: 'Maria Pereira',  username: 'mariap',    password: '123', profileImage: 'https://ui-avatars.com/api/?name=Maria+Pereira&background=random',  followers: 50,   following: 10),
  User(id: 'u4', name: 'Carlos Santos',  username: 'carlos_s',  password: '123', profileImage: 'https://ui-avatars.com/api/?name=Carlos+Santos&background=random',  followers: 300,  following: 400),
  User(id: 'u5', name: 'Ana Costa',      username: 'anacosta',  password: '123', profileImage: 'https://ui-avatars.com/api/?name=Ana+Costa&background=random',      followers: 1000, following: 5),
];

// ── Lista de posts fictícios ──────────────────────────────────
// Cada post referencia um autor pelo "userId".
// As datas simulam posts antigos subtraindo horas do momento atual.
final List<Post> mockPosts = [
  Post(id: 'p1',  userId: 'u2', content: 'Meu primeiro post no Papacapim! 🎉',            likes: 12,  createdAt: DateTime.now().subtract(const Duration(hours: 1))),
  Post(id: 'p2',  userId: 'u3', content: 'Hoje o dia está lindo! ☀️',                     likes: 5,   createdAt: DateTime.now().subtract(const Duration(hours: 2))),
  Post(id: 'p3',  userId: 'u4', content: 'Alguém recomenda um bom livro de Flutter?',     likes: 20,  createdAt: DateTime.now().subtract(const Duration(hours: 3))),
  Post(id: 'p4',  userId: 'u5', content: 'Acabei de lançar meu novo app!',                likes: 150, createdAt: DateTime.now().subtract(const Duration(hours: 4))),
  Post(id: 'p5',  userId: 'u1', content: 'Aprendendo provider e image_picker.',           likes: 8,   createdAt: DateTime.now().subtract(const Duration(hours: 5))),
  Post(id: 'p6',  userId: 'u2', content: 'Bora codar galera 💻',                          likes: 30,  createdAt: DateTime.now().subtract(const Duration(hours: 6))),
  Post(id: 'p7',  userId: 'u3', content: 'Café + Código = Felicidade ☕',                 likes: 45,  createdAt: DateTime.now().subtract(const Duration(hours: 7))),
  Post(id: 'p8',  userId: 'u4', content: 'A documentação do Flutter é muito boa.',        likes: 60,  createdAt: DateTime.now().subtract(const Duration(hours: 8))),
  Post(id: 'p9',  userId: 'u5', content: 'Sextou!',                                       likes: 200, createdAt: DateTime.now().subtract(const Duration(hours: 9))),
  Post(id: 'p10', userId: 'u1', content: 'Terminando o projeto acadêmico hoje 🚀',        likes: 25,  createdAt: DateTime.now().subtract(const Duration(hours: 10))),
  Post(id: 'p11', userId: 'u2', content: 'Que calor! 🥵',                                 likes: 10,  createdAt: DateTime.now().subtract(const Duration(hours: 11))),
  Post(id: 'p12', userId: 'u3', content: 'Assistindo uma série muito boa agora.',         likes: 15,  createdAt: DateTime.now().subtract(const Duration(hours: 12))),
  Post(id: 'p13', userId: 'u4', content: 'Mais um bug resolvido! 🐛',                     likes: 40,  createdAt: DateTime.now().subtract(const Duration(hours: 13))),
  Post(id: 'p14', userId: 'u5', content: 'Bom dia papacapinzada!',                        likes: 120, createdAt: DateTime.now().subtract(const Duration(hours: 14))),
  Post(id: 'p15', userId: 'u1', content: 'O design dessa rede está ficando show!',        likes: 35,  createdAt: DateTime.now().subtract(const Duration(hours: 15))),
];
