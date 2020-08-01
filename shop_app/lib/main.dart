import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/pages/auth_page.dart';
import 'package:shopapp/pages/cart_page.dart';
import 'package:shopapp/pages/edit_product_page.dart';
import 'package:shopapp/pages/orders_page.dart';
import 'package:shopapp/pages/product_detail_page.dart';
import 'package:shopapp/pages/products_overview_page.dart';
import 'package:shopapp/pages/user_products_page.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // TODO We don't use .value because it's a new object, we can use create
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(null, null, []),
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts.items == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(null, []),
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            previousOrders.orders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
          home: auth.isAuth ? ProductsOverviewPage() : AuthPage(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartPage.routeName: (ctx) => CartPage(),
            OrdersPage.routeName: (ctx) => OrdersPage(),
            UserProductsPage.routeName: (ctx) => UserProductsPage(),
            EditProductPage.routeName: (ctx) => EditProductPage(),
          },
        ),
      ),
    );
  }
}
