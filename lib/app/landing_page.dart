import 'package:flutter/material.dart';
import 'package:memorize/app/home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:memorize/app/sign_in/sign_in_page.dart';
import 'package:memorize/services/auth.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double width = (constraints.maxWidth - 480) > 0
                      ? (constraints.maxWidth - 480) / 2
                      : 0;
                  return Container(
                      padding: EdgeInsets.symmetric(horizontal: width),
                      child: SignInPage());
                },
              );
            }
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double width = (constraints.maxWidth - 480) > 0
                    ? (constraints.maxWidth - 480) / 2
                    : 0;
                return Container(
                    padding: EdgeInsets.symmetric(horizontal: width),
                    child: HomePage());
              },
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
