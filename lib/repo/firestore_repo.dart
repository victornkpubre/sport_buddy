

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sport_buddy/models/models.dart';

class FirestoreRepo {

    //Interest Repo
    Future<List<Interest>> getAllInterest(int? min, int? max) async {
      if(min != null || max != null){
        var snapshot = await FirebaseFirestore.instance.collection('interest').get();
        return snapshot.docs.map((q) => Interest.fromJson(q.data())).toList();
      }
      else {
         var snapshot = await FirebaseFirestore.instance.collection('interest').orderBy("title").limitToLast(10).get();
         return snapshot.docs.map((q) => Interest.fromJson(q.data())).toList();
      }
    }

    List<Future<Interest>> getInterests(List<String> uids) {
      return uids.map((uid) async => (await getInterest(uid))).toList();
    }

    Future<Interest> getInterest(String uid) async {
      return Interest.fromSnap(await FirebaseFirestore.instance
        .collection("interest").doc(uid).get());
    }

    Future<bool> addInterest(String title) async {
      String id = FirebaseFirestore.instance.collection("interest").doc().id;
      var interest = Interest(id: id, title: title);

      try {
        await FirebaseFirestore.instance
        .collection("interest").add(interest.toJson());
        return true;
      } catch (e) {
        return false;
      } 
    }

    Future<void> addInterests(List<String> titles) async {
      titles.forEach((title) async {
        String id = FirebaseFirestore.instance.collection("interest").doc().id;
        var interest = Interest(id: id, title: title);

        try {
          await FirebaseFirestore.instance
          .collection("interest").doc(id).set(interest.toJson());
        } catch (e) {
        }
      });
      
      
    }

    void removeInterest(Interest interest){
      FirebaseFirestore.instance
        .collection("interest").doc(interest.id).delete();
    }



    //User Repo
    Future<List<AppUser>> getAllUsers(int min, int max) async {
      if(min != null || max != null) {
        var snapshot = await FirebaseFirestore.instance.collection('users').get();
        return snapshot.docs.map((q) => AppUser.fromJson(q.data())).toList();
      }
      else {
         var snapshot = await FirebaseFirestore.instance.collection('users').orderBy("username").limitToLast(5).get();
         return snapshot.docs.map((q) => AppUser.fromJson(q.data())).toList();
         
      }
      
    }

    List<Future<AppUser>> getUsers(List<String> uids) {
      return uids.map((uid) async => (await getUser(uid))!).toList();
    }

    Future<AppUser?> getUser(String uid) async {
      var userMap = await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if(!userMap.exists){
        return null;
      }
      else{
        return AppUser.fromSnap(userMap);
      }
      
    }

    Future<bool> addUser(AppUser user) async {
      await FirebaseFirestore.instance
        .collection("users").doc(user.uid)
        .set(user.toJson()).onError((error, stackTrace) => false);
      return true;
    }

    Future<bool> updateUser(String uid, Map<String, dynamic> update) async {
      await FirebaseFirestore.instance
        .collection("users").doc(uid)
        .update(update).onError((error, stackTrace) => false);
      return true;
    }

    void removeUser(AppUser user) {
      FirebaseFirestore.instance
        .collection("users").doc(user.uid).delete();
    }

  Future<bool> usernameAvaliable(String name) async{
    var user = await FirebaseFirestore.instance
        .collection("users").where("username", isEqualTo: name).get();
    return user.docs.isEmpty? true: false;
  }

}