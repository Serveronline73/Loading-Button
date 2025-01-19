import 'package:flutter/material.dart';
import 'package:flutter_application_1/repository/data_manager.dart';
import 'package:flutter_application_1/screens/item_detail_screen.dart';
import 'package:money2/money2.dart';

class NewScreen extends StatelessWidget {
  NewScreen({super.key});

  final Currency selectedCurrency =
      Currency.create('TRY', 2, symbol: '₺'); // Türkische währung in Lira
  final DataManager _dataManager = DataManager(); //

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = List.generate(
      // Liste von Blöcken
      50, // Anzahl der Blöcke
      (i) {
        final int blockNumber = (i ~/ 2) + 1; // Blocknummer berechnen
        final String suffix = (i % 2 == 0) ? '' : 'a'; // Suffix berechnen
        return {
          'title':
              'Zeta Park Blok 1/$blockNumber$suffix', // Blocktitel mit Blocknummer und Suffix
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
                  physics:
                      const NeverScrollableScrollPhysics(), // Scrollen deaktivieren
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final blockAmounts = _dataManager
                        .getBlockAmounts(); // Blockbeträge aus dem DataManager holen
                    return Card(
                      // Karte für jeden Block erstellen
                      child: ListTile(
                        // Liste für jeden Block erstellen
                        leading: Icon(
                          Icons.house,
                          size: 60,
                          color: colors[index %
                              colors
                                  .length], // Farbe für jeden Block aus der Liste wählen
                        ),
                        title: Text(
                          items[index]['title']!,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(items[index]['subtitle']!),
                        onTap: () {
                          // Karte klicken -> Blockdetails anzeigen
                          Navigator.push(
                            // Navigation zu ItemDetailScreen
                            context,
                            MaterialPageRoute(
                              // Navigation zu ItemDetailScreen
                              builder: (context) => ItemDetailScreen(
                                title: items[index]['title']!,
                                subtitle: items[index]['subtitle']!,
                                blockAmounts: blockAmounts,
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
