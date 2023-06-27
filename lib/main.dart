import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wite_dashboard/Bloc/auth_bloc.dart';
import 'package:wite_dashboard/Screen/Dashboard.dart';
import 'package:wite_dashboard/Screen/loginPage.dart';
import 'package:wite_dashboard/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final AuthBloc authBloc = AuthBloc();
  runApp(MyApp(authBloc: authBloc));
}

Color _colorPrime = HexColor("#1C6758");
Color _colorSec = HexColor("#FFFFFF");

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  final AuthBloc authBloc;

  const MyApp({required this.authBloc});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => authBloc,
      child: GetMaterialApp(
        title: 'WITE Dashboard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // primarySwatch: Colors.blue,
          accentColor: Colors.grey.shade600,
          textSelectionColor: Colors.grey.shade300,
          primaryColor: _colorPrime,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const Dashboard();
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColor(String hex) {
    String formattedHex = "FF${hex.toUpperCase().replaceAll("#", "")}";
    return int.parse(formattedHex, radix: 16);
  }

  HexColor(final String hex) : super(_getColor(hex));
}
