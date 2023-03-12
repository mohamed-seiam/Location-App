import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_app/business_logic/cubit/auth_cubit/phone_auth_cubit.dart';
import 'package:location_app/presentation/screens/login_screen.dart';
import 'package:location_app/presentation/screens/map_screen.dart';
import 'package:location_app/presentation/screens/otp_screen.dart';

import 'constance/strings.dart';

class AppRouter {

  PhoneAuthCubit ? phoneAuthCubit ;

  AppRouter(){
    phoneAuthCubit =PhoneAuthCubit();
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mapScreen :
        return MaterialPageRoute(
            builder: (_)=>const MapScreen(),
        );

      case loginScreen:
        return MaterialPageRoute(
            builder: (_)=>  BlocProvider<PhoneAuthCubit>.value(
              value: phoneAuthCubit!,
                child: LogInScreen()),
        );
      case otpScreen:
        return MaterialPageRoute(
          builder: (_)=>  BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
              child: const OtpScreen()),
        );
    }
    return null;
  }
}
