import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/item_detail_screen.dart';
import 'package:money2/money2.dart';

class NewScreen extends StatelessWidget {
  NewScreen({super.key});

  final Currency selectedCurrency = Currency.create('TRY', 2, symbol: '₺');

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = List.generate(
      50,
      (i) {
        final int blockNumber = (i ~/ 2) + 1;
        final String suffix = (i % 2 == 0) ? '' : 'a';
        return {
          'title': 'Zeta Park Blok 1/$blockNumber$suffix',
          'subtitle': 'Aidat ödeme ve Ek Ödeme Bilgileri.',
        };
      },
    );

    final List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.amber,
      Colors.indigo,
      Colors.lime,
      Colors.pink,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blok Listesi'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Container(
                color: Colors.black,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.house,
                          size: 60,
                          color: colors[index % colors.length],
                        ),
                        title: Text(
                          items[index]['title']!,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(items[index]['subtitle']!),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItemDetailScreen(
                                title: items[index]['title']!,
                                subtitle: items[index]['subtitle']!,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
