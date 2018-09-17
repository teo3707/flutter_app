library com.newt.utils;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
export 'dialog.dart';


Future<T> showPersistentModalBottomSheet<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
  bool enableDrag = false,
}) {
  assert(context != null);
  assert(builder != null);
  return Navigator.push(context, new PersistentModalBottomSheetRoute<T>(
    builder: builder,
    theme: Theme.of(context, shadowThemeOnly: true),
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    enableDrag: enableDrag,
  ));
}

class PersistentModalBottomSheetRoute<T> extends PopupRoute<T> {
  PersistentModalBottomSheetRoute({
    this.builder,
    this.theme,
    this.barrierLabel,
    this.enableDrag,
    RouteSettings settings,
  }) : super(settings: settings);

  final WidgetBuilder builder;
  final ThemeData theme;
  final bool enableDrag;

  @override
  Duration get transitionDuration => Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => false;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    // By definition, the bottom sheet is aligned to the bottom of the page
    // and isn't exposed to the top padding of the MediaQuery.
    Widget bottomSheet = new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: new _PersistentModalBottomSheet<T>(route: this, enableDrag: enableDrag,),
    );
    if (theme != null)
      bottomSheet = new Theme(data: theme, child: bottomSheet);
    return bottomSheet;
  }
}

class _PersistentModalBottomSheet<T> extends StatefulWidget {
  const _PersistentModalBottomSheet({ Key key, this.route, this.enableDrag }) : super(key: key);

  final PersistentModalBottomSheetRoute<T> route;
  final bool enableDrag;

  @override
  _PersistentModalBottomSheetState<T> createState() => new _PersistentModalBottomSheetState<T>();
}

class _PersistentModalBottomSheetState<T> extends State<_PersistentModalBottomSheet<T>> {
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        //onTap: () => Navigator.pop(context),
        child: new AnimatedBuilder(
            animation: widget.route.animation,
            builder: (BuildContext context, Widget child) {
              return new ClipRect(
                  child: new CustomSingleChildLayout(
                      delegate: new _PersistentModalBottomSheetLayout(widget.route.animation.value),
                      child: new BottomSheet(
                          animationController: widget.route._animationController,
                          onClosing: () => Navigator.pop(context),
                          builder: widget.route.builder,
                          enableDrag: widget.enableDrag?? false,
                      )
                  )
              );
            }
        )
    );
  }
}

class _PersistentModalBottomSheetLayout extends SingleChildLayoutDelegate {
  _PersistentModalBottomSheetLayout(this.progress);

  final double progress;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return new BoxConstraints(
        minWidth: constraints.maxWidth,
        maxWidth: constraints.maxWidth,
        minHeight: 0.0,
        maxHeight: constraints.maxHeight * 9.0 / 16.0
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return new Offset(0.0, size.height - childSize.height * progress);
  }

  @override
  bool shouldRelayout(_PersistentModalBottomSheetLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}


Future<void> showLoading({
  @required BuildContext context,
  Completer<void> completer,
  bool barrierDismissible = false,
  Widget content = const Center(
    child: CupertinoActivityIndicator(),
  ),
}) async {
  Widget widget = AnimatedPadding(
    padding: MediaQuery.of(context).viewInsets + const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
    duration: Duration(milliseconds: 300),
    curve: Curves.easeOut,
    child: new MediaQuery.removeViewInsets(
      removeLeft: true,
      removeTop: true,
      removeRight: true,
      removeBottom: true,
      context: context,
      child: content,
    ),
  );

  if (completer != null) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        Timer(Duration(milliseconds: 0), () {
          completer.future.then((_) {
            Navigator.of(context).pop();
          });
        });
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: widget,
        );
      }
    );
  }
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => widget,
  );
}