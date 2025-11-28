import 'package:flutter/material.dart';
import 'package:cafeteria_cuc/services/database_helper.dart';

class SalesListWidget extends StatefulWidget {
  const SalesListWidget({super.key});

  @override
  State<SalesListWidget> createState() => _SalesListWidgetState();
}

class _SalesListWidgetState extends State<SalesListWidget> {
  late Future<List<Map<String, dynamic>>> _sales;

  @override
  void initState() {
    super.initState();
    _refreshSales();
  }

  void _refreshSales() {
    setState(() {
      _sales = DatabaseHelper.instance.readSales();
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _sales,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());

          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hay ventas registradas'));
            }

            final sales = snapshot.data!;
       
            print(snapshot.data);

            return ListView.builder(
              itemCount: sales.length,
              itemBuilder: (context, index) {
                final sale = sales[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      'Venta #${sale['sale_id']} - ${sale['date']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hora: ${sale['time']}'),
                        Text('Producto: ${sale['item_name']}'),
                        Text('Cantidad: ${sale['quantity']}'),
                        Text('Precio unitario: \$${sale['price']}'),
                      ],
                    ),
                    trailing: Text(
                      '\$${sale['total'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );

          default:
            return const SizedBox();
        }
      },
    );
  }
}
