import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ecommerce/Widgets/product_item.dart';
import 'package:flutter_ecommerce/providers/product.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  const ProductsGrid(
    this.showFavs,
  );

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = showFavs ? productData.favoritesItems : productData.items;
    return products.isEmpty
        ? Center(
            child: Text("There is no prouduct!"),
          )
        : GridView.builder(
            padding: EdgeInsets.all(10),
            itemBuilder: (ctx, i) => ChangeNotifierProvider(
              child: ProductItem(),
              create: (_) => products[i],
              builder: (_, wid) => wid,
            ),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
          );
  }
}
