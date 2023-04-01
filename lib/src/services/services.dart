import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/models/timer.dart';
import 'package:nextcloud_cookbook_flutter/src/screens/recipe_import_screen.dart';
import 'package:nextcloud_cookbook_flutter/src/util/url_validator.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:xml/xml.dart';

part "api_provider.dart";
part "authentication_provider.dart";
part "data_repository.dart";
part "intent_repository.dart";
part "net/nextcloud_metadata_api.dart";
part "notification_provider.dart";
part "user_repository.dart";
part 'timer_repository.dart';
