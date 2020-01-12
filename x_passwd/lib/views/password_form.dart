import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x_passwd/main.dart';
import 'package:x_passwd/theme.dart';
import 'package:x_passwd/views/password_list.dart';
import 'package:x_passwd/utils.dart';

AppTheme theme = new AppTheme();
Utils utils = new Utils();

class PasswordForm extends StatefulWidget {
	@override
	PasswordFormState createState() => PasswordFormState();
	
	String action;
	String passwordID;
	
	String currentTitle = "";
	String currentUrl = "";
	String currentPassword = "";
	String currentNotes = "";
	
	PasswordForm();
	
	PasswordForm.action(String desiredAction) {
		this.action = desiredAction;
	}
	
	PasswordForm.edit(String desiredAction, String id, Map list) {
		this.action = desiredAction;
		this.passwordID = id;
		
		Map<String, dynamic> item = jsonDecode(list[id]);
		
		this.currentTitle = item["title"];
		this.currentUrl = item["url"];
		this.currentPassword = item["password"];
		this.currentNotes = item["notes"];
	}
}

class PasswordFormState extends State<PasswordForm> {
	bool obscurePassword = true;
	
	void toggleObscurity(TextEditingController controller) {
		setState(() {
			obscurePassword = !obscurePassword;
		});
	}
	
	@override
	Widget build(BuildContext context) {
		String action = widget.action;
		var inputTitle = TextEditingController(text: widget.currentTitle);
		var inputURL = TextEditingController(text: widget.currentUrl);
		var inputPassword = TextEditingController(text: widget.currentPassword);
		var inputNotes = TextEditingController(text: widget.currentNotes);
		
		return Scaffold(
			backgroundColor: theme.getTheme()["backgroundColorLight"],
			appBar: AppBar(
				title: Text(capitalize(action) + " Password"),
				backgroundColor: theme.getTheme()["accentColor"],
				elevation: 0.0,
				leading: IconButton(
					icon: Icon(Icons.arrow_back),
					onPressed: () async {
						Navigator.of(context).pop();
						theme.statusColorAccent();
					}
				),
				actions: <Widget>[
					if(action == "edit") IconButton(
						icon: Icon(Icons.delete),
						onPressed: () async {
							showDialog(
								context: context,
								child: AlertDialog(
									title: Text("Confirmation"),
									content: Text("Are you sure you want to delete this password?"),
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
												Utils utils = new Utils();
												
												await utils.remove(widget.passwordID);
												
												String list = await utils.read();
												
												Navigator.push(
													context,
													MaterialPageRoute(builder: (context) => PasswordList.setPasswordList(list))
												);
												theme.statusColorAccent();
											},
											child: Text("Delete", style: TextStyle(
												fontWeight: FontWeight.bold,
												color: theme.getTheme()["accentColorDark"],
												fontSize: 18
											)),
										),
									],
								),
							);
						},
					)
				]
			),
			body: ListView.builder(
				itemCount: 1,
				itemBuilder: (context, index) {
					return Column(
						children: <Widget>[
							Padding(
								padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
								child: Card(
									color: theme.getTheme()["backgroundColorMedium"],
									child: Column(
										children: <Widget>[
											Padding(
												padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
												child: TextFormField(
													controller: inputTitle,
													style: TextStyle(
														color: theme.getTheme()["textColorDark"]
													),
													decoration: InputDecoration(
														labelStyle: TextStyle(
															color: theme.getTheme()["textColorDark"]
														),
														labelText: "Title...",
														border: InputBorder.none,
														suffixIcon: IconTheme(
															data: IconThemeData(
																color: theme.getTheme()["textColorLight"]
															),
															child: IconButton(
																icon: Icon(Icons.content_paste, size: 32),
																onPressed: () async {
																	if(inputTitle.text.toString().trim() != "") {
																		Clipboard.setData(new ClipboardData(text: inputTitle.text.toString()));
																		utils.notify(context, "Copied to clipboard.");
																	}
																},
															),
														)
													)
												),
											),
										],
									),
								),
							),
							Padding(
								padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
								child: Card(
									color: theme.getTheme()["backgroundColorMedium"],
									child: Column(
										children: <Widget>[
											Padding(
												padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
												child: TextFormField(
													controller: inputURL,
													style: TextStyle(
														color: theme.getTheme()["textColorDark"]
													),
													decoration: InputDecoration(
														labelStyle: TextStyle(
															color: theme.getTheme()["textColorDark"]
														),
														labelText: "URL...",
														border: InputBorder.none,
														suffixIcon: IconTheme(
															data: IconThemeData(
																color: theme.getTheme()["textColorLight"]
															),
															child: IconButton(
																icon: Icon(Icons.content_paste, size: 32),
																onPressed: () async {
																	if(inputURL.text.toString().trim() != "") {
																		Clipboard.setData(new ClipboardData(text: inputURL.text.toString()));
																		utils.notify(context, "Copied to clipboard.");
																	}
																},
															),
														)
													)
												),
											)
										],
									),
								),
							),
							Padding(
								padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
								child: Card(
									color: theme.getTheme()["backgroundColorMedium"],
									child: Column(
										children: <Widget>[
											Padding(
												padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
												child: TextFormField(
													controller: inputPassword,
													obscureText: obscurePassword,
													style: TextStyle(
														color: theme.getTheme()["textColorDark"]
													),
													decoration: InputDecoration(
														labelStyle: TextStyle(
															color: theme.getTheme()["textColorDark"]
														),
														labelText: "Password...",
														border: InputBorder.none,
														suffixIcon: IconTheme(
															data: IconThemeData(
																color: theme.getTheme()["textColorLight"]
															),
															child: IconButton(
																icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off, size: 32),
																onPressed: () async {
																	toggleObscurity(inputPassword);
																},
															),
														)
													)
												),
											)
										],
									),
								),
							),
							Padding(
								padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
								child: Card(
									color: theme.getTheme()["backgroundColorMedium"],
									child: Column(
										children: <Widget>[
											Padding(
												padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
												child: TextFormField(
													controller: inputNotes,
													obscureText: false,
													maxLines: 6,
													expands: false,
													keyboardType: TextInputType.multiline,
													style: TextStyle(
														color: theme.getTheme()["textColorDark"]
													),
													decoration: InputDecoration(
														labelStyle: TextStyle(
															color: theme.getTheme()["textColorDark"]
														),
														labelText: "Notes...",
														alignLabelWithHint: true,
														border: InputBorder.none,
														suffixIcon: IconTheme(
															data: IconThemeData(
																color: theme.getTheme()["textColorLight"]
															),
															child: IconButton(
																icon: Icon(Icons.content_paste, size: 32),
																onPressed: () async {
																	if(inputNotes.text.toString().trim() != "") {
																		Clipboard.setData(new ClipboardData(text: inputNotes.text.toString()));
																		utils.notify(context, "Copied to clipboard.");
																	}
																},
															),
														)
													)
												),
											)
										],
									),
								),
							),
							Padding(
								padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
								child: InkWell(
									onTap: () async {
										if(inputTitle.text.toString().trim() != "" && inputPassword.text.toString().trim() != "") {
											if(action == "add") {
												await utils.save(inputTitle.text.toString(), inputURL.text.toString(), inputPassword.text.toString(), inputNotes.text.toString());
											}
											else if(action == "edit") {
												await utils.edit(widget.passwordID, inputTitle.text.toString(), inputURL.text.toString(), inputPassword.text.toString(), inputNotes.text.toString());
											}
											
											String list = await utils.read();
											
											Navigator.push(
												context,
												MaterialPageRoute(builder: (context) => PasswordList.setPasswordList(list))
											);
											
											theme.statusColorAccent();
										}
										else {
											utils.notify(context, "Title and password need to be provided.");
										}
									},
									child: Card(
										color: theme.getTheme()["accentColor"],
										child: Padding(
											padding: const EdgeInsets.all(15),
											child: Column(
												children: <Widget>[
													Padding(
														padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
														child: Row(
															children: <Widget>[
																Expanded(
																	child: Column(
																		crossAxisAlignment: CrossAxisAlignment.center,
																		mainAxisAlignment: MainAxisAlignment.center,
																		children: <Widget>[
																			Text((action == "add") ? "Add Password" : "Update Password", style: TextStyle(
																				fontSize: 24,
																				fontWeight: FontWeight.bold,
																				color: theme.getTheme()["accentContrast"],
																			)),
																		],
																	),
																)
															],
														)
													)
												],
											),
										),
									),
								),
							),
						],
					);
				}
			)
		);
	}
	
	String capitalize(String input) {
		if (input == null) {
			throw new ArgumentError("string: $input");
		}
		if (input.length == 0) {
			return input;
		}
		return input[0].toUpperCase() + input.substring(1);
	}
}

