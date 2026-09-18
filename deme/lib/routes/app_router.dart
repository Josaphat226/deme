import 'package:flutter/material.dart';
import '../features/auth/welcome_screen.dart';
import '../features/auth/phone_input_screen.dart';
import '../features/commerce/create_business_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String welcome = '/welcome';
  static const String phoneInput = '/phone-input';
  static const String createBusiness = '/create-business';

  static Map<String, WidgetBuilder> get routes {
    return {
      home: (context) => const WelcomeScreen(),
      welcome: (context) => const WelcomeScreen(),
      phoneInput: (context) => const PhoneInputScreen(),
      createBusiness: (context) => const CreateBusinessScreen(),
      // On retire otpVerification des routes statiques car on y navigue toujours avec des paramètres
    };
  }
}