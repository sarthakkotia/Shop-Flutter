import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/order.dart';
import '../Widgets/orderwidget.dart';
import '../Widgets/drawer.dart';

//we want that as soon as we enter the screen the orders should be fetched from the web and displayed
// so for that we need to access the init state of our screen hence
// change the screen to a stareful widget

//We are just changing the screen to stateful widget just because of the loading screen
// so there is an alternative where in this case we can make it stateless widget
// that is by using future builder
class OrderScreen extends StatelessWidget {
  static const routename = '/orders';
  const OrderScreen({super.key});
  // bool isloading = false;
  // @override
  // void initState() {
  //   isloading = true;
  //   // Provider.of<Orders>(context, listen: false).fetchorders();
  //   // Future.delayed(Duration.zero).then((_) async {
  //   Provider.of<Orders>(context, listen: false).fetchorders().then((value) {
  //     setState(() {
  //       isloading = false;
  //     });
  //   });
  //   super.initState();
  //   // });
  // }
  @override
  Widget build(BuildContext context) {
    // final orderdata = Provider.of<Orders>(context);
    return Scaffold(
      drawer: Drawerwidget(),
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body:
          // nwow future builder is a wicdget which is specialized in handling futures
          // If the content to be rendered depends ont eh future state then this widget is the best
          FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // the builder methods have a snapshot attribute
          // this snapshot have all the data which the future is need to have
          if (snapshot.connectionState == ConnectionState.waiting) {
            // if the connection state of the future is thatw e are waiting for an response ie essentially loading
            // then show our loading widget
            return Center(
              child: CircularProgressIndicator(
                // ignore: deprecated_member_use
                color: Theme.of(context).colorScheme.secondary,
              ),
            );
          } else {
            // else means that the connection state have got the response
            if (snapshot.error == null) {
              // this emans that we have got what we want with no error
              // but with this essentially we in an infinite loop because we are constantly calling thefucntion fetchorders and that is doing it's work
              // but att he end it's notifying the listeners in this case which is orderdata
              // hence rebuilding the app again
              //the solution is to use Consumer
              return Consumer<Orders>(
                builder: (context, orderdata, child) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return OrderWidget(orderdata.order[index]);
                    },
                    itemCount: orderdata.order.length,
                  );
                },
              );
            } else {
              return Text("An error occured");
            }
          }
        },
        // now here we define the future we want to listen to
        future: Provider.of<Orders>(context, listen: false).fetchorders(),
      ),
      // isloading == true
      //     ? Center(
      //         child: CircularProgressIndicator(
      //           color: Theme.of(context).accentColor,
      //         ),
      //       )
      //     : ListView.builder(
      //         itemBuilder: (context, index) {
      //           return OrderWidget(orderdata.order[index]);
      //         },
      //         itemCount: orderdata.order.length,
      //       ),
    );
  }
}
