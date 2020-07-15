import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNewPost extends StatefulWidget {
  final List uploadList;
  final List files;

  const CreateNewPost({Key key, this.uploadList, this.files}) : super(key: key);

  @override
  _CreateNewPostState createState() => _CreateNewPostState();
}

class _CreateNewPostState extends State<CreateNewPost> {
  TextEditingController _captionController = TextEditingController();
  TextEditingController _decriptionController = TextEditingController();
  String _caption = '';
  String _description = '';
  bool _isLoading = false;

  _submit() async {}

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context, isDismissible: false);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF8B66),
        title: Text(
          'Create Post',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              if (_captionController.text == '') {
                FlutterToast.showToast(
                    msg: 'Please Enter a Caption for your post');
              } else {
                if (!_isLoading) {
                  await pr.show();
                  setState(() {
                    _isLoading = true;
                  });
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  int uid = prefs.getInt('uid');

                  // Create post
                  FormData formData = FormData.fromMap({
                    'user_id': uid,
                    'title': _captionController.text,
                    'photo': widget.uploadList,
                    'description': _decriptionController.text,
                  });
                  const url = 'https://www.mustdiscovertech.co.in/social/v1/';
                  Dio dio = new Dio();
                  try {
                    Response response =
                        await dio.post('${url}post/upload', data: formData);
                    print(response);

                    FlutterToast.showToast(
                        msg: 'Your post is uploaded successfully!');
                    // Reset data
                    _captionController.clear();

                    setState(() {
                      _caption = '';
                      _description = '';
                      _isLoading = false;
                    });
                    await pr.hide();
                    Navigator.pop(context);
                  } on DioError catch (e) {
                    print(e.error);
                    await pr.hide();

                    FlutterToast.showToast(msg: 'Not able to upload your post');

                    throw (e.error);
                  }
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          child: Column(
            children: <Widget>[
              Expanded(
                child: PageView.builder(
                    itemCount: widget.files.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: <Widget>[
                            Image.file(widget.files[index]),
                            IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.files.removeAt(index);
                                  widget.uploadList.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    controller: PageController(
                      viewportFraction: 0.85,
                      initialPage: 0,
                    )),
              ),
              // widget.files != null
              //     ? Expanded(
              //         flex: 2,
              //         child: GridView.builder(
              //           shrinkWrap: true,
              //           physics: AlwaysScrollableScrollPhysics(),
              //           primary: false,
              //           itemCount: widget.files.length,
              //           gridDelegate:
              //               SliverGridDelegateWithFixedCrossAxisCount(
              //             crossAxisCount: 1,
              //             childAspectRatio: 1,
              //           ),
              //           itemBuilder: (BuildContext context, int index) {
              //             return Padding(
              //               padding: EdgeInsets.all(5.0),
              //               child: Stack(
              //                 children: <Widget>[
              //                   Image.file(widget.files[index]),
              //                   IconButton(
              //                     icon: Icon(
              //                       Icons.cancel,
              //                       color: Colors.red,
              //                       size: 30,
              //                     ),
              //                     onPressed: () {
              //                       setState(() {
              //                         widget.files.removeAt(index);
              //                       });
              //                     },
              //                   ),
              //                 ],
              //               ),
              //             );
              //           },
              //         ),
              //       )
              //     : Container(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: TextField(
                  controller: _captionController,
                  style: TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                    labelText: 'Caption',
                  ),
                  onChanged: (input) => _caption = input,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: TextField(
                  controller: _decriptionController,
                  style: TextStyle(fontSize: 18.0),
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  onChanged: (input) => _description = input,
                ),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
