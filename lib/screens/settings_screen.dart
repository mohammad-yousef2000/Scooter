// ignore_for_file: unused_local_variable, import_of_legacy_library_into_null_safe, depend_on_referenced_packages, prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../DarkLight/theme.dart';
import '../DarkLight/theme_button.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsScreen extends StatelessWidget {
  static const keyLanguage = "key-language";
  static const keyNot = "key-notifications";
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? "DarkTheme"
        : "LightTheme";

    return Scaffold(
        body: SafeArea(
      child: ListView(
        padding: EdgeInsets.all(10),
        children: [
          const SizedBox(
            height: 10,
          ),
          SettingsGroup(title: 'Settings', children: <Widget>[
            ChangeThemeButtonWidget(),
            Notifiaction(),
            buildLanguage(),
          ])
        ],
      ),
    ));
  }

  Widget buildLanguage() => DropDownSettingsTile(
        settingKey: keyLanguage,
        title: "Language",
        selected: 1,
        values: <int, String>{
          1: "English",
          2: "Arabic",
        },
        onChange: (language) {/* no */},
      );
  Widget Notifiaction() => SwitchSettingsTile(
      title: 'Notifications',
      settingKey: keyNot,
      leading: Icon(
        Icons.notifications,
        color: Colors.redAccent,
      ));
}
