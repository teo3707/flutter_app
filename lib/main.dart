import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/components/ensure_visible_when_focused.dart';
import 'package:flutter_app/components/interactive_list.dart';
import 'package:flutter_app/components/password.dart';
import 'i18n/i18n.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './utils/utils.dart';
import 'components/components.dart';
import 'components/obsure_text_form_field.dart';


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
  TextEditingController textEditingController;
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    controller = ScrollController();
    controller.addListener(() {
      if (controller.offset == controller.position.maxScrollExtent) {
        Future<Null>.delayed(Duration(seconds: 2), () {
           data.addAll(List.generate(10, (index) => data.length + index));
           setState(() {

           });
        });
      }
    });

    list = InteractiveList(
      data: data,
      itemBuilder: (context, index) => ListTile(
        title: Text('item $index'),
      ),
      //pullDown: false,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool autoValidate = false;


  void show() {
    context.visitChildElements((element) {
      if (element is StatefulElement) {
        if (element.state is ScaffoldState) {
          showPersistentModalBottomSheet(context: element, builder: (context) => WillPopScope(
            child: GestureDetector(
              child: Container(
                child: Text('ddddd' * 100),
              ),
            ),
            onWillPop: () async {
              return false;
            },
          ),
            enableDrag: true
          );
        }
      }
    });
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _focusNodeFirstName = FocusNode();

  List<int> data = List.generate(30, (index) => index + 1);
  InteractiveList list;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text("Test")),
    body: list,
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        //list.togglePullDown();
        //list.animateTo(1000.0);
        list.getScrollPosition()
            .then((sp) {
          print(sp.maxScrollExtent);
        });
      },
      child: Icon(Icons.language),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  );
}

/// Format incoming numeric text to fit the format of (###) ###-#### ##...
class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue
      ) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1)
        selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3)
        selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6)
        selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
      if (newValue.selection.end >= 10)
        selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
