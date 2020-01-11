import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x_passwd/main.dart';
import 'package:x_passwd/theme.dart';
import 'package:x_passwd/views/create_vault.dart';
import 'package:x_passwd/views/password_list.dart';

import '../utils.dart';

AppTheme theme = new AppTheme();

class LoginForm extends StatelessWidget {
	final inputPassword = TextEditingController(text: "");
	
	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			backgroundColor: theme.getTheme()["backgroundColorLight"],
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
															onFieldSubmitted: (value) async {
																await login(context);
															},
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
														await login(context);
													},
													child: Card(
														color: theme.getTheme()["accentColor"],
														elevation: 0.2,
														child: Column(
															children: <Widget>[
																Padding(
																	padding: const EdgeInsets.all(15),
																	child: Text("Access Vault", style: TextStyle(
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
													onTap: () async {
														Utils utils = new Utils();
														bool vaultExists = await utils.vaultExists();
														if(inputPassword.text.toString().trim() != "") {
															Navigator.push(
																context,
																MaterialPageRoute(builder: (context) => CreateForm.autoFill(vaultExists, inputPassword.text.toString()))
															);

															inputPassword.clear();
														}
														else {
															
															Navigator.push(
																context,
																MaterialPageRoute(builder: (context) => CreateForm(vaultExists))
															);
														}
														
														theme.statusColorAccent();
													},
													child: Card(
														color: theme.getTheme()["accentColorLight"],
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
								],
							)
						],
					),
			)
		);
	}
	login(BuildContext context) async {
		Utils utils = new Utils();
		
		String password = inputPassword.text.toString().trim();
		String currentPassword = await utils.getPassword();
		
		String list = await utils.read();
		
		print(list);
		
		if(password == currentPassword) {
			inputPassword.clear();
			
			Navigator.push(
				context,
				MaterialPageRoute(builder: (context) => PasswordList.setPasswordList(list))
			);
			
			theme.statusColorAccent();
		}
		else {
			utils.notify(context, "Wrong password.");
		}
	}
}