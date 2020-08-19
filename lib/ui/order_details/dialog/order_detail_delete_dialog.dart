import 'package:eopy_management_system/models/order_detail.dart';
import 'package:flutter/material.dart';

class OrderDetailDeleteDialog extends StatelessWidget {
  final OrderDetail orderdDetail;

  const OrderDetailDeleteDialog({Key key, this.orderdDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(orderdDetail.stockCode),
      content: Text("Kalemi silmek istiyor musunuz?"),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            "İptal",
            style: TextStyle(color: Colors.black87),
          ),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(
            "Sil",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.red,
        )
      ],
    );
  }
}
