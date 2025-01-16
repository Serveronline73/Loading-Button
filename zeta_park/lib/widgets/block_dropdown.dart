import 'package:flutter/material.dart';

class BlockDropdown extends StatelessWidget {
  final String selectedBlock;
  final ValueChanged<String?> onChanged;

  const BlockDropdown({
    Key? key,
    required this.selectedBlock,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> blocks = _generateBlocks();

    return DropdownButton<String>(
      value: selectedBlock,
      items: blocks.map((String block) {
        return DropdownMenuItem<String>(
          value: block,
          child: Text(block),
        );
      }).toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }

  List<String> _generateBlocks() {
    return List.generate(
      50,
      (i) {
        final int blockNumber = (i ~/ 2) + 1;
        final String suffix = (i % 2 == 0) ? '' : 'a';
        return 'Zeta Park Blok 1/$blockNumber$suffix';
      },
    );
  }
}
