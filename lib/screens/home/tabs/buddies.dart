

import 'package:flutter/material.dart';

class BuddiesPage extends StatefulWidget {
  BuddiesPage({Key? key}) : super(key: key);

  @override
  State<BuddiesPage> createState() => _BuddiesPageState();
}

class _BuddiesPageState extends State<BuddiesPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10,),
        Text("Buddies")
      ],
    );
  }
}