import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';
import '../widgets/main_drawer.dart';
import '../screens/add_and_edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false).getAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild....');
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'hero-fab',
        backgroundColor: Colors.purple,
        icon: Icon(Icons.add),
        label: Text('Add Product'),
        onPressed: () => Navigator.of(context).pushNamed(AddAndEditProductScreen.routeName),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      // drawer: MainDrawer(),
      appBar: AppBar(title: Text('Your Products'), elevation: 0, centerTitle: true),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Consumer<ProductsProvider>(
                  builder: (ctx, productsData, child) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: productsData.items.length,
                      itemBuilder: (ctx, i) => Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(productsData.items[i].imageUrl),
                            ),
                            title: Text(productsData.items[i].title),
                            trailing: Container(
                              width: 100,
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.purple,
                                    ),
                                    onPressed: () => Navigator.of(context).pushNamed(
                                        AddAndEditProductScreen.routeName,
                                        arguments: productsData.items[i].id),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        productsData.deleteProduct(productsData.items[i].id),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
