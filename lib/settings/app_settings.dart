import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tswiri_base/settings/global_settings.dart';
export 'package:tswiri_base/settings/global_settings.dart';

//Camera Settings
List<CameraDescription> cameras = [];
ResolutionPreset cameraResolution = ResolutionPreset.max;

///Vibration.
bool vibrate = true;
String vibratePref = 'vibrate';

//Image Labeling
bool imageLabeling = true;
String imageLabelingPref = 'imageLabeling';
double imageLabelingConfidence = 0.5;
String imageLabelingConfidencePref = 'imageLabelingConfidence';

//Object Detection.
bool objectDetection = true;
String objectDetectionPref = 'objectDetection';
double objectDetectionConfidence = 0.5;
String objectDetectionConfidencePref = 'objectDetectionConfidence';

//Text Detection.
bool textDetection = true;
String textDetectionPref = 'textDetection';

//Camera focal length
double focalLength = 1;
String focalLengthPref = 'focalLength';

Future<void> loadAppSettings() async {
  //Get Camera descriptions.
  cameras = await availableCameras();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  //Default barcode size.
  defaultBarcodeSize =
      prefs.getDouble(defaultBarcodeSizePref) ?? defaultBarcodeSize;

  //Vibration.
  vibrate = prefs.getBool(vibratePref) ?? true;

  //Image Labeling.
  imageLabeling = prefs.getBool(imageLabelingPref) ?? true;
  imageLabelingConfidence = prefs.getDouble(imageLabelingConfidencePref) ?? 0.5;

  //Object Detection.
  objectDetection = prefs.getBool(objectDetectionPref) ?? true;
  objectDetectionConfidence =
      prefs.getDouble(objectDetectionConfidencePref) ?? 0.5;

  //Text Detection.
  textDetection = prefs.getBool(textDetectionPref) ?? true;

  //Focal Length.
  focalLength = prefs.getDouble(focalLengthPref) ?? 1.0;

  //Color Mode.
  colorModeEnabled = prefs.getBool(colorModeEnabledPref) ?? false;

  //Spaces
  currentSpacePath = prefs.getString(currentSpacePathPref) ??
      '${(await getApplicationSupportDirectory()).path}/main_space';
}
