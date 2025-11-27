// lib/pages/add_product_page.dart
import 'package:flutter/material.dart';
import 'package:cafeteria_cuc/services/database_helper.dart';
import 'package:cafeteria_cuc/models/product_model.dart';
import 'package:cafeteria_cuc/widgets/product_general_edit_create_widget.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  AddProductPageState createState() => AddProductPageState();
}

class AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  // Guardar nuevo producto
  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        name: _nameController.text.trim(),
        price: double.parse(_priceController.text.trim()),
      );

      await DatabaseHelper.instance.createProduct(product);

      if (!mounted) return;
      Navigator.pushNamed(context, '/product_list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProductForm(
      title: 'Agregar producto',
      formKey: _formKey,
      nameController: _nameController,
      priceController: _priceController,
      buttonText: 'Guardar cambios',
      onSubmit: _saveProduct);
  }
}
