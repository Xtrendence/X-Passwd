import 'package:flutter/material.dart';
import 'package:x_passwd/utils.dart';
import 'views/password_list.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    Utils utils = new Utils();
    
    String list = await utils.read();
    
    runApp(App(list));
}

class App extends StatelessWidget {
    String passwords;
    
    App(String list) {
        this.passwords = list;
    }
    
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home:PasswordList.setPasswordList(this.passwords),
            title:"X:/Passwd",
            debugShowCheckedModeBanner:false
        );
    }
}