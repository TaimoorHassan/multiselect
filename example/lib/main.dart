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
  List<dynamic> selected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: DropDownMultiSelect(
          onChanged: (List<dynamic> x) {
            print(x);
          },
          options: [new TestClass("a", 1), new TestClass("b", 2), "c", "d"],
          selectedValues: selected,
          whenEmpty: 'Select Something',
        ),
      ),
    ));
  }
}

class TestClass {
  final String caption;
  final int value;

  TestClass(this.caption, this.value);

  @override
  String toString() {
    // TODO: implement toString
    return this.caption;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is TestClass) {
      return other.value == value;
    }

    return false;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}
