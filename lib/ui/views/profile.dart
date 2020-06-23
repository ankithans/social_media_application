import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static Random random = Random();
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
          'Profile',
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              CircleAvatar(
                backgroundImage: AssetImage(
                  "assets/images/grootlover.jpg",
                ),
                radius: 50,
              ),
              SizedBox(height: 10),
              Text(
                'Ankit Hans',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 3),
              Text(
                "Status should be here",
                style: TextStyle(),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton(
                    child: Icon(
                      Icons.message,
                      color: Colors.white,
                    ),
                    color: Colors.grey,
                    onPressed: () {},
                  ),
                  SizedBox(width: 10),
                  FlatButton(
                    child: Text(
                      'Edit',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).accentColor,
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildCategory("Posts"),
                    _buildCategory("Followers"),
                    _buildCategory("Following"),
                  ],
                ),
              ),
              SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                primary: false,
                padding: EdgeInsets.all(5),
                itemCount: 10,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 200 / 200,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        "assets/images/gamora.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(String title) {
    return Column(
      children: <Widget>[
        Text(
          random.nextInt(10000).toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(),
        ),
      ],
    );
  }
}
