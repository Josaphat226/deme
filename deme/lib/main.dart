import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

void main() async {
  // 1. Initialise les bindings Flutter.
  // C'est OBLIGATOIRE avant d'appeler toute fonction asynchrone (comme Supabase)
  // avant le lancement de l'application.
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Force l'orientation en mode portrait.
  // Pour une application de gestion commerciale mobile, c'est plus stable et ergonomique.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 3. Initialise la connexion à Supabase.
  // On attend que la connexion soit établie avant de lancer l'app.
  await SupabaseService.initialize();

  // 4. Lance l'application.
  runApp(const DemeApp());
}

class DemeApp extends StatelessWidget {
  const DemeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Titre de l'application (visible dans le gestionnaire de tâches du téléphone)
      title: 'DƐMƐ',
      
      // Enlève le bandeau rouge "DEBUG" en haut à droite de l'écran
      debugShowCheckedModeBanner: false,
      
      // Applique notre thème personnalisé (couleurs #FF8A00, polices Quicksand/Roboto, etc.)
      theme: AppTheme.lightTheme,
      
      // Utilise notre routeur centralisé pour la navigation
      routes: AppRouter.routes,
      
      // Définit l'écran de démarrage par défaut
      initialRoute: AppRouter.home,
    );
  }
}