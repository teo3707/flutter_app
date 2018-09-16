import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';


void alert({
  @required BuildContext context,
  Widget title,
  bool barrierDismissible = true
}) {

  assert(context != null);
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: title,
        ),
      );
      break;
    default:
      showDialog(
        context: context,
        barrierDismissible: barrierDismissible
      );

  }

  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: title,
    ),
  );
}
