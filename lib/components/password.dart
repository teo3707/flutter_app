import 'package:flutter/material.dart';
import 'dart:math' as math;


const double _kHorizontalPadding = 24.0;
const double _kVerticalPadding = 8.0;
const double _kMaxSize = 48.0;
const double _kSize = 56.0;
const double _kRadius = 8.0;
const double _kStrokeWidth = 1.0;
const double _kKeyboardSize = 50.0;
const Color _kBorderColor = Colors.black54;


class Password extends StatefulWidget {
  Password({this.count = 6, this.onFinish});

  final int count;
  final ValueChanged onFinish;

  @override
  State<StatefulWidget> createState() => PasswordState();
}


class PasswordState extends State<Password> {

  String letters = "";

  double _computeSize() {
    double width = MediaQuery.of(context).size.width - _kHorizontalPadding * 2;
    return math.min(_kMaxSize, width / widget.count) - _kStrokeWidth * 2;
  }

  void clear() {
    letters = '';
    setState(() {
    });
  }

  String get value => letters;

  ///
  /// ['7', '8', '9'],
  /// ['4', '5', '6'],
  /// ['1', '2', '3'],
  /// [null, '0', 'Del']
  Widget _buildKeyboard() {
    List<Widget> keys = <Widget>[];
    for (var number in [7, 8, 9, 4, 5, 6, 1, 2, 3]) {
      keys.add(_buildNumber(number));
    }
    // null
    keys.add(Container(width: _kKeyboardSize, height: _kKeyboardSize,));
    keys.add(_buildNumber(0));
    keys.add(_buildDel());

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          children: <Widget>[keys[0], keys[1], keys[2]],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
        Row(
          children: <Widget>[keys[3], keys[4], keys[5]],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
        Row(
          children: <Widget>[keys[6], keys[7], keys[8]],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
        Row(
          children: <Widget>[keys[9], keys[10], keys[11]],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ],
    );
  }

  Widget _buildDel() {
    return RawMaterialButton(
      shape: StadiumBorder(),
      onPressed: letters.isEmpty ? null : () {
        letters = letters.substring(0, letters.length - 1);
        setState(() {
        });
      },
      constraints: BoxConstraints(
        minHeight: _kKeyboardSize,
        maxHeight: _kKeyboardSize,
        minWidth: _kKeyboardSize,
        maxWidth: _kKeyboardSize,
      ),
      child: Icon(Icons.close),
    );
  }

  Widget _buildNumber(int number) {
    return RawMaterialButton(
      shape: StadiumBorder(),
      constraints: BoxConstraints(
        minHeight: _kKeyboardSize,
        maxHeight: _kKeyboardSize,
        minWidth: _kKeyboardSize,
        maxWidth: _kKeyboardSize,
      ),
      onPressed: letters.length == widget.count ? null: () {
        letters += '$number';
        setState(() {
        });
        if (letters.length == widget.count && widget.onFinish != null) {
          widget.onFinish(this);
        }
      },
      child: Text('$number', style: TextStyle(fontSize: _kKeyboardSize / 2),),
    );
  }

  Widget _buildDisplay() {
    double size = _computeSize();
    BorderSide borderSide = BorderSide(
      color: _kBorderColor,
      width: _kStrokeWidth,
    );

    Widget passwordArea = Container(
      width: MediaQuery.of(context).size.width,
      height: _kSize,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.count, (index) {
              return Container(
                height: size,
                width: size,
                decoration: BoxDecoration(
                  border: () {
                    if (index == 0 || index == widget.count - 1) {
                      return Border(
                        top: borderSide,
                        left: borderSide,
                        bottom: borderSide,
                        right: borderSide
                      );
                    }
                    if (index == widget.count - 2) {
                      return Border(
                        top: borderSide,
                        bottom: borderSide,
                      );
                    }
                    return Border(
                      top: borderSide,
                      bottom: borderSide,
                      right: borderSide,
                    );
                  }(),
                  borderRadius: index == 0
                      ? BorderRadius.only(topLeft: Radius.circular(_kRadius), bottomLeft: Radius.circular(_kRadius))
                      : (index + 1 == widget.count ? BorderRadius.only(topRight: Radius.circular(_kRadius), bottomRight: Radius.circular(_kRadius)) : null),
                ),
                child: index < letters.length ? Center(child: Text('*')) : null,
              );
            })
          ),
        ),
    );

    return Column(
      children: <Widget>[
        passwordArea,
        SizedBox(height: _kHorizontalPadding * 2,),
        _buildKeyboard(),
        Container(
          height: 250.0,
          color: Colors.red,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDisplay();
  }
}