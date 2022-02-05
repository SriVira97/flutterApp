import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SturdentDetails extends StatefulWidget {
  int student;
  String name;
  String TotalMarks;
  SturdentDetails(this.student, this.name, this.TotalMarks);

  @override
  _SturdentDetailsState createState() =>
      _SturdentDetailsState(this.student, this.name, this.TotalMarks);
}

class _SturdentDetailsState extends State<SturdentDetails> {
  int student;
  String name;
  String TotalMarks;
  _SturdentDetailsState(this.student, this.name, this.TotalMarks);

  @override
  void initState() {
    super.initState();
  }

  List<Marks> marks = [];

  Future<List<Marks>> getAllMarks() async {
    var response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/studentmarks/${this.student}'));
    var jsondata = jsonDecode(response.body.toString());
    for (Map s in jsondata) {
      Marks mark = Marks(s['id'], s['marks'], s['subject']);
      marks.add(mark);
    }
    //this.name = jsondata['name'];
    print(marks);

    return marks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Details - " + this.name),
      ),
      body: Column(
        children: [
          Center(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(this.name + "'s Total Mark Is " + this.TotalMarks,
                      style: TextStyle(fontSize: 22)))),
          Expanded(
            child: FutureBuilder(
              future: getAllMarks(),
              builder: (context, AsyncSnapshot<List<Marks>> snapshot) {
                return ListView.builder(
                    itemCount: marks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data![index].subject),
                        subtitle: Text(snapshot.data![index].marks.toString()),
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

class Marks {
  final String subject;
  final int marks, id;
  Marks(
    this.id,
    this.marks,
    this.subject,
  );
}
