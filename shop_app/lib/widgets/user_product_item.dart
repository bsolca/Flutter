import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/pages/edit_product_page.dart';
import 'package:shopapp/providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(
    this.id,
    this.title,
    this.imageUrl,
  );

  @override
  Widget build(BuildContext context) {
    final _scaffold = Scaffold.of(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductPage.routeName,
                  arguments: id,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () async {
                await Provider.of<Products>(context, listen: false)
                    .deleteProduct(id)
                    .catchError((err) {
                  _scaffold.showSnackBar(SnackBar(
                    backgroundColor: Theme.of(context).errorColor,
                      content: Text(
                    err,
                    textAlign: TextAlign.center,
                  )));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
