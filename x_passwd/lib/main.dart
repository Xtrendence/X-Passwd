import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x_passwd/utils.dart';
import 'package:x_passwd/views/create_vault.dart';
import 'package:x_passwd/views/login.dart';

var backgroundColorDark = Color.fromRGBO(230, 230, 230, 1);
var backgroundColorMedium = Color.fromRGBO(245, 245, 245, 1);
var backgroundColorLight = Color.fromRGBO(255, 255, 255, 1);

var accentColorLight = Color.fromRGBO(0, 175, 255, 1);
var accentColor = Color.fromRGBO(0, 150, 255, 1);
var accentColorDark = Color.fromRGBO(0, 125, 255, 1);

var textColorDark = Color.fromRGBO(75, 75, 75, 1);
var textColorBright = Color.fromRGBO(100, 100, 100, 1);

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    Utils utils = new Utils();
    
    String list = await utils.read();
    
    bool vaultExists = await utils.vaultExists();
    
    if(vaultExists) {
        runApp(App(LoginForm(), list));
    }
    else {
        runApp(App(CreateForm(), list));
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
        SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
                systemNavigationBarColor: backgroundColorMedium,
                statusBarColor: accentColor,
                systemNavigationBarIconBrightness: Brightness.dark,
            ),
        );
        
        return MaterialApp(
            home:this.page,
            title:"X:/Passwd",
            debugShowCheckedModeBanner:false
        );
    }
}