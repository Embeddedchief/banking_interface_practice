import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'cards_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _cards = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );

  @override
  void dispose() {
    _cards.dispose();
    super.dispose();
  }

  void _open() => _cards.animateTo(1, curve: Curves.easeOutCubic);
  void _close() => _cards.animateBack(0, curve: Curves.easeOutCubic);

  void _dragUpdate(DragUpdateDetails d) {
    final width = MediaQuery.of(context).size.width;
    _cards.value -= d.primaryDelta! / width;
  }

  void _dragEnd(DragEndDetails d) {
    final velocity = d.primaryVelocity ?? 0;
    if (velocity < -300 || (velocity.abs() <= 300 && _cards.value > 0.4)) {
      _open();
    } else {
      _close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.2,
                colors: [Color(0xFF1F4D5A), Color(0xFF0D1A20), Colors.black],
                stops: [0.0, 0.45, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 42,
                              width: 42,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage('assets/images/profile.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            SizedBox(width: 300),

                            Icon(CupertinoIcons.bell_fill, color: Colors.white),
                          ],
                        ),

                        SizedBox(height: 70),

                        const Text(
                          'Total balance',
                          style: TextStyle(
                            color: Color.fromARGB(255, 110, 109, 109),
                            fontSize: 15,
                          ),
                        ),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$7,854',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '.43',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              height: 35,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(
                                    CupertinoIcons.arrow_left_circle_fill,
                                  ),

                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Send',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              height: 35,
                              width: 90,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Request',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 60),

                        Container(
                          height: 70,
                          width: 450,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Spending',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 13
                              ),),
                              Text('\$1,385',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.option),
                              Text(
                                'Transactions',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                              Icon(
                                CupertinoIcons.search_circle,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: -8,
            top: 140,
            child: GestureDetector(
              onTap: _open,
              onHorizontalDragUpdate: _dragUpdate,
              onHorizontalDragEnd: _dragEnd,
              child: AnimatedBuilder(
                animation: _cards,
                builder: (_, child) =>
                    Opacity(opacity: 1 - _cards.value, child: child),
                child: const CardStrips(),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _cards,
            builder: (context, child) {
              final width = MediaQuery.of(context).size.width;
              return IgnorePointer(
                ignoring: _cards.value == 0,
                child: Transform.translate(
                  offset: Offset((1 - _cards.value) * width, 0),
                  child: child,
                ),
              );
            },
            child: CardsPage(
              progress: _cards,
              onDragUpdate: _dragUpdate,
              onDragEnd: _dragEnd,
              onClose: _close,
            ),
          ),
        ],
      ),
    );
  }
}
