import 'package:flutter/material.dart';
import 'package:location_app/presentation/screens/login_screen.dart';

import 'constance/strings.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginScreen:
        return MaterialPageRoute(
            builder: (_)=>  LogInScreen(),
        );
    }
  }
}
