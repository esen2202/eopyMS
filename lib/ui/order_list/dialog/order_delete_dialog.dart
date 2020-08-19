import 'package:eopy_management_system/models/order.dart';
import 'package:flutter/material.dart';

class OrderDeleteDialog extends StatelessWidget {
  final Order order;

  const OrderDeleteDialog({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(order.name),
      content: Text("Siparişi silmek istiyor musunuz?"),
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
