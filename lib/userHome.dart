import 'package:flutter/material.dart';
import 'databaseHelper.dart';
import 'user.dart';
import 'package:flutter/services.dart';
import 'main.dart';

class UserHome extends StatefulWidget {
  final String username;
  UserHome({super.key, required this.username});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  User? user;
  int balance = 0;
  final TextEditingController addBalanceController = TextEditingController();
  final TextEditingController withdrawBalanceController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser(); // Call the method to load the user
  }

  Future<void> _loadUser() async {
    user = await getUser(); // Await the result of getUser
    balance = user!.balance;
    setState(() {});
  }

  Future<User?> getUser() async {
    User? user = await DatabaseHelper().getUserByUsername(widget.username);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(user != null ? "Welcome ${user!.name}" : "Loading..."),
      ),
      body: Center(
        child: user == null
            ? const CircularProgressIndicator()
            : Column(children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 30.0),
                  child: Text("Welcome, ${user!.name}!",
                      style: const TextStyle(fontSize: 30)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50.0),
                  child: Text("Your Current Balance: $balance",
                      style: const TextStyle(fontSize: 25)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    children: [
                      // Add Balance Row
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 10.0),
                              child: TextField(
                                controller: addBalanceController,
                                decoration: const InputDecoration(
                                  labelText: 'Add Balance',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          ElevatedButton(
                            onPressed: () async {
                              if (addBalanceController.text.isEmpty ||
                                  addBalanceController.text == "0") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please add an amount"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                int tempBalance = balance +
                                    int.parse(addBalanceController.text);
                                balance = tempBalance;
                                setState(() {});
                                String result = await DatabaseHelper()
                                    .updateUserBalance(user!.id, balance);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                            child: const Text('+'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      // Withdraw Balance Row
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 10.0),
                              child: TextField(
                                controller: withdrawBalanceController,
                                decoration: const InputDecoration(
                                  labelText: 'Withdraw Balance',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          ElevatedButton(
                            onPressed: () async {
                              if (withdrawBalanceController.text.isEmpty ||
                                  withdrawBalanceController.text == "0" ||
                                  int.parse(withdrawBalanceController.text) >
                                      balance) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Please enter an amount less tha your balance"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                int tempBalance = balance -
                                    int.parse(withdrawBalanceController.text);
                                balance = tempBalance;
                                setState(() {});
                                String result = await DatabaseHelper()
                                    .updateUserBalance(user!.id, balance);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                            child: const Text('-'),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyHomePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                        ),
                        child: const Text('Log out'),
                      ),
                    ],
                  ),
                ),
              ]),
      ),
    );
  }
}
