import 'package:flutter/material.dart';

class WelcomeVC extends StatefulWidget {
  const WelcomeVC({Key? key}) : super(key: key);

  @override
  State<WelcomeVC> createState() => _WelcomeVCState();
}

class _WelcomeVCState extends State<WelcomeVC> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          "assets/photo-1567620905732-2d1ec7ab7445.webp",
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
