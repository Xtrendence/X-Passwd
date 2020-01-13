import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:x_passwd/theme.dart';
import 'package:x_passwd/utils.dart';

Utils utils = new Utils();

class ImportVault extends StatelessWidget {
	AppTheme theme;
	final inputPassword = TextEditingController();
	
	ImportVault(AppTheme appTheme) {
		this.theme = appTheme;
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: theme.getTheme()["backgroundColorLight"],
			appBar: AppBar(
				backgroundColor: theme.getTheme()["accentColor"],
				elevation: 0.0,
				actions: <Widget>[
					IconButton(
						icon: Icon(Icons.help),
						onPressed: () async {
							showDialog(
								context: context,
								child: AlertDialog(
									title: Text("Help"),
									content: Text("Exported vaults are saved in \"" + (await getExternalStorageDirectory()).path + "/\" and have the extension \".passwd\""),
									actions: [
										FlatButton(
											onPressed: () {
												Navigator.of(context).pop();
											},
											child: Text("Dismiss", style: TextStyle(
												fontWeight: FontWeight.bold,
												color: theme.getTheme()["accentColor"],
												fontSize: 18
											)),
										)
									],
								),
							);
						},
					)
				],
			),
			body: Builder(
				builder: (builderContext) =>
					ListView(
						children: <Widget>[
							Column(
								mainAxisAlignment: MainAxisAlignment.center,
								crossAxisAlignment: CrossAxisAlignment.center,
								children: <Widget>[
									Padding(
										padding: const EdgeInsets.fromLTRB(40, 60, 40, 0),
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
																labelText: "Imported Vault Password...",
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
														String password = inputPassword.text.toString().trim();
														if(password != "") {
															String filePath = await FilePicker.getFilePath(type: FileType.ANY);
															File vaultFile = File(filePath);
															String content = await vaultFile.readAsString();
															bool imported = await utils.importVault(content, password);
															
															if(imported) {
																showDialog(
																	context: context,
																	builder: (BuildContext context) {
																		return AlertDialog(
																			title: Text("Restart Required"),
																			content: Text("The selected vault has been imported. This requires the app to be restarted."),
																			actions: [
																				FlatButton(
																					onPressed: () async {
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
															}
															else {
																utils.notify(builderContext, "Couldn't import the selected vault. Make sure you entered the right password.", 8000);
															}
														}
														else {
															utils.notify(builderContext, "You need to provide a password to decrypt the vault.", 6000);
														}
													},
													child: Card(
														color: theme.getTheme()["accentColor"],
														elevation: 0.2,
														child: Column(
															children: <Widget>[
																Padding(
																	padding: const EdgeInsets.all(15),
																	child: Text("Choose File", style: TextStyle(
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
					)
			)
		);
	}
}