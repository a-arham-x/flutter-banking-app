import 'package:flutter/material.dart';
import 'signup.dart'; // Import the SignupPage
import 'passwordField.dart';
import 'databaseHelper.dart';
import 'userHome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 20, 224, 51)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String _title = "Login to your account";
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.75, // 50% of screen width
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
                width: MediaQuery.of(context).size.width *
                    0.75, // 50% of screen width
                child: PasswordField(
                    label: "Enter your password",
                    controller: _passwordController)),
            const SizedBox(height: 20), // Space between the text and the button
            ElevatedButton(
              onPressed: () async {
                print("Clicked Login");
                print(_usernameController.text);
                print(_passwordController.text);
                String result = await DatabaseHelper().verifyUser(
                    _usernameController.text, _passwordController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result),
                    backgroundColor: result == 'User verified successfully.'
                        ? Colors.green
                        : Colors.red,
                  ),
                );
                if (result == 'User verified successfully.') {
                  String username = _usernameController.text;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserHome(username: username)),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // Rounded edges
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 30), // Square shape
              ),
              child: const Text('Login'),
            ),
            const SizedBox(height: 20), // Space between the button and the text
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Signup()),
                );
              },
              child: const Text(
                'Create Account',
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
