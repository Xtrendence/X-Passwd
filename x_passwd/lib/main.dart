import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:x_passwd/locator.dart';
import 'package:x_passwd/theme.dart';
import 'package:x_passwd/utils.dart';
import 'package:x_passwd/views/create_vault.dart';
import 'package:x_passwd/views/login.dart';

AppTheme theme = new AppTheme();

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    setupLocator();
    
    Utils utils = new Utils();
    
    String list = await utils.read();
    
    bool vaultExists = await utils.vaultExists();
    
    if(vaultExists) {
        runApp(App(LoginForm(), list));
        theme.statusColorBackground();
    }
    else {
        runApp(App(CreateForm(vaultExists), list));
        theme.statusColorAccent();
    }
}

class App extends StatelessWidget {
    StatelessWidget page;
    String passwords;
    
    App(StatelessWidget form, String list) {
        this.page = form;
        this.passwords = list;
    }
    
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home:this.page,
            title:"X:/Passwd",
            debugShowCheckedModeBanner:false
        );
    }
}