import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ============================================================
// ARQUIVO: theme/app_theme.dart
// FUNÇÃO: Define o Design System e paleta de cores do app.
// ============================================================

class AppTheme {
  // ── Paleta de Cores ─────────────────────────────────────────
  
  // Amarelo Pastel: Suave e agradável, usado em fundos e bordas.
  static const Color pastelYellow = Color(0xFFFFF59D); 
  
  // Roxo Marcante: Alto contraste, usado em botões, ícones ativos e detalhes.
  static const Color strikingPurple = Color(0xFF7B1FA2); 
  
  // Cores de superfície mais orgânicas (sem branco puro)
  static const Color scaffoldBackground = Color(0xFFF9F8F6); // Cinza quente muito suave
  static const Color cardBackground = Color(0xFFF2EFE9);     // Creme/areia bem claro
  
  // Cor para alertas/curtidas (vermelho/coral bem suave, sem ser neon)
  static const Color softCoral = Color(0xFFE5A0A0);
  
  // Cores de texto
  static const Color inkDark = Color(0xFF2B2B2B);
  static const Color inkLight = Color(0xFF757575);

  // ── Tema Global (ThemeData) ─────────────────────────────────
  static ThemeData get theme {
    // Configura as fontes base
    final baseTextTheme = GoogleFonts.nunitoTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: pastelYellow,
        primary: strikingPurple,
        secondary: pastelYellow,
        background: scaffoldBackground,
        surface: cardBackground,
      ),
      scaffoldBackgroundColor: scaffoldBackground,

      // ── Tipografia ──────────────────────────────────────────
      textTheme: baseTextTheme.copyWith(
        titleLarge: GoogleFonts.baloo2(
          textStyle: baseTextTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: strikingPurple,
          ),
        ),
        titleMedium: GoogleFonts.baloo2(
          textStyle: baseTextTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: inkDark,
          ),
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(color: inkDark),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: inkDark),
      ),

      // ── AppBar ──────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        foregroundColor: strikingPurple,
        elevation: 0.5, // Leve sombra típica de mobile
        shadowColor: Colors.black12,
        centerTitle: true,
        titleTextStyle: GoogleFonts.baloo2(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: strikingPurple,
        ),
      ),

      // ── Cartões (Cards) ─────────────────────────────────────
      // Estilo de app mobile: ocupando a tela ou com margens sutis e cor de fundo macia.
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 8), // Separação vertical apenas
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // ── Botões (ElevatedButton) ─────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: strikingPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24), // Cantos bem arredondados
          ),
        ),
      ),

      // ── Botões com Borda (OutlinedButton) ───────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: strikingPurple,
          side: const BorderSide(color: strikingPurple, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),

      // ── Botões Flutuantes (FAB) ─────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: strikingPurple,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // ── Campos de Texto (TextField) ─────────────────────────
      // Inputs suaves, sem bordas agressivas, muito comum em mobile moderno.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: strikingPurple, width: 1.5),
        ),
        labelStyle: const TextStyle(color: strikingPurple),
        prefixIconColor: strikingPurple,
      ),

      // ── Divisores ───────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: cardBackground,
        thickness: 1,
        space: 1,
      ),

      // ── Tabs ────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: strikingPurple,
        unselectedLabelColor: inkLight,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: strikingPurple, width: 3),
        ),
        labelStyle: GoogleFonts.nunito(fontWeight: FontWeight.bold),
      ),
    );
  }
}
