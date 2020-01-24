import 'package:flutter_upload_ftp/controller/locationController.dart';
import 'package:flutter_upload_ftp/controller/servicesController.dart';
import 'package:get_it/get_it.dart';

var locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton(() => LocationController());
  locator.registerLazySingleton(() => ServicesController());
}
