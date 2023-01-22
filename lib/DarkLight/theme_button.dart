// ignore_for_file: import_of_legacy_library_into_null_safe, depend_on_referenced_packages, unused_local_variable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../DarkLight/theme.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  static const keyDarkMode = "key-Dark-mode";
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SwitchSettingsTile(
      settingKey: keyDarkMode,
      leading: const Icon(
        Icons.dark_mode,
        color: Colors.amberAccent,
      ),
      title: "Dark Mode",
      //value: themeProvider.isDarkMode,
      onChange: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(value);
      },
    );
  }
}
