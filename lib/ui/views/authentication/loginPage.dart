import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/models/default.dart';
import 'package:social_media_application/models/user.dart';
import 'package:social_media_application/repositories/api_client.dart';
import 'package:social_media_application/repositories/api_repositories.dart';
import 'package:social_media_application/ui/views/page_controller.dart';
import 'package:social_media_application/ui/widgets/authentication/bezierContainer.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool otpSent = false;
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _nameController = TextEditingController();
  Default _default;
  User _user;
  bool _isloading = false;

  final ApiRepository apiRepository = ApiRepository(
    apiClient: ApiClient(),
  );

  void loginWithPhone() async {
    _default = await apiRepository.signInWithMobile(
        _nameController.text, '${_phoneController.text}', 'registrationToken');
  }

  void addUserDetails(String name, String bio, [String picurl]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    prefs.setString('bio', bio);
    prefs.setString('pic', picurl);
  }

  addBoolToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
  }

  getSharedPF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int user_Id = prefs.getInt('userId');
    print(user_Id);
  }

  void verifyOtp() async {
    final ProgressDialog pr = ProgressDialog(context, isDismissible: false);
    pr.show();
    setState(() {
      _isloading = true;
    });
    _user = await apiRepository.verifyOtp(
        _phoneController.text, _otpController.text);
    setState(() {
      _isloading = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('uid', _user.result.userId);
    addUserDetails(
      _nameController.text,
      'Please update your bio in profile section',
    );
    pr.hide();
    addBoolToSF();
    getSharedPF();
    navigateToHome();
    print(_user.result.mobile);
    getSharedPF();
  }

  void resendOtp() async {
    setState(() {
      _isloading = true;
    });
    _default = await apiRepository.resendOtp(_phoneController.text);
    setState(() {
      _isloading = false;
    });
  }

  void googleSignIn() async {
    final ProgressDialog pr = ProgressDialog(context, isDismissible: false);

    // GoogleSignIn _googleSignIn = GoogleSignIn(
    //   scopes: [
    //     'email',
    //   ],
    // );

    // final user = await _googleSignIn.signIn();
    // print(user.email);
    pr.show();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    SharedPreferences myPrefs = await SharedPreferences.getInstance();

    // print(user.email);
    // print(user.displayName);
    // print(user.photoUrl);
    // addBoolToSF();
    const url = 'https://www.mustdiscovertech.co.in/social/v1/';
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({
      'email': user.email,
      'registration_token': 'aaaa',
      'name': user.displayName,
      'profile_pic': user.photoUrl,
      'mobile': '',
    });

    try {
      Response response =
          await dio.post('${url}user/sociallogin', data: formData);

      _user = User.fromJson(response.data);
      pr.hide();

      myPrefs.setInt('uid', _user.result.userId);
      addUserDetails(user.displayName,
          'Please update your bio in profile section', user.photoUrl);
      navigateToHome();
      addBoolToSF();
      getSharedPF();
    } on DioError catch (e) {
      pr.hide();
      FlutterToast.showToast(
          msg: 'Not able to login at this moment. Please try again.');
      print(e.error);
      throw e.error;
    }
  }

  // _user = await apiRepository.socialSignIn(
  //   user.email,
  //   'mfkkenf',
  //   user.displayName,
  //   user.photoUrl,
  // );

  void navigateToHome() {
    if (_user.error == false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PageControl(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _entryField(String title, TextEditingController controller,
      TextInputType textInputType) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            cursorColor: Colors.black,
            keyboardType: textInputType,
            controller: controller,
            decoration: new InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
              hintText: title,
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return FlatButton(
      onPressed: () {
        if (_nameController.text != '' || _phoneController.text != '') {
          if (_phoneController.text.length == 10) {
            if (otpSent == false) {
              loginWithPhone();
              setState(() {
                otpSent = true;
              });
            } else {
              if (_otpController.text == '') {
                FlutterToast.showToast(msg: 'Please Enter OTP first.');
              } else {
                verifyOtp();
              }
            }
          } else {
            FlutterToast.showToast(msg: 'Please Enter a valid phone number');
          }
        } else {
          FlutterToast.showToast(msg: 'Please enter your name and phone');
        }
      },
      child: Container(
        width: otpSent ? 200 : MediaQuery.of(context).size.width * 0.78,
        padding: EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: _isloading
            ? CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 2,
              )
            : Text(
                otpSent == false ? 'Login' : 'Verify Otp',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Social',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'Media',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Name", _nameController, TextInputType.text),
        _entryField("Phone", _phoneController, TextInputType.phone),
        if (otpSent) _entryField('otp', _otpController, TextInputType.number),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .3,
              child: BezierContainer()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .3),
                  _title(),
                  SizedBox(height: 50),
                  _emailPasswordWidget(),

                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      _submitButton(),
                      if (otpSent)
                        Align(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              resendOtp();
                            },
                            child: Text(
                              'Resend Otp',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _divider(),
                  SizedBox(
                    height: 5,
                  ),
                  SignInButton(
                    Buttons.Google,
                    text: "Sign up with Google",
                    onPressed: () async {
                      googleSignIn();
                    },
                  ),
                  // SignInButton(
                  //   Buttons.Facebook,
                  //   text: "Sign up with Facebook",
                  //   onPressed: () {},
                  // ),
                  SizedBox(height: height * .015),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
