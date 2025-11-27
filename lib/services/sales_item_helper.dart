class SaleItem {
  final int orderDetailId;
  final int quantity;
  final String date;
  final String name;
  final double price;

  SaleItem({
    required this.orderDetailId,
    required this.quantity,
    required this.date,
    required this.name,
    required this.price,
  });

  factory SaleItem.fromMap(Map<String, dynamic> m) => SaleItem(
    orderDetailId: m['order_detail_id'] as int,
    quantity: m['quantity'] as int,
    date: m['date'] as String,
    name: m['name'] as String,
    price: (m['price'] as num).toDouble(),
  );
}


/* 
   SELECT 
      sd.id AS order_detail_id,
      sd.quantity AS quantity,
      s.date AS date,
      p.name AS name,
      p.price AS price
  FROM saledetails sd
  JOIN sales s ON sd.sale_id = s.id
  JOIN products p ON sd.product_id = p.id
  WHERE sd.sale_id = ?;

  ''', [saleId]); */