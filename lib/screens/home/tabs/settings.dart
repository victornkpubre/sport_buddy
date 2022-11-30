
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_buddy/models/models.dart';
import 'package:sport_buddy/repo/firestore_repo.dart';
import 'package:sport_buddy/screens/auth/auth.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var emailController = TextEditingController();
  var usernameController = TextEditingController();


  FirestoreRepo _firestoreRepo = FirestoreRepo();
  AppUser? user;


  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser == null ? {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => AuthPage()
      ))
    } : null;
  }


  @override
  Widget build(BuildContext context) {
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Text("Settings"),
          FutureBuilder(
            future: getUser(),
            builder: (context, snapshot) {
              user = snapshot.data;
              usernameController.text = (user != null) ? user!.username: "Loading Username";
              emailController.text = (user != null) ? user!.email: "Loading Email";
              return !snapshot.hasData? Center(child: SizedBox( height: 50, child: CircularProgressIndicator())) :
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  SizedBox(height: 64),
    
                  Text("Update Username"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width/2,
                        child: TextField(
                          controller: usernameController,
                        ),
                      ),
                      SizedBox(width: 10,),
                      
                      ElevatedButton(
                        onPressed: (){
                          //update username method
                          updateUsername(usernameController.text.trim());
                        }, 
                        child: Text("Save")
                      )
                    ],
                  ),
                  SizedBox(height: 64),
    
                  Text("Update Email"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width/2,
                        child: TextField(
                          controller: emailController,
                        ),
                      ),
                      SizedBox(width: 10,),

                      ElevatedButton(
                        onPressed: (){
                          //update username method
                          updateEmail(emailController.text.trim());
                        }, 
                        child: Text("Save")
                      )
                    ],
                  ),
                  SizedBox(height: 15,),
    
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: (){
                            //changePassword method
                            resetPassword();
                            
                          }, 
                          child: Text("Reset Password")
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                          onPressed: () {
                            //Logout
                            logout();
                          }, 
                          child: Text("LOGOUT")
                        )
                      ],
                    ),
                  ),
    
    
                ],
              );
            }
          ),
        ],
      ),
    );
  }

  Future<AppUser?> getUser() async {
    print("Getting user"+FirebaseAuth.instance.currentUser!.uid);
    return (await  _firestoreRepo.getUser(FirebaseAuth.instance.currentUser!.uid))!;
  }

  resetPassword() {
    showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog (
          content: Column (
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Click to Reset Password via Email"),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email"
                ),
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: (){
                  FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
                  Navigator.pop(context);
                }, 
                child: Text("Reset Password")
              )
            ],
          ),
        );
      })
    );

  }

  updateEmail(String newEmail) {
    FirebaseAuth.instance.currentUser!.updateEmail(newEmail);
    _firestoreRepo.updateUser(FirebaseAuth.instance.currentUser!.uid, {"email": newEmail});
  }

  updateUsername(String newUsername) {
    FirebaseAuth.instance.currentUser!.updateDisplayName(newUsername);
    _firestoreRepo.updateUser(FirebaseAuth.instance.currentUser!.uid, {"username": newUsername});
    
  }

  logout() {
     FirebaseAuth.instance.signOut();
     //Navigate to Auth Page
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => AuthPage()
        ));
  }




}