import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: 20,
        height: 20,
        child: const CircularProgressIndicator(
          strokeWidth: 3.0,
          color: Colors.greenAccent,
        ),
      ),
    );
  }
}
