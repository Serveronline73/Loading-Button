import 'package:flutter/material.dart';

import '../new_screen.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 350),
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewScreen()),
                  );
                },
                child: _buildButton(
                  color: const Color(0xFF488AEC),
                  shadowColor: const Color(0xFF488AEC).withValues(alpha: 0.19),
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  text: 'Aidat Ödemesi',
                  subText: 'Aylik Görüntüleri',
                ),
              ),
              const SizedBox(width: 10),
              _buildButton(
                color: Colors.white,
                shadowColor: const Color(0xFF0B1625).withValues(alpha: 0.19),
                textColor: Colors.black,
                iconColor: Colors.black,
                text: 'Ek Ödeme',
                subText: 'Ödeme Yap',
              ),
            ],
          ),
        ],
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
            color: shadowColor.withValues(alpha: 0.17),
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
