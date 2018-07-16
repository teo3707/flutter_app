import 'package:flutter/material.dart';
import 'i18n/i18n.dart';
import 'components/components.dart';

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

  final GlobalKey<AnimatedComponentsState> animatedComponents = GlobalKey<AnimatedComponentsState>();
  bool showBegin = true;
  double animatedValue = 0.0;

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
      child: Column(
        children: <Widget>[
          FlatButton(
            child: Icon(Icons.language),
            onPressed: () async {
              print('waiting');
              print(await settingLanguage(context));
            },
          ),
          Text('$animatedValue')
        ],
      )
    ),
    floatingActionButton: FloatingActionButton(
      child: AnimatedComponents(
        begin: Icon(Icons.home),
        end: Icon(Icons.close),
        key: animatedComponents,
        listener: (AnimationController controller) {
          animatedValue = controller.value;
          setState(() {

          });
        },
      ),
      onPressed: () {
        showBegin = !showBegin;
        if (!showBegin) {
          animatedComponents.currentState.forward();
        } else {
          animatedComponents.currentState.reverse();
        }
      },
    ),
  );
}

