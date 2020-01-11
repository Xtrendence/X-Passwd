import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:x_passwd/main.dart';
import 'package:x_passwd/theme.dart';
import 'package:x_passwd/utils.dart';
import 'package:x_passwd/views/login.dart';
import 'package:x_passwd/views/password_list.dart';

AppTheme theme = new AppTheme();

class CreateForm extends StatelessWidget {
	String password = null;
	
	CreateForm();
	
	CreateForm.autoFill(String pass) {
		this.password = pass;
	}
	
	@override
	Widget build(BuildContext context) {
		final inputPassword = TextEditingController(text: this.password);
		final inputPasswordRepeat = TextEditingController();
		
		return new Scaffold(
			backgroundColor: theme.getTheme()["backgroundColorLight"],
			appBar: AppBar(
				backgroundColor: theme.getTheme()["accentColor"],
				elevation: 0.0,
				leading: IconButton(
					icon: Icon(Icons.arrow_back),
					onPressed: () async {
						Navigator.of(context).pop();
						theme.statusColorBackground();
					}
				),
			),
			body: Builder(
				builder: (context) =>
					Stack(
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
													color: theme.getTheme()["backgroundColorLight"],
													elevation: 0.2,
													child: Column(
														children: <Widget>[
															Padding(
																padding: const EdgeInsets.all(10),
																child: Text("X:/Passwd", style: TextStyle(
																	fontSize: 20,
																	fontWeight: FontWeight.bold,
																	color: theme.getTheme()["accentColor"]
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
										padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
										child: Card(
											child: Column(
												children: <Widget>[
													Padding(
														padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
														child: TextFormField(
															controller: inputPasswordRepeat,
															obscureText: true,
															decoration: InputDecoration(
																labelText: "Repeat Password...",
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
														
														String newPassword = inputPassword.text.toString().trim();
														String repeatPassword = inputPasswordRepeat.text.toString().trim();
														
														if(newPassword != "" && repeatPassword != "") {
															if(newPassword == repeatPassword) {
																showDialog(
																	context: context,
																	builder: (BuildContext context) {
																		return AlertDialog(
																			title: Text("Warning"),
																			content: Text("Creating a vault would overwrite and delete any existing ones."),
																			actions: [
																				FlatButton(
																					onPressed: () {
																						Navigator.of(context).pop();
																					},
																					child: Text("Cancel", style: TextStyle(
																						fontWeight: FontWeight.bold,
																						color: theme.getTheme()["accentColor"],
																						fontSize: 18
																					)),
																				),
																				FlatButton(
																					onPressed: () async {
																						await utils.setPassword(newPassword);
																						
																						inputPassword.clear();
																						inputPasswordRepeat.clear();
																						
																						Navigator.push(
																							context,
																							MaterialPageRoute(builder: (context) => PasswordList())
																						);
																						
																						theme.statusColorAccent();
																					},
																					child: Text("Confirm", style: TextStyle(
																						fontWeight: FontWeight.bold,
																						color: theme.getTheme()["accentColorDark"],
																						fontSize: 18
																					)),
																				),
																			],
																		);
																	},
																);
															}
															else {
																utils.notify(context, "Passwords didn't match.");
															}
														}
														else {
															utils.notify(context, "Please fill out both fields.");
														}
													},
													child: Card(
														color: theme.getTheme()["accentColor"],
														elevation: 0.2,
														child: Column(
															children: <Widget>[
																Padding(
																	padding: const EdgeInsets.all(15),
																	child: Text("Create Vault", style: TextStyle(
																		fontSize: 24,
																		fontWeight: FontWeight.bold,
																		color: theme.getTheme()["backgroundColorLight"]
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
														inputPassword.clear();
														inputPasswordRepeat.clear();
													},
													child: Card(
														color: theme.getTheme()["accentColorLight"],
														elevation: 0.2,
														child: Column(
															children: <Widget>[
																Padding(
																	padding: const EdgeInsets.all(15),
																	child: Text("Import Vault", style: TextStyle(
																		fontSize: 24,
																		fontWeight: FontWeight.bold,
																		color: theme.getTheme()["backgroundColorLight"]
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
			)
		);
	}
}