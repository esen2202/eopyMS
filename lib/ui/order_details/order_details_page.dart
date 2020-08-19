import 'package:eopy_management_system/http/order_detail_service.dart';
import 'package:eopy_management_system/models/order.dart';
import 'package:eopy_management_system/models/order_detail.dart';
import 'package:eopy_management_system/ui/order_details/dialog/order_detail_delete_dialog.dart';
import 'package:flutter/material.dart';

import 'dialog/order_detail_form_dialog.dart';

class OrderDetailsPage extends StatefulWidget {
  final Order order;

  OrderDetailsPage({Key key, @required this.order}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final GlobalKey<ScaffoldState> _scaffoldDetailKey =
      new GlobalKey<ScaffoldState>();
  OrderDetailService _orderDetailService;
  Future<List<OrderDetail>> getOrderDetails;
  List<OrderDetail> _orderDetails;
  int orderDetailCount = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _orderDetailService = OrderDetailService();
    _orderDetails = List<OrderDetail>();
    getOrderDetailList();
    super.initState();
  }

  void getOrderDetailList() {
    getOrderDetails = _orderDetailService.getOrderDetails(widget.order.id);
    getOrderDetails.then((value) {
      _orderDetails = value;
      orderDetailCount = value.length;
      refreshPage();
    });
  }

  void refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldDetailKey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("${widget.order.name} - $orderDetailCount Kalem"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () async {
              OrderDetail _orderDetail =
                  new OrderDetail(orderId: widget.order.id);

              var result = showDialog(
                context: context,
                builder: (BuildContext context) =>
                    OrderDetailFormDialog(orderDetail: _orderDetail),
              );
              result.then(
                (value) async {
                  if (value != null && value) {
                    bool any = _orderDetails.any((element) =>
                        element.stockCode == _orderDetail.stockCode);
                    if (!any) {
                      await _orderDetailService
                          .addOrderDetail(_orderDetail)
                          .then(
                        (value) {
                          getOrderDetailList();
                        },
                      );
                    } else {
                      var snackBar =
                          _scaffoldDetailKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text("Eklenmedi. Zaten mevcut!"),
                          duration: Duration(microseconds: 5000),
                        ),
                      );

                      snackBar.closed.then((onValue) {
                        //Navigator.pop(context, "");
                      });
                    }
                  }
                },
              );
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          FutureBuilder(
            future: _orderDetailService.getOrderDetails(widget.order.id),
            builder: (BuildContext context,
                AsyncSnapshot<List<OrderDetail>> snapshot) {
              if (snapshot.hasData && snapshot.data.length == 0) {
                return Center(child: Text("Kalem bilgisi bulunamadı!"));
              }

              if (snapshot.hasData) {
                return ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    OrderDetail orderDetail = snapshot.data[index];

                    return GestureDetector(
                      child: Dismissible(
                        key: UniqueKey(),
                        background: slideRightBackground(),
                        secondaryBackground: slideLeftBackground(),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  OrderDetailDeleteDialog(
                                      orderdDetail: orderDetail),
                            );
                          } else {
                            bool result = await showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  OrderDetailFormDialog(
                                      orderDetail: orderDetail),
                            );

                            if (result != null && result) {
                              await _orderDetailService
                                  .updateOrderDetail(orderDetail)
                                  .then(
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
                            orderDetail.status = "isDeleted";
                            await _orderDetailService
                                .updateOrderDetail(orderDetail);
                            setState(() {});
                          }
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text((index + 1).toString()),
                          ),
                          title: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(orderDetail.stockCode),
                              ],
                            ),
                          ),
                          trailing: Text(orderDetail.amount.toString(),
                              style:
                                  TextStyle(color: Colors.red, fontSize: 16)),
                          subtitle: Text(
                            orderDetail.stockName,
                          ),
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
