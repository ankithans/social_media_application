import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_application/ui/views/authentication/welcomePage.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Settings',
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black12,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: 'Account',
            tiles: [
              SettingsTile(
                title: 'My Profile',
                leading: Icon(Icons.verified_user),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {},
              ),
              SettingsTile(
                title: 'Phone number',
                leading: Icon(Icons.phone),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
              SettingsTile(
                title: 'Email',
                leading: Icon(Icons.email),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
              SettingsTile(
                title: 'Security',
                leading: Icon(Icons.security),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
              SettingsTile(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove("isLoggedIn");
                  prefs.remove('userId');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomePage(),
                    ),
                  );
                },
                title: 'Sign out',
                leading: Icon(Icons.exit_to_app),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
            ],
          ),
          SettingsSection(
            title: 'Others',
            tiles: [
              SettingsTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                title: 'Terms of Service',
                leading: Icon(Icons.description),
              ),
              SettingsTile(
                title: 'Licences',
                leading: Icon(Icons.collections_bookmark),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
              SettingsTile(
                title: 'Help',
                leading: Icon(Icons.help),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
              SettingsTile(
                title: 'About',
                leading: Icon(Icons.info),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
            ],
          )
        ],
      ),
    );
  }
}
