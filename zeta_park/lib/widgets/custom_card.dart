import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/role.dart';
import '../screens/new_screen.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.9),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF070F2D), Color(0xFF3A3C54)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF545A6A)),
            ),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kusadasi',
                    style: TextStyle(
                      color: Color(0xFF488AEC),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Zeta Park ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Villalari',
                    style: TextStyle(
                      color: Color(0xFF9799A7),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (context.watch<RoleManager>().admin)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewScreen()),
                            );
                          },
                          child: _buildButton(
                            color: const Color(0xFF488AEC),
                            shadowColor: const Color(0xFF488AEC)
                                .withAlpha((0.19 * 255).toInt()),
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            text: "Site Sakini",
                            subText: "Aylik Görüntüler",
                          ),
                        ),
                      if (context.watch<RoleManager>().admin)
                        const SizedBox(width: 10),
                      _buildButton(
                        color: Colors.white,
                        shadowColor: const Color(0xFF0B1625)
                            .withAlpha((0.19 * 255).toInt()),
                        textColor: Colors.black,
                        iconColor: Colors.black,
                        text: 'Ek Ödeme',
                        subText: 'Ödeme Yap',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildButton({
    required Color color,
    required Color shadowColor,
    required Color textColor,
    required Color iconColor,
    required String text,
    required String subText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -1,
          ),
          BoxShadow(
            color: shadowColor.withAlpha((0.17 * 255).toInt()),
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: -1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          SizedBox(
            height: 25,
            width: 25,
            child: Icon(Icons.star, color: iconColor),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              Text(
                subText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
