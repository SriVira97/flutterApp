import 'dart:convert';
import 'package:app/student_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Studets List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    setState(() {});
  }

  List<Student> students = [];

  Future<List<Student>> getAllStudents() async {
    var response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/students'));
    var jsondata = jsonDecode(response.body.toString());

    for (Map s in jsondata) {
      Student student =
          Student(s['name'], s['total'], s['student_id'], s['subjects']);
      students.add(student);
    }
    print(students);
    return students;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getAllStudents(),
              builder: (context, AsyncSnapshot<List<Student>> snapshot) {
                return ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data![index].name),
                        subtitle:
                            Text("Total Marks :" + snapshot.data![index].total),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SturdentDetails(
                                    snapshot.data![index].studentid,
                                    snapshot.data![index].name,
                                    snapshot.data![index].total))),
                      );
                    });
              },
            ),
          )
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Student {
  final String name, total;
  final int studentid, subjects;

  Student(this.name, this.total, this.studentid, this.subjects);
}
