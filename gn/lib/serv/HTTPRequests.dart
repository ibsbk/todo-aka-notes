import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gn/pages/mainscreen.dart';
import 'package:gn/mod/Note.dart';

class HTTPRequests {
  Future<http.Response> getUserId(googleAccount) async {
    var userIdUrl = Uri.parse(
        'https://10.0.2.2:7168/api/users/get_userId/' + googleAccount?.id);
    var userIdResponse =
        await http.get(userIdUrl, headers: {"Content-Type": "text"});
    return userIdResponse;
  }

  void auth(context, googleAccount) async {
    try {
      var getUserResponse = await getUserId(googleAccount);
      if (getUserResponse.statusCode != 200) {
        var addUserUrl = Uri.parse('https://10.0.2.2:7168/api/users/add_user');
        var user = jsonEncode({
          "google_id": googleAccount!.id,
          "name": googleAccount!.displayName
        });
        var addUserResponse = await http.put(addUserUrl,
            headers: {"Content-Type": "application/json"}, body: user);
        if (addUserResponse.statusCode == 200) {
          // Navigator.pushReplacement(
          //     context,
          //     new MaterialPageRoute(
          //         builder: (__) =>
          //             new MainScreen(googleAccount: googleAccount)));
        } else {}
      } else {
        // Navigator.pushReplacement(
        //     context,
        //     new MaterialPageRoute(
        //         builder: (__) => new MainScreen(googleAccount: googleAccount)));
      }
    } catch (e) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Ошибка'),
          content: const Text('Ошибка подключения'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void createNote(context, text, googleAccount) async {
    try{
      if (text != '') {
        var url = Uri.parse('https://10.0.2.2:7168/api/notes/add_note');
        var userId = await getUserId(googleAccount);
        var now = DateTime.now().toIso8601String();
        var note = jsonEncode({
          "note": text,
          "created_at": now.toString(),
          "user_id": userId.body.toString(),
          "isDone": false,
        });
        var response = await http.put(url,
            headers: {"Content-Type": "application/json"}, body: note);
        if (response.statusCode == 200) {
          // Navigator.pushReplacement(
          //     context,
          //     new MaterialPageRoute(
          //         builder: (__) => new MainScreen(googleAccount: googleAccount)));
        }
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Ошибка'),
            content: const Text('Нет текста задачи'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e){
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Ошибка'),
          content: const Text('Ошибка'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<List> getAllNotes(google_id) async {
    try{
      var allNotes = [];
      var getUserUrl =
      Uri.parse('https://10.0.2.2:7168/api/users/get_userId/' + google_id);
      var getUserResponse = await http
          .get(getUserUrl, headers: {"Content-Type": "application/json"});
      var getAllNotesUrl = Uri.parse(
          'https://10.0.2.2:7168/api/notes/get_user_notes/' +
              getUserResponse.body);
      var getAllNotesResponse = await http
          .get(getAllNotesUrl, headers: {"Content-Type": "application/json"});
      var userMap = jsonDecode(getAllNotesResponse.body);
      userMap.forEach((e) {
        Note note = Note.fromJson(e);
        allNotes.add(note);
      });
      return allNotes;
    } catch(e){
      // showDialog<String>(
      //   context: context,
      //   builder: (BuildContext context) => AlertDialog(
      //     title: const Text('Ошибка'),
      //     content: const Text('Ошибка получения задач'),
      //     actions: [
      //       TextButton(
      //         onPressed: () => Navigator.pop(context, 'OK'),
      //         child: const Text('OK'),
      //       ),
      //     ],
      //   ),
      // );
      return [];
    }
  }

  void isDoneChange(context, note, isDone) async {
    try{
      note.isdone = isDone;
      var url = Uri.parse('https://10.0.2.2:7168/api/notes/edit_note');
      var body = {
        'id': note.id,
        'note': note.note,
        'created_at': note.created_at.toString(),
        'user_id': note.user_id,
        'isdone': note.isdone,
      };
      var noteJSON = jsonEncode(body);
      await http.patch(url,
          headers: {"Content-Type": "application/json"}, body: noteJSON);
    } catch(e){
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Ошибка'),
          content: const Text('Ошибка подключения'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void deleteNote(context, note, googleAccount) async {
    try{
      var url = Uri.parse('https://10.0.2.2:7168/api/notes/delete_note');
      var deleteNote = jsonEncode({
        "id": note.id,
        "note": note.note,
        "created_at": note.created_at,
        "user_id": note.user_id,
        "isDone": note.isdone,
      });
      var response = await http.delete(url,
          headers: {"Content-Type": "application/json"}, body: deleteNote);
      if (response.statusCode == 200) {
        // Navigator.pushReplacement(
        //     context,
        //     new MaterialPageRoute(
        //         builder: (__) => new MainScreen(googleAccount: googleAccount)));
      }
    } catch(e){
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Ошибка'),
          content: const Text('Ошибка при удалении'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void editNote(context, noticeText, note, googleAccount) async {
    try{
      if (noticeText != '') {
        var url = Uri.parse('https://10.0.2.2:7168/api/notes/edit_note');
        var noteNew = jsonEncode({
          "id": note.id,
          "note": noticeText,
          "created_at": note.created_at,
          "user_id": note.user_id,
          "isDone": note.isdone,
        });
        var response = await http.patch(url,
            headers: {"Content-Type": "application/json"}, body: noteNew);
        if (response.statusCode == 200) {
          // Navigator.pushReplacement(
          //     context,
          //     new MaterialPageRoute(
          //         builder: (__) => new MainScreen(googleAccount: googleAccount)));
        } else {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Ошибка'),
              content: const Text('не удалось отредактировать'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Ошибка'),
            content: const Text('Нет текста задачи'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch(e){
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Ошибка'),
          content: const Text('Ошибка при сохранении'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
