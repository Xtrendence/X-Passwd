import 'dart:ui';

import 'package:flutter/services.dart';

class AppTheme {
	AppTheme();
	
	getTheme() {
		Map<String, Color> light = {
			"backgroundColorDark": Color.fromRGBO(230, 230, 230, 1),
			"backgroundColorMedium": Color.fromRGBO(245, 245, 245, 1),
			"backgroundColorLight": Color.fromRGBO(255, 255, 255, 1),
			"accentColorLight": Color.fromRGBO(0, 175, 255, 1),
			"accentColor": Color.fromRGBO(0, 150, 255, 1),
			"accentColorDark": Color.fromRGBO(0, 125, 255, 1),
			"accentContrast": Color.fromRGBO(255, 255, 255, 1),
			"textColorDark": Color.fromRGBO(75, 75, 75, 1),
			"textColorLight": Color.fromRGBO(100, 100, 100, 1)
		};
		
		Map<String, Color> dark = {
			"backgroundColorDark": Color.fromRGBO(60, 60, 60, 1),
			"backgroundColorMedium": Color.fromRGBO(40, 40, 40, 1),
			"backgroundColorLight": Color.fromRGBO(20, 20, 20, 1),
			"accentColorLight": Color.fromRGBO(0, 175, 255, 1),
			"accentColor": Color.fromRGBO(0, 150, 255, 1),
			"accentColorDark": Color.fromRGBO(0, 125, 255, 1),
			"accentContrast": Color.fromRGBO(255, 255, 255, 1),
			"textColorDark": Color.fromRGBO(255, 255, 255, 1),
			"textColorLight": Color.fromRGBO(175, 175, 175, 1)
		};
		
		return light;
	}
	
	statusColorAccent() {
		SystemChrome.setSystemUIOverlayStyle(
			SystemUiOverlayStyle(
				systemNavigationBarColor: this.getTheme()["backgroundColorMedium"],
				statusBarColor: this.getTheme()["accentColor"],
				systemNavigationBarIconBrightness: Brightness.dark,
			),
		);
	}
	
	statusColorBackground() {
		SystemChrome.setSystemUIOverlayStyle(
			SystemUiOverlayStyle(
				systemNavigationBarColor: this.getTheme()["backgroundColorMedium"],
				statusBarColor: this.getTheme()["backgroundColorLight"],
				systemNavigationBarIconBrightness: Brightness.dark,
			),
		);
	}
}