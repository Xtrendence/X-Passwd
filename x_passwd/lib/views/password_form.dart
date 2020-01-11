import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x_passwd/main.dart';
import 'package:x_passwd/theme.dart';
import 'package:x_passwd/views/password_list.dart';
import 'package:x_passwd/utils.dart';

AppTheme theme = new AppTheme();

class PasswordForm extends StatelessWidget {
	String action;
	String passwordID;
	
	PasswordForm(String desiredAction) {
		this.action = desiredAction;
	}
	
	PasswordForm.edit(String desiredAction, String id) {
		this.action = desiredAction;
		this.passwordID = id;
	}
	
	@override
	Widget build(BuildContext context) {
		final inputTitle = TextEditingController();
		final inputURL = TextEditingController();
		final inputPassword = TextEditingController();
		final inputNotes = TextEditingController();
		
		return Scaffold(
			appBar: AppBar(
				title: Text(capitalize(this.action) + " Password"),
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
					if(this.action == "edit") IconButton(
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
												
												await utils.remove(passwordID);
												
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
									child: Column(
										children: <Widget>[
											Padding(
												padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
												child: TextFormField(
													controller: inputTitle,
													decoration: InputDecoration(
														labelText: "Title...",
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
								child: Card(
									child: Column(
										children: <Widget>[
											Padding(
												padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
												child: TextFormField(
													controller: inputURL,
													decoration: InputDecoration(
														labelText: "URL...",
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
														border: InputBorder.none,
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
													decoration: InputDecoration(
														labelText: "Notes...",
														alignLabelWithHint: true,
														border: InputBorder.none,
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
										Utils utils = new Utils();
										
										if(inputTitle.text.toString().trim() != "" && inputPassword.text.toString().trim() != "") {
											await utils.save(inputTitle.text.toString(), inputURL.text.toString(), inputPassword.text.toString(), inputNotes.text.toString());
											
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
																			Text((this.action == "add") ? "Add Password" : "Update Password", style: TextStyle(
																				fontSize: 24,
																				fontWeight: FontWeight.bold,
																				color: theme.getTheme()["backgroundColorLight"],
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

