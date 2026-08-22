import 'package:flutter/material.dart';

class TravelcoLogo extends StatelessWidget {
  const TravelcoLogo({super.key, this.size = 78, this.showName = true, this.light = false});
  final double size;
  final bool showName;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final foreground = light ? Colors.white : const Color(0xFF0F4C81);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: light ? Colors.white.withOpacity(0.16) : Colors.white,
            borderRadius: BorderRadius.circular(size * 0.28),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size * 0.28),
            child: Image.asset(
              'assets/images/travelco_icon.png',
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (showName) ...[
          const SizedBox(height: 14),
          Text('TRAVELCO', style: TextStyle(color: foreground, fontSize: size * 0.27, fontWeight: FontWeight.w900, letterSpacing: 2.2)),
        ],
      ],
    );
  }
}
