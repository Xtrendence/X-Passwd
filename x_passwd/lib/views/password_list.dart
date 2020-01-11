import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x_passwd/views/password_form.dart';

var backgroundColorDark = Color.fromRGBO(230, 230, 230, 1);
var backgroundColorMedium = Color.fromRGBO(245, 245, 245, 1);
var backgroundColorLight = Color.fromRGBO(255, 255, 255, 1);

var accentColor = Color.fromRGBO(0, 175, 255, 1);

var textColorDark = Color.fromRGBO(75, 75, 75, 1);
var textColorBright = Color.fromRGBO(100, 100, 100, 1);

class PasswordList extends StatelessWidget {
	Map passwords;
	List ids = new List(0);
	
	PasswordList();
	
	PasswordList.setPasswordList(String list) {
		this.passwords = jsonDecode(list) as Map;
		this.ids = this.passwords.keys.toList();
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
		
		return Scaffold(
			appBar: AppBar(
				title: Text("X:/Passwd"),
				backgroundColor: accentColor,
				elevation: 0.0,
				actions: <Widget>[
					IconButton(
						icon: Icon(Icons.add_circle_outline),
						onPressed: () {
							Navigator.push(
								context,
								MaterialPageRoute(builder: (context) => PasswordForm("add"))
							);
						},
					)
				],
			),
			body: ListView.builder(
				itemCount: this.ids.length,
				itemBuilder: (context, index) {
					return Padding(
						padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
						child: InkWell(
							onTap: () {
								Navigator.push(
									context,
									MaterialPageRoute(builder: (context) => PasswordForm.edit("edit", index))
								);
							},
							child: Card(
								child: Padding(
									padding: const EdgeInsets.all(8.0),
									child: Row(
										children: <Widget>[
											Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												mainAxisAlignment: MainAxisAlignment.center,
												children: <Widget>[
													Padding(
														padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
														child: Text(this.passwords[ids[index]]["title"], style: TextStyle(
															fontWeight: FontWeight.bold,
															color: textColorDark,
															fontSize: 18
														)),
													),
													Padding(
														padding: const EdgeInsets.all(10),
														child: Text(this.passwords[ids[index]]["url"], style: TextStyle(
															fontStyle:FontStyle.italic,
															color: textColorBright
														)),
													),
												],
											),
											Expanded(
												child: IconButton(
													icon: Icon(Icons.arrow_forward_ios),
													iconSize: 24,
													alignment: Alignment.centerRight,
												)
											)
										],
									),
								)
							),
						),
					);
				}
			)
		);
	}
}
