import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solacellbackendweb/states/admin_service.dart';
import 'package:solacellbackendweb/utility/my_dialog.dart';
import 'package:solacellbackendweb/widgets/show_button.dart';
import 'package:solacellbackendweb/widgets/show_form.dart';
import 'package:solacellbackendweb/widgets/show_logo.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 200,
              child: ShowLogo(),
            ),
            ShowForm(
                lable: 'Email :',
                iconData: Icons.email_outlined,
                changeFunc: (String string) => email = string.trim()),
            ShowForm(
              obsecu: true,
              lable: 'Password :',
              iconData: Icons.lock_outline,
              changeFunc: (String string) => password = string.trim(),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 250,
              child: ShowButton(
                label: 'Login',
                pressFunc: () {
                  if ((email?.isEmpty ?? true) || (password?.isEmpty ?? true)) {
                    MyDialog(context: context).normalDialog(
                        title: 'Have Space ?',
                        message: 'Please Fill Every Blank');
                  } else {
                    processAuthen();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> processAuthen() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      print('Login Success');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminService(),
          ),
          (route) => false);
    }).catchError((onError) {
      MyDialog(context: context)
          .normalDialog(title: onError.code, message: onError.message);
    });
  }
}
