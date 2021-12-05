import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  TextEditingController number = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final country = _selectedCountry;
    return Scaffold(
      body: Column(
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
               createUser(country.callingCode,number.text);
              },
              child: Text('Send OTP'),
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

  void createUser(String callingCode, String text) {}

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

