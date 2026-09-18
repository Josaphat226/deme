import 'package:flutter/material.dart';

/// Couleurs officielles de la charte graphique DƐMƐ.
/// Centralisées ici pour garantir la cohérence dans toute l'app.
class AppColors {
  AppColors._(); // Empêche l'instanciation

  // === Couleurs de marque ===
  static const Color orangePrincipal = Color(0xFFFF8A00);   // Actions principales
  static const Color orangeSecondaire = Color(0xFFFFC107);  // Dégradés, décorations
  static const Color bleuNuit = Color(0xFF0A1F35);          // Logo, titres forts

  // === Couleurs fonctionnelles ===
  static const Color textePrincipal = Color(0xFF111827);    // Titres, contenu
  static const Color texteSecondaire = Color(0xFF687280);   // Légendes, labels
  static const Color fond = Color(0xFFF8FAFC);              // Fond général

  // === Couleurs d'état ===
  static const Color alerte = Color(0xFFDC2626);            // Rupture, erreurs
  static const Color avertissement = Color(0xFFF59E0B);     // Stock faible
  static const Color succes = Color(0xFF059669);            // Vente OK, sync OK
}