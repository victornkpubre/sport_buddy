import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_buddy/models/models.dart';
import 'package:sport_buddy/repo/firestore_repo.dart';
import 'package:sport_buddy/screens/home/home.dart';

class InterestPage extends StatefulWidget {
  AppUser user;
  
  InterestPage({
    super.key,
    required this.user,
  });

  @override
  State<InterestPage> createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
  final FirestoreRepo _firestoreRepo = FirestoreRepo();
  String pageTitle = "Update Interests";


  Future<List<Interest>> getAppInterests() async {
    return await _firestoreRepo.getAllInterest(null,null);
  }
  Future<List<Interest>> getUserInterest(AppUser? user) async{
    List<Interest> list = [];
    for(int i=0; i< user!.interests.length; i++){
      String uid = user.interests[i];
      list.add(await _firestoreRepo.getInterest(uid));
    }
    print(list.toString());
    return list;
  }

  @override
  void initState() {
    super.initState();
    // _firebaseRepo.addInterests(["Hockey", "Football", "Basketball", "Ice Hockey",
    //       "Motorsports", "Bandy", "Rugby", "Skiing", "Shooting"]);
  }

  @override
  Widget build(BuildContext context) {
    AppUser?  user = widget.user;
    
    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
            
                Text("Select Interests"),
                SizedBox(height: 5),
                
                FutureBuilder(
                  future: getAppInterests(),
                  builder: (context, snapshot){
                    
                    return Column(
                      children: snapshot.data!.map((interest) => GestureDetector(
                        child: Container(
                          color: Colors.black38,
                          padding: EdgeInsets.only(top:15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Center(child: Column(
                              children: [
                                Text(interest.title, style: TextStyle(fontSize: 21, color:user.interests.contains(interest.id)? Colors.blue: Colors.black38 ),),
                                Divider(height: 0,)
                              ],
                            ))),
                        ),
                        onTap: (){
                          if (user.interests.contains(interest.id)) {
                            setState(() {
                              user.interests.remove(interest.id);
                              
                            });
                            
                          }
                          else {
                            setState(() {
                              user.interests.add(interest.id);
                            
                            });
                            
                          }
                        }
                      )).toList()
                    );
                  }
                ),
        
                SizedBox(height: 25),
        
                ElevatedButton(
                onPressed: () async {
                  updateUserInterests(user);
                    
                  //Navigate to Home
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => HomePage()
                  ));
                  
                }, 
                  child: Text("Save")
                )
        
              ],
            ),
        ),
      ),
    );
  }

  
  void updateUserInterests(AppUser user) {

    _firestoreRepo.updateUser(user.uid, user.toJson());

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