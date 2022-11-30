
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sport_buddy/models/models.dart';
import 'package:sport_buddy/repo/firestore_repo.dart';
import 'package:sport_buddy/screens/auth/auth.dart';
import 'package:sport_buddy/screens/interests/interests.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  FirestoreRepo _firestoreRepo = FirestoreRepo();
  AppUser? user;
  File? _pickedImage;
  
  var _firebaseAuth = FirebaseAuth.instance;
  var firebaseStorage = FirebaseStorage.instance;
  


  @override
  initState()  {
    super.initState();
    _firebaseAuth.currentUser == null ? {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => AuthPage()
      ))
    } : null;
    
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Text("Profile"),
        SizedBox(height: 25,),

        FutureBuilder(
          future: getUser(),
          builder: (context, snapshot) {
            user = snapshot.data;
            return !snapshot.hasData? Center(child: SizedBox( height: 50, child: CircularProgressIndicator())) :Column(
              children: [
                
                InkWell(
                  child: CircleAvatar(
                    radius: 50,
                    child: user!.profileImg!.isNotEmpty? Image.network(user!.profileImg!): Icon(Icons.person_add_alt_1_rounded),
                  ),
                  onTap: (() {
                    pickImage();
                  }),
                ),
                SizedBox(height: 15),

                Text(user!.username),
                SizedBox(height: 10),

                Text(user!.phone),
                SizedBox(height: 10),

                Text("Interests"),
                SizedBox(height: 5),

                FutureBuilder(
                  future: getUserInterest(),
                  builder: (context, snapshot){
                    return snapshot.hasData? Column(
                      children: snapshot.data!.map((interest) => GestureDetector(
                        child: Container(
                          color: Colors.black38,
                          padding: EdgeInsets.only(top:15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Center(child: Column(
                              children: [
                                Text(interest.title, style: TextStyle(fontSize: 21, color: Colors.blue)),
                                Divider(height: 0,)
                              ],
                            ))),
                        ),
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => InterestPage(user: user!)
                          ));
                        }
                      )).toList()
                    ): Text("Loading");
                  }
                ),
                
              ],
            );
          }
        ),
      ],
    );
  }

  Future<String> _uploadToStorage(File image) async{
    Reference ref = firebaseStorage.ref().child('profilePics').child(_firebaseAuth.currentUser!.uid);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    return snap.ref.getDownloadURL();
  }

  Future<List<Interest>> getUserInterest() async{
    List<Interest> list = [];
    for(int i=0; i< user!.interests.length; i++){
      String uid = user!.interests[i];
      list.add(await _firestoreRepo.getInterest(uid));
    }
    print(list.toString());
    return list;
  }
  
  Future<AppUser?> getUser() async {
    return (await  _firestoreRepo.getUser(FirebaseAuth.instance.currentUser!.uid))!;
  }

  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedImage != null){
      //Get.snackbar("Profile Picture", "You have successfully picked a profile picture");
    }
    _pickedImage = File(pickedImage!.path);
    String imgUrl = await _uploadToStorage(_pickedImage!);
    setState(() {
      user!.profileImg = imgUrl;
    });
    _firestoreRepo.updateUser(user!.uid, {
      "profileImg" : imgUrl
    });
  }
}

