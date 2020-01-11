import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:x_passwd/main.dart';
import 'package:x_passwd/views/create_vault.dart';
import 'package:x_passwd/views/password_list.dart';

import '../utils.dart';

class LoginForm extends StatelessWidget {
	
	@override
	Widget build(BuildContext context) {
		final inputPassword = TextEditingController();
		
		return new Scaffold(
			backgroundColor: accentColor,
			body: Builder(
				builder: (context) =>
					Container(
						decoration: BoxDecoration(
							gradient: LinearGradient(
								begin: Alignment.topCenter,
								end: Alignment.bottomCenter,
								stops: [0.3, 0.5, 1],
								colors: [accentColor, accentColorDark, accentColorLight]
							)
						),
						child: Stack(
							children: <Widget>[
								Column(
									mainAxisAlignment: MainAxisAlignment.center,
									crossAxisAlignment: CrossAxisAlignment.center,
									children: <Widget>[
										Padding(
											padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
											child: Container(
												child: Align(
													alignment: Alignment.bottomCenter,
													child: Card(
														color: backgroundColorLight,
														elevation: 0.2,
														child: Column(
															children: <Widget>[
																Padding(
																	padding: const EdgeInsets.all(10),
																	child: Text("X:/Passwd", style: TextStyle(
																		fontSize: 20,
																		fontWeight: FontWeight.bold,
																		color: accentColor
																	)),
																)
															],
														),
													),
												),
											),
										),
										Padding(
											padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
											child: Card(
												child: Column(
													children: <Widget>[
														Padding(
															padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
															child: TextFormField(
																controller: inputPassword,
																obscureText: true,
																decoration: InputDecoration(
																	labelText: "Password...",
																	border: InputBorder.none
																)
															),
														)
													],
												),
											),
										),
										Padding(
											padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
											child: Container(
												child: Align(
													alignment: Alignment.bottomCenter,
													child: InkWell(
														onTap: () async {
															Utils utils = new Utils();
															
															String password = inputPassword.text.toString().trim();
															String currentPassword = await utils.getPassword();
															
															if(password == currentPassword) {
																Navigator.push(
																	context,
																	MaterialPageRoute(builder: (context) => PasswordList())
																);
															}
															else {
																utils.notify(context, "Wrong password.");
															}
														},
														child: Card(
															color: accentColor,
															elevation: 0.2,
															child: Column(
																children: <Widget>[
																	Padding(
																		padding: const EdgeInsets.all(15),
																		child: Text("Access Vault", style: TextStyle(
																			fontSize: 24,
																			fontWeight: FontWeight.bold,
																			color: backgroundColorLight
																		)),
																	)
																],
															),
														),
													),
												),
											),
										),
										Padding(
											padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
											child: Container(
												child: Align(
													alignment: Alignment.bottomCenter,
													child: InkWell(
														onTap: () {
															if(inputPassword.text.toString().trim() != "") {
																print("Value: " + inputPassword.text.toString());
																Navigator.push(
																	context,
																	MaterialPageRoute(builder: (context) => CreateForm.autoFill(inputPassword.text.toString()))
																);
															}
															else {
																Navigator.push(
																	context,
																	MaterialPageRoute(builder: (context) => CreateForm())
																);
															}
														},
														child: Card(
															color: accentColorLight,
															elevation: 0.2,
															child: Column(
																children: <Widget>[
																	Padding(
																		padding: const EdgeInsets.all(15),
																		child: Text("Create Vault", style: TextStyle(
																			fontSize: 24,
																			fontWeight: FontWeight.bold,
																			color: backgroundColorLight
																		)),
																	)
																],
															),
														),
													),
												),
											),
										),
									],
								)
							],
						),
					),
			)
		);
	}
}