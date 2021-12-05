import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class PhoneSignUp extends StatefulWidget {
  _State createState() => _State();
}

class _State extends State<PhoneSignUp> {
  Country? _selectedCountry;

  @override
  void initState() {
    initCountry();
    super.initState();
  }

  void initCountry() async {
    final country = await getDefaultCountry(context);
    setState(() {
      _selectedCountry = country;
    });
  }

  void signInWithPhoneAuth(PhoneAuthCredential phoneAuthCredential)async{
    setState(() {
      this.isloading = true;
    });
    try {
      final authcredit = await firebaseAuth.signInWithCredential(phoneAuthCredential);
      setState(() {
        this.isloading= false;
      });
      if(authcredit?.user!= null){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        this.isloading = false;
      });
      print(e.message);
    }

  }

  String verificationCode =" ";
  TextEditingController number = TextEditingController();
  bool isotpvisible = false;
  FirebaseAuth firebaseAuth =FirebaseAuth.instance;
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    final country = _selectedCountry;
    return Scaffold(
      body: isloading ?Center(
        child: CircularProgressIndicator(),
      ):Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: (){
                      _onPressed();
                    },
                    child: Padding(
                        padding: EdgeInsets.all(2),
                        child: Text('${country!.callingCode}',style: TextStyle(fontSize: 20),)),
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Padding(
                        padding: EdgeInsets.all(2),
                        child: TextField(
                          controller: number,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              )
                          ),
                        )
                    )

                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: (){
                if(country.callingCode.isEmpty || number.text.isEmpty){

                }
                else if(number.text.length<10){
                  print('small');
                }
                else{
                  setState(() {
                    isotpvisible = true;
                  });
                  setState(() {
                    this.isloading = true;
                    createUser(country.callingCode,number.text);
                  });

                }

              },
              child: Text('Send OTP'),
            ),
          ),
          Visibility(
            visible: isotpvisible,
            child: Padding(
                padding: EdgeInsets.all(2),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                )
            ),
          )
        ],
      )
    );
  }

  void _onPressed() async {
    final country =
        await Navigator.push(context, new MaterialPageRoute(builder: (context) {
      return PickerPage();
    }));
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }

  void createUser(String callingCode, String text) async{
   await firebaseAuth.verifyPhoneNumber(
        phoneNumber: callingCode+text,
        verificationCompleted: (phoneAuthCrediential)async{
          setState(() {
            this.isloading = false;
          });
          signInWithPhoneAuth(phoneAuthCrediential);
        },
        verificationFailed: (verificationFailed){
          setState(() {
            this.isloading = false;
          });
          print(verificationFailed.message);
        },
        codeSent: (verificationId,resendingToken) async{

          setState(() {
            this.verificationCode = verificationId;
            this.isloading = false;
          });
        },
        codeAutoRetrievalTimeout: (verificationId) async{

        }
   );
  }

}

class PickerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Country'),
      ),
      body: Container(
        child: CountryPickerWidget(
          onSelected: (country) => Navigator.pop(context, country),
        ),
      ),
    );
  }
}

