import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';

class ApiVersionWarning extends StatelessWidget {
  const ApiVersionWarning({super.key});

  @override
  Widget build(BuildContext context) {
    final VersionProvider versionProvider = UserRepository().versionProvider;
    final ApiVersion apiVersion = versionProvider.getApiVersion();

    if (!versionProvider.warningWasShown) {
      versionProvider.warningWasShown = true;
      Future.delayed(const Duration(milliseconds: 100), () {
        if (apiVersion.loadFailureMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                translate(
                  "categories.errors.api_version_check_failed",
                  args: {"error_msg": apiVersion.loadFailureMessage},
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else if (apiVersion.isVersionAboveConfirmed()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                translate(
                  "categories.errors.api_version_above_confirmed",
                  args: {
                    "version":
                        "${apiVersion.majorApiVersion}.${apiVersion.minorApiVersion}"
                  },
                ),
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
      });
    }
    return Container();
  }
}
