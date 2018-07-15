library com.newt.i18n;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_configuration/flutter_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';


part 'app.dart';


String _lang;

class I18n {

  Map<String, Map<String, String>> _transDict = {
    // I18n delegate
    '__openAppDrawerTooltip': {
      'en': 'Open navigation menu',
      'zh': '打开Drawer'
    },

    '__backButtonTooltip': {
      'en': 'Back',
      'zh': '后退'
    },

    '__closeButtonTooltip': {
      'en': 'Close',
      'zh': '关闭'
    },

    '__deleteButtonTooltip': {
      'en': 'Delete',
      'zh': '删除'
    },

    '__nextMonthTooltip': {
      'en': 'Next month',
      'zh': '下个月'
    },

    '__previousMonthTooltip': {
      'en': 'Previous month',
      'zh': '上个月'
    },

    '__nextPageTooltip': {
      'en': 'Next page',
      'zh': '下一页'
    },

    '__previousPageTooltip': {
      'en': 'Previous page',
      'zh': '上一页'
    },

    '__showMenuTooltip': {
      'en': 'Show menu',
      'zh': '打开菜单'
    },

    '__drawerLabel': {
      'en': 'Navigation menu',
      'zh': 'Nav菜单'
    },

    '__popupMenuLabel': {
      'en': 'Popup menu',
      'zh': 'Popup菜单'
    },

    '__dialogLabel': {
      'en': 'Dialog',
      'zh': '对话框'
    },

    '__alertDialogLabel': {
      'en': 'Alert',
      'zh': '警告框'
    },

    '__about': {
      'en': 'About',
      'zh': '关于'
    },

    '__licensesPageTitle': {
      'en': 'Licenses',
      'zh': '授权'
    },

    '__pageRowsInfoTitle_of': {
      'en': 'of',
      'zh': '共'
    },

    '__pageRowsInfoTitle_of_about': {
      'en': 'of about',
      'zh': '大约'
    },

    '__rowsPerPageTitle': {
      'en': 'Rows per page:',
      'zh': '每页显示:'
    },

    '__cancelButtonLabel': {
      'en': 'CANCEL',
      'zh': '取消'
    },

    '__continueButtonLabel': {
      'en': 'CONTINUE',
      'zh': '继续'
    },

    '__copyButtonLabel': {
      'en': 'COPY',
      'zh': '复制'
    },

    '__cutButtonLabel': {
      'en': 'CUT',
      'zh': '剪切'
    },

    '__okButtonLabel': {
      'en': 'OK',
      'zh': '确定'
    },

    '__pasteButtonLabel': {
      'en': 'PASTE',
      'zh': '粘贴'
    },

    '__selectAllButtonLabel': {
      'en': 'SELECT ALL',
      'zh': '全选'
    },

    '__viewLicensesButtonLabel': {
      'en': 'VIEW LICENSES',
      'zh': '查看授权'
    },

    '__anteMeridiemAbbreviation': {
      'en': 'AM',
      'zh': '上午'
    },

    '__postMeridiemAbbreviation': {
      'en': 'PM',
      'zh': '下午'
    },

    '__timePickerHourModeAnnouncement': {
      'en': 'Select hours',
      'zh': '选择小时'
    },

    '__timePickerMinuteModeAnnouncement': {
      'en': 'Select minutes',
      'zh': '选择分钟'
    },

    '__modalBarrierDismissLabel': {
      'en': 'Dismiss',
      'zh': 'DISMISS'
    },

    '__signedInLabel': {
      'en': 'Sigend in',
      'zh': '注册'
    },

    '__hideAccountsLabel': {
      'en': 'Hide accounts',
      'zh': '隐藏账户',
    },

    '__showAccountsLabel': {
      'en': 'Show accounts',
      'zh': '显示账户'
    },

    'app_setting_language_label': {
      'en': 'Setting Language',
      'zh': '语言设置'
    },

    // configure here
    'app_title': {
      'en': 'flutter demo',
      'zh': 'flutter demo.'
    },

    'app_name': {
      'en': 'flutter',
      'zh': 'Flutter'
    }
  };

  static final I18n _instance = new I18n._internal();

  factory I18n() {
    return _instance;
  }


  I18n._internal();

  bool isSupported(String languageCode) {
    return ['en', 'zh'].contains(languageCode);
  }

  List<Map<String, String>> getSupportedLanguages() {
    return <Map<String, String>>[
      {
        'label': 'English',
        'key': 'en',
      },
      {
        'label': '中文',
        'key': 'zh'
      }
    ];
  }


  void addTransDict(Map<String, Map<String, String>> dict) {

    for (String key in dict.keys) {
      if (_transDict[key] == null) {
        _transDict[key] = Map<String, String>();
      }

      Map<String, String> valuesDict = dict[key];
      for (String vk in valuesDict.keys) {
        if (_transDict[key].containsKey(vk))
          print('[$key $vk] exists, this will not add to dict');
        else
          _transDict[key][vk] = valuesDict[vk];
      }
    }
  }

  String T(String key, { String lang }) {
    // _lang inject by I18nApp
    if (_lang == "") {
      print('make sure your app root is I18nApp');
    }

    if (lang == null) {
      lang = _lang?? 'en';
    }

    try {
      String result = _transDict[key][lang];

      if (result == null) {
        print("[$key $lang] cannot be null");
        return key;
      }

      return result;

    } catch (e) {
      print('$key not found');
      return key;
    }
  }


}


class _I18nLocalizations implements MaterialLocalizations {

  const _I18nLocalizations();

  static const List<String> _shortWeekdays = const <String>[
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  // Ordered to match DateTime.monday=1, DateTime.sunday=6
  static const List<String> _weekdays = const <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> _narrowWeekdays = const <String>[
    'S',
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
  ];

  static const List<String> _shortMonths = const <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const List<String> _months = const <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static I18n _i18n = I18n();

  static Future<MaterialLocalizations> load(Locale locale) =>
      SynchronousFuture<MaterialLocalizations>(const _I18nLocalizations());

  static const LocalizationsDelegate<MaterialLocalizations> delegate = const _I18nLocalizationsDelegate();

  @override
  String aboutListTileTitle(String applicationName) => '${_i18n.T("__about")} $applicationName';

  @override
  String get alertDialogLabel => _i18n.T('__alertDialogLabel');

  @override
  String get anteMeridiemAbbreviation => _i18n.T('__anteMeridiemAbbreviation');

  @override
  String get postMeridiemAbbreviation => _i18n.T('__postMeridiemAbbreviation');

  @override
  String get backButtonTooltip => _i18n.T('__backButtonTooltip');

  @override
  String get cancelButtonLabel => _i18n.T('__cancelButtonLabel');

  @override
  String get closeButtonLabel => _i18n.T('__closeButtonTooltip');

  // TODO: implement closeButtonTooltip
  @override
  String get closeButtonTooltip => null;

  @override
  String get continueButtonLabel => _i18n.T('__continueButtonLabel');

  @override
  String get copyButtonLabel => _i18n.T('__copyButtonLabel');

  @override
  String get cutButtonLabel => _i18n.T('__cutButtonLabel');

  @override
  String get deleteButtonTooltip => _i18n.T('__deleteButtonTooltip');

  @override
  String get dialogLabel => _i18n.T('__dialogLabel');

  @override
  String get drawerLabel => _i18n.T('__drawerLabel');

  @override
  int get firstDayOfWeekIndex => 0; // narrowWeekdays[0] is 'S' for Sunday

  @override
  String formatDecimal(int number) {
    if (number > -1000 && number < 1000)
      return number.toString();

    final String digits = number.abs().toString();
    final StringBuffer result = new StringBuffer(number < 0 ? '-' : '');
    final int maxDigitIndex = digits.length - 1;
    for (int i = 0; i <= maxDigitIndex; i += 1) {
      result.write(digits[i]);
      if (i < maxDigitIndex && (maxDigitIndex - i) % 3 == 0)
        result.write(',');
    }
    return result.toString();
  }

  @override
  String formatFullDate(DateTime date) {
    final String month = _months[date.month - DateTime.january];
    return '${_weekdays[date.weekday - DateTime.monday]}, $month ${date.day}, ${date.year}';
  }

  @override
  String formatHour(TimeOfDay timeOfDay, {bool alwaysUse24HourFormat: false}) {
    final TimeOfDayFormat format = timeOfDayFormat(alwaysUse24HourFormat: alwaysUse24HourFormat);
    switch (format) {
      case TimeOfDayFormat.h_colon_mm_space_a:
        return formatDecimal(timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod);
      case TimeOfDayFormat.HH_colon_mm:
        return _formatTwoDigitZeroPad(timeOfDay.hour);
      default:
        throw new AssertionError('$runtimeType does not support $format.');
    }
  }

  /// Formats [number] using two digits, assuming it's in the 0-99 inclusive
  /// range. Not designed to format values outside this range.
  String _formatTwoDigitZeroPad(int number) {
    assert(0 <= number && number < 100);

    if (number < 10)
      return '0$number';

    return '$number';
  }

  @override
  String formatMediumDate(DateTime date) {
    final String day = _shortWeekdays[date.weekday - DateTime.monday];
    final String month = _shortMonths[date.month - DateTime.january];
    return '$day, $month ${date.day}';
  }

  @override
  String formatMinute(TimeOfDay timeOfDay) {
    final int minute = timeOfDay.minute;
    return minute < 10 ? '0$minute' : minute.toString();
  }

  @override
  String formatMonthYear(DateTime date) {
    final String year = formatYear(date);
    final String month = _months[date.month - DateTime.january];
    return '$month $year';
  }

  @override
  String formatTimeOfDay(TimeOfDay timeOfDay, {bool alwaysUse24HourFormat: false}) {
    // Not using intl.DateFormat for two reasons:
    //
    // - DateFormat supports more formats than our material time picker does,
    //   and we want to be consistent across time picker format and the string
    //   formatting of the time of day.
    // - DateFormat operates on DateTime, which is sensitive to time eras and
    //   time zones, while here we want to format hour and minute within one day
    //   no matter what date the day falls on.
    final StringBuffer buffer = new StringBuffer();

    // Add hour:minute.
    buffer
      ..write(formatHour(timeOfDay, alwaysUse24HourFormat: alwaysUse24HourFormat))
      ..write(':')
      ..write(formatMinute(timeOfDay));

    if (alwaysUse24HourFormat) {
      // There's no AM/PM indicator in 24-hour format.
      return '$buffer';
    }

    // Add AM/PM indicator.
    buffer
      ..write(' ')
      ..write(_formatDayPeriod(timeOfDay));
    return '$buffer';
  }

  String _formatDayPeriod(TimeOfDay timeOfDay) {
    switch (timeOfDay.period) {
      case DayPeriod.am:
        return anteMeridiemAbbreviation;
      case DayPeriod.pm:
        return postMeridiemAbbreviation;
    }
    return null;
  }

  @override
  String formatYear(DateTime date) => date.year.toString();

  @override
  String get hideAccountsLabel => _i18n.T('__hideAccountsLabel');

  @override
  String get showAccountsLabel => _i18n.T('__showAccountsLabel');

  @override
  String get licensesPageTitle => _i18n.T('__licensesPageTitle');

  @override
  TextTheme get localTextGeometry => MaterialTextGeometry.englishLike;

  @override
  String get modalBarrierDismissLabel => _i18n.T('__modalBarrierDismissLabel');

  @override
  List<String> get narrowWeekdays => _narrowWeekdays;

  @override
  String get nextMonthTooltip => _i18n.T('__nextMonthTooltip');

  @override
  String get previousMonthTooltip => _i18n.T('__previousMonthTooltip');

  @override
  String get nextPageTooltip => _i18n.T('__nextPageTooltip');

  @override
  String get previousPageTooltip => _i18n.T('__previousPageTooltip');

  @override
  String get okButtonLabel => _i18n.T('__okButtonLabel');

  @override
  String get openAppDrawerTooltip => _i18n.T('__openAppDrawerTooltip');

  @override
  String pageRowsInfoTitle(int firstRow, int lastRow, int rowCount, bool rowCountIsApproximate) {
    return rowCountIsApproximate
        ? '$firstRow–$lastRow ${_i18n.T('__pageRowsInfoTitle_of_about')} $rowCount'
        : '$firstRow–$lastRow ${_i18n.T('__pageRowsInfoTitle_of')} $rowCount';
  }

  @override
  String get pasteButtonLabel => _i18n.T('__pasteButtonLabel');

  @override
  String get popupMenuLabel => _i18n.T('__popupMenuLabel');

  @override
  String get rowsPerPageTitle => _i18n.T('__rowsPerPageTitle');

  @override
  String get selectAllButtonLabel => _i18n.T('__selectAllButtonLabel');

  @override
  String selectedRowCountTitle(int selectedRowCount) {
    switch (selectedRowCount) {
      case 0:
        return 'No items selected';
      case 1:
        return '1 item selected';
      default:
        return '$selectedRowCount items selected';
    }
  }

  @override
  String get showMenuTooltip => _i18n.T('__showMenuTooltip');

  @override
  String get signedInLabel => _i18n.T('__signedInLabel');

  @override
  String tabLabel({int tabIndex, int tabCount}) {
    assert(tabIndex >= 1);
    assert(tabCount >= 1);
    return 'Tab $tabIndex of $tabCount';
  }

  @override
  TimeOfDayFormat timeOfDayFormat({bool alwaysUse24HourFormat: false}) {
    return alwaysUse24HourFormat
        ? TimeOfDayFormat.HH_colon_mm
        : TimeOfDayFormat.h_colon_mm_space_a;
  }

  @override
  String get timePickerHourModeAnnouncement => _i18n.T('__timePickerHourModeAnnouncement');

  @override
  String get timePickerMinuteModeAnnouncement => _i18n.T('__timePickerMinuteModeAnnouncement');

  @override
  String get viewLicensesButtonLabel => _i18n.T('__viewLicensesButtonLabel');



}


class _I18nLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {

  static const languageCode = 'com.newt.not.exist';

  const _I18nLocalizationsDelegate();


  @override
  bool isSupported(Locale locale) => locale.languageCode == languageCode;

  @override
  Future<MaterialLocalizations> load(Locale locale) => _I18nLocalizations.load(locale);

  @override
  bool shouldReload(_I18nLocalizationsDelegate old) => false;
}


Widget createI18nApp({GenValueByLang<String> title, GenValueByLang<Widget> child}) => I18nApp(
  title: title,
  child: child,
);