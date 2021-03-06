import 'package:eopy_management_system/http/order_service.dart';
import 'package:eopy_management_system/models/order.dart';
import 'package:eopy_management_system/ui/order_list/dialog/order_form_dialog.dart';
import 'package:eopy_management_system/ui/order_details/order_details_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dialog/order_delete_dialog.dart';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  OrderService _orderService;

  Future<List<Order>> getOrders;
  List<Order> _orders;
  int _orderCount = 0;

  @override
  void initState() {
    _orderService = OrderService();
    _orders = List<Order>();
    getOrderList();
    super.initState();
  }

  void getOrderList() {
    getOrders = _orderService.getOrders();
    getOrders.then((value) {
      _orders = value;
      _orderCount = value.length;
      refreshPage();
    });
  }

  void refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          title: Text("Siparişler - $_orderCount"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () async {
                Order _order = new Order();
                bool result = await showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      OrderFormDialog(order: _order),
                );
                if (result != null && result) {
                  await _orderService.addOrder(_order).then(
                    (value) {
                      getOrderList();
                    },
                  );
                }
              },
            )
          ],
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              getOrderList();
            },
            child: Stack(
              children: <Widget>[
                FutureBuilder(
                  future: _orderService.getOrders(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Order>> snapshot) {
                    if (snapshot.hasData && snapshot.data.length == 0) {
                      return Center(child: Text("Listeniz Boş!"));
                    }

                    if (snapshot.hasData) {
                      return ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Order order = snapshot.data[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetailsPage(
                                    order: order,
                                  ),
                                ),
                              );
                            },
                            child: Dismissible(
                              key: UniqueKey(),
                              background: slideRightBackground(),
                              secondaryBackground: slideLeftBackground(),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        OrderDeleteDialog(order: order),
                                  );
                                } else {
                                  bool result = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        OrderFormDialog(order: order),
                                  );

                                  if (result != null && result) {
                                    await _orderService.updateOrder(order).then(
                                      (value) {
                                        setState(() {});
                                      },
                                    );
                                  }
                                  return false;
                                }
                              },
                              onDismissed: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  order.status = "isDeleted";
                                  await _orderService.updateOrder(order);
                                  setState(() {});
                                }
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text((index + 1).toString()),
                                ),
                                title: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(order.name),
                                      Container(
                                        color: Colors.black54,
                                        padding: EdgeInsets.all(2),
                                        child: Text(
                                          DateFormat('yy-MM-dd (kk:mm)')
                                              .format(order.createdDateTime),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.amber),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Text(order.note),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Sil",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Text(" Düzenle ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.right),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
