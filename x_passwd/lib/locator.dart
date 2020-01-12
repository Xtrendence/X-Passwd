import 'package:get_it/get_it.dart';
import 'package:x_passwd/auth_service.dart';

GetIt locator = GetIt();

void setupLocator() {
	locator.registerLazySingleton(() => LocalAuthenticationService());
}