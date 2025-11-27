// lib/pages/product_list_page.dart
import 'package:flutter/material.dart';
import 'package:cafeteria_cuc/services/database_helper.dart';
import 'package:cafeteria_cuc/models/product_model.dart';
import 'package:cafeteria_cuc/screens/product_edit.dart';
import 'package:cafeteria_cuc/screens/product_add.dart';
import 'package:cafeteria_cuc/widgets/product_list_general_widget.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  ProductListPageState createState() => ProductListPageState();
}

class ProductListPageState extends State<ProductListPage> {
  late Future<List<Product>> _productList;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _productList = DatabaseHelper.instance.readProducts();
    });
  }

  void _deleteProduct(int product_id) async {
    await DatabaseHelper.instance.deleteProducts(product_id);
    _refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis productos')),

      body: ReusableProductList(
        productList: _productList,
        rowContentBuilder: (product) {
          return Row(
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteProduct(product.id!),
              ),
              TextButton.icon(
                icon: const Icon(Icons.edit, color: Colors.blue),
                label: const Text('Editar'),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductEditPage(product: product),
                    ),
                  );
                  if (result == 'updated') {
                    _refreshList();
                  }
                },
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddProductPage()),
          );
          _refreshList();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
