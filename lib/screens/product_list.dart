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
      appBar: AppBar(
        title: const Text('Mis productos'),
        //Override automatic arrow
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Pointing to main
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),

      body: ReusableProductList(
        productList: _productList,
        rowContentBuilder: (product) {
          return Row(
            children: [
              //TRASHCAN ICON DELETES PRODUCT ITEM IN ROW
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteProduct(product.id!),
              ),
              //EDIT TEXT WITH ICON OPENS TAB TO MODIFY PRODUCT.
              TextButton.icon(
                icon: const Icon(Icons.edit, color: Colors.blue),
                label: const Text('Editar'),
                //ROUTE TO OPEN BUTTON.
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductEditPage(product: product),
                    ),
                  );
                  //TODO: requires an else clause.
                  if (result == 'updated') {
                    _refreshList();
                  }
                  else{
                    Text("no data, :/");
                  }
                },
              ),
            ],
          );
        },
      ),
      //ADD PRODUCT BUTTON
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
