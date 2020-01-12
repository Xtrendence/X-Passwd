import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_passwd/main.dart';
import 'package:x_passwd/theme.dart';
import 'package:x_passwd/views/create_vault.dart';
import 'package:x_passwd/views/password_list.dart';

import '../utils.dart';



class LoginForm extends StatelessWidget {
	AppTheme theme;
	final inputPassword = TextEditingController(text: "");
	
	LoginForm(appTheme) {
		this.theme = appTheme;
	}
	
	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () async => false,
			child: new Scaffold(
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
											padding: const EdgeInsets.fromLTRB(10, 80, 10, 0),
											child: Container(
												child: Align(
													alignment: Alignment.bottomCenter,
													child: Card(
														color: theme.getTheme()["backgroundColorMedium"],
														elevation: 0.8,
														child: Column(
															children: <Widget>[
																Padding(
																	padding: const EdgeInsets.all(15),
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
																onFieldSubmitted: (value) async {
																	await login(context);
																},
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
																	MaterialPageRoute(builder: (context) => CreateForm.autoFill(theme, vaultExists, inputPassword.text.toString()))
																);
																
																inputPassword.clear();
															}
															else {
																
																Navigator.push(
																	context,
																	MaterialPageRoute(builder: (context) => CreateForm(theme, vaultExists))
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
										Padding(
											padding: const EdgeInsets.all(8.0),
											child: Container(
												decoration: BoxDecoration(
													borderRadius: BorderRadius.all(Radius.circular(72)),
													color: theme.getTheme()["backgroundColorMedium"],
												),
												child: InkWell(
													onTap: () async {
														Utils utils = new Utils();
														
														var auth = LocalAuthentication();
														
														bool bioAvailable = await auth.canCheckBiometrics;
														
														if(bioAvailable) {
															List<BiometricType> bios = await auth.getAvailableBiometrics();
															
															try {
																bool valid = await auth.authenticateWithBiometrics(localizedReason: "Login using biometrics.", stickyAuth: true, useErrorDialogs: true);
																
																if(valid) {
																	inputPassword.text = await utils.getPassword();
																	login(context);
																}
															}
															on PlatformException catch (e) {
																utils.notify(context, e.message.toString());
															}
														}
													},
													child: Padding(
														padding: const EdgeInsets.all(4),
														child: IconTheme(
															data: IconThemeData(
																color: theme.getTheme()["accentColorLight"]
															),
															child: Icon(Icons.fingerprint, size: 72),
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
			),
		);
	}
	login(BuildContext context) async {
		Utils utils = new Utils();
		
		String password = inputPassword.text.toString().trim();
		String currentPassword = await utils.getPassword();
		
		String list = await utils.read();
		
		if(password == currentPassword) {
			inputPassword.clear();
			
			Navigator.push(
				context,
				MaterialPageRoute(builder: (context) => PasswordList.setPasswordList(theme, list))
			);
			
			theme.statusColorAccent();
		}
		else {
			utils.notify(context, "Wrong password.");
		}
	}
}