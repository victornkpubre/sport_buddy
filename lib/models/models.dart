

import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Interest {
  String id;
  String title;

  Interest({
    required this.id,
    required this.title,
  });

  Map<String, dynamic> toJson() => {
    "id" : id,
    "title": title,
  };

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json["id"],
      title: json["title"],
    );
  }

  factory Interest.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Interest.fromJson(snapshot);
  }
  

}




class AppUser {
  String uid;
  String username;
  String email;
  String phone;
  String? profileImg;
  User? firebaseUser;
  List<String> interests;
  List<String> buddies;

  AppUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.phone,
    required this.buddies,
    this.firebaseUser,
    this.profileImg,
    required this.interests,
  });

  Map<String, dynamic> toJson() => {
    "uid" : uid,
    "username" : username,
    "email": email,
    "phone": phone,
    "profileImg": profileImg,
    "buddies": buddies,
    "interests" : interests,
  };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    User? user = FirebaseAuth.instance.currentUser;

    return AppUser(
      uid : json["uid"],
      email: json["email"],
      username: json["username"],
      phone: json["phone"],
      profileImg: json["profileImg"],
      interests: List<String>.from(json["interests"]),
      buddies: List<String>.from(json["buddies"]),
      
      firebaseUser: user, 
    );
  } 

  factory AppUser.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return AppUser.fromJson(snapshot);
  }

}