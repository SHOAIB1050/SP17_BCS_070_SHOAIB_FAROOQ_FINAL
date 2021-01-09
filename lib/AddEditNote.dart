import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Window_after_login.dart';
import 'AddNote.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:share/share.dart';

enum NoteMode { Editing, Adding }

class Note extends StatefulWidget {
  final String uid;
  final String name;
  final String email;
  final NoteMode noteMode;
  final Map<String, dynamic> note;

  Note(this.noteMode, this.note, this.uid, this.name, this.email);

  @override
  NoteState createState() {
    return new NoteState(uid, name, email);
  }
}

class NoteState extends State<Note> {
  final String uid;
  final String name;
  final String email;
  NoteState(this.uid, this.name, this.email);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('icon');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return NewScreen(
        payload: payload,
      );
    }));
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  @override
  void didChangeDependencies() {
    if (widget.noteMode == NoteMode.Editing) {
      _titleController.text = widget.note['title'];
      _textController.text = widget.note['text'];
      _dateTimeController.text = widget.note['datetime'];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title:
            Text(widget.noteMode == NoteMode.Adding ? 'Add note' : 'Edit note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget.noteMode == NoteMode.Adding
                ? Text(dateFormat.format(selectedDate),
                    style: TextStyle(fontSize: 30.0))
                : Text(_dateTimeController.text,
                    style: TextStyle(fontSize: 30.0)),
            SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'Title of Note'),
            ),
            Container(
              height: 10,
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: widget.noteMode == NoteMode.Adding ? 4 : 6,
              controller: _textController,
              decoration: InputDecoration(hintText: 'Detail of Note'),
            ),
            Container(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _NoteButton('SAVE', Colors.pink, () {
                  final title = _titleController.text;
                  final text = _textController.text;
                  final datetime = _dateTimeController.text;

                  if (widget?.noteMode == NoteMode.Adding) {
                    print(title + " " + text + " " + datetime);
                    NoteProvider.insertNote(
                        {'title': title, 'text': text, 'datetime': datetime});
                    if (datetime.length != 0) {
                      scheduleNotification(selectedDate, title);
                    }
                  } else if (widget?.noteMode == NoteMode.Editing) {
                    NoteProvider.updateNote({
                      'id': widget.note['id'],
                      'title': _titleController.text,
                      'text': _textController.text,
                      'datetime': datetime
                    });
                  }
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WindowAfierLogin(
                            uid: uid, name: name, email: email)),
                    (Route<dynamic> route) => false,
                  );
                }),
                _NoteButton('Share', Colors.blue, () {
                  final title = _titleController.text;
                  final text = _textController.text;
                  final datetime = _dateTimeController.text;
                  Share.share(_textController.text);
                }),
                Container(
                  height: 16.0,
                ),
                _NoteButton('Cancel', Colors.purple, () {
                  Navigator.pop(context);
                }),
                widget.noteMode == NoteMode.Editing
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: _NoteButton('Delete', Colors.red, () async {
                          await NoteProvider.deleteNote(widget.note['id']);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WindowAfierLogin(
                                    uid: uid, name: name, email: email)),
                            (Route<dynamic> route) => false,
                          );
                        }),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child:
                            _NoteButton('Add Notify', Colors.black, () async {
                          /*
                          showDateTimeDialog(context, initialDate: selectedDate,
                              onSelectedDate: (selectedDate) {
                            setState(() {
                              this.selectedDate = selectedDate;
                              _dateTimeController.text =
                                  selectedDate.toString().substring(0, 16);
                            });
                          });
                      */
                        }),
                      )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> scheduleNotification(DateTime selectedDate, String title) async {
    var scheduledNotificationDateTime = selectedDate;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      icon: 'icon',
      largeIcon: DrawableResourceAndroidBitmap('icon'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(0, title, 'Tap to see more',
        scheduledNotificationDateTime, platformChannelSpecifics);
  }
}

class _NoteButton extends StatelessWidget {
  final String _text;
  final Color _color;
  final Function _onPressed;

  _NoteButton(this._text, this._color, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _onPressed,
      child: Text(
        _text,
        style: TextStyle(color: Colors.white),
      ),
      height: 50,
      minWidth: 50,
      color: _color,
    );
  }
}

class NewScreen extends StatelessWidget {
  String payload;

  NewScreen({
    @required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(payload),
      ),
    );
  }
}
