import 'package:cafeteria_cuc/screens/product_add.dart';
import 'package:flutter/material.dart';
import 'package:cafeteria_cuc/screens/product_list.dart';
import 'package:cafeteria_cuc/widgets/bottom_card_widget.dart';
import 'package:cafeteria_cuc/widgets/circular_button_widget.dart';
import 'package:cafeteria_cuc/screens/sale_execute.dart';
import 'package:cafeteria_cuc/widgets/sale_list_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/': (context) => MyHomePage(title: ''),
        '/product_add': (context) => AddProductPage(),
        '/product_list': (context) => ProductListPage(),
        '/product_sale': (context) => ProductSale(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //"Go back arrow" deactivated
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              SalesListWidget(),
          ],
        ),
      ),
      bottomNavigationBar: BottomCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularButton(
              icon: Icons.inventory,
              label: 'Productos',
              onPressed: () {
                Navigator.pushNamed(context, '/product_list');
              },
            ),
            CircularButton(
              icon: Icons.attach_money,
              label: 'Cobrar',
              onPressed: () {
                Navigator.pushNamed(context, '/product_sale');
              },
            ),
            
          ],
        ),
      ),
    );
  }
}
