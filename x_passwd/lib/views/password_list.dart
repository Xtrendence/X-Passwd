import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x_passwd/main.dart';
import 'package:x_passwd/theme.dart';
import 'package:x_passwd/utils.dart';
import 'package:x_passwd/views/create_vault.dart';
import 'package:x_passwd/views/login.dart';
import 'package:x_passwd/views/password_form.dart';
import 'package:x_passwd/views/settings.dart';

AppTheme theme = new AppTheme();

class PasswordList extends StatelessWidget {
	Map passwords;
	List ids;
	
	PasswordList();
	
	PasswordList.setPasswordList(String list) {
		this.passwords = jsonDecode(list) as Map;
		this.ids = this.passwords.keys.toList();
	}
	
	@override
	Widget build(BuildContext context) {
		
		return WillPopScope(
			onWillPop: () async => false,
			child: Scaffold(
				backgroundColor: theme.getTheme()["backgroundColorLight"],
				appBar: AppBar(
					backgroundColor: theme.getTheme()["accentColor"],
					elevation: 0.0,
					leading: IconButton(
						icon: Icon(Icons.power_settings_new),
						onPressed: () async {
							Navigator.of(context).pop();
							
							Utils utils = new Utils();
							
							bool vaultExists = await utils.vaultExists();
							
							if(vaultExists) {
								Navigator.push(
									context,
									MaterialPageRoute(builder: (context) => LoginForm())
								);
							}
							else {
								Navigator.push(
									context,
									MaterialPageRoute(builder: (context) => CreateForm(vaultExists))
								);
							}
							theme.statusColorBackground();
						}
					),
					actions: <Widget>[
						IconButton(
							icon: Icon(Icons.settings),
							onPressed: () {
								Navigator.push(
									context,
									MaterialPageRoute(builder: (context) => Settings())
								);
								theme.statusColorAccent();
							},
						),
						IconButton(
							icon: Icon(Icons.search),
							onPressed: () {
								theme.statusColorAccent();
							},
						),
						IconButton(
							icon: Icon(Icons.add_circle_outline),
							onPressed: () {
								Navigator.push(
									context,
									MaterialPageRoute(builder: (context) => PasswordForm.action("add"))
								);
								theme.statusColorAccent();
							},
						)
					],
				),
				body: (this.ids.length > 0) ? ListView.builder(
					itemCount: this.ids.length,
					itemBuilder: (context, index) {
						String id = this.ids[index];
						Map<String, dynamic> item = jsonDecode(this.passwords[id]);
						String title = item["title"];
						String url = item["url"];
						
						return Padding(
							padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
							child: InkWell(
								onTap: () {
									Navigator.push(
										context,
										MaterialPageRoute(builder: (context) => PasswordForm.edit("edit", id, this.passwords))
									);
									theme.statusColorAccent();
								},
								child: Card(
									color: theme.getTheme()["backgroundColorMedium"],
									elevation: 1.5,
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
															child: Text(title, style: TextStyle(
																fontWeight: FontWeight.bold,
																color: theme.getTheme()["textColorDark"],
																fontSize: 18
															)),
														),
														Padding(
															padding: const EdgeInsets.all(10),
															child: Text(url, style: TextStyle(
																fontStyle:FontStyle.italic,
																color: theme.getTheme()["textColorLight"]
															)),
														),
													],
												),
												Expanded(
													child: Padding(
														padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
														child: Column(
															crossAxisAlignment: CrossAxisAlignment.end,
															children: <Widget>[
																IconTheme(
																	data: IconThemeData(
																		color: theme.getTheme()["textColorLight"]
																	),
																	child: Icon(Icons.arrow_forward_ios, size: 24),
																),
															],
														),
													),
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
												MaterialPageRoute(builder: (context) => PasswordForm.action("add"))
											);
											theme.statusColorAccent();
										},
										child: Card(
											color: theme.getTheme()["accentColor"],
											child: Column(
												children: <Widget>[
													Padding(
														padding: const EdgeInsets.all(20),
														child: Row(
															children: <Widget>[
																Text("Add a password...", style: TextStyle(
																	fontWeight: FontWeight.bold,
																	color: theme.getTheme()["accentContrast"],
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
			),
		);
	}
}
