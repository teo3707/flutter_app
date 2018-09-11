part of com.newt.i18n;


Future<String> settingLanguage({BuildContext context, String currentLanguage}) {
  return Navigator.push(context, MaterialPageRoute(
    builder: (context) => LanguageSetting(currentLanguage: currentLanguage)
  ));
}

Future<String> findSystemLocale() {
  return Future.delayed(Duration(seconds: 2), () {
    return strings.LANGUAGES[0];
  });
}

class LanguageSetting extends StatelessWidget {

  const LanguageSetting({this.currentLanguage});

  final String currentLanguage;

  @override
  Widget build(BuildContext context) {
    I18n i18n = I18n();
    List<String> languages = I18n.getAllLanguages();
    return Scaffold(
      appBar: AppBar(
          title: Text(i18n.T('languageSetting'))
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) => ListTile(
          title: Text(i18n.T('__language_${languages[index]}')),
          subtitle: Text(i18n.T('__language_${languages[index]}', lang: languages[index])),
          onTap: () {
            I18n().language = languages[index];
            Navigator.pop(context, languages[index]);
          },
        ),
        itemCount: languages.length,
      ),
    );
  }
}