part of 'building-material_pages.dart';

class BuildingMaterialCategoriesPage extends StatelessWidget {
  final _service = BuildingMaterialsRest();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(hideHome: true),
      body: LiveScrollableView<BuildingMaterialBase>(
        title: 'Building Material',
        subtitle: loremIpsum.substring(0, 70),
        loader: () => _service.getCategories(),
        builder: (context, BuildingMaterialBase data) {
          return ProductListTile(
            name: data.name,
            image: data.image.name,
            onTap: () => navigateTo(context, BuildingMaterialSubCategoriesPage(data)),
          );
        },
      ),
    );
  }
}

class BuildingMaterialSubCategoriesPage extends StatelessWidget {
  final BuildingMaterialBase product;
  final _service = BuildingMaterialsRest();
  BuildingMaterialSubCategoriesPage(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(hideHome: true),
      body: LiveScrollableView<BuildingMaterialBase>(
        title: 'Building Material',
        subtitle: loremIpsum.substring(0, 70),
        loader: () => _service.getSubCategories(product.id),
        builder: (context, BuildingMaterialBase data) {
          return ProductListTile(
            name: data.name,
            image: data.image.name,
            onTap: () => navigateTo(context, BuildingMaterialsPage(data)),
          );
        },
      ),
    );
  }
}

class BuildingMaterialsPage extends StatelessWidget {
  BuildingMaterialsPage(this.product);

  final BuildingMaterialBase product;
  final _service = BuildingMaterialsRest();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HaweyatiAppBar(),
      body: LiveScrollableView<BuildingMaterial>(
        title: product.name,
        subtitle: product.description,
        loader: () => _service.get(AppData().city, product.id),
        builder: (context, BuildingMaterial data) {
          return ProductListTile(
            name: data.name,
            image: data.image.name,
            detail: '${data.price12} - ${data.price20} SAR',
            onTap: () => navigateTo(context, BuildingMaterialPage(data)),
          );
        },
      ),
    );
  }
}

class BuildingMaterialPage extends StatelessWidget {
  final BuildingMaterial item;
  BuildingMaterialPage(this.item);

  @override
  Widget build(BuildContext context) {
    return ProductDetailView(
      shareableData: ShareableData(
        id: item.id,
        type: OrderType.dumpster,
        socialMediaTitle: item.name,
        socialMediaDescription: item.description
      ),
      title: item.name,
      image: item.image.name,
      price: TextSpan(
        text: ''
            '${item.price12?.toStringAsFixed(2)} SAR - '
            '${item.price20?.toStringAsFixed(2)} SAR',
        style: TextStyle(color: Color(0xFF313F53)),
        children: [
          TextSpan(
            text: '   per container',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade600,
            ),
          )
        ],
      ),
      bottom: FlatActionButton(
        label: 'Buy Now',
        onPressed: () =>
            navigateTo(context, BuildingMaterialOrderSelectionPage(item)),
      ),
    );
  }
}
