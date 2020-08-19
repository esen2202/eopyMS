class StockBarcode {
  int id;
  String barcode;
  String stockCode;
  String stockName;
  String detail;

  StockBarcode({
    this.id,
    this.barcode,
    this.stockCode,
    this.stockName,
    this.detail,
  });

  StockBarcode.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    barcode = json['Barcode'];
    stockCode = json['StockCode'];
    stockName = json['StockName'];
    detail = json['Detail'];
  }

  Map<String, dynamic> toJson() => {
        'Id': this.id,
        'Barcode': this.barcode,
        'StockName': this.stockName,
        'StockCode': this.stockCode,
        'Detail': this.detail,
      };
}
