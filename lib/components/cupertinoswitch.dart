import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketit/components/theme_provider.dart';
import 'package:marketit/theme/theme.dart';
import 'package:provider/provider.dart';

class CupertinoSwitcher extends StatelessWidget {
  const CupertinoSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeData == darkMode;
    return CupertinoSwitch(
      value: isDarkMode,
      onChanged: (bool value) {
        themeProvider.toggleTheme();
      },
    );
  }
}
