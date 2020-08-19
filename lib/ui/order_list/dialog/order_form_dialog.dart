import 'package:eopy_management_system/models/order.dart';
import 'package:flutter/material.dart';

class OrderFormDialog extends StatefulWidget {
  final Order order;

  const OrderFormDialog({Key key, this.order}) : super(key: key);
  @override
  _OrderFormDialogState createState() => _OrderFormDialogState();
}

class _OrderFormDialogState extends State<OrderFormDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.order.id == null
          ? "Yeni Sipariş Ekle..."
          : "Siparişi Düzenle..."),
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: widget.order.name,
                      maxLength: 50,
                      onSaved: (value) => widget.order.name = value,
                      autofocus: true,
                      validator: (value) {
                        if (value == "") {
                          return "boş olamaz";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: widget.order.note,
                      maxLength: 100,
                      onSaved: (value) => widget.order.note = value,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              FlatButton(
                child: Text(
                  widget.order.id == null ? "Siparişi Ekle" : "Güncelle",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: _saveForm,
                color: Theme.of(context).accentColor,
              )
            ],
          ),
        )
      ],
    );
  }

  void _saveForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.pop(context, true);
      FocusScope.of(context).unfocus();
    }
  }
}
