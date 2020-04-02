import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 2.0),
              color: Colors.grey[200],
              child: ListTile(
                leading: CircleAvatar(
                  radius: kToolbarHeight / 2,
                ),
                title: Text("Bạn nhận được lời mời kết bạn!"),
                subtitle: Row(
                  children: <Widget>[
                    FlatButton(
                      color: Colors.green,
                      onPressed: () {},
                      child: Text("Đồng ý"),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    FlatButton(
                      color: Colors.redAccent,
                      onPressed: () {},
                      child: Text("Từ chối"),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
