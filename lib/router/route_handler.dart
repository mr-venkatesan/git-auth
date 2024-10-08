import 'package:flutter/material.dart';
import 'package:git_auth/router/routes.dart';
import 'package:git_auth/view/pages/home_view.dart';
import 'package:git_auth/view/pages/repo_view.dart';
import 'package:git_auth/view/pages/sign_in_view.dart';

class RouteHandler{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name) {
      case Routes.root:
        return _createSlideTransitionRoute(const SignInView());
      case Routes.signIn:
        return _createSlideTransitionRoute(const SignInView());
      case Routes.home:
        return _createSlideTransitionRoute(const HomeView());
      case Routes.repo:
        return _createSlideTransitionRoute(const RepoView());
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