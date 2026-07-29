// ============================================================
// ARQUIVO: screens/register_screen.dart
// FUNÇÃO: Tela de cadastro de novos usuários.
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

  // ── Função de cadastro ───────────────────────────────────────
  void _register() {
    // ── Validação: as senhas devem ser iguais ─────────────────
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem')),
      );
      return;
    }

    // ── Validação: campos obrigatórios não podem estar vazios ─
    if (_nameController.text.isEmpty || _usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    // Realiza o cadastro.
    final success = Provider.of<AppState>(context, listen: false).register(
      _nameController.text,
      _usernameController.text,
      _passwordController.text,
    );

    if (success) {
      // Sucesso: Vai para o feed e limpa histórico de navegação.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const FeedScreen()),
        (route) => false,
      );
    } else {
      // Erro: Login indisponível.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login já em uso')),
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
              onPressed: _register,
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
