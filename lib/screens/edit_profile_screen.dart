// ============================================================
// ARQUIVO: screens/edit_profile_screen.dart
// FUNÇÃO: Tela para editar os dados do perfil do usuário logado
//         com envio de imagem em Base64 e exclusão de conta via API.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:convert';

import '../providers/app_state.dart';
import 'login_screen.dart';

// StatefulWidget para gerenciar a seleção de nova imagem e atualização de dados.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controladores dos campos de texto.
  final _nameController     = TextEditingController();
  final _passwordController = TextEditingController();

  // Caminho da nova foto selecionada.
  String? _newImagePath;
  Uint8List? _newImageBytes;

  // Estados de carregamento
  bool _isSaving = false;
  bool _isDeleting = false;

  // Instância do image_picker.
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Preenche os campos com os dados atuais.
    final user = Provider.of<AppState>(context, listen: false).currentUser;
    if (user != null) {
      _nameController.text     = user.name;
      _passwordController.text = user.password;
    }
  }

  // ── Função: selecionar imagem (câmera ou galeria) ─────────────
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _newImagePath = pickedFile.path;
          _newImageBytes = bytes;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao selecionar imagem')),
      );
    }
  }

  // ── Função: salvar perfil na API ─────────────────────────────
  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);

    final appState = Provider.of<AppState>(context, listen: false);
    final success = await appState.updateProfile(
      _nameController.text.trim(),
      _passwordController.text,
      _newImagePath,
      base64Image: _newImageBytes != null ? base64Encode(_newImageBytes!) : null,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(appState.lastErrorMessage ?? 'Erro ao atualizar perfil'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // ── Função: confirmar exclusão de conta via API ──────────────
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Conta'),
        content: const Text(
          'Tem certeza que deseja excluir sua conta permanentemente? '
          'Esta ação não pode ser desfeita e todas as suas postagens serão apagadas no servidor.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              setState(() => _isDeleting = true);

              final appState = Provider.of<AppState>(context, listen: false);
              final success = await appState.deleteProfile();

              if (!mounted) return;
              setState(() => _isDeleting = false);

              if (success) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(appState.lastErrorMessage ?? 'Erro ao excluir conta'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ── Construção da interface visual ───────────────────────────
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.currentUser;

    if (user == null) return const Scaffold();

    return Scaffold(
      // ── Barra superior ──────────────────────────────────────
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        actions: [
          _isSaving
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
                  icon: const Icon(Icons.check),
                  onPressed: _saveProfile,
                ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ── Pré-visualização da foto de perfil ─────────────
            CircleAvatar(
              radius: 50,
              backgroundImage: _newImageBytes != null 
                  ? MemoryImage(_newImageBytes!) as ImageProvider
                  : user.avatarProvider,
            ),

            const SizedBox(height: 16),

            // ── Botões para selecionar nova foto (Câmera / Galeria) ──
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Câmera'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galeria'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Campo: Nome ─────────────────────────────────────
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // ── Campo: Nova Senha ────────────────────────────────
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nova Senha',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 48),

            // ── Botão de excluir conta ───────────────────────────
            _isDeleting
                ? const CircularProgressIndicator(color: Colors.red)
                : ElevatedButton(
                    onPressed: _confirmDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Excluir Perfil'),
                  ),
          ],
        ),
      ),
    );
  }
}
