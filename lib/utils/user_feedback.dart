import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

// These functions are to allow users to send feedback and report bugs

// This is where all reports will be sent to
const String _emailAddress = 'prac.log.app@gmail.com';

// Email subject for bug reports
const String _emailSubjectBug = 'PracLog: User bug report';

// Email subject for feedback
const String _emailSubjectFeedback = 'PracLog: User feedback';

Future<String> _getDeviceInfo() async {
  final String info;
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    String? release = androidInfo.version.release;
    int? sdkInt = androidInfo.version.sdkInt;
    String? manufacturer = androidInfo.manufacturer;
    String? model = androidInfo.model;
    info = 'Android $release (SDK $sdkInt), $manufacturer $model';
  } else if (Platform.isIOS) {
    var iosInfo = await DeviceInfoPlugin().iosInfo;
    var systemName = iosInfo.systemName;
    var version = iosInfo.systemVersion;
    var name = iosInfo.name;
    var model = iosInfo.model;
    info = '$systemName $version, $name $model';
  } else {
    info = '';
  }
  return '<Device info: $info>';
}

/// Returns `true` if successful, `false` if unsuccessful or error
Future<bool> launchEmail(bool bugReport) async {
  final String url;
  if (bugReport) {
    final String deviceInfo = await _getDeviceInfo();
    url =
        'mailto:$_emailAddress?subject=${Uri.encodeFull(_emailSubjectBug)}&body=${Uri.encodeFull(deviceInfo)}';
  } else {
    url =
        'mailto:$_emailAddress?subject=${Uri.encodeFull(_emailSubjectFeedback)}&body=';
  }

  try {
    return await launchUrl(Uri.parse(url));
  } catch (e) {
    return false;
  }
}
