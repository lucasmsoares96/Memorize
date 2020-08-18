import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memorize/app/home/colections/collections_page.dart';
import 'package:memorize/app/home/settings/settings_page.dart';
import 'package:memorize/app/home/training/training_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: "Coleções",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: "Treinamento",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Configurações",
          ),
        ],
      ),
      tabBuilder: (context, i) {
        switch (i) {
          case 0:
            return CollectionsPage();
            break;
          case 1:
            return TrainingPage();
            break;
          case 2:
            return SettingsPage();
            break;
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }
}
