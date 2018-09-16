import 'package:flutter/material.dart';
import 'dart:async';


// ignore: must_be_immutable
class InteractiveList extends StatefulWidget {

  InteractiveList({
    Key key,
    @required this.itemBuilder,
    List<dynamic> data,
    bool pullDown,
    bool pullUp,
    this.loadMore,
    this.onLoadMore,
    this.onRefresh,
  }) :  pullDown = pullDown?? true,
        pullUp = pullUp?? true,
        super(key: key) {
    if (data != null) {
      this.data.addAll(data);
    }
  }

  final List<dynamic> data = <dynamic>[];
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScrollableState> _scrollableKey = GlobalKey<ScrollableState>();
  bool pullDown;
  bool pullUp;
  final RefreshCallback onRefresh;
  final IndexedWidgetBuilder itemBuilder;
  final Widget loadMore;
  final RefreshCallback onLoadMore;

  State state;

  @override
  State<StatefulWidget> createState() {
    state = InteractiveListState();
    return state;
  }

  Future<void> refresh() {
    Completer<void> completer = Completer();
    if (!pullDown) {
      completer.complete(null);
    } else {
      state.context.visitChildElements((element) {
        if (element.widget is RefreshIndicator) {
          RefreshIndicatorState refreshIndicatorState =
              (element as StatefulElement).state;

          refreshIndicatorState
            .show()
            .then((_) {
            completer.complete(null);
          });
        } else {
          completer.complete(null);
        }
      });
    }
    return completer.future;
  }

  void disablePullDown() {
    pullDown = false;
    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }

  void enablePullDown() {
    pullDown = true;
    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }

  void togglePullDown() {
    pullDown = !pullDown;
    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }

  void disablePullUp() {
    pullUp = false;
    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }

  void enablePullUp() {
    pullUp = true;
    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }

  void togglePullUp() {
    pullUp = !pullUp;
    // ignore: invalid_use_of_protected_member
    state.setState(() {});
  }

  void jumpTo(double value) {
    void visitor(element) {
      if (element.widget is ListView) {
        ListView listView = element.widget;
        listView.controller.jumpTo(value);
      } else {
        element.visitChildElements(visitor);
      }
    }

    state.context.visitChildElements(visitor);
  }

  Future<void> animateTo(double offset, {
    Duration duration,
    Curve curve,
  }) {
    if (curve == null) {
      curve = Curves.easeOut;
    }
    if (duration == null) {
      duration = Duration(milliseconds: 200);
    }

    Completer<void> completer = Completer<void>();
    void visitor(element) {
      if (element.widget is ListView) {
        element
          .widget
          .controller
          .animateTo(offset, duration: duration, curve: curve)
          .then((_) {
          completer.complete(null);
        });
      } else {
        element.visitChildElements(visitor);
      }
    }

    state.context.visitChildElements(visitor);
    return completer.future;
  }

  Future<ScrollPosition> getScrollPosition() {
    Completer<ScrollPosition> completer = Completer<ScrollPosition>();

    void visitor(element) {
      if (element is StatefulElement && element.state is ScrollableState) {
        ScrollableState scrollableState = element.state;
        completer.complete(scrollableState.position);
      } else {
        element.visitChildElements(visitor);
      }
    }
    state.context.visitChildElements(visitor);
    return completer.future;
  }


}


class InteractiveListState extends State<InteractiveList> {


  ScrollController scrollController;
  bool showLoadMore = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    if (widget.pullUp) {
      scrollController.addListener(_handlePullUp);
    }
  }

  void _handlePullUp() async {
    if (scrollController.offset == scrollController.position.maxScrollExtent) {
      if (showLoadMore) {
        return;
      }
      showLoadMore = true;
      setState(() {
      });

      await (widget.onLoadMore?? () async {
        return Future<void>.delayed(Duration(milliseconds: 300));
      })();

      showLoadMore = false;
      setState(() {
      });

    }
  }

  @override
  void dispose() {
    if (widget.pullUp) {
      scrollController.removeListener(_handlePullUp);
    }
    scrollController.dispose();
    super.dispose();
  }

  Widget _buildListView() {
    return ListView.builder(
      controller: scrollController,
      key: widget._scrollableKey,
      itemCount: widget.data.length + 1,
      itemBuilder: (context, index) {
        if (index < widget.data.length) {
          return widget.itemBuilder(context, index);
        }
        return showLoadMore
            ? widget.loadMore?? Container(child: Text('loading...'))
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pullDown) {
      return RefreshIndicator(
        key: widget._refreshKey,
        child: _buildListView(),
        onRefresh: widget.onRefresh?? () {
          Completer<void> completer = Completer<void>();
          Timer(Duration(milliseconds: 300), () {
            completer.complete(null);
          });
          return completer.future;
        },
      );
    }
    return _buildListView();
  }
}