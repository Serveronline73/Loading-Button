import 'package:flutter/material.dart';

class CustomStarCard extends StatelessWidget {
  const CustomStarCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 180,
        height: 200,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFF22), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              offset: const Offset(0, 25),
              blurRadius: 25,
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.star, // Replace with your desired icon
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 40,
                color: Colors.white.withValues(alpha: 0.05),
                child: const Center(
                  child: Text(
                    'Your Text Here', // Replace with your desired text
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
