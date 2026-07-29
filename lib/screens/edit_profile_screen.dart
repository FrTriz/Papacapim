// ============================================================
// ARQUIVO: screens/edit_profile_screen.dart
// FUNÇÃO: Tela para editar os dados do perfil do usuário logado.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../providers/app_state.dart';
import 'login_screen.dart';

// StatefulWidget para gerenciar a seleção de nova imagem.
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

  // ── Função: selecionar imagem ────────────────────────────────
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _newImagePath = pickedFile.path;
      });
    }
  }

  // ── Função: salvar perfil ────────────────────────────────────
  void _saveProfile() {
    Provider.of<AppState>(context, listen: false).updateProfile(
      _nameController.text,
      _passwordController.text,
      _newImagePath,
    );
    Navigator.pop(context);
  }

  // ── Função: confirmar exclusão de conta ──────────────────────
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Conta'),
        content: const Text(
          'Tem certeza que deseja excluir sua conta permanentemente? '
          'Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<AppState>(context, listen: false).deleteProfile();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
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

    // Define qual imagem mostrar (nova ou atual).
    String currentImage = _newImagePath ?? user.profileImage;

    return Scaffold(
      // ── Barra superior ──────────────────────────────────────
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        actions: [
          IconButton(
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
              backgroundImage: currentImage.startsWith('http')
                  ? NetworkImage(currentImage)
                  : FileImage(File(currentImage)) as ImageProvider,
            ),

            const SizedBox(height: 16),

            // ── Botões para selecionar nova foto ─────────────
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
            ElevatedButton(
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
