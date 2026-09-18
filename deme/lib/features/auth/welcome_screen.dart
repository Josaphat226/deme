import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_router.dart'; // <-- Import ajouté pour la navigation

/// Écran d'accueil (Welcome Screen) de DƐMƐ.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Formes décoratives
            Positioned(
              top: -50, left: -50,
              child: Container(
                width: 150, height: 150,
                decoration: BoxDecoration(
                  color: AppColors.orangePrincipal.withOpacity(0.20),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -80, right: -80,
              child: Container(
                width: 200, height: 200,
                decoration: BoxDecoration(
                  color: AppColors.orangePrincipal.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Contenu principal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  // 1. Logo et textes
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/deme_logo.png',
                        height: 85,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.bleuNuit,
                          ),
                          children: [
                            const TextSpan(text: 'Gérez'),
                            TextSpan(text: '.', style: TextStyle(color: AppColors.orangePrincipal)),
                            const TextSpan(text: ' Vendez'),
                            TextSpan(text: '.', style: TextStyle(color: AppColors.orangePrincipal)),
                            const TextSpan(text: ' Grandissez'),
                            TextSpan(text: '.', style: TextStyle(color: AppColors.orangePrincipal)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Votre commerce, plus simple,\nplus rapide, plus proche.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          color: AppColors.texteSecondaire,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 2. Illustration (prend l'espace vide)
                  Expanded(
                    child: Image.asset(
                      'assets/images/welcome_illustration.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. Boutons
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // BOUTON CRÉER (Connecté à la navigation)
                      ElevatedButton.icon(
                        onPressed: () {
                          // C'est ici que la magie opère : on navigue vers l'écran du numéro
                          Navigator.pushNamed(context, AppRouter.phoneInput);
                        },
                        icon: const Icon(Icons.store_outlined, size: 22),
                        label: const Text(
                          'Créer mon commerce',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orangePrincipal,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // BOUTON REJOINDRE
                      OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Navigation vers rejoindre
                        },
                        icon: const Icon(Icons.person_outline, size: 22),
                        label: const Text(
                          'Rejoindre un commerce',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppColors.bleuNuit,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                          side: const BorderSide(color: AppColors.bleuNuit, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // LIEN CONNEXION
                      TextButton(
                        onPressed: () {
                          // TODO: Navigation vers connexion
                        },
                        child: Text(
                          'J\'ai déjà un compte',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: AppColors.texteSecondaire,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}