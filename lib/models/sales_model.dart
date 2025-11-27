class Sales {
  final int? saleId;
  final String date;
  final String time;

  Sales({this.saleId, required this.date, required this.time});

  Map<String, dynamic> toMap(){
    return {
      'sale_id': saleId,
      'date': date,
      'time': time,
    };
  }

    // Convert Map → Sales (from DB)
  factory Sales.fromMap(Map<String, dynamic> map) {
    return Sales(
      saleId: map['sale_id'],
      date: map['date'],
      time: map['time'],
    );
  }
}