import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:social_media_application/utils/data.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: Colors.grey[50],
        leading: Icon(
          Icons.camera,
          color: Colors.black,
          size: 30,
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.meriendaOne(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return IconButton(
              color: Colors.black,
              icon: Icon(OMIcons.nearMe),
              onPressed: () => {},
            );
          }),
        ],
      ),
      body: ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(10),
        separatorBuilder: (BuildContext context, int index) {
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 0.5,
              width: MediaQuery.of(context).size.width / 1.3,
              child: Divider(),
            ),
          );
        },
        itemCount: notifications.length,
        itemBuilder: (BuildContext context, int index) {
          Map notif = notifications[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  notif['dp'],
                ),
                radius: 25,
              ),
              contentPadding: EdgeInsets.all(0),
              title: Text(notif['notif']),
              trailing: Text(
                notif['time'],
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 11,
                ),
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
