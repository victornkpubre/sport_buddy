
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_buddy/models/models.dart';
import 'package:sport_buddy/repo/firestore_repo.dart';
import 'package:sport_buddy/screens/home/home.dart';

class InfoPage extends StatefulWidget {
  User user;
  
  InfoPage({
    super.key,
    required this.user,
  });

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final FirestoreRepo _firebaseRepo = FirestoreRepo();
  String pageTitle = "Select an Interest";
  List<String> userInterests = [];
  TextEditingController userController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  


  Future<List<Interest>> getAppInterests() async {
    return await _firebaseRepo.getAllInterest(null,null);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User?  user = widget.user;
    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                Text(user.email!, style: TextStyle(fontSize: 18),),
                SizedBox(height: 10),

                Text("Enter a Username"),
                SizedBox(height: 5),

                TextField(
                  controller: userController,
                  decoration: const InputDecoration(
                    hintText: "Username"
                  ),
                ),
                SizedBox(height: 25),

                Text("Enter your Phone Number"),
                SizedBox(height: 5),

                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    hintText: "Phone"
                  ),
                ),
                SizedBox(height: 25),
            
                Text("Choose at least one Interest"),
                SizedBox(height: 5),
                
                FutureBuilder(
                  future: getAppInterests(),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      if(snapshot.data!.isEmpty){
                        _firebaseRepo.addInterests(["Hockey", "Football", "Basketball", "Ice Hockey", "Motorsports", "Bandy", "Rugby", "Skiing", "Shooting"]);
                        
                      }
                    }
                    return snapshot.hasData? Column(
                      children: snapshot.data!.map((interest) => GestureDetector(
                        child: Container(
                          color: Colors.black38,
                          padding: EdgeInsets.only(top:15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Center(child: Column(
                              children: [
                                Text(interest.title, style: TextStyle(fontSize: 21, color:userInterests.contains(interest.id)? Colors.blue: Colors.black38 ),),
                                Divider(height: 0,)
                              ],
                            ))),
                        ),
                        onTap: (){
                          if (userInterests.contains(interest.id)) {
                            setState(() {
                              userInterests.remove(interest.id);
                            });
                            
                          }
                          else {
                            setState(() {
                              userInterests.add(interest.id);
                            });
                            
                          }
                        }
                      )).toList()
                    ): Text("Loading");
                  }
                ),
        
                SizedBox(height: 25),
        
                ElevatedButton(
                onPressed: () async {
                  if(await validateUser()){

                    if(phoneController.text.isNotEmpty){
                      verifyPhone(phoneController.text.trim(), context);
                      // //After verification
                      // await saveUserDetails(user, userController.text.trim(), phoneController.text.trim());
                      // //Navigate to Home
                      // Navigator.pushReplacement(context, MaterialPageRoute(
                      //   builder: (context) => HomePage()
                      // ));

                    }
                    else {
                      showErrorDialog("Input Error", "Enter a phone number");
                    }


                  }
                  
                }, 
                  child: Text("Save")
                )
        
              ],
            ),
        ),
      ),
    );
  }

  validateUser() async {
    if(userController.text.isNotEmpty){
      if(await _firebaseRepo.usernameAvaliable(userController.text.trim())){
        return true;
      }
      else {
        showErrorDialog("CHoose another username", "Username Not avaliable");
        return false;
      }
    }
    else {
      showErrorDialog("Missing Imput", "Enter an Username");
      return false;
    }
  }

  void verifyPhone(String mobileNum, BuildContext context) {
    //String mobile = "+234 08090659632";
    String mobile = "+234 $mobileNum";
    
    _firebaseAuth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential){
        loginWithCred(authCredential);
      },
      verificationFailed: (e){}, 
      codeSent: (verificationId, forceResendingToken) {
        //show dialog to take input from the user
        showPhoneVerificationDialog(context, verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {  

      }
    );

  }

  showPhoneVerificationDialog(BuildContext context, String verificationId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Enter SMS Code"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _codeController,
            ),

          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Done"),
            onPressed: () {
              String smsCode = _codeController.text.trim();
              
              var _credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
              _firebaseAuth.signInWithCredential(_credential).then((result) async {

                //After verification
                await saveUserDetails(result.user!, userController.text.trim(), phoneController.text.trim());
                //Navigate to Home
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => HomePage()
                ));

              }).catchError((e){
                print(e);
              });
            },
          )
        ],
      )
    );
  }

  void loginWithCred(AuthCredential authCredential) {
    _firebaseAuth.signInWithCredential(authCredential).then(( result) async {
      await saveUserDetails(result.user!, userController.text.trim(), phoneController.text.trim());
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => HomePage()
      ));

    }).catchError((e){
      showErrorDialog("Login Error", e.toString());
    });
  }
  
  Future<AppUser> saveUserDetails(User user, String username, String phone) async {
    AppUser newUser = AppUser(
      email: user.email!, 
      phone: phone,
      profileImg: '',
      buddies: [],
      interests: userInterests, 
      uid: user.uid, 
      username: username,
    );
    await _firebaseRepo.addUser(newUser) ;

    return newUser;
  }

  void showErrorDialog(String title, String error) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error)
          ],
        ),
      )
    );
  }
}