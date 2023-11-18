import 'package:book_a_stay/screens/admin/admin_home_screen.dart';
import 'package:flutter/material.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});
  static const routeName = 'admin-login-screen';

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _passwordController = TextEditingController();

  void validate(BuildContext ctx) async {
    final password = _passwordController.text;
    if (password == 'admin123') {
      Navigator.of(context).pushReplacementNamed(AdminHomeScreen.routeName);
    } else {
      return showDialog<void>(
        context: ctx,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Wrong Password',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text(
              'Please enter the correct password to login as Admin.',
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/admin_bg.jpg'),
              fit: BoxFit.cover,
              opacity: 0.3),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 55),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
                child: const Text(
                  'Admin Login',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                constraints: BoxConstraints(
                    maxHeight: 250,
                    minWidth: MediaQuery.of(context).size.width * 0.8),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Enter Admin Password"),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 150,
                        child: TextFormField(
                          obscureText: true,
                          decoration:
                              const InputDecoration(hintText: 'Password'),
                          controller: _passwordController,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          onPressed: () {
                            validate(context);
                          },
                          child: const Text('Log In'))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
