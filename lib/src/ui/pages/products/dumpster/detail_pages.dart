part of 'dumpster_pages.dart';

class DumpstersPage extends StatelessWidget {
  final _service = DumpstersRest();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(hideHome: true),
      body: LiveScrollableView<Dumpster>(
        title: 'Construction Dumpsters',
        subtitle: loremIpsum.substring(0, 70),
        loader: () => _service.get(AppData().city),
        builder: (context, data) => ProductListTile(
          name: '${data.name} Yards',
          image: data.image.name,
          onTap: () => navigateTo(context, DumpsterPage(data)),
        ),
      ),
    );
  }
}

class DumpsterPage extends StatelessWidget {
  final Dumpster dumpster;
  DumpsterPage(this.dumpster);

  @override
  Widget build(BuildContext context) {
    final title = '${dumpster.name} Yards Container';

    return ProductDetailView(
      shareableData: ShareableData(
        id: dumpster.id,
        type: OrderType.dumpster,
        socialMediaTitle: title,
        socialMediaDescription: dumpster.description
      ),
      title: title,
      image: dumpster.image.name,
      price: TextSpan(
        text: '${dumpster.pricing.first.rent.toStringAsFixed(2)} SAR',
        style: TextStyle(color: Color(0xFF313F53)),
        children: [
          TextSpan(
            text: '   per ${dumpster.pricing.first.days} days ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade600,
            ),
          )
        ],
      ),
      description: dumpster.description,
      bottom: RaisedActionButton(
        label: 'Buy Now',
        onPressed: () => navigateTo(
          context,
          DumpsterOrderSelectionPage(dumpster),
        ),
      ),
    );
  }
}
