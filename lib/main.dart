// ============================================================
// ARQUIVO: main.dart
// FUNÇÃO: Ponto de entrada do aplicativo Flutter.
// ============================================================

// Importa os componentes visuais do Flutter.
import 'package:flutter/material.dart';

// Pacote "provider" para compartilhamento de estado entre telas.
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
// Importa o AppState, responsável pela lógica e dados do app.
import 'providers/app_state.dart';

// Importa a tela inicial de login.
import 'screens/login_screen.dart';

// ── Função principal ──────────────────────────────────────────
// Ponto de partida do aplicativo.
void main() {
  // Inicializa o app e provê o AppState para todas as telas.
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const PapacapimApp(),
    ),
  );
}

// ── Widget raiz do aplicativo ─────────────────────────────────
// Configuração global do app sem estado próprio.
class PapacapimApp extends StatelessWidget {
  const PapacapimApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp configura o título, tema e tela inicial.
    return MaterialApp(
      title: 'Papacapim',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const LoginScreen(),
    );
  }
}
