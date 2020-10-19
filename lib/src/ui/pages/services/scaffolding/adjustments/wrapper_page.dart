import 'package:flutter/material.dart';
import 'package:haweyati/src/models/services/scaffolding/scaffolding-types.dart';
import 'package:haweyati/src/ui/views/scroll_view.dart';
import 'package:haweyati/src/utils/simple-future-builder.dart';
import 'package:haweyati/src/services/scaffolding_service.dart';
import 'package:haweyati/src/ui/widgets/buttons/raised-action-button.dart';

class WrapperPage extends StatefulWidget {
  final ScaffoldingType type;
  final void Function() onPressed;
  final List<Widget> Function(ScaffoldingPrice) builder;

  WrapperPage({
    this.type,
    this.builder,
    this.onPressed
  });

  @override
  _WrapperPageState createState() => _WrapperPageState();
}

class _WrapperPageState extends State<WrapperPage> {
  Future<ScaffoldingPrice> _pricing;
  final ScaffoldingService service = ScaffoldingService();

  @override
  void initState() {
    super.initState();

    switch (widget.type) {
      case ScaffoldingType.steel:
        _pricing = service.steelScaffoldingPrice();
        break;
      case ScaffoldingType.single:
        _pricing = service.singleScaffoldingPrice();
        break;
      case ScaffoldingType.patented:
        _pricing = service.patentedScaffoldingPrice();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleFutureBuilder(
      context: context,
      future: _pricing,
      builder: (context) => ScrollableView(
        showBackground: true,
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
        children: widget.builder(context.data),
        crossAxisAlignment: CrossAxisAlignment.start,
        bottom: RaisedActionButton(
          label: 'Rent Now',
          onPressed: widget.onPressed
        )
      ),
      errorBuilder: (value) {
        return Scaffold(
          body: Center(child: Text('Service not available')),
        );
      },
      waitingChild: Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
      noDataChild: Scaffold(
        body: Center(child: Text('Service not available')),
      ),
      noneChild: Scaffold(
        body: Center(child: Text('Service not available')),
      ),
      activeChild: Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
      unknownChild: Scaffold(
        body: Center(child: Text('Service not available')),
      ),
    );
  }
}
