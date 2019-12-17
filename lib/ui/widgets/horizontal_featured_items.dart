import 'package:flutter/material.dart';

class HorizontalFeaturedItems extends StatelessWidget {
  final int initialPage;
  final double aspectRatio;
  final double viewportFraction;
  final EdgeInsetsGeometry padding;
  final SliverChildDelegate childrenDelegate;

  HorizontalFeaturedItems({
    Key key,
    this.initialPage: 0,
    this.aspectRatio: 1.0,
    this.viewportFraction: 1.0,
    this.padding,
    @required IndexedWidgetBuilder itemBuilder,
    int itemCount,
    bool addAutomaticKeepAlives: true,
    bool addRepaintBoundaries: true,
  })
    : childrenDelegate = new SliverChildBuilderDelegate(
    itemBuilder,
    childCount: itemCount,
    addAutomaticKeepAlives: addAutomaticKeepAlives,
    addRepaintBoundaries: addRepaintBoundaries,
  ),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final double itemWidth = (constraints.maxWidth - padding.horizontal) * this.viewportFraction;
      final double itemHeight = (itemWidth * this.aspectRatio);
      return new Container(
        height: itemHeight,
        child: new ListView.custom(
          scrollDirection: Axis.horizontal,
          controller: new PageController(
            initialPage: this.initialPage,
            viewportFraction: this.viewportFraction,
          ),
          physics: const PageScrollPhysics(),
          padding: this.padding,
          itemExtent: itemWidth,
          childrenDelegate: this.childrenDelegate,
        ),
      );
    });
  }
}