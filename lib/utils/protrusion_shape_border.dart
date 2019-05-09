enum ProtrusionDirection {
  left,
  top,
  right,
  bottom,
}

class ProtrusionShapeBorder extends ShapeBorder {
  const ProtrusionShapeBorder({this.direction = ProtrusionDirection.left})
      : assert(direction != null);

  /// The direction of triangle.
  final ProtrusionDirection direction;

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.zero;
  }

  @override
  ShapeBorder scale(double t) => this;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    ProtrusionDirection direction = this.direction;
    if (textDirection == TextDirection.rtl && direction == ProtrusionDirection.left) {
      direction = ProtrusionDirection.right;
    }

    if (textDirection == TextDirection.rtl && direction == ProtrusionDirection.right) {
      direction = ProtrusionDirection.left;
    }

    double x1, y1, x2, y2;
    x1 = rect.topLeft.dx;
    y1 = rect.topLeft.dy;
    x2 = rect.bottomRight.dx;
    y2 = rect.bottomRight.dy;
    double height = y2 - y1;
    double width = x2 - x1;
    double triangleWidth = 8;
    double triangleHeight = 12;

    switch (direction) {
      case ProtrusionDirection.left:
        return Path()
          ..lineTo(x1 + 8, y1)
          ..lineTo(x2 - 8, y1)
          ..conicTo(x2, y1, x2, y1 + 8, 1) // top right arch
          ..lineTo(x2, y2 - 8)
          ..conicTo(x2, y2, x2 - 8, y2, 1) // bottom right arch
          ..lineTo(x1 + 8, y2)
          ..conicTo(x1, y2, x1, y2 - 8, 1) // bottom left arch
          // draw left triangle
          ..lineTo(x1, y1 + height / 2 - triangleWidth / 2)
          ..lineTo(x1 - triangleHeight, y1 + height / 2)
          ..lineTo(x1, y1 + height / 2 + triangleWidth / 2)
          // end draw left triangle
          ..lineTo(x1, y1 + 8)
          ..conicTo(x1, y1, x1 + 8, y1, 1); // top left arch

      case ProtrusionDirection.top:
        return Path()
          ..lineTo(x1 + 8, y1)
          // draw top triangle
          ..lineTo(x1 + width / 2 - triangleWidth / 2, y1)
          ..lineTo(x1 + width / 2, y1 - triangleHeight)
          ..lineTo(x1 + width / 2 + triangleWidth / 2, y1)
          // end draw top triangle
          ..lineTo(x2 - 8, y1)
          ..conicTo(x2, y1, x2, y1 + 8, 1) // top right arch
          ..lineTo(x2, y2 - 8)
          ..conicTo(x2, y2, x2 - 8, y2, 1) // bottom right arch
          ..lineTo(x1 + 8, y2)
          ..conicTo(x1, y2, x1, y2 - 8, 1) // bottom left arch
          ..lineTo(x1, y1 + 8)
          ..conicTo(x1, y1, x1 + 8, y1, 1); // top left arch

      case ProtrusionDirection.right:
        return Path()
          ..lineTo(x1 + 8, y1)
          ..lineTo(x2 - 8, y1)
          ..conicTo(x2, y1, x2, y1 + 8, 1) // top right arch
          // draw top triangle
          ..lineTo(x2, y1 + height / 2 - triangleWidth / 2)
          ..lineTo(x2 + triangleHeight, y1 + height / 2)
          ..lineTo(x2, y1 + height / 2 + triangleWidth / 2)
          // end draw top triangle
          ..lineTo(x2, y2 - 8)
          ..conicTo(x2, y2, x2 - 8, y2, 1) // bottom right arch
          ..lineTo(x1 + 8, y2)
          ..conicTo(x1, y2, x1, y2 - 8, 1) // bottom left arch
          ..lineTo(x1, y1 + 8)
          ..conicTo(x1, y1, x1 + 8, y1, 1); // top left arch

      case ProtrusionDirection.bottom:
        return Path()
          ..lineTo(x1 + 8, y1)
          ..lineTo(x2 - 8, y1)
          ..conicTo(x2, y1, x2, y1 + 8, 1) // top right arch
          ..lineTo(x2, y2 - 8)
          ..conicTo(x2, y2, x2 - 8, y2, 1) // bottom right arch
          // draw top triangle
          ..lineTo(x1 + width / 2 + triangleWidth / 2, y2)
          ..lineTo(x1 + width / 2, y2 + triangleHeight)
          ..lineTo(x1 + width / 2 - triangleWidth / 2, y2)
          // end draw top triangle
          ..lineTo(x1 + 8, y2)
          ..conicTo(x1, y2, x1, y2 - 8, 1) // bottom left arch
          ..lineTo(x1, y1 + 8)
          ..conicTo(x1, y1, x1 + 8, y1, 1); // top left arch
    }
    throw Exception('Not Reached');
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}
}
