import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const cardColors = [Color(0xFFFFD60A), Color(0xFF1DE9B6), Color(0xFF2196F3)];
const cardNumbers = ['7642', '5123', '3413'];

// The 3 strips on the right edge of the home page
class CardStrips extends StatelessWidget {
  const CardStrips({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 150,
      child: Stack(
        children: [
          for (var i = 2; i >= 0; i--)
            Positioned(
              left: i * 14.0,
              top: 0,
              bottom: 0,
              width: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: cardColors[i],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// The cards page that slides over the home page
class CardsPage extends StatelessWidget {
  final Animation<double> progress;
  final GestureDragUpdateCallback onDragUpdate;
  final GestureDragEndCallback onDragEnd;
  final VoidCallback onClose;

  const CardsPage({
    super.key,
    required this.progress,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // dragging right on this page pushes it back closed
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
      child: Container(
        color: const Color(0xFF111315),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onClose,
                      child: const Icon(
                        CupertinoIcons.back,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Cards',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Order a card',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: 3,
                    separatorBuilder: (_, __) => const SizedBox(height: 24),
                    itemBuilder: (_, i) => AnimatedBuilder(
                      animation: progress,
                      builder: (_, child) {
                        // each card starts moving a little later than the one above it
                        final start = i * 0.15;
                        final t = Curves.easeOut.transform(
                          ((progress.value - start) / (1 - start)).clamp(
                            0.0,
                            1.0,
                          ),
                        );
                        return Opacity(
                          opacity: t,
                          child: Transform.translate(
                            offset: Offset((1 - t) * 120, 0),
                            child: child,
                          ),
                        );
                      },
                      child: DigitalCard(index: i),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// One big card
class DigitalCard extends StatelessWidget {
  final int index;
  const DigitalCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final color = cardColors[index];
    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.45),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Digital card',
                style: TextStyle(color: Colors.black54),
              ),
              Text(
                '•••• ${cardNumbers[index]}',
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              for (final icon in [
                CupertinoIcons.snow,
                CupertinoIcons.creditcard,
                CupertinoIcons.play_circle,
              ])
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
              const Spacer(),
              CupertinoSwitch(value: false, onChanged: (_) {}),
            ],
          ),
        ],
      ),
    );
  }
}
