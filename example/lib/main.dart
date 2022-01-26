import 'package:example/models/user.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(
        users: User.generateRandomUser,
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    Key? key,
    required this.users,
  }) : super(key: key);

  final List<User> users;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<User> selected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: DropDownMultiSelect(
          menuItembuilder: (user) => Text(user!.name),
          onChanged: (List x) {
            setState(() {
              selected = x as List<User>;
            });
          },
          options: widget.users,
          selectedValues: selected,
          whenEmpty: 'No users selected yet',
        ),
      ),
    ));
  }
}
