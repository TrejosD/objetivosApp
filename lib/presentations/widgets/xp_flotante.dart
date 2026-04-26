import 'package:flutter/material.dart';

// "DEPRECATED"
class XpFlotante extends StatefulWidget {
  final int xp;
  const XpFlotante({super.key, required this.xp});

  @override
  State<XpFlotante> createState() => _XpFlotanteState();
}

class _XpFlotanteState extends State<XpFlotante>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(
      begin: 0,
      end: -40,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.4,
      left: MediaQuery.of(context).size.width * 0.5,
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, child) {
          return Transform.translate(
            offset: Offset(0, animation.value),
            child: Opacity(
              opacity: 1 - animation.value,
              child: Text(
                '+${widget.xp} XP',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
