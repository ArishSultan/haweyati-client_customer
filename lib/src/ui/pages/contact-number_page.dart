import 'package:flutter/material.dart';
import 'package:haweyati/src/ui/widgets/simple-form.dart';
import 'package:haweyati/src/utils/const.dart';
import 'package:haweyati/src/ui/widgets/app-bar.dart';

class ContactNumberPage extends StatelessWidget {
  final GlobalKey<SimpleFormState> key = GlobalKey<SimpleFormState>();

  ContactNumberPage();

  @override
  Widget build(BuildContext context) {
    return SimpleForm(
      key: key,
      onSubmit: () {
        throw Error();
      },
      child: Scaffold(
        key: key,
        appBar: HaweyatiAppBar(
          progress: 0,
          hideCart: true,
          hideHome: true
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment(0, 1),
              image: AssetImage('assets/images/pattern.png'),
            )
          ),
          child: SingleChildScrollView(child: Column(children: [
            Padding(
              padding: EdgeInsets.only(top: 30, bottom: 10),
              child: Text(
                'Hello',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
            Text(
              'Enter your contact number',
              textAlign: TextAlign.center,
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter Contact #',
                ),

                onSaved: Navigator.of(context).pop,
              ),
            )
          ])),
        ),

        floatingActionButton: FloatingActionButton(
          elevation: 0,
          onPressed: () {
            Navigator.of(context).pop('123');
            // key.currentState.submit();
          },
          child: Image.asset(NextFeatureIcon, width: 30)
        )
      ),
    );
  }
}
