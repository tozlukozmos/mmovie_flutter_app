import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                AppButtons.appElevatedButton(
                  name: "Sign up",
                  onPressed: signup,
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
        Navigator.pushReplacementNamed(context, "feed_screen");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An account already exists for that email'),
            duration: Duration(milliseconds: 1500),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
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
