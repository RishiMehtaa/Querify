import 'package:flutter/material.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/signup_page.dart';
import '../pages/org/org_home_page.dart';
import '../pages/org/access_page.dart';
import '../pages/chat/chat_home_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignupPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/org-home':
        return MaterialPageRoute(builder: (_) => OrgHomePage());
      case '/access':
        return MaterialPageRoute(builder: (_) => AccessPage());
      case '/chat':
        return MaterialPageRoute(builder: (_) => ChatHomePage());
      default:
        return MaterialPageRoute(builder: (_) => LoginPage());
    }
  }
}
