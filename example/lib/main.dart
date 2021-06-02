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
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<String> selected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: DropDownMultiSelect(
          onChanged: (List<String> x) {
            setState(() {
              selected =x;
            });
          },
          options: ['a' , 'b' , 'c' , 'd'],
          selectedValues: selected,
          whenEmpty: 'Select Something',
        ),
      ),
    ));
  }
}
