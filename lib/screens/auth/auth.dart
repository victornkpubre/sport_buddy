import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_buddy/models/models.dart';
import 'package:sport_buddy/repo/firestore_repo.dart';
import 'package:sport_buddy/screens/auth/info.dart';
import 'package:sport_buddy/screens/auth/verification.dart';
import 'package:sport_buddy/screens/home/tabs/discover.dart';
import 'package:sport_buddy/screens/home/home.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin{
  bool registeringState = false;
  bool loadingState = false;
  
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController resetemailController = TextEditingController();
  
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirestoreRepo firebaseRepo = FirestoreRepo();
  
  late TabController tabController;
  
  
 


  @override
  void initState() {
    super.initState();
     tabController = TabController(length: 2, vsync: this); 
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text("Sport Buddy"),),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
        
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email"
                ),
              ),
        
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "Password"
                ),
              ),
        
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: "Phone"
                ),
              ),
        
              registeringState? 
              //Registration Panel
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    registerEmail(emailController.text.trim(), passwordController.text.trim(), phoneController.text.trim());
                  }, 
                  child: Text("Register") 
                ),
              ): 
              
              //Login Panel
              Column(
                children: [
                  SizedBox(
                    width: width,
                    height: 50,
                    child: TabBar(
                      controller: tabController,
                      labelColor: Colors.black,
                      indicatorColor: Colors.blue,
                      unselectedLabelColor: Colors.black26,
                      tabs: [
                        Tab(text: "Sign In with your Email"),
                        Tab(text: "Sign In with your Phone"),
                      ],
                    ),
                  ),
            
                  SizedBox(
                    width: width,
                    height: 70,
                    child: TabBarView(
                      controller: tabController,
                      children: [
            
                        SizedBox(
                          child: ElevatedButton(
                            onPressed: () {
                              loginEmail(emailController.text.trim(), passwordController.text.trim());
                            }, 
                            child: Text("Login") 
                          ),
                        ),
                        
            
                        SizedBox(
                          child: ElevatedButton(
                            onPressed: (){
                              print("Phone Login started");
                              if(validatePhone()){
                                loginPhone(phoneController.text.trim(), context);
                              }
                              
                            }, 
                            child: Text("Login")
                          ),
                        ),
                        
                      ]
                    ),
                  ),
                ],
              ),
        
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: (){
                      setState(() {
                        registeringState = !registeringState;
                      });
                    }, 
                    child: Text((registeringState)? "Already have an account?\n Login Here" : "Don't have an account?\n Register Here")
                  ),
                  TextButton(
                    child: Text("Forgot your \n Password?"),
                    onPressed: (){

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
                                  controller: resetemailController,
                                  decoration: InputDecoration(
                                    hintText: "Email"
                                  ),
                                ),
                                SizedBox(height: 25),
                                ElevatedButton(
                                  onPressed: (){
                                    if(validateEmail(resetemailController.text)){
                                      showErrorDialog("Reset Error", "Enter an email for recovery");
                                    }
                                    else {
                                      FirebaseAuth.instance.sendPasswordResetEmail(email: resetemailController.text);
                                    }
                                  }, 
                                  child: Text("Reset Password")
                                )
                              ],
                            ),
                          );
                        })
                      );


                    }, 
                  )
                ],
              ),
              SizedBox(height: 25,),

            ],
          ),
        ),
      ),
    );

  }

  validateEmail(String email){
    if(emailController.text.isNotEmpty){
      if(emailController.text.contains("@")){
        return true;
      }
      else {
        showErrorDialog("Wrong Imput", "Enter a valid email Address");
        return false;
      }
    }
    else {
      showErrorDialog("Wrong Imput", "Enter an email Address");
      return false;
    }
  }

  validatePhone(){
    if(phoneController.text.isNotEmpty){
      if(phoneController.text.isNumeric()){
        return true;
      }
      else {
        showErrorDialog("Wrong Imput", "Phone number should be numeric");
        return false;
      }
    }
    else {
      showErrorDialog("Wrong Imput", "Enter an Phone Number");
      return false;
    }
  }

  validatePassword() {
    if(passwordController.text.isNotEmpty){
      if(passwordController.text.containsUppercase()){
        return true;
      }
      else {
        showErrorDialog("Wrong Imput", "Password should have atleast One Uppercase Character");
        return false;
      }
    }
    else {
      showErrorDialog("Wrong Imput", "Enter an Password");
      return false;
    }
  }

  validateAuthInput(){
    return validateEmail(emailController.text.trim()) && validatePassword() && validatePhone();
  }


  Future<void> registerEmail(String email, String password, String phone) async {
    if(validateAuthInput()){
      User? user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    
      try {
        await user!.sendEmailVerification();
        print("sent verification mail\n");
        print(user.email );
      }
      catch(e){
        print(e);
      }

      await NavigateToHome(user!);
    }
    

  }


  void loginPhone(String mobileNum, BuildContext context) {
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

                await NavigateToHome(result.user!);

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
    _firebaseAuth.signInWithCredential(authCredential).then(( result){
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => HomePage()
      ));

    }).catchError((e){
      showErrorDialog("Login Error", e.toString());
    });
  }

  
  Future<void> loginEmail(String email, String password) async {
    
    User? user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
    print("Logging In " + user.toString());

    await NavigateToHome(user!);

  }
  
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
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

  
  
  Future<void> NavigateToHome(User user) async {
    if(user.emailVerified ){
      AppUser? appUser = await firebaseRepo.getUser(user.uid);
      if(appUser == null) {
        //Navigate to Info Page
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => InfoPage(user: user)
        ));
      }
      else {
        //Navigate to Home Page
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => HomePage()
        ));
      }
    }
    else {
      //Navigate to Verification Page
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => VerificationPage(user: user)
      ));
    }
  }
}

extension on String {
  isNumeric(){
    return double.parse(this) != null || int.parse(this) != null;
  }
  containsUppercase() {
    return contains(RegExp(r'[A-Z]'));
  }
}
