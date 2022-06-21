import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/app_alerts.dart';
import '../widgets/app_buttons.dart';
import '../widgets/app_form.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Signup();
}

class _Signup extends State<Signup> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Map<String, dynamic> _userLog = {
    "user_id": 0,
    "movie_dataset": [],
    "watched": [],
    "created": 0,
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Sign up")),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppForm.appTextFormField(
                  label: "Email",
                  isEmail: true,
                  controller: _emailController,
                ),
                const SizedBox(height: 20),
                AppForm.appTextFormField(
                  label: "Password",
                  isPassword: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: AppButtons.appElevatedButton(
                        name: "Sign up",
                        onPressed: signup,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "By signing up, you agree to our Terms and Data Policy.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ThemeData.dark().backgroundColor,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    const SizedBox(width: 10),
                    AppButtons.appTextButton(
                      name: "Log in",
                      onPressed: () {
                        Navigator.pushNamed(context, "login_screen");
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signup() async {
    try {
      if (_formKey.currentState!.validate()) {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        final CollectionReference _logs =
        FirebaseFirestore.instance.collection('logs');
        _userLog = {
          "user_id": _auth.currentUser!.uid,
          "movie_dataset": [],
          "watched": [],
          "created": DateTime.now(),
        };
        await _logs.doc((_auth.currentUser!.uid)).set(_userLog).then((value) => null).catchError((error) => null);
        Navigator.pushReplacementNamed(context, "feed_screen");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            padding: const EdgeInsets.all(0),
            content: AppAlerts.appAlert(
              title: "An account already exists for that email",
              color: Colors.red,
              icon: const Icon(Icons.clear),
            ),
            duration: const Duration(milliseconds: 1500),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(0),
          content: AppAlerts.appAlert(
            title: e.toString(),
            color: Colors.red,
            icon: const Icon(Icons.clear),
          ),
          duration: const Duration(milliseconds: 1500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
