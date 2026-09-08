// ============================================================
// ARQUIVO: models/user.dart
// FUNÇÃO: Modelo de dados de um Usuário no app integrado à API.
// ============================================================

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

// Classe que define os dados de um usuário.
class User {
  // Login identificador único na API (imutável).
  final String login;

  // Nome de exibição do usuário (mutável).
  String name;

  // Senha do usuário (utilizada localmente em formulários).
  String password;

  // URL da foto de perfil.
  String profileImage;

  // Número de seguidores.
  int followers;

  // Número de pessoas que o usuário segue.
  int following;

  // Indica se o usuário logado segue este perfil.
  bool youFollow;

  // Indica se este perfil segue o usuário logado.
  bool followsYou;

  // ── Getters de compatibilidade com a Parte 1 ────────────────
  // Permitem que todo o código e widgets anteriores continuem funcionando sem quebras.
  String get id => login;
  String get username => login;

  // Fornece um ImageProvider seguro baseado no conteúdo de profileImage
  dynamic get avatarProvider {
    if (profileImage.startsWith('data:image')) {
      try {
        final parts = profileImage.split(',');
        if (parts.length > 1) {
          return MemoryImage(base64Decode(parts[1]));
        }
      } catch (_) {}
    }
    if (profileImage.startsWith('http')) {
      return NetworkImage(profileImage);
    }
    // Fallback para arquivo local se for path do dispositivo (não web)
    return FileImage(File(profileImage));
  }

  // ── Construtor ──────────────────────────────────────────────
  User({
    String? login,
    required this.name,
    this.password = '',
    required this.profileImage,
    this.followers = 0,
    this.following = 0,
    this.youFollow = false,
    this.followsYou = false,
    String? id,
    String? username,
  }) : login = login ?? username ?? id ?? '';

  // ── Construtor a partir do JSON retornado pela API ───────────
  factory User.fromJson(Map<String, dynamic> json) {
    final rawLogin = json['login']?.toString() ?? json['user_login']?.toString() ?? '';
    final rawName = json['name']?.toString() ?? rawLogin;
    final rawImage = json['profile_image']?.toString();

    // Fallback de imagem caso o usuário ainda não possua foto cadastrada na API
    String safeImage = 'https://ui-avatars.com/api/?name=${rawName.replaceAll(' ', '+')}&background=random&format=png';
    
    if (rawImage != null && rawImage.isNotEmpty) {
      if (rawImage.startsWith('http') || rawImage.startsWith('data:')) {
        safeImage = rawImage;
        if (safeImage.contains('ui-avatars.com') && !safeImage.contains('format=png')) {
          safeImage += '&format=png';
        }
      } else {
        // Assume que a API retornou a string base64 pura
        safeImage = 'data:image/png;base64,$rawImage';
      }
    }

    return User(
      login: rawLogin,
      name: rawName,
      profileImage: safeImage,
      followers: (json['followers_number'] as num?)?.toInt() ?? 0,
      following: (json['following_number'] as num?)?.toInt() ?? 0,
      youFollow: json['you_follow'] == true,
      followsYou: json['follows_you'] == true,
    );
  }

  // ── Conversão do modelo para JSON ───────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'name': name,
      'profile_image': profileImage,
      'followers_number': followers,
      'following_number': following,
      'you_follow': youFollow,
      'follows_you': followsYou,
    };
  }
}
