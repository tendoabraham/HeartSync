import 'dart:ui';

import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hi",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: "Itim",
                    fontWeight: FontWeight.normal),
              ),
              const Text(
                "Lovely",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Itim"),
              ),
              SizedBox(height: 16),
              Center(
                child: IntertwinedPictures(),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Love 1",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "Itim",
                        fontWeight: FontWeight.normal),
                  ),
                  Container(
                    width: 40,
                    child: Image.asset(
                      'assets/images/twolove.png',
                      // width: 60,
                      // height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    "Tendo",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "Itim",
                        fontWeight: FontWeight.normal),
                  ),
                ],),
              const SizedBox(height: 8),
              // Row(
              //   children: [
              //     Icon(Icons.change_history, color: Colors.black),
              //     SizedBox(width: 8),
              //     Icon(Icons.circle, color: Colors.black),
              //     SizedBox(width: 8),
              //     Icon(Icons.nightlight_round, color: Colors.black),
              //     SizedBox(width: 8),
              //     Icon(Icons.invert_colors, color: Colors.black),
              //   ],
              // ),
              // SizedBox(height: 8),
              const Center(
                child: Text(
                  "Tell Love 1 how you are feeling right now",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: "Itim",
                      fontWeight: FontWeight.normal
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ModeCard(
                              color: Colors.deepOrange.withOpacity(0.7),
                              title: '...missing you',
                              icon: 'assets/images/cry.png',
                            ),
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            flex: 2,
                            child: ModeCard(
                              color: Colors.lightBlue.withOpacity(0.5),
                              title: '...thinking about you',
                              icon: 'assets/images/twolove.png',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                        child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ModeCard(
                            color: Colors.red.withOpacity(0.3),
                            title: 'I love you',
                            icon: 'assets/images/love3.png',
                          ),
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          flex: 1,
                          child: ModeCard(
                            color: Colors.lightGreen.withOpacity(0.7),
                            title: 'Send Custom Message',
                            icon: 'assets/images/write.png',
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 4,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ModeCard extends StatelessWidget {
  final Color color;
  final String title;
  final String icon;

  ModeCard({required this.color, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 30,
                child: Image.asset(
                  icon,
                  // width: 60,
                  // height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IntertwinedPictures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 32),
        child: Stack(
      alignment: Alignment.center,
      children: [
        ClipOval(
          child: Image.asset(
            'assets/images/bg2.jpeg',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 50,
          child: ClipOval(
            child: Image.asset(
              'assets/images/bg2.jpeg',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    ));
  }
}
