class SalesDetail {
  final int? id;
  final int saleId;
  final int productId;
  final int quantity;
  final double total;

  SalesDetail({
    this.id,
    required this.saleId,
    required this.productId,
    required this.quantity,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sale_id': saleId,
      'product_id': productId,
      'quantity': quantity,
      'total': total,
    };
  }

  factory SalesDetail.fromMap(Map<String, dynamic> map) {
    return SalesDetail(
      id: map['id'],
      saleId: map['sale_id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      total: map['total'],
    );
  }
}

// 001, sales time, 