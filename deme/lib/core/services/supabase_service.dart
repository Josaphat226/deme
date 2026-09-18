import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();

  static const String supabaseUrl = 'https://sebstqvkitwdqwalglkm.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNlYnN0cXZraXR3ZHF3YWxnbGttIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk1NjMyNzcsImV4cCI6MjEwNTEzOTI3N30.NNT9sUpYMSoimXn0j8WIij11nV1Tn8kQNdZU7lxcwkU';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}