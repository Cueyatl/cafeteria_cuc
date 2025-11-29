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

String get customerChange {
    if (_productListData.isEmpty) return '0'.toString();
    double change = 0;
    double receivedMoney = 200;
    change =  receivedMoney - totalPrice;
    if(totalPrice>receivedMoney){
      return 'Cantidad Insuficiente';
    }
    return 'Cambio: \$${change.toStringAsFixed(2)}';
  }
  

  List<Product> _productListData = [];
//MODED TO FINAL NEEDS TESTING.
  final Map<int, int> _quantities = {}; // key: product.id, value: quantity

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

  // 6. Navigate ONLY ONCE
  if (mounted) {
    Navigator.pushNamed(context, '/');
  }
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
            Text('Recibido', 
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            Text(
              customerChange,
              style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: customerChange == 'Cantidad Insuficiente' ? Colors.red : Colors.black,
  ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
  ElevatedButton(
    child: const Text('Cobrar'),
    onPressed: () async {
      // Wait until the sale and details are fully inserted
      await _registerSale();

      
      
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
