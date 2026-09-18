import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import 'otp_verification_screen.dart';

/// Écran de création de compte (Étape 1 sur 3).
class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  bool _isPinVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    // 1. Validations
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer votre nom complet.')),
      );
      return;
    }
    if (_phoneController.text.trim().length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un numéro valide.')),
      );
      return;
    }
    if (_pinController.text.trim().length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le code PIN doit contenir au moins 4 chiffres.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Appeler notre Edge Function pour générer et envoyer l'OTP
      final response = await Supabase.instance.client.functions.invoke(
        'send-sms',
        body: {
          'phone': _phoneController.text.trim(),
          'generateOtp': true,
          'message': '', // Pas nécessaire quand generateOtp est true
        },
      );

      if (response.data?['success'] == true) {
        // Pour le débogage : afficher le code dans la console
        final debugCode = response.data?['debug_otp'];
        if (debugCode != null) {
          print('🔐 CODE OTP POUR TEST: $debugCode');
        }

        // 3. Naviguer vers l'écran OTP
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(
                phoneNumber: _phoneController.text.trim(),
                fullName: _nameController.text.trim(),
                pin: _pinController.text.trim(),
              ),
            ),
          );
        }
      } else {
        throw Exception(response.data?['error'] ?? 'Erreur lors de l\'envoi du code');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // === HEADER BLEU NUIT ===
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 32,
              left: 24,
              right: 24,
            ),
            decoration: const BoxDecoration(
              color: AppColors.bleuNuit,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.orangePrincipal, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          const Text('ÉTAPE 1 SUR 3', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    const Text('Créer votre compte', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 26, color: Colors.white)),
                    const SizedBox(width: 8),
                    Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.orangePrincipal, shape: BoxShape.circle)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Rejoignez les commerçants modernes et\npilotez vos ventes en temps réel.',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),

          // === CONTENU PRINCIPAL ===
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Nom complet', required: true),
                        const SizedBox(height: 10),
                        _buildTextField(controller: _nameController, hintText: 'ex: Amadou Traoré', icon: Icons.person_outline),
                        const SizedBox(height: 24),

                        _buildLabel('Numéro de téléphone', required: true),
                        const SizedBox(height: 10),
                        _buildPhoneField(),
                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLabel('Code PIN secret', required: true),
                            Text('4 ou 6 chiffres', style: TextStyle(fontSize: 12, color: AppColors.texteSecondaire)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildPinField(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orangePrincipal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        shadowColor: AppColors.orangePrincipal.withOpacity(0.4),
                      ),
                      child: _isLoading
                          ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                          : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text('Continuer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 20),
                            ]),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Vous avez déjà un compte ?', style: TextStyle(color: AppColors.texteSecondaire, fontSize: 14)),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {},
                        child: const Text('Se connecter', style: TextStyle(color: AppColors.orangePrincipal, fontWeight: FontWeight.bold, fontSize: 14, decoration: TextDecoration.underline, decorationColor: AppColors.orangePrincipal)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return Row(
      children: [
        Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textePrincipal)),
        if (required) const Text(' *', style: TextStyle(color: AppColors.orangePrincipal, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hintText, required IconData icon}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontFamily: 'Roboto', fontSize: 15, color: AppColors.textePrincipal),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.texteSecondaire.withOpacity(0.5)),
          prefixIcon: Icon(icon, color: AppColors.texteSecondaire, size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      height: 56,
      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('+226', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.textePrincipal)),
                const SizedBox(width: 6),
                Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.texteSecondaire),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(fontFamily: 'Roboto', fontSize: 15, color: AppColors.textePrincipal),
              decoration: InputDecoration(
                hintText: '70 00 00 00',
                hintStyle: TextStyle(color: AppColors.texteSecondaire.withOpacity(0.5)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinField() {
    return Container(
      height: 56,
      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: _pinController,
        keyboardType: TextInputType.number,
        obscureText: !_isPinVisible,
        maxLength: 6,
        style: const TextStyle(fontFamily: 'Roboto', fontSize: 18, letterSpacing: 6, color: AppColors.textePrincipal, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: '••••',
          hintStyle: TextStyle(fontSize: 18, letterSpacing: 6, color: AppColors.texteSecondaire.withOpacity(0.4), fontWeight: FontWeight.w500),
          prefixIcon: Icon(Icons.lock_outline, color: AppColors.texteSecondaire, size: 22),
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _isPinVisible = !_isPinVisible),
            child: Container(
              margin: const EdgeInsets.all(12),
              child: Icon(_isPinVisible ? Icons.visibility : Icons.visibility_off, color: AppColors.texteSecondaire, size: 22),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          counterText: '',
        ),
      ),
    );
  }
}