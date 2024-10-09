import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_auth/router/routes.dart';
import 'package:git_auth/view/pages/home_view.dart';
import 'package:git_auth/view/pages/repo_view.dart';
import 'package:git_auth/view/pages/sign_in_view.dart';

class RouteHandler{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name) {
      case Routes.root:
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          return _createSlideTransitionRoute(const HomeView());
        }
        return _createSlideTransitionRoute(const SignInView());
      case Routes.signIn:
        return _createSlideTransitionRoute(const SignInView());
      case Routes.home:
        return _createSlideTransitionRoute(const HomeView());
      case Routes.repo:
        final argument=settings.arguments as Map<String,dynamic>;
    return _createSlideTransitionRoute(RepoView(owner: argument["owner"],repo: argument["repo"], updatedAt: argument["updatedAt"], avatarUrl: argument["avatarUrl"],));
      default:
        return _createSlideTransitionRoute(const SignInView());
    }
  }
  // Helper function for PageRouteBuilder with slide transition
  static PageRouteBuilder _createSlideTransitionRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween.chain(CurveTween(curve: curve)));
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}