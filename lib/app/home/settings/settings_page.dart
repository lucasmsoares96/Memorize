import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:memorize/common_widgets/platform_alert_dialog.dart';
import 'package:memorize/services/auth.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> _confirmSignOut(BuildContext context) async {
  //   final didRequestSignOut = await PlatformAlertDialog(
  //     title: 'Logout',
  //     content: 'Você tem certeza que deseja sair?',
  //     cancelActionText: 'Cancelar',
  //     defaultActionText: 'Sair',
  //   ).show(context);
  //   if (didRequestSignOut == true) {
  //     _signOut(context);
  //   }
  // }

  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (contex) => SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Configurações'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    child: RaisedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.exit_to_app),
                          Text(
                            'Sair',
                            style: TextStyle(fontSize: 20),
                          ),
                          Opacity(
                            child: Icon(Icons.exit_to_app),
                            opacity: 0.0,
                          )
                        ],
                      ),
                      textColor: Colors.white,
                      color: Colors.indigo,
                      onPressed: () => _signOut(context),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
