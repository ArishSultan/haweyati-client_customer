import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/src/data.dart';
import 'package:haweyati/src/models/services/dumpster/model.dart';

class DumpsterItemPage extends StatelessWidget {
  final Dumpster dumpster;

  DumpsterItemPage(this.dumpster) {
    dumpster.pricing.first = dumpster.pricing
      .firstWhere((element) => element.city == AppData.instance().city);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,

      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          bottom: TabBar(
            labelColor: Colors.white,
            indicator: RoundUnderlineTabIndicator(
              borderSide: BorderSide(width: 10, color: Colors.red),
              borderRadius: BorderRadius.circular(0),
            ),
            tabs: [
              Tab(child: Text('Tab1')),
              Tab(child: Text('Tab2')),
              Tab(child: Text('Tab3'))
            ]
          ),
        ),
        body: TabBarView(children: [
          Container(color: Colors.red),
          Container(color: Colors.blue),
          Container(color: Colors.green),
        ])
      )
    );
  }
}

class RoundUnderlineTabIndicator extends Decoration {
  final BorderSide borderSide;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry insets;

  const RoundUnderlineTabIndicator({
    this.borderRadius,
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
  }) : assert(borderRadius != null),
       assert(borderSide != null),
       assert(insets != null);

  // @override
  // Decoration lerpFrom(Decoration a, double t) {
  //   if (a is RoundUnderlineTabIndicator) {
  //     return RoundUnderlineTabIndicator(
  //       borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
  //       insets: EdgeInsetsGeometry.lerp(a.insets, insets, t),
  //     );
  //   }
  //   return super.lerpFrom(a, t);
  // }
  //
  // @override
  // Decoration lerpTo(Decoration b, double t) {
  //   if (b is RoundUnderlineTabIndicator) {
  //     return RoundUnderlineTabIndicator(
  //       borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
  //       insets: EdgeInsetsGeometry.lerp(insets, b.insets, t),
  //     );
  //   }
  //   return super.lerpTo(b, t);
  // }
  //
  // @override
  // _UnderlinePainter createBoxPainter([ VoidCallback onChanged ]) {
  //   return _UnderlinePainter(this, onChanged);
  // }

  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return _RoundUnderlinePainter(this, onChanged);
  }
}

class _RoundUnderlinePainter extends BoxPainter {
  _RoundUnderlinePainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  final RoundUnderlineTabIndicator decoration;

  BorderSide get borderSide => decoration.borderSide;
  EdgeInsetsGeometry get insets => decoration.insets;
  BorderRadius get borderRadius => decoration.borderRadius;

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    assert(rect != null);
    assert(textDirection != null);
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    return Rect.fromLTWH(
      indicator.left,
      indicator.bottom - borderSide.width,
      indicator.width,
      borderSide.width,
    );
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);

    final Rect rect = offset & configuration.size;
    final TextDirection textDirection = configuration.textDirection;

    final Rect _indicator = _indicatorRectFor(rect, textDirection).deflate(borderSide.width / 2.0);

    final RRect indicator = RRect.fromRectAndCorners(
      _indicatorRectFor(rect, textDirection).deflate(borderSide.width / 2.0),
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );

    final Paint paint = borderSide.toPaint()..strokeCap = StrokeCap.square;
    final path = Path()
      ..lineTo(_indicator.bottomLeft.dx, _indicator.bottomLeft.dy)
      ..lineTo(_indicator.bottomRight.dx, _indicator.bottomRight.dy);
      // ..lineTo(_indicator.bottomLeft, _indicator.bottomRight);
    // canvas.drawRRect(indicator, paint);
    // canvas.clipRRect(indicator);

    canvas.drawPath(path, paint);
  }
}
