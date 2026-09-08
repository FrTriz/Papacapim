// ============================================================
// ARQUIVO: screens/register_screen.dart
// FUNÇÃO: Tela de cadastro de novos usuários integrada à API.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'feed_screen.dart';

// Tela de registro com validação de formulário.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores dos campos de texto.
  final _nameController            = TextEditingController();
  final _usernameController        = TextEditingController();
  final _passwordController        = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Estado de carregamento da requisição
  bool _isLoading = false;

  // ── Função de cadastro ───────────────────────────────────────
  Future<void> _register() async {
    // ── Validação: as senhas devem ser iguais ─────────────────
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem')),
      );
      return;
    }

    // ── Validação: campos obrigatórios não podem estar vazios ─
    if (_nameController.text.trim().isEmpty ||
        _usernameController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Realiza o cadastro e login na API.
    final appState = Provider.of<AppState>(context, listen: false);
    final success = await appState.register(
      _nameController.text.trim(),
      _usernameController.text.trim(),
      _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      // Sucesso: Vai para o feed e limpa histórico de navegação.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const FeedScreen()),
        (route) => false,
      );
    } else {
      // Erro: Exibe mensagem retornada pelo servidor (ex: login já em uso).
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(appState.lastErrorMessage ?? 'Falha ao cadastrar. Tente outro login.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // ── Construção da interface visual ───────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Campo: Nome completo ─────────────────────────────
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
            ),

            const SizedBox(height: 16),

            // ── Campo: Login (username) ──────────────────────────
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Login',
              ),
            ),

            const SizedBox(height: 16),

            // ── Campo: Senha ─────────────────────────────────────
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
              ),
            ),

            const SizedBox(height: 16),

            // ── Campo: Confirmação de senha ──────────────────────
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmação de Senha',
              ),
            ),

            const SizedBox(height: 24),

            // ── Botão Cadastrar ──────────────────────────────────
            ElevatedButton(
              onPressed: _isLoading ? null : _register,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
