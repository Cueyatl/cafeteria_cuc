import 'package:flutter/material.dart';
import 'package:cafeteria_cuc/models/product_model.dart';

class ReusableProductList extends StatelessWidget {
  final Future<List<Product>> productList;
  final Widget Function(Product) rowContentBuilder;
  

  const ReusableProductList({
    super.key,
    required this.productList,
    required this.rowContentBuilder,
    
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: productList,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = snapshot.data!;
        if (products.isEmpty) {
          return const Center(child: Text('Todavía no hay productos.'));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        rowContentBuilder(product),
                      ],
                    ),
                  );
                },
              ),
            ),
          
          ],
        );
      },
    );
  }
}
