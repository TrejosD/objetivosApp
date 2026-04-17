import 'package:flutter/material.dart';
import 'package:objetivos/infrastructure/entitites/momentum.dart';

class MomentumBar extends StatelessWidget {
  final Momentum momentum;
  const MomentumBar({super.key, required this.momentum});

  double calculateMomentumScore(Momentum m) {
    if (m.dailyRequired == 0) return 1;
    final raw = m.currentAverage / m.dailyRequired;
    return raw.clamp(0, 1.5);
  }

  @override
  Widget build(BuildContext context) {
    final score = calculateMomentumScore(momentum);
    final color = switch (momentum.type) {
      MomentumType.strong => Colors.green,
      MomentumType.normal => Colors.blue,
      MomentumType.risk => Colors.orange,
    };
    if (score > 1) {
      // todo aplicar box shadow animdado
      // el box shadow, iria en un container, revisar animacion!!!
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Momentum', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.green.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              height: 12,
              width: MediaQuery.of(context).size.width * score * 0.8,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
