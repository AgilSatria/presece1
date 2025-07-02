import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: 'https://cznegaaggbluolwncfmg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN6bmVnYWFnZ2JsdW9sd25jZm1nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA3MzM4MDYsImV4cCI6MjA2NjMwOTgwNn0.RzWEmISk5_XRtsvz8orchTIdDnH4F3ZDoIzA5_-4Eb4',
  );

  runApp(
    StreamBuilder<firebase_auth.User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        print(snapshot.data);
        return GetMaterialApp(
          title: "Application",
          initialRoute: snapshot.data != null ? Routes.HOME : Routes.LOGIN,
          getPages: AppPages.routes,
        );
      },
    ),
  );
}
