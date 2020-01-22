import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_passwd/main.dart';
import 'package:x_passwd/theme.dart';
import 'package:x_passwd/utils.dart';
import 'package:x_passwd/views/import_vault.dart';
import 'package:x_passwd/views/login.dart';
import 'package:x_passwd/views/password_list.dart';

Utils utils = new Utils();

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
	
	getAppBar(BuildContext context) {
		if(this.vaultExists) {
			return AppBar(
				backgroundColor: theme.getTheme()["accentColor"],
				elevation: 0.0,
				leading: getBackButton(context),
			);
		}
	}
	
	@override
	Widget build(BuildContext context) {
		final inputPassword = TextEditingController(text: this.password);
		final inputPasswordRepeat = TextEditingController();
		
		return new Scaffold(
			backgroundColor: theme.getTheme()["backgroundColorLight"],
			appBar: getAppBar(context),
			body: Builder(
				builder: (context) =>
					ListView(
						children: <Widget>[
							Column(
								mainAxisAlignment: MainAxisAlignment.center,
								crossAxisAlignment: CrossAxisAlignment.center,
								children: <Widget>[
									Padding(
										padding: const EdgeInsets.fromLTRB(10, 60, 10, 0),
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
														String newPassword = inputPassword.text.toString().trim();
														String repeatPassword = inputPasswordRepeat.text.toString().trim();
														
														if(newPassword != "" && repeatPassword != "") {
															if(newPassword == repeatPassword) {
																SharedPreferences preferences = await SharedPreferences.getInstance();
																if(preferences.containsKey("tosAccepted") && preferences.getBool("tosAccepted") == true) {
																	showWarning(context, newPassword, inputPassword, inputPasswordRepeat);
																}
																else {
																	showDialog(
																		context: context,
																		builder: (BuildContext context) {
																			return AlertDialog(
																				backgroundColor: theme.getTheme()["backgroundColorLight"],
																				title: Text("Terms of Service", style: TextStyle(
																					color: theme.getTheme()["textColorDark"]
																				)),
																				content: Text("While every step has been taken by the developer to ensure the protection, and the integrity of your passwords, by using this app, you agree that the developer cannot be held accountable for any lost passwords or any other losses.", style: TextStyle(
																					color: theme.getTheme()["textColorLight"]
																				)),
																				actions: [
																					FlatButton(
																						onPressed: () {
																							SystemChannels.platform.invokeMethod("SystemNavigator.pop");
																						},
																						child: Text("Disagree", style: TextStyle(
																							fontWeight: FontWeight.bold,
																							color: theme.getTheme()["accentColor"],
																							fontSize: 18
																						)),
																					),
																					FlatButton(
																						onPressed: () async {
																							await preferences.setBool("tosAccepted", true);
																							Navigator.of(context).pop();
																							inputPassword.text = newPassword;
																							inputPasswordRepeat.text = repeatPassword;
																							showWarning(context, newPassword, inputPassword, inputPasswordRepeat);
																						},
																						child: Text("Agree", style: TextStyle(
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
															}
															else {
																utils.notify(context, "Passwords didn't match.", 4000);
															}
														}
														else {
															utils.notify(context, "Please fill out both fields.", 4000);
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
														showWarning(context, inputPassword.text.toString().trim(), inputPassword, inputPasswordRepeat);
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
	
	showWarning(BuildContext context, String newPassword, TextEditingController inputPassword, TextEditingController inputPasswordRepeat) {
		showDialog(
			context: context,
			builder: (BuildContext context) {
				return AlertDialog(
					backgroundColor: theme.getTheme()["backgroundColorLight"],
					title: Text("Warning", style: TextStyle(
						color: theme.getTheme()["textColorDark"]
					)),
					content: Text("Creating a vault would overwrite and delete any existing ones.", style: TextStyle(
						color: theme.getTheme()["textColorLight"]
					)),
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