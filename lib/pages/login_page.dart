import 'package:flutter/material.dart';
import 'package:notekeep/components/my_button.dart';
import 'package:notekeep/components/mytext_field.dart';
import 'package:notekeep/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void signIn() async {
    final AuthService authService = AuthService();
    try {
      await authService.signInWithEmailandPassword(
          _emailController.text, _passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                Icon(
                  Icons.note_alt_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("Welcome Back"),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: _emailController,
                    hintText: "Email",
                    obscureText: false),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: _passwordController,
                    hintText: "password",
                    obscureText: true),
                const SizedBox(
                  height: 10,
                ),
                MyButton(onTap: signIn, text: "Sign In"),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a Member?"),
                    SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register Now",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
