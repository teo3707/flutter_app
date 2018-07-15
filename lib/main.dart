import 'package:flutter/material.dart';
import 'i18n/i18n.dart';

void main() {
  I18n i18n = I18n();

  runApp(
    createI18nApp(
      title: (_) => i18n.T('app_title'),
      child: (_) => MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    I18n i18n = I18n();
    i18n.addTransDict({
      'app_title': {
        'zh': '标题'
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text("Test")),
    body: Center(
      child: FlatButton(
        child: Icon(Icons.language),
        onPressed: () async {
          print('waiting');
          print(await settingLanguage(context));
        },
      ),
    ),
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.date_range),
      onPressed: () {
        String a;
        print(a == null);
//        showDatePicker(
//          context: context,
//          initialDate: DateTime.now(),
//          firstDate: DateTime(1991),
//          lastDate: DateTime(2099),
//        );
        showTimePicker(context: context, initialTime: TimeOfDay(hour: 10, minute: 5));
      },
    ),
  );
}

