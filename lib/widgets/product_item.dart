import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../provider/product.dart';
import '../provider/cart.dart';
import '../provider/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id);
          },
          child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder: AssetImage('assets/images/placeholder.png'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              )),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () => product.toggleFavoriteStatus(authData.token, authData.userId),
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text('Added to Cart!'),
                ),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () => cart.removeSingleItem(product.id),
                ),
                duration: Duration(seconds: 2),
              ));
            },
          ),
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
