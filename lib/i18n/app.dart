part of com.newt.i18n;


typedef T GenValueByLang<T>(String en);


class I18nApp extends StatelessWidget {

  final GenValueByLang<String> title;
  final GenValueByLang<Widget> child;

  I18nApp({
    Key key,
    this.title,
    @required this.child,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Future<SharedPreferences> instanceFuture = SharedPreferences.getInstance();
    SharedPreferences preferences;
    Future<String> langFuture = instanceFuture.then((prefs) {
      preferences = prefs;
      return prefs.getString("__sys_store_language");
    });

    Future<String> future = langFuture.then((lang) {
      if (lang == null || lang == "") {
        return FlutterConfiguration.language.then((res) {
          preferences.setString('__sys_store_language', res);
          return res;
        });

      } else {
        return lang;
      }
    });

    return FutureBuilder<String>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        Widget home;
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            break;
          default:
            _lang = snapshot.data;
            print('_lang: $_lang');
            home = child(_lang);
        }

        return MaterialApp(
          title: title == null ? 'App' : title(_lang),
          localizationsDelegates: [
            _I18nLocalizations.delegate
          ],
          supportedLocales: [
            const Locale(_I18nLocalizationsDelegate.languageCode)
          ],
          home: home == null
              ? Container()
              : _SettingLanguage(
                  home: home,
                ),
        );
      },
    );
  }
}


class _SettingLanguage extends StatefulWidget {
  final Widget home;

  _SettingLanguage({Key key, this.home}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingLanguageState();
}


class _Language extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LanguageState();
}


class _LanguageState extends State<_Language> {

  int selected = -1;
  I18n _i18n = I18n();
  List<Map<String, String>> languages;

  @override
  void initState() {
    super.initState();
    languages = _i18n.getSupportedLanguages();
    languages.map((lang) {
      if (lang['key'] == _lang) {
        selected = languages.indexOf(lang);
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: _i18n.isSupported(_lang)
            ? Text(_i18n.T('app_setting_language_label'))
            : Text('Setting Language'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) => ListTile(
                  title: Text(languages[index]['label']),
                  selected: selected == index,
                  onTap: () {
                    selected = index;
                    setState(() {
                    });
                  },
                ),
                itemCount: languages.length,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text(_i18n.T('__cancelButtonLabel'), style: Theme.of(context).textTheme.subhead.copyWith(color: Theme.of(context).bottomAppBarColor)),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  RaisedButton(
                    child: Text(_i18n.T('__okButtonLabel'), style: Theme.of(context).textTheme.subhead.copyWith(color: Theme.of(context).bottomAppBarColor)),
                    color: Theme.of(context).primaryColor,
                    onPressed: selected >=0
                        ? () async {
                      _lang = languages[selected]['key'];
                      print(_lang);
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString('__sys_store_language', _lang);
                      Navigator.pop(context, _lang);
                    }
                        : null,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<String> settingLanguage(BuildContext context) async {

  return Navigator.push<String>(context, MaterialPageRoute(
    builder: (BuildContext context) => _Language()
  ));
}

class _SettingLanguageState extends State<_SettingLanguage> {

  I18n _i18n = I18n();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_i18n.isSupported(_lang)) {
      print("setting");
      Future.delayed(Duration(milliseconds: 0))
      .then((_) {
        settingLanguage(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: widget.home,
    );
  }
}