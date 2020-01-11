import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'views/password_list.dart';

void main() => runApp(App());

class App extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        
        return MaterialApp(
            home:PasswordList(),
            title:"X:/Passwd",
            debugShowCheckedModeBanner:false
        );
    }
}