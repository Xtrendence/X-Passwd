import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
	String colorScheme;
	
	AppTheme(String scheme) {
		this.colorScheme = scheme;
	}
	
	getTheme() {
		print(this.colorScheme);
		
		Map<String, dynamic> light = {
			"backgroundColorDark": Color.fromRGBO(230, 230, 230, 1),
			"backgroundColorMedium": Color.fromRGBO(245, 245, 245, 1),
			"backgroundColorLight": Color.fromRGBO(255, 255, 255, 1),
			"accentColorLight": Color.fromRGBO(0, 175, 255, 1),
			"accentColor": Color.fromRGBO(0, 150, 255, 1),
			"accentColorDark": Color.fromRGBO(0, 125, 255, 1),
			"accentContrast": Color.fromRGBO(255, 255, 255, 1),
			"textColorDark": Color.fromRGBO(75, 75, 75, 1),
			"textColorLight": Color.fromRGBO(100, 100, 100, 1),
			"navigationBarColor": Color.fromRGBO(245, 245, 245, 1),
			"navigationBarIcons": Brightness.dark
		};
		
		Map<String, dynamic> dark = {
			"backgroundColorDark": Color.fromRGBO(60, 60, 60, 1),
			"backgroundColorMedium": Color.fromRGBO(40, 40, 40, 1),
			"backgroundColorLight": Color.fromRGBO(20, 20, 20, 1),
			"accentColorLight": Color.fromRGBO(0, 175, 255, 1),
			"accentColor": Color.fromRGBO(0, 150, 255, 1),
			"accentColorDark": Color.fromRGBO(0, 125, 255, 1),
			"accentContrast": Color.fromRGBO(255, 255, 255, 1),
			"textColorDark": Color.fromRGBO(255, 255, 255, 1),
			"textColorLight": Color.fromRGBO(175, 175, 175, 1),
			"navigationBarColor": Color.fromRGBO(30, 30, 30, 1),
			"navigationBarIcons": Brightness.light
		};
		
		if(this.colorScheme == "dark") {
			return dark;
		}
		else {
			return light;
		}
	}
	
	setTheme(String scheme) async {
		SharedPreferences preferences = await SharedPreferences.getInstance();
		preferences.setString("theme", scheme);
		this.colorScheme = scheme;
	}
	
	statusColorAccent() {
		SystemChrome.setSystemUIOverlayStyle(
			SystemUiOverlayStyle(
				systemNavigationBarColor: this.getTheme()["navigationBarColor"],
				systemNavigationBarIconBrightness: this.getTheme()["navigationBarIcons"],
				statusBarColor: this.getTheme()["accentColor"]
			),
		);
	}
	
	statusColorBackground() {
		SystemChrome.setSystemUIOverlayStyle(
			SystemUiOverlayStyle(
				systemNavigationBarColor: this.getTheme()["navigationBarColor"],
				systemNavigationBarIconBrightness: this.getTheme()["navigationBarIcons"],
				statusBarColor: this.getTheme()["backgroundColorLight"]
			),
		);
	}
}