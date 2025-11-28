import 'package:flutter/material.dart';
import 'package:cafeteria_cuc/services/database_helper.dart';
import 'package:cafeteria_cuc/models/product_model.dart';
import 'package:cafeteria_cuc/widgets/product_general_edit_create_widget.dart';

class ProductEditPage extends StatefulWidget {
  final Product product;

  const ProductEditPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductEditPage> createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(text: widget.product.price.toString(),);
  }

  void _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = Product(
        id: widget.product.id,
        name: _nameController.text.trim(),
        price: double.parse(_priceController.text.trim()),
      );

      await DatabaseHelper.instance.updateProducts(updatedProduct);

      if (!mounted) return;
      //Updates the context so it refreshes the list.
      Navigator.pop(context, 'updated'); // Go back to an UPDATED the product list.
    }
  }

  @override
  Widget build(BuildContext context){
    return ProductForm(
      title: 'Editar producto',
      formKey: _formKey,
      nameController: _nameController, 
      priceController: _priceController, 
      buttonText: 'Guardar cambios',
      onSubmit: _updateProduct);
  }
}
