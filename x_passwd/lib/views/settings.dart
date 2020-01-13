import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_passwd/main.dart';
import 'package:x_passwd/theme.dart';
import 'package:x_passwd/utils.dart';
import 'package:x_passwd/views/login.dart';

Utils utils = new Utils();

class Settings extends StatelessWidget {
	AppTheme theme;
	final inputPassword = TextEditingController();
	final inputPasswordRepeat = TextEditingController();
	
	Settings(AppTheme appTheme) {
		this.theme = appTheme;
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: theme.getTheme()["backgroundColorLight"],
			appBar: AppBar(
				title: Text("Settings"),
				backgroundColor: theme.getTheme()["accentColor"],
				elevation: 0.0,
				leading: IconButton(
					icon: Icon(Icons.arrow_back),
					onPressed: () async {
						Navigator.of(context).pop();
						theme.statusColorAccent();
					}
				),
			),
			body: Builder(
				builder: (builderContext) =>
					ListView(
						children: <Widget>[
							Column(
								mainAxisAlignment: MainAxisAlignment.start,
								crossAxisAlignment: CrossAxisAlignment.center,
								children: <Widget>[
									Padding(
										padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
										child: Card(
											color: theme.getTheme()["backgroundColorMedium"],
											elevation: 1.5,
											child: Row(
												children: <Widget>[
													Expanded(
														child: Padding(
															padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
															child: Text("Theme", style: TextStyle(
																color: theme.getTheme()["textColorDark"],
																fontWeight: FontWeight.bold,
																fontSize: 18
															)),
														),
													),
													Row(
														children: <Widget>[
															Padding(
																padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
																child: InkWell(
																	onTap: () async {
																		showDialog(
																			context: context,
																			builder: (BuildContext context) {
																				return AlertDialog(
																					title: Text("Warning"),
																					content: Text("Changing the theme requires the app to restart. Would you like to continue?"),
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
																								await theme.setTheme("light");
																								SystemChannels.platform.invokeMethod("SystemNavigator.pop");
																							},
																							child: Text("Restart", style: TextStyle(
																								fontWeight: FontWeight.bold,
																								color: theme.getTheme()["accentColorDark"],
																								fontSize: 18
																							)),
																						),
																					],
																				);
																			},
																		);
																	},
																	child: Container(
																		decoration: BoxDecoration(
																			color: theme.getTheme()["accentColor"],
																			borderRadius: BorderRadius.all(Radius.circular(4))
																		),
																		child: Padding(
																			padding: const EdgeInsets.all(10),
																			child: Text("Light", style: TextStyle(
																				color: theme.getTheme()["accentContrast"],
																				fontWeight: FontWeight.bold,
																				fontSize: 18
																			)),
																		),
																	),
																),
															),
															Padding(
																padding: const EdgeInsets.all(8.0),
																child: InkWell(
																	onTap: () async {
																		showDialog(
																			context: context,
																			builder: (BuildContext context) {
																				return AlertDialog(
																					title: Text("Warning"),
																					content: Text("Changing the theme requires the app to restart. Would you like to continue?"),
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
																								await theme.setTheme("dark");
																								SystemChannels.platform.invokeMethod("SystemNavigator.pop");
																							},
																							child: Text("Restart", style: TextStyle(
																								fontWeight: FontWeight.bold,
																								color: theme.getTheme()["accentColorDark"],
																								fontSize: 18
																							)),
																						),
																					],
																				);
																			},
																		);
																	},
																	child: Container(
																		decoration: BoxDecoration(
																			color: theme.getTheme()["accentColor"],
																			borderRadius: BorderRadius.all(Radius.circular(4))
																		),
																		child: Padding(
																			padding: const EdgeInsets.all(10),
																			child: Text("Dark", style: TextStyle(
																				color: theme.getTheme()["accentContrast"],
																				fontWeight: FontWeight.bold,
																				fontSize: 18
																			)),
																		),
																	),
																),
															),
														],
													),
												],
											),
										),
									),
									Padding(
										padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
										child: Card(
											color: theme.getTheme()["backgroundColorMedium"],
											elevation: 1.5,
											child: Row(
												children: <Widget>[
													Expanded(
														child: Padding(
															padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
															child: Text("Vault", style: TextStyle(
																color: theme.getTheme()["textColorDark"],
																fontWeight: FontWeight.bold,
																fontSize: 18
															)),
														),
													),
													Row(
														children: <Widget>[
															Padding(
																padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
																child: InkWell(
																	onTap: () async {
																		showDialog(
																			context: context,
																			builder: (BuildContext context) {
																				return AlertDialog(
																					title: Text("Warning"),
																					content: Text("Importing a vault will overwrite the existing one. Are you sure you want to continue?"),
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
																								String filePath = await FilePicker.getFilePath(type: FileType.ANY);
																							},
																							child: Text("Import", style: TextStyle(
																								fontWeight: FontWeight.bold,
																								color: theme.getTheme()["accentColorDark"],
																								fontSize: 18
																							)),
																						),
																					],
																				);
																			},
																		);
																	},
																	child: Container(
																		decoration: BoxDecoration(
																			color: theme.getTheme()["accentColor"],
																			borderRadius: BorderRadius.all(Radius.circular(4))
																		),
																		child: Padding(
																			padding: const EdgeInsets.all(10),
																			child: Text("Import", style: TextStyle(
																				color: theme.getTheme()["accentContrast"],
																				fontWeight: FontWeight.bold,
																				fontSize: 18
																			)),
																		),
																	),
																),
															),
															Padding(
																padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
																child: InkWell(
																	onTap: () async {
																	
																	},
																	child: Container(
																		decoration: BoxDecoration(
																			color: theme.getTheme()["accentColor"],
																			borderRadius: BorderRadius.all(Radius.circular(4))
																		),
																		child: Padding(
																			padding: const EdgeInsets.all(10),
																			child: Text("Export", style: TextStyle(
																				color: theme.getTheme()["accentContrast"],
																				fontWeight: FontWeight.bold,
																				fontSize: 18
																			)),
																		),
																	),
																),
															),
															Padding(
																padding: const EdgeInsets.all(8.0),
																child: InkWell(
																	onTap: () async {
																		showDialog(
																			context: context,
																			builder: (BuildContext context) {
																				return AlertDialog(
																					title: Text("Warning"),
																					content: Text("This will delete all your saved passwords and their details. Are you sure you want to continue?"),
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
																								await utils.deleteVault();
																								exit(0);
																							},
																							child: Text("Delete", style: TextStyle(
																								fontWeight: FontWeight.bold,
																								color: theme.getTheme()["accentColorDark"],
																								fontSize: 18
																							)),
																						),
																					],
																				);
																			},
																		);
																	},
																	child: Container(
																		decoration: BoxDecoration(
																			color: theme.getTheme()["accentColor"],
																			borderRadius: BorderRadius.all(Radius.circular(4))
																		),
																		child: Padding(
																			padding: const EdgeInsets.all(10),
																			child: Text("Delete", style: TextStyle(
																				color: theme.getTheme()["accentContrast"],
																				fontWeight: FontWeight.bold,
																				fontSize: 18
																			)),
																		),
																	),
																),
															),
														],
													),
												],
											),
										),
									),
									Padding(
										padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
										child: Card(
											color: theme.getTheme()["backgroundColorMedium"],
											elevation: 1.5,
											child: Column(
												children: <Widget>[
													Row(
														children: <Widget>[
															Expanded(
																child: Padding(
																	padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
																	child: Text("Change Password", style: TextStyle(
																		color: theme.getTheme()["textColorDark"],
																		fontWeight: FontWeight.bold,
																		fontSize: 18
																	)),
																),
															),
														],
													),
													Row(
														children: <Widget>[
															Expanded(
																child: Padding(
																	padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
																	child: Container(
																		padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.all(Radius.circular(5)),
																			color: theme.getTheme()["backgroundColorDark"]
																		),
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
																				labelText: "New Password...",
																				border: InputBorder.none,
																			)
																		),
																	),
																),
															),
														],
													),
													Row(
														children: <Widget>[
															Expanded(
																child: Padding(
																	padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
																	child: Container(
																		padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.all(Radius.circular(5)),
																			color: theme.getTheme()["backgroundColorDark"]
																		),
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
																				border: InputBorder.none,
																			)
																		),
																	),
																),
															),
														],
													),
													Row(
														children: <Widget>[
															Expanded(
																child: Column(
																	mainAxisAlignment: MainAxisAlignment.end,
																	crossAxisAlignment: CrossAxisAlignment.end,
																	children: <Widget>[
																		Padding(
																			padding: const EdgeInsets.all(10),
																			child: InkWell(
																				onTap: () async {
																					String newPassword = inputPassword.text.toString().trim();
																					String repeatPassword = inputPasswordRepeat.text.toString().trim();
																					
																					if(newPassword != "" && repeatPassword != "") {
																						if(newPassword == repeatPassword) {
																							showDialog(
																								context: context,
																								builder: (BuildContext context) {
																									return AlertDialog(
																										title: Text("Confirmation"),
																										content: Text("All your passwords will be encrypted with your new password. Are you sure you want to continue?"),
																										actions: [
																											FlatButton(
																												onPressed: () {
																													Navigator.of(context).pop();
																													inputPassword.text = "";
																													inputPasswordRepeat.text = "";
																													FocusScope.of(builderContext).requestFocus(new FocusNode());
																												},
																												child: Text("Cancel", style: TextStyle(
																													fontWeight: FontWeight.bold,
																													color: theme.getTheme()["accentColor"],
																													fontSize: 18
																												)),
																											),
																											FlatButton(
																												onPressed: () async {
																												
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
																				child: Container(
																					decoration: BoxDecoration(
																						color: theme.getTheme()["accentColor"],
																						borderRadius: BorderRadius.all(Radius.circular(4))
																					),
																					child: Padding(
																						padding: const EdgeInsets.all(14),
																						child: Text("Confirm", style: TextStyle(
																							color: theme.getTheme()["accentContrast"],
																							fontWeight: FontWeight.bold,
																							fontSize: 20
																						)),
																					),
																				),
																			),
																		),
																	],
																),
															),
														],
													)
												],
											),
										),
									),
								],
							)
						],
					)
			),
		);
	}
}