import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/Widgets/badge.dart';
import 'package:flutter_ecommerce/screens/cart_screen.dart';
import 'package:provider/provider.dart';

import '../Widgets/app_drawer.dart';
import '../Widgets/products_grid.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

enum FilterOption { Favorites, All }

class ProductOverViewScreen extends StatefulWidget {
  @override
  State<ProductOverViewScreen> createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var _isLoading = false;
  var _showOnlyFavirites = false;

  @override
  void initState() {
    _isLoading = true;
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) => setState(() {
              _isLoading = false;
            }))
        .catchError(
          (_) => setState(() => _isLoading = false),
        );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
        actions: [
          PopupMenuButton(
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text("Only Favorites"),
                value: FilterOption.Favorites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOption.All,
              ),
            ],
            onSelected: (FilterOption selectval) {
              setState(() {
                if (selectval == FilterOption.Favorites) {
                  _showOnlyFavirites = true;
                } else {
                  _showOnlyFavirites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(_showOnlyFavirites),
      drawer: AppDrawer(),
    );
  }
}
