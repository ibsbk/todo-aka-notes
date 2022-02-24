import 'package:flutter/material.dart';
import 'package:gn/serv/HTTPRequests.dart';

class TaskList extends StatefulWidget {
  final List tasks;

  TaskList({required this.tasks});

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  HTTPRequests request = new HTTPRequests();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.tasks.length,
        itemBuilder: (context, index) {
          if (widget.tasks[index].isdone == true) {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  color: Colors.green),
              margin: const EdgeInsets.all(10.0),
              child: ListTile(
                title: Text(widget.tasks[index].note),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                onTap: () {
                  setState(() {
                    try {
                      request.isDoneChange(context, widget.tasks[index], false);
                    } catch (e) {}
                  });
                },
                onLongPress: () {
                  Navigator.pushReplacementNamed(context, '/edit',
                      arguments:widget.tasks[index]);
                },
              ),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  color: Colors.red),
              margin: const EdgeInsets.all(10.0),
              child: ListTile(
                title: Text(widget.tasks[index].note),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                onTap: () {
                  setState(() {
                    try {
                      request.isDoneChange(context, widget.tasks[index], true);
                    } catch (e) {}
                  });
                },
                onLongPress: () {
                  Navigator.pushReplacementNamed(context, '/edit',
                      arguments:widget.tasks[index]);
                },
              ),
            );
          }
        });
    ;
  }
}
