part of com.newt.components;


class AnimatedComponents extends StatefulWidget {

  final Widget begin;
  final Widget end;
  final Duration duration;
  final Axis axis;
  final ValueChanged<AnimationController> listener;

  AnimatedComponents({
    Key key,
    this.begin,
    this.end,
    this.duration: const Duration(milliseconds: 300),
    this.axis: Axis.vertical,
    this.listener,
  }) : assert(begin != null),
       assert(end != null),
       super(key: key);


  @override
  AnimatedComponentsState createState() => AnimatedComponentsState();
}



class AnimatedComponentsState extends State<AnimatedComponents> with SingleTickerProviderStateMixin {

  AnimationController _controller;

  TickerFuture forward() => _controller.forward();

  TickerFuture reverse() => _controller.reverse();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.addListener(() {
      if (widget.listener != null) {
        widget.listener(_controller);
      }
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scale = 2 * (_controller.value - 0.5).abs();

    return Transform(
      transform: (widget.axis == Axis.horizontal)
          ? (Matrix4.identity()..scale(scale, 1.0))
          : (Matrix4.identity()..scale(1.0, scale)),
      alignment: Alignment.center,
      child: _controller.value < 0.5 ? widget.begin : widget.end,
    );
  }

}