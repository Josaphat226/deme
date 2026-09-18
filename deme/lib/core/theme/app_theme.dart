import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Thème global de l'application DƐMƐ.
/// Définit les couleurs, polices et styles par défaut.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      // Fond général de l'application
      scaffoldBackgroundColor: AppColors.fond,

      // Couleur principale (boutons, accents)
      primaryColor: AppColors.orangePrincipal,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.orangePrincipal,
        primary: AppColors.orangePrincipal,
      ),

      // === Typographie ===
      textTheme: const TextTheme(
        // Montants importants (dashboard, totaux) — Quicksand Bold 26-30px
        headlineLarge: TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: AppColors.textePrincipal,
        ),
        // Titres d'écran — Quicksand Bold 18-20px
        titleLarge: TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColors.textePrincipal,
        ),
        // Titres de cartes/sections — Roboto Medium 15-16px
        titleMedium: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: AppColors.textePrincipal,
        ),
        // Texte courant — Roboto Regular 13-14px
        bodyMedium: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: AppColors.textePrincipal,
        ),
        // Textes secondaires / légendes — Roboto Regular 11-12px
        bodySmall: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.normal,
          fontSize: 12,
          color: AppColors.texteSecondaire,
        ),
      ),

      // === AppBar ===
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.fond,
        foregroundColor: AppColors.textePrincipal,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColors.bleuNuit,
        ),
      ),

      // === Boutons primaires (orange) ===
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orangePrincipal,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),

      // === Boutons secondaires ===
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.bleuNuit,
          side: const BorderSide(color: AppColors.bleuNuit, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      // === Champs de saisie ===
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.orangePrincipal, width: 2),
        ),
      ),

      // === Cartes ===
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}