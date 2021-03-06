import 'package:flutter/material.dart';
import 'package:flutter_application_20/providers/orders.dart' show Orders;
import 'package:flutter_application_20/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuture;
Future _obtainOrdersFuture() {
  return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
}

@override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building orders');
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      
      body: FutureBuilder(
        future: _ordersFuture,
         builder: (ctx, dataSnapshot) {
       if (dataSnapshot.connectionState == ConnectionState.waiting) {
       return Center(child: CircularProgressIndicator());
       } else {
         if (dataSnapshot.error != null) {
           // ...
           // Do error handling stuff
           return Center(
             child: Text('An error occurred!'),
           );
         } else {
         return Consumer<Orders>(
          builder: (ctx, orderData, child) => ListView.builder(
        itemCount: orderData.orders.length,
         itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
          ),
         ); 
         }
       }
      },),
    );
  }
}