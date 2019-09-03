import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'SecondPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(title: 'My APP flutter'),
    );
  }
}

class _Image extends StatelessWidget {
  final String name;
  _Image(this.name);
  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/$name');
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final teditName = new TextEditingController();
final teditDis = new TextEditingController();
final teditVno = new TextEditingController();
// Color _cardColor = const Color(0xFFFFEB3B);

List<String> list = [];
List<String> listVno = [];
List<String> _date = [];

class _MyHomePageState extends State<MyHomePage> {

  // showNotification() async {
  //   var android = AndroidNotificationDetails(
  //       'channel id', 'channel name', 'channel description');
  //   var iOS = IOSNotificationDetails();
  //   var platform = NotificationDetails(android, iOS);
  //   var scheduledNotificationDateTime =
  //       new DateTime.now().add(Duration(seconds: 5));
  //   await flutterLocalNotificationsPlugin.schedule(0, 'Title ', 'Body', scheduledNotificationDateTime, platform);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondPage()),
              );
            },
          ),
          title: Text('Never Miss'),
          expandedHeight: MediaQuery.of(context).size.height / 5,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[Colors.blue[100], Colors.blue[600]],
                      begin: Alignment.bottomLeft,
                      end: Alignment(-1.0, -1.0))),
            ),
          ),
          floating: true,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Dismissible(
                child: Text('data'),
                key: Key(UniqueKey().toString()),
                background: Container(
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 16,
                      ),
                      Icon(
                        Icons.delete,
                        size: 70,
                      ),
                    ],
                  ),
                  color: Colors.red,
                ),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {
                  setState(() {
                    list.removeAt(index);
                    listVno.removeAt(index);
                    _date.removeAt(index);
                  });
                },
              );
            },
            childCount: list.length,
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        hoverColor: Colors.blue,
        onPressed: () {
          //--------------------  ADD CARD ALERT---------------------------------------
          setState(() {
            return Alert(
                style: const AlertStyle(
                    animationType: AnimationType.shrink,
                    backgroundColor: Color(0xFFFFEB3B)),
                context: context,
                title: "Add Card",
                content: Column(
                  children: <Widget>[
                    TextField(
                      controller: teditName,
                      decoration: InputDecoration(
                        icon: Icon(Icons.add_comment),
                        labelText: 'Name',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: teditDis,
                      decoration: InputDecoration(
                        icon: Icon(Icons.announcement),
                        labelText: 'Discription',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: teditVno,
                      decoration: InputDecoration(
                        icon: Icon(Icons.announcement),
                        labelText: 'Vehicle No(Only for License etc)',
                      ),
                    ),
                  ],
                ),
                buttons: [
                  DialogButton(
                    onPressed: () {
                      // ------- SHOW DatePicker ADD--------
                      DatePicker.showDatePicker(context,
                          theme: DatePickerTheme(
                            containerHeight: 210.0,
                            backgroundColor: Color(0xFFFFEB3B),
                          ),
                          showTitleActions: true,
                          minTime: DateTime(2015, 01, 01),
                          maxTime: DateTime(2025, 12, 31), onConfirm: (date) {
                        _date.add('${date.year} - ${date.month} - ${date.day}');

                        listVno.add(teditVno.text);
                        list.add(teditName.text);
                        _notificationPlugin.showWeeklyAtDayAndTime(
                            Time(12, 26, 00),
                            Day.Monday,
                            0,
                            teditVno.text,
                            'Your ${teditName.text} is expire soon');

                        Navigator.pop(context);

                        setState(() {});
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Text(
                      "ADD Expire Date",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ]).show();
          });
        },
        tooltip: 'Add Reminder',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 37,
        ),
      ),
      //------------------------------------------------------------------------------------
    );
  }
}
//---------------------------------------------------- CARD -------------------------------------
