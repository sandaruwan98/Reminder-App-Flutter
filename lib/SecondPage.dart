import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SecondPageState();
}


List<double> data1 = [1.0, 1.1, 1.0, 1.2, 1.3, 1.3, 1.3, 1.3];
class SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(child: _Text()),
         bottomNavigationBar: BottomAppBar(
        color: Colors.teal,shape: CircularNotchedRectangle(),
        child: Container(height: 20,),
      ),  
        
      // floatingActionButton: FloatingActionButton(
      //   hoverColor: Colors.blue,
      //   onPressed: () {
      //     setState(() {
      //    //   list.add('fuck');
      //     });
      //   },
      //   tooltip: 'Add Reminder',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}

class _Text extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text('This is Awesome'),
        ),
      ),
    );
  }
}


