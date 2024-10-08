import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:git_auth/router/route_handler.dart';
import 'package:git_auth/router/routes.dart';
import 'package:git_auth/utils/app_color.dart';

import 'firebase_options.dart';

Future<void> main() async {
  // Ensures that the Flutter framework is fully initialized before any other setup.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the default platform-specific options.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Start the app with the MyApp widget.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Sets the application title.
      title: 'Git Auth',

      // Hides the debug banner in the top-right corner of the app.
      debugShowCheckedModeBanner: false,

      // Configures the theme of the app, using Material 3 design principles.
      theme: ThemeData(
        // Generates a color scheme from the primary color defined in AppColor.
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primaryColor),
        useMaterial3: true,
      ),

      // Handles the generation of routes for navigation throughout the app.
      onGenerateRoute: RouteHandler.generateRoute,

      // Sets the initial route of the app based on whether the user is signed in or not.
      initialRoute: isAlreadySignIn(),
    );
  }

  // This method checks if a user is already signed in.
  // Returns the appropriate initial route: 'home' if signed in, or 'root' if not.
  String isAlreadySignIn() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return Routes.home;
    }
    return Routes.root;
  }
}

