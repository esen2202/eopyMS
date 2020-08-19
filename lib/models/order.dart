class Order {
  int id;
  String name;
  String note;
  DateTime createdDateTime;
  String status;

  Order({
    this.id,
    this.name,
    this.note,
    this.createdDateTime,
    this.status,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    note = json['Note'];
    createdDateTime = DateTime.parse(json['CreatedDateTime']);
    status = json['Status'];
  }

  Map<String, dynamic> toJson() => {
        'Id': this.id == null ? 0 : this.id,
        'Name': this.name,
        'Note': this.note,
        'CreatedDateTime': this.createdDateTime != null
            ? this.createdDateTime.toString()
            : DateTime.now().toString(),
        'Status': this.status == null ? "" : this.status,
      };
}
