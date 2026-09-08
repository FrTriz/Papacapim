// ============================================================
// ARQUIVO: screens/create_post_screen.dart
// FUNÇÃO: Tela para criar uma publicação ou responder a um post
//         enviando para a API (POST /posts ou POST /posts/{id}/replies).
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

// StatefulWidget para gerenciar o estado do campo de texto e envio à API.
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

  // Estado de envio
  bool _isLoading = false;

  // ── Função: publicar post ou resposta na API ─────────────────
  Future<void> _submit() async {
    final text = _contentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isLoading = true);

    final appState = Provider.of<AppState>(context, listen: false);
    final success = await appState.createPost(
      text,
      parentPostId: widget.parentPostId,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(appState.lastErrorMessage ?? 'Falha ao enviar postagem'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // ── Construção da interface visual ───────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── Barra superior ──────────────────────────────────────
      appBar: AppBar(
        title: Text(widget.parentPostId == null ? 'Nova Postagem' : 'Responder Post'),
        actions: [
          _isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : IconButton(
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
          autofocus: true,
          decoration: InputDecoration(
            hintText: widget.parentPostId == null
                ? 'O que está acontecendo?'
                : 'Escreva sua resposta...',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
