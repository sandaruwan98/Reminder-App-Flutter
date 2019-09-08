import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'SecondPage.dart';
import 'notificationPlugin.dart';
import 'DBhelper.dart';

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
  final NotificationPlugin _notificationPlugin = NotificationPlugin();

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
                child: myCardDetails(index, context, setState),
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

Widget myCardDetails(int index, BuildContext context, Function setstate) {
  return Padding(
    padding: const EdgeInsets.only(top: 6, bottom: 6),
    child: FlatButton(
      splashColor: Colors.white,
      highlightColor: Colors.white,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(98.0),
      // ),
      //elevation: 6.0,

      child: Material(
        color: Colors.yellow,
        elevation: 6.0,
        borderRadius: BorderRadius.circular(9.0),
        shadowColor: Color(0x802196F3),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 150.0,
            child: Center(
                child: Column(
              children: <Widget>[
                Text(
                  list[index],
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 37,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Exp',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.w100),
                    ),
                    Text(
                      'Vehicle No',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w100),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _date[index],
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 27,
                          fontWeight: FontWeight.lerp(
                              FontWeight.w200, FontWeight.bold, 0.5)),
                    ),
                    Text(
                      listVno[index],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w200),
                    )
                  ],
                )
              ],
            )),
          ),
        ),
      ),
      onPressed: () {
        //--------------------  UPDATE CARD ALERT---------------------------------
        teditName.text = list[index];
        teditVno.text = listVno[index];
        return Alert(
            style: const AlertStyle(
                animationType: AnimationType.grow,
                backgroundColor: Color(0xFFFFEB3B)),
            context: context,
            title: "Update Card",
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
                    icon: Icon(Icons.airplay),
                    labelText: 'Vehicle No(Only for License etc)',
                  ),
                ),
              ],
            ),
            buttons: [
              DialogButton(
                onPressed: () {
                  // ------- SHOW DatePicker UPDATE--------

                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        backgroundColor: Color(0xFFFFEB3B),
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime(2010, 12, 31),
                      maxTime: DateTime(2025, 12, 31), onConfirm: (date) {
                    _date[index] = '${date.year} - ${date.month} - ${date.day}';

                    //  currentDate= '${date.year}${date.month}${date.day}';
                    list[index] = teditName.text;
                    listVno[index] = teditVno.text;
                    setstate(() {});
                    Navigator.pop(context);
                  },
                      currentTime: DateTime.parse('20200101'),
                      locale: LocaleType.en);
                },
                child: Text(
                  "ADD Expire Date",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ]).show();
        //----------------------------------------------------------------------
      },
    ),
  );
}

// RaisedButton(
//   onPressed: () {},
//   shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(5.0)),
//   child: Row(
//     children: <Widget>[
//       Container(
//         alignment: Alignment.center,
//         width: 250,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Icon(
//               Icons.date_range,
//               size: 18.0,
//               color: Colors.teal,
//             ),
//             SizedBox(
//               width: 5,
//             ),
//             Text(
//               _date,
//               style: TextStyle(
//                 color: Colors.teal,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18.0,
//               ),
//             )
//           ],
//         ),
//       ),
//     ],
//   ),
//   color: Colors.white,
// )


//read data from DB
 _read() async {
        DatabaseHelper helper = DatabaseHelper.instance;
        int rowId = 1;
        Word word = await helper.queryWord(rowId);
        if (word == null) {
          print('read row $rowId: empty');
        } else {
          print('read row $rowId: ${word.word} ${word.frequency}');
        }
      }



//save data to DB
_save() async {
        Word word = Word();
        word.word = 'hello';
        word.frequency = 15;
        DatabaseHelper helper = DatabaseHelper.instance;
        int id = await helper.insert(word);
        print('inserted row: $id');
      }