import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:location_app/app_router.dart';
import 'package:location_app/constance/strings.dart';
late String initialRoute ;
void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.authStateChanges().listen((user)
  {
    if(user == null) {
      initialRoute = loginScreen;
    }
      else
      {
        initialRoute = mapScreen;
      }

  });
  runApp( LocationApp(appRouter: AppRouter(),));
}
class LocationApp extends StatelessWidget {
  const LocationApp({Key? key, required this.appRouter}) : super(key: key);
  final AppRouter appRouter ;
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
     debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: initialRoute,
    );
  }
}
