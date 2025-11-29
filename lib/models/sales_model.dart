class Sales {
  final int? id;
  final String date;
  final String time;

  Sales({this.id, required this.date, required this.time});

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'date': date,
      'time': time,
    };
  }

    // Convert Map → Sales (from DB)
  factory Sales.fromMap(Map<String, dynamic> map) {
    return Sales(
      id: map['id'],
      date: map['date'],
      time: map['time'],
    );
  }
}