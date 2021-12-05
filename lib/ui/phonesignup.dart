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

  @override
  Widget build(BuildContext context) {
    final country = _selectedCountry;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            country == null
                ? Container()
                : Column(
                    children: <Widget>[
                      Image.asset(
                        country.flag,
                        package: countryCodePackageName,
                        width: 100,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        '${country.callingCode} ${country.name} (${country.countryCode})',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
            SizedBox(
              height: 100,
            ),
            MaterialButton(
              child: Text('Select Country using full screen'),
              color: Colors.amber,
              onPressed: _onPressed,
            ),
            SizedBox(
              height: 24,
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
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
