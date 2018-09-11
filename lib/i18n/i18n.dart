library com.newt.i18n;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'strings/strings.dart' as strings;

part 'settings.dart';

class I18n {

  String language;

  Map<String, Map<String, String>> _transDict = strings.STRINGS;

  static final I18n _instance = new I18n._internal();

  factory I18n() {
    return _instance;
  }


  I18n._internal();

  static bool isSupported(String languageCode) {
    return languageCode != null && strings.LANGUAGES.contains(languageCode);
  }

  static List<String> getAllLanguages() => strings.LANGUAGES;

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
    if (language == null || language.isEmpty) {
      print('please set: i18n.language = ...');
    }

    if (lang == null) {
      lang = language;
    }

    if (!isSupported(lang)) {
      lang = strings.LANGUAGES[0];
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


class I18nLocalizations implements DefaultMaterialLocalizations {

  const I18nLocalizations();

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
      SynchronousFuture<MaterialLocalizations>(const I18nLocalizations());

  static const LocalizationsDelegate<MaterialLocalizations> delegate = const I18nLocalizationsDelegate();

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

  @override
  String get searchFieldLabel => _i18n.T('__Search');
}


class I18nLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {

  static const languageCode = 'com.newt.not.exist';

  const I18nLocalizationsDelegate();


  @override
  bool isSupported(Locale locale) => locale.languageCode == languageCode;

  @override
  Future<MaterialLocalizations> load(Locale locale) => I18nLocalizations.load(locale);

  @override
  bool shouldReload(I18nLocalizationsDelegate old) => false;
}