import 'dart:convert';
import 'package:Prism/data/categories/categories.dart';
import 'package:Prism/theme/themeModel.dart';
import 'package:Prism/ui/pages/home/pageManager.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:Prism/theme/theme.dart';
import 'package:provider/provider.dart';

RemoteConfig remoteConfig;

class SplashWidget extends StatelessWidget {
  const SplashWidget({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      Provider.of<ThemeModel>(context).currentTheme == kLightTheme
          ? 'assets/animations/Prism Splash.flr'
          : 'assets/animations/Prism Splash Dark.flr',
      (context) => PageManager(),
      startAnimation:
          Provider.of<ThemeModel>(context).currentTheme == kLightTheme
              ? 'Main'
              : 'Dark',
      backgroundColor:
          Provider.of<ThemeModel>(context).currentTheme == kLightTheme
              ? Color(0xFFFFFFFF)
              : Color(0xFF181818),
      until: () async {
        remoteConfig = await RemoteConfig.instance;
        await remoteConfig
            .setConfigSettings(RemoteConfigSettings(debugMode: false));
        await remoteConfig.setDefaults(<String, dynamic>{
          'categories': categories.toString(),
        });
        await remoteConfig.fetch(expiration: const Duration(hours: 6));
        await remoteConfig.activateFetched();
        var cList = [];
        var tempVar = remoteConfig
            .getString('categories')
            .replaceAll('[', "")
            .replaceAll(']', "")
            .split("},");
        tempVar = tempVar.sublist(0, tempVar.length - 1);
        tempVar.forEach((element) {
          cList.add(element.split('"name": "')[1].split('",')[0].toString());
          categories[tempVar.indexOf(element)] = json.decode(element + "}");
        });
        print(cList);
      },
    );
  }
}
