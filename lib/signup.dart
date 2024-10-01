import 'package:flutter/material.dart';
import 'main.dart';
import 'passwordField.dart';
import 'databaseHelper.dart'; // Import the DatabaseHelper where you have the `insertUser` function
import 'userHome.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final String _title = "Signup and Get Started";
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Enter your username',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter your Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: PasswordField(
                  label: "Enter your password",
                  controller: _passwordController,
                )),
            const SizedBox(height: 16),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: PasswordField(
                  label: 'Confirm password',
                  controller: _confirmPasswordController,
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                print("Now we talkin!");
                String username = _usernameController.text;
                String name = _nameController.text;
                String password = _passwordController.text;
                String confirmPassword = _confirmPasswordController.text;

                if (username.isEmpty ||
                    name.isEmpty ||
                    password.isEmpty ||
                    confirmPassword.isEmpty) {
                  // Show error if any field is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All fields are required.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (password != confirmPassword) {
                  // Show error if passwords do not match
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Passwords do not match.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  // Insert user into database
                  String result = await DatabaseHelper().insertUser({
                    'username': username,
                    'name': name,
                    'password': password,
                    'balance':
                        0, // Initialize balance to 0 or any default value
                  });
                  print(result);
                  // Show the result message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result),
                      backgroundColor: result == 'New user created'
                          ? Colors.green
                          : Colors.red,
                    ),
                  );

                  if (result == 'New user created') {
                    String username = _usernameController.text;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserHome(username: username)),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              ),
              child: const Text('Signup'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                );
              },
              child: const Text(
                'Login to an existing account',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
