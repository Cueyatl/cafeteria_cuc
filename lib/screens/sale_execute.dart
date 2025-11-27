// lib/pages/product_list_page.dart
import 'package:flutter/material.dart';
import 'package:cafeteria_cuc/services/database_helper.dart';
import 'package:cafeteria_cuc/models/product_model.dart';
import 'package:cafeteria_cuc/widgets/bottom_card_widget.dart';
import 'package:cafeteria_cuc/widgets/product_list_general_widget.dart';
import 'package:cafeteria_cuc/widgets/plus_minus_number_i_widget.dart';
import 'package:cafeteria_cuc/models/sales_model.dart';
import 'package:cafeteria_cuc/models/sale_detail_model.dart';

class ProductSale extends StatefulWidget {
  const ProductSale({super.key});

  @override
  ProductSaleState createState() => ProductSaleState();
}

class ProductSaleState extends State<ProductSale> {


  late Future<List<Product>> _productList;
  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _productList = DatabaseHelper.instance.readProducts();
      _productList.then((products) {
        _productListData = products;
        for (var product in products) {
          _quantities[product.id!] = 0;
        }
        setState(() {}); // refresh UI after loading products
      });
    });
  }

  

double get totalPrice {
  if (_productListData.isEmpty) return 0;
  double total = 0;
  _quantities.forEach((productId, quantity) {
    final product = _productListData.firstWhere((p) => p.id == productId);
    total += product.price * quantity;
  });
  return total;
}

  

  List<Product> _productListData = [];

  Map<int, int> _quantities = {}; // key: product.id, value: quantity

Future<void> _registerSale() async {
  // 1. Validate that user selected at least one product
  if (_quantities.values.every((q) => q == 0)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Selecciona al menos un producto')),
    );
    return;
  }

  // 2. Create the sale entry (with current date/time)
  final now = DateTime.now();
  final sale = Sales(
    date: "${now.year}-${now.month}-${now.day}",
    time: "${now.hour}:${now.minute}:${now.second}",
  );

  // 3. Insert the sale into DB and get its ID
  final saleId = await DatabaseHelper.instance.createSale(sale);

  // 4. For each selected product, insert a sale_detail row
  for (var entry in _quantities.entries) {
    final productId = entry.key;
    final quantity = entry.value;

    if (quantity > 0) {
      // Find product info to calculate subtotal
      final product = _productListData.firstWhere((p) => p.id == productId);
      final subtotal = product.price * quantity;

      // Create sale detail entry
      final salesDetail = SalesDetail(
        saleId: saleId,
        productId: productId,
        quantity: quantity,
        total: subtotal,
      );

      // Insert into sales_detail
      await DatabaseHelper.instance.createSalesDetail(salesDetail);
    }
  }

  // 5. Reset form quantities and confirm
  setState(() {
    _quantities.updateAll((key, value) => 0);
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Venta registrada correctamente' )),
  );
  
  print("✅ Sale $saleId , $_quantities registered successfully");
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cobrar')),
      body: Center(
        child: ReusableProductList(
          productList: _productList,
          rowContentBuilder: (product) {
            return Row(
              children: [
                //Aumenta o diminuye cantidad de productos
                NumberInput(
                  initialValue: _quantities[product.id!] ?? 0,
                  onChanged: (newValue) {
                    setState(() {
                      _quantities[product.id!] = newValue;
                    });
                  },
                ),
                const SizedBox(width: 16),
              
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total: \$${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
  ElevatedButton(
    child: const Text('Cobrar'),
    onPressed: () async {
      // Wait until the sale and details are fully inserted
      await _registerSale();

      // Navigate back to home or main page
     
  Navigator.pop(context, true); // true = sale was registered
}

    
  ),
],


            ),
          ],
        ),
      ),
    );
  }
}
