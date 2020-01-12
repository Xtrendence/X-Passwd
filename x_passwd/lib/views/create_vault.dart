import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_passwd/main.dart';
import 'package:x_passwd/theme.dart';
import 'package:x_passwd/utils.dart';
import 'package:x_passwd/views/login.dart';
import 'package:x_passwd/views/password_list.dart';

class CreateForm extends StatelessWidget {
	AppTheme theme;
	bool vaultExists;
	String password = null;
	
	CreateForm(AppTheme appTheme, bool vaultExistence) {
		this.theme = appTheme;
		this.vaultExists = vaultExistence;
	}
	
	CreateForm.autoFill(AppTheme appTheme, bool vaultExistence, String pass) {
		this.theme = appTheme;
		this.vaultExists = vaultExistence;
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
				leading: getBackButton(context),
			),
			body: Builder(
				builder: (context) =>
					ListView(
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
													color: theme.getTheme()["backgroundColorMedium"],
													elevation: 0.8,
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
											color: theme.getTheme()["backgroundColorMedium"],
											elevation: 1.5,
											child: Column(
												children: <Widget>[
													Padding(
														padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
														child: TextFormField(
															controller: inputPassword,
															obscureText: true,
															style: TextStyle(
																color: theme.getTheme()["textColorDark"]
															),
															decoration: InputDecoration(
																labelStyle: TextStyle(
																	color: theme.getTheme()["textColorDark"]
																),
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
											color: theme.getTheme()["backgroundColorMedium"],
											elevation: 1.5,
											child: Column(
												children: <Widget>[
													Padding(
														padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
														child: TextFormField(
															controller: inputPasswordRepeat,
															obscureText: true,
															style: TextStyle(
																color: theme.getTheme()["textColorDark"]
															),
															decoration: InputDecoration(
																labelStyle: TextStyle(
																	color: theme.getTheme()["textColorDark"]
																),
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
																						
																						String list = await utils.read();
																						
																						Navigator.push(
																							context,
																							MaterialPageRoute(builder: (context) => PasswordList.setPasswordList(theme, list))
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
	
	getBackButton(context) {
		if(this.vaultExists) {
			return IconButton(
				icon: Icon(Icons.arrow_back),
				onPressed: () async {
					Navigator.of(context).pop();
					theme.statusColorBackground();
				}
			);
		}
	}
}