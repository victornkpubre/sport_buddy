/*
 * Content: Username, Buddies and Chats
 * Bottom Navigator:  Profile, Buddies, Discover and Settings
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DiscoverPage extends StatefulWidget {
  DiscoverPage({
    super.key,
  });

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10,),
        Text("Discover")
        
      ],
    );
  }
}