import 'package:eopy_management_system/http/stock_service.dart';
import 'package:eopy_management_system/models/order_detail.dart';
import 'package:eopy_management_system/models/stock_barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class OrderDetailFormDialog extends StatefulWidget {
  final OrderDetail orderDetail;

  const OrderDetailFormDialog({Key key, this.orderDetail}) : super(key: key);
  @override
  _OrderDetailFormDialogState createState() => _OrderDetailFormDialogState();
}

class _OrderDetailFormDialogState extends State<OrderDetailFormDialog> {
  StockService _stockService;
  final _formKey = GlobalKey<FormState>();
  String barcodeText = "", stockDetail = "";
  TextEditingController _stockNameController, _stockCodeController;

  @override
  void dispose() {
    _stockNameController.dispose();
    _stockCodeController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _stockService = StockService();

    _stockNameController = TextEditingController();
    _stockNameController.text = widget.orderDetail.stockName;
    _stockCodeController = TextEditingController();
    _stockCodeController.text = widget.orderDetail.stockCode;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.orderDetail.id == null
          ? "Yeni Kalem Ekle..."
          : "Kalemi Düzenle..."),
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
                      enabled: widget.orderDetail.id == null,
                      controller: _stockCodeController,
                      //initialValue: widget.orderDetail.stockCode,
                      decoration: new InputDecoration(
                          hintText: "Stok Kodu", helperText: "$barcodeText"),
                      maxLength: 50,
                      onSaved: (value) => widget.orderDetail.stockCode = value,
                      //autofocus: true,
                      validator: (value) {
                        if (value == "") {
                          return "boş olamaz";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _stockNameController,
                      //initialValue: widget.orderDetail.stockName,
                      decoration: new InputDecoration(
                          hintText: "Stok İsmi", helperText: "$stockDetail"),
                      maxLength: 100,
                      onSaved: (value) => widget.orderDetail.stockName = value,
                      validator: (value) {
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: widget.orderDetail.amount.toString(),
                      decoration: new InputDecoration(suffixText: "Adet"),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onSaved: (value) =>
                          widget.orderDetail.amount = int.parse(value),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "boş olamaz";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    child: Text(
                      widget.orderDetail.id == null ? "Kalem Ekle" : "Güncelle",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _saveForm,
                    color: Theme.of(context).accentColor,
                  ),
                  widget.orderDetail.id == null
                      ? IconButton(
                          icon: Icon(Icons.camera),
                          onPressed: _captureCode,
                          color: Theme.of(context).accentColor,
                        )
                      : Container(),
                ],
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

  void _captureCode() async {
    barcodeText = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.DEFAULT);
    if (barcodeText == "-1") {
      barcodeText = "barkod okunamadı";
    } else {
      try {
        StockBarcode result = await _stockService.getStock(barcodeText);

        setState(() {
          _stockNameController.text = result.stockName;
          _stockCodeController.text = result.stockCode;
          stockDetail = result.detail;
        });
      } catch (e) {
        barcodeText = "hata oluştu";
      }
    }
  }
}
