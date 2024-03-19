import 'package:flutter/material.dart';
import 'package:notekeep/components/my_button.dart';
import 'package:notekeep/components/mytext_field.dart';
import 'package:notekeep/services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  //final _nameController = TextEditingController();
  final _confirmPassword = TextEditingController();

//sign in user

  void signUp() async {
    if (_passwordController.text != _confirmPassword.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Password Do not match")));
      return;
    }
    AuthService authService = AuthService();
    try {
      await authService.signUpWithEmailandPassword(
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Icon(
                    Icons.note_alt_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Let's create an account"),
                  const SizedBox(
                    height: 10,
                  ),
                  //TextField
                  // MyTextField(
                  //     controller: _nameController,
                  //     hintText: "Enter Your Name",
                  //     obscureText: false),
                  // const SizedBox(
                  //   height: 10,
                  // ),
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
                  MyTextField(
                      controller: _confirmPassword,
                      hintText: "confirm password",
                      obscureText: true),

                  const SizedBox(
                    height: 10,
                  ),

                  MyButton(onTap: signUp, text: "Sign In"),

                  const SizedBox(
                    height: 30,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already a Member?"),
                      SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Login Now",
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
      ),
    );
  }
}
