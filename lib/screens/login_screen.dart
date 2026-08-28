// ============================================================
// ARQUIVO: screens/login_screen.dart
// FUNÇÃO: Tela inicial de autenticação do usuário com a API.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';
import 'register_screen.dart';
import 'feed_screen.dart';

// Tela de login com controle de estado para formulário.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores dos campos de texto.
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Estado de carregamento da requisição
  bool _isLoading = false;

  // ── Função de login ─────────────────────────────────────────
  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha o login e a senha')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final appState = Provider.of<AppState>(context, listen: false);
    final success = await appState.login(username, password);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      // Sucesso: Vai para a tela do feed (substituindo a de login).
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FeedScreen()),
      );
    } else {
      // Erro: Exibe mensagem amigável de falha retornada pela API.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(appState.lastErrorMessage ?? 'Login ou senha incorretos'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // ── Construção da interface visual ───────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Ícone Divertido ─────────────────────────────────
              Icon(
                Icons.flutter_dash, // O Dash lembra um passarinho (papa-capim)
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),

              // ── Título do app ──────────────────────────────────
              Text(
                'Papacapim',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 40,
                ),
              ),

              const SizedBox(height: 48),

              // ── Campo de login ─────────────────────────────────
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Login',
                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 16),

              // ── Campo de senha ─────────────────────────────────
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),

              const SizedBox(height: 24),

              // ── Botão Entrar ───────────────────────────────────
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Entrar'),
              ),

              const SizedBox(height: 16),

              // ── Link para cadastro ─────────────────────────────
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text('Não tem conta? Cadastre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
