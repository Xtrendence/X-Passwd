import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x_passwd/main.dart';
import 'package:x_passwd/views/password_form.dart';

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
		return Scaffold(
			appBar: AppBar(
				title: Text("X:/Passwd"),
				backgroundColor: accentColor,
				elevation: 0.0,
				actions: <Widget>[
					IconButton(
						icon: Icon(Icons.search),
						onPressed: () {
						
						},
					),
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
			body: (this.ids.length > 0) ? ListView.builder(
				itemCount: this.ids.length,
				itemBuilder: (context, index) {
					return Padding(
						padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
						child: InkWell(
							onTap: () {
								Navigator.push(
									context,
									MaterialPageRoute(builder: (context) => PasswordForm.edit("edit", this.ids[index]))
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
			) : Stack(
				children: <Widget>[
					Column(
						children: <Widget>[
							Padding(
								padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
								child: InkWell(
									onTap: () {
										Navigator.push(
											context,
											MaterialPageRoute(builder: (context) => PasswordForm("add"))
										);
									},
									child: Card(
										color: accentColor,
										child: Column(
											children: <Widget>[
												Padding(
													padding: const EdgeInsets.all(20),
													child: Row(
														children: <Widget>[
															Text("Add a password...", style: TextStyle(
																fontWeight: FontWeight.bold,
																color: backgroundColorLight,
																fontSize: 18
															)),
														],
													),
												)
											],
										),
									),
								),
							),
						],
					),
				],
			),
		);
	}
}
