import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:x_passwd/theme.dart';

AppTheme theme = new AppTheme();

class Settings extends StatelessWidget {
	
	@override
	Widget build(BuildContext context) {
		SystemChrome.setSystemUIOverlayStyle(
			SystemUiOverlayStyle(
				systemNavigationBarColor: theme.getTheme()["backgroundColorMedium"],
				statusBarColor: theme.getTheme()["accentColor"],
				systemNavigationBarIconBrightness: Brightness.dark,
			),
		);
	}
}