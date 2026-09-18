import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_router.dart';

/// Écran de vérification OTP (Étape 2 sur 3).
class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String fullName;
  final String pin;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.fullName,
    required this.pin,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  
  int _countdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _countdown = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
      } else {
        setState(() => _countdown--);
      }
    });
  }

  Future<void> _onValidate() async {
    if (_otpController.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le code doit contenir 6 chiffres.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Vérifier le code dans la base de données
      final supabase = Supabase.instance.client;
      
      final response = await supabase
          .from('otp_codes')
          .select()
          .eq('phone', widget.phoneNumber)
          .eq('code', _otpController.text.trim())
          .eq('used', false)
          .gt('expires_at', DateTime.now().toIso8601String())
          .single();

      if (response != null) {
        // 2. Code valide ! Marquer comme utilisé
        await supabase
            .from('otp_codes')
            .update({'used': true, 'used_at': DateTime.now().toIso8601String()})
            .eq('id', response['id']);

        // 3. Créer le compte utilisateur dans Supabase Auth
        // Note: On utilise un email fictif car Supabase Auth nécessite un email ou phone
        final authResponse = await supabase.auth.signUp(
          email: '${widget.phoneNumber}@deme.local',
          password: widget.pin, // On utilise le PIN comme mot de passe temporaire
          data: {
            'full_name': widget.fullName,
            'phone': widget.phoneNumber,
          },
        );

        if (authResponse.user != null && mounted) {
          // 4. Navigation vers la création du commerce
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouter.createBusiness,
            (route) => false,
          );
        }
      } else {
        throw Exception('Code incorrect ou expiré');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : ${e.toString()}'),
            backgroundColor: AppColors.alerte,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendCode() async {
    if (_countdown > 0) return;

    setState(() => _isLoading = true);
    
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'send-sms',
        body: {
          'phone': widget.phoneNumber,
          'generateOtp': true,
          'message': '',
        },
      );

      if (response.data?['success'] == true && mounted) {
        _startTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nouveau code envoyé !')),
        );
      } else {
        throw Exception(response.data?['error'] ?? 'Erreur lors du renvoi');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, bottom: 32, left: 24, right: 24),
            decoration: const BoxDecoration(
              color: AppColors.bleuNuit,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
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
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
                        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.orangePrincipal, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          const Text('ÉTAPE 2 SUR 3', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text('Vérification du numéro', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 26, color: Colors.white)),
                const SizedBox(height: 10),
                Text(
                  'Un code à 6 chiffres a été envoyé au\n${widget.phoneNumber}.',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),

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
                        const Text('Code de vérification *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textePrincipal)),
                        const SizedBox(height: 16),
                        Container(
                          height: 64,
                          decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
                          child: TextField(
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontFamily: 'Roboto', fontSize: 24, letterSpacing: 12, fontWeight: FontWeight.bold, color: AppColors.textePrincipal),
                            decoration: InputDecoration(
                              hintText: '000000',
                              hintStyle: TextStyle(fontSize: 24, letterSpacing: 12, color: AppColors.texteSecondaire.withOpacity(0.3), fontWeight: FontWeight.bold),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              counterText: '',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.sms_outlined, size: 16, color: AppColors.texteSecondaire),
                            const SizedBox(width: 8),
                            Text('Si vous ne recevez rien, vérifiez vos SMS.', style: TextStyle(fontSize: 12, color: AppColors.texteSecondaire)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onValidate,
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
                              Text('Valider le code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 20),
                            ]),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Center(
                    child: TextButton(
                      onPressed: _countdown > 0 ? null : _resendCode,
                      child: _countdown > 0
                          ? Text(
                              'Renvoyer le code dans 00:${_countdown.toString().padLeft(2, '0')}',
                              style: TextStyle(color: AppColors.texteSecondaire.withOpacity(0.5), fontWeight: FontWeight.w600, fontSize: 14),
                            )
                          : const Text(
                              'Renvoyer le code',
                              style: TextStyle(color: AppColors.orangePrincipal, fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}