import 'package:flutter/material.dart';
import 'package:jemputah_app_driver/constants/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jemputah_app_driver/screens/login_screen.dart';
import 'package:jemputah_app_driver/reuseable_widget/reuseable_widget.dart';

class SettingUI extends StatelessWidget {
  const SettingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Setting UI',
      home: ChangePasswordPage(),
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordTextController =
      TextEditingController();
  final TextEditingController _newPasswordTextController =
      TextEditingController();
  final TextEditingController _newSecondPasswordTextController =
      TextEditingController();

  var newPassword = '';

  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _newPasswordTextController.dispose();
    super.dispose();
  }

  changePassword({oldPassword, newPassword}) async {
    try {
      var cred = EmailAuthProvider.credential(
          email: currentUser!.email.toString(), password: oldPassword);
      await currentUser!.reauthenticateWithCredential(cred).then((value) {
        currentUser!.updatePassword(newPassword);
      });
      FirebaseAuth.instance.signOut().then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
      const snackBar = SnackBar(
        content: Text('Password Successfully Changed, Please Log In Again.'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (error) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                "Error",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: AppColors.secondaryBorder,
              content: const Text(
                "The old password is incorrect. Please check again.",
                textAlign: TextAlign.center,
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGreen,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: AppColors.mainGreen,
        title: const Text('Change Password'),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: ListView(
          children: [
            const SizedBox(
              height: 25,
            ),
            Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 50,
                        color: Color(0xffEEEEEE)),
                  ],
                ),
                alignment: Alignment.center,
                child: reusableTextField("Old Password", Icons.lock, true,
                    _oldPasswordTextController)),
            Container(
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 50,
                        color: Color(0xffEEEEEE)),
                  ],
                ),
                alignment: Alignment.center,
                child: reusableTextField("New Password", Icons.vpn_key, true,
                    _newPasswordTextController)),
            Container(
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 50,
                        color: Color(0xffEEEEEE)),
                  ],
                ),
                alignment: Alignment.center,
                child: reusableTextField("Re-enter New Password", Icons.vpn_key,
                    true, _newSecondPasswordTextController)),
            GestureDetector(
              onTap: () => {
                if (_oldPasswordTextController.text.isEmpty ||
                    _newPasswordTextController.text.isEmpty ||
                    _newSecondPasswordTextController.text.isEmpty)
                  {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: AppColors.secondaryBorder,
                            title: const Text(
                              "Error",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            ),
                            content: const Text(
                              "Please fill in the fields that are still empty first.",
                              textAlign: TextAlign.center,
                            ),
                          );
                        })
                  }
                else if (_oldPasswordTextController.text ==
                    _newPasswordTextController.text)
                  {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: AppColors.secondaryBorder,
                            title: const Text(
                              "Error",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            ),
                            content: const Text(
                              "The old password and the new password you entered are the same.",
                              textAlign: TextAlign.center,
                            ),
                          );
                        })
                  }
                else if (_newPasswordTextController.text !=
                    _newSecondPasswordTextController.text)
                  {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: AppColors.secondaryBorder,
                            title: const Text(
                              "Error",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            ),
                            content: const Text(
                              "The new password and its confirmation do not match. Please check again.",
                              textAlign: TextAlign.center,
                            ),
                          );
                        })
                  }
                else if (_newPasswordTextController.text ==
                    _newSecondPasswordTextController.text)
                  {
                    changePassword(
                        oldPassword: _oldPasswordTextController.text,
                        newPassword: _newPasswordTextController.text)
                  }
              },
              child: Container(
                margin: const EdgeInsets.only(top: 300),
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.buttonBackground,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 50,
                        color: Color(0xffEEEEEE)),
                  ],
                ),
                child: const Text(
                  'SAVE',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
