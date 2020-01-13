import 'dart:async';
import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_passwd/main.dart';
import 'package:x_passwd/theme.dart';
import 'package:x_passwd/utils.dart';
import 'package:x_passwd/views/create_vault.dart';
import 'package:x_passwd/views/login.dart';
import 'package:x_passwd/views/password_form.dart';
import 'package:x_passwd/views/settings.dart';

AppTheme theme;
Map passwords;

final inputSearch = TextEditingController();

class PasswordList extends StatefulWidget {
	PasswordList(AppTheme appTheme) {
		theme = appTheme;
	}
	
	PasswordList.setPasswordList(AppTheme appTheme, String list) {
		theme = appTheme;
		passwords = jsonDecode(list) as Map;
	}
	
	@override
	State createState() => PasswordListState();
}

class Delay {
	int delay;
	VoidCallback action;
	Timer timer;
	
	Delay({ this.delay });
	
	run(VoidCallback action) {
		if(timer != null) {
			timer.cancel();
		}
		timer = Timer(Duration(milliseconds: delay), action);
	}
}

class PasswordListState extends State<PasswordList> {
	final delay = Delay(delay: 420);
	
	Map<String, dynamic> passwordItems;
	List passwordIDs;
	
	Map<String, dynamic> filteredPasswordItems;
	List filteredPasswordIDs;
	
	@override
	void initState() {
		super.initState();
		setState(() {
			passwordItems = passwords;
			passwordIDs = passwordItems.keys.toList();
			filteredPasswordItems = passwordItems;
			filteredPasswordIDs = passwordIDs;
		});
	}
	
	@override
	Widget build(BuildContext builderContext) {
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
									MaterialPageRoute(builder: (context) => LoginForm(theme))
								);
							}
							else {
								Navigator.push(
									context,
									MaterialPageRoute(builder: (context) => CreateForm(theme, vaultExists))
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
									MaterialPageRoute(builder: (context) => Settings(theme))
								);
								theme.statusColorAccent();
							},
						),
						IconButton(
							icon: Icon(Icons.add_circle_outline),
							onPressed: () {
								Navigator.push(
									context,
									MaterialPageRoute(builder: (context) => PasswordForm.action(theme, "add"))
								);
								theme.statusColorAccent();
							},
						)
					],
				),
				body: Column(
					children: <Widget>[
						if(passwordIDs.length > 0) Padding(
							padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
							child: Card(
								color: theme.getTheme()["backgroundColorMedium"],
								child: Column(
									children: <Widget>[
										Padding(
											padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
											child: TextFormField(
												onChanged: (query) async {
													delay.run(() {
														setState(() {
															filteredPasswordItems = passwordItems;
															filteredPasswordIDs = passwordIDs;
															Map<String, dynamic> tempItems = {};
															for(int i = 0; i < filteredPasswordIDs.length; i++) {
																String id = filteredPasswordIDs[i];
																Map<String, dynamic> item = jsonDecode(filteredPasswordItems[id]);
																if(item["title"].toString().toLowerCase().contains(query.toLowerCase())) {
																	tempItems[id] = jsonEncode(item);
																}
															}
															filteredPasswordItems = tempItems;
															filteredPasswordIDs = tempItems.keys.toList();
														});
													});
												},
												controller: inputSearch,
												style: TextStyle(
													color: theme.getTheme()["textColorDark"]
												),
												decoration: InputDecoration(
													labelStyle: TextStyle(
														color: theme.getTheme()["textColorDark"]
													),
													labelText: "Search...",
													border: InputBorder.none,
													suffixIcon: IconTheme(
														data: IconThemeData(
															color: theme.getTheme()["textColorLight"]
														),
														child: IconButton(
															icon: Icon(Icons.clear, size: 32),
															onPressed: () async {
																inputSearch.clear();
																setState(() {
																	filteredPasswordItems = passwordItems;
																	filteredPasswordIDs = passwordIDs;
																});
																FocusScope.of(builderContext).requestFocus(new FocusNode());
															},
														),
													)
												),
											),
										),
									],
								),
							),
						),
						(filteredPasswordIDs.length > 0) ? Expanded(
							child: ListView.builder(
								itemCount: filteredPasswordIDs.length,
								itemBuilder: (context, index) {
									String id = filteredPasswordIDs[index];
									Map<String, dynamic> item = jsonDecode(filteredPasswordItems[id]);
									String title = item["title"];
									String url = item["url"];
									
									return Padding(
										padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
										child: InkWell(
											onTap: () {
												Navigator.push(
													context,
													MaterialPageRoute(builder: (context) => PasswordForm.edit(theme, "edit", id, passwords))
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
							),
						) : Expanded(
							child: Stack(
								children: <Widget>[
									if(passwordIDs.length <= 0) Column(
										children: <Widget>[
											Padding(
												padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
												child: InkWell(
													onTap: () {
														Navigator.push(
															context,
															MaterialPageRoute(builder: (context) => PasswordForm.action(theme, "add"))
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
						)
					]
				),
			),
		);
	}
}
