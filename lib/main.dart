import 'dart:async';
import 'i18n/i18n.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  // get system default language
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String defaultLanguage = prefs.getString("__sys_store_language");

  if (defaultLanguage == null || defaultLanguage.isEmpty) {
    defaultLanguage = await findSystemLocale();
    if (!I18n.isSupported(defaultLanguage)) {
      defaultLanguage = I18n.getAllLanguages()[0];
    }
    I18n().language = defaultLanguage;
    prefs.setString('__sys_store_language', defaultLanguage);
  }


  runApp(MaterialApp(
    title: "Title",
    localizationsDelegates: [
      I18nLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale(I18nLocalizationsDelegate.languageCode)
    ],
    home: MyApp(),
  ));
}


class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  String defaultLanguage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text("Test")),
    body: Center(
      child: Text(I18n().T('languageSetting')),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        settingLanguage(
          context: context,
          currentLanguage: defaultLanguage,
        );
      },
      child: Icon(Icons.language),
    ),
  );
}
