import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_passwd/locator.dart';
import 'package:x_passwd/theme.dart';
import 'package:x_passwd/utils.dart';
import 'package:x_passwd/views/create_vault.dart';
import 'package:x_passwd/views/login.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    setupLocator();
    
    Utils utils = new Utils();
    
    bool vaultExists = await utils.vaultExists();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String scheme = preferences.getString("theme");
    AppTheme theme = new AppTheme(scheme);
    
    if(vaultExists) {
        runApp(App(LoginForm(theme)));
    }
    else {
        runApp(App(CreateForm(theme, vaultExists)));
    }
    
    theme.statusColorBackground();
}

class App extends StatefulWidget {
    StatelessWidget page;
    
    App(StatelessWidget form) {
        this.page = form;
    }

    @override
    State createState() => AppState();
}

class AppState extends State<App> {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home:widget.page,
            title:"X:/Passwd",
            debugShowCheckedModeBanner:false
        );
    }
}