import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:location_app/app_router.dart';
void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
    );
  }
}
