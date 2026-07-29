// ============================================================
// ARQUIVO: screens/create_post_screen.dart
// FUNÇÃO: Tela para criar uma publicação ou responder a um post.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

// StatefulWidget para gerenciar o estado do campo de texto.
class CreatePostScreen extends StatefulWidget {
  // ID do post original (se for uma resposta).
  final String? parentPostId;

  const CreatePostScreen({super.key, this.parentPostId});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // Controlador do campo de texto.
  final _contentController = TextEditingController();

  // ── Função: publicar post ────────────────────────────────────
  void _submit() {
    if (_contentController.text.trim().isEmpty) return;

    Provider.of<AppState>(context, listen: false).createPost(
      _contentController.text,
      parentPostId: widget.parentPostId,
    );

    Navigator.pop(context);
  }

  // ── Construção da interface visual ───────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── Barra superior ──────────────────────────────────────
      appBar: AppBar(
        title: Text(widget.parentPostId == null ? 'Nova Postagem' : 'Responder Post'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _submit,
          ),
        ],
      ),

      // ── Corpo da tela: campo de texto ────────────────────────
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _contentController,
          maxLines: 10,
          decoration: const InputDecoration(
            hintText: 'O que está acontecendo?',
          ),
        ),
      ),
    );
  }
}
