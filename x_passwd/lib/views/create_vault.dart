import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:x_passwd/main.dart';
import 'package:x_passwd/utils.dart';
import 'package:x_passwd/views/login.dart';
import 'package:x_passwd/views/password_list.dart';

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
			backgroundColor: accentColor,
			appBar: AppBar(
				backgroundColor: accentColor,
				elevation: 0.0
			),
			body: Builder(
				builder: (context) =>
					Container(
						decoration: BoxDecoration(
							gradient: LinearGradient(
								begin: Alignment.topCenter,
								end: Alignment.bottomCenter,
								stops: [0, 1],
								colors: [accentColor, accentColorDark]
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
																	await utils.setPassword(newPassword);
																	
																	inputPassword.clear();
																	inputPasswordRepeat.clear();
																	
																	Navigator.push(
																		context,
																		MaterialPageRoute(builder: (context) => PasswordList())
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
															color: accentColor,
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
															color: accentColorLight,
															elevation: 0.2,
															child: Column(
																children: <Widget>[
																	Padding(
																		padding: const EdgeInsets.all(15),
																		child: Text("Import Vault", style: TextStyle(
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