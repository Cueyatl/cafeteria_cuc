import 'package:flutter/material.dart';


class ProductForm extends StatelessWidget {
  final String title;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final String buttonText;
  final VoidCallback onSubmit;

  const ProductForm({
    super.key,
    required this.title,
    required this.formKey,
    required this.nameController,
    required this.priceController,
    required this.buttonText,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter price' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onSubmit,
                child: Text(buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
