part of 'single-scaffolding_pages.dart';

class SingleScaffoldingsPage extends StatelessWidget {
  final _service = SingleScaffoldingRest();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(hideHome: true),
      body: LiveScrollableView<SingleScaffolding>(
        title: 'Scaffolding',
        subtitle: loremIpsum.substring(0, 70),
        loader: () => _service.get(AppData().city),
        builder: (context, data) => ProductListTile(
          name: data.name,
          assetImage: true,
          image: "assets/images/singleScaffolding.png",
          onTap: () => navigateTo(context, SingleScaffoldingPage(data)),
        ),
      ),
    );
  }
}

class SingleScaffoldingPage extends StatelessWidget {
  final SingleScaffolding scaffolding;
  SingleScaffoldingPage(this.scaffolding);

  @override
  Widget build(BuildContext context) {
    final title = scaffolding.name;

    return ProductDetailView(
      shareableData: ShareableData(
        id: scaffolding.id,
        type: OrderType.scaffolding,
        socialMediaTitle: title,
        socialMediaDescription: scaffolding.description
      ),
      title: title,
      assetImage: true,
      image: "assets/images/singleScaffolding.png",
      price: TextSpan(
        text: '${scaffolding.rent.toStringAsFixed(2)} SAR ',
        style: TextStyle(color: Color(0xFF313F53)),
        children: [
          TextSpan(
            text: 'per ${scaffolding.days} days ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade600,
            ),
          )
        ],
      ),
      description: scaffolding.description,
      bottom: RaisedActionButton(
        label: 'Buy Now',
        onPressed: () => navigateTo(
          context,
          SingleScaffoldingSelectionPage(scaffolding),
        ),
      ),
    );
  }
}
