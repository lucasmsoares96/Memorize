import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:memorize/app/landing_page.dart';
import 'package:memorize/services/auth.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(Memorize());
}

class Memorize extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Memorize',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LandingPage(),
      ),
    );
  }
}
