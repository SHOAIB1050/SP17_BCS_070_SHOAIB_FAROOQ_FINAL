import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'AddEditNote.dart';
import 'AddNote.dart';

class WindowAfierLogin extends StatefulWidget {
  final String uid;
  final String name;
  final String email;
  WindowAfierLogin(
      {Key key, @required this.uid, @required this.name, @required this.email})
      : super(key: key);
  @override
  _WindowAfierLoginState createState() =>
      _WindowAfierLoginState(uid, name, email);
}

class _WindowAfierLoginState extends State<WindowAfierLogin> {
  final String uid;
  final String name;
  final String email;
  _WindowAfierLoginState(this.uid, this.name, this.email);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('Notes'),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                foregroundColor: Colors.pink,
                radius: 500,
                child: Text(
                  name[0],
                  style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                backgroundColor: Colors.white,
              ),
            ),
            ListTile(
              leading: Icon(Icons.perm_identity),
              title: Text(name),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text(email),
            ),
            Divider(),
            ListTile(leading: Icon(Icons.settings), title: Text("Settings")),
            ListTile(leading: Icon(Icons.feedback), title: Text("Feedback")),
            ListTile(leading: Icon(Icons.note), title: Text("About")),
            Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ListTile(
                        leading: Icon(Icons.copyright),
                        title: Text("Welcome to Hello and Hi"))))
          ],
        ),
      ),
      body: FutureBuilder(
        future: NoteProvider.getNoteList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final notes = snapshot.data;
            return ListView.builder(
              itemBuilder: (context, index) {
                //FOR EDITING
                return GestureDetector(
                  onTap: () {
                    /*
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Note(NoteMode.Editing, notes[index])));
                 */
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 30.0, bottom: 30, left: 13.0, right: 22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _NoteTitle(
                              notes[index]['title'], notes[index]['datetime']),
                          Container(
                            height: 4,
                          ),
                          _NoteText(notes[index]['text'])
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: notes.length,
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Note(NoteMode.Adding, null, uid, name, email)));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _NoteTitle extends StatelessWidget {
  final String _title;
  final String _datetime;

  _NoteTitle(this._title, this._datetime);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          _title,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        _datetime.length == 0
            ? Container()
            : Image(
                image: AssetImage('assets/icon/alarm.png'),
                height: 40.0,
                width: 40.0,
              )
      ],
    );
  }
}

class _NoteText extends StatelessWidget {
  final String _text;

  _NoteText(this._text);

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(color: Colors.grey.shade600),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
