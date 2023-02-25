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

class Person {
  String name;
  String age;

  Person(this.name, this.age);
}

class _HomeState extends State<Home> {

  var people = [
    Person('A' , '1'),
    Person('B' , '2'),
    Person('C' , '3'),
    Person('D' , '4'),
    Person('E' , '5'),
    Person('F' , '6'),
    Person('G' , '7'),
    Person('H' , '8'),
    Person('I' , '9'),
    Person('J' , '10'),
  ];

  List<Person> selected = [];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        setState(() {
          
        });
      }),
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        // child: SimpleDP<String>(),
        child: DropDownMultiSelect<Person>(
          onChanged: ( x) {
            setState(() {
              selected =x;
            });
          },
          options: people,
          selectedValues: selected,
          whenEmpty: 'Select Something',
        ),
      ),
    ));
  }
}
