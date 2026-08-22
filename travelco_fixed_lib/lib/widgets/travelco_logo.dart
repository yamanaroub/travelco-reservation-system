import 'package:flutter/material.dart';

class TravelcoLogo extends StatelessWidget {
  const TravelcoLogo({
    super.key,
    this.size = 78,
    this.showName = true,
    this.light = false,
  });

  final double size;
  final bool showName;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final Color foreground = light ? Colors.white : const Color(0xFF0F4C81);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: light ? Colors.white.withOpacity(0.16) : Colors.white,
            borderRadius: BorderRadius.circular(size * 0.28),
            boxShadow: light
                ? null
                : const [
                    BoxShadow(
                      color: Color(0x1A0F172A),
                      blurRadius: 24,
                      offset: Offset(0, 10),
                    ),
                  ],
          ),
          child: Icon(
            Icons.directions_bus_rounded,
            color: foreground,
            size: size * 0.58,
          ),
        ),
        if (showName) ...[
          const SizedBox(height: 14),
          Text(
            'TRAVELCO',
            style: TextStyle(
              color: foreground,
              fontSize: size * 0.27,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.2,
            ),
          ),
        ],
      ],
    );
  }
}
