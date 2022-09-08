<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

This package includes reusable widgets and functions.

## Features

## Usage

App settings:
 - cameras (List(```(CameraDescription)```).
 - cameraResolution (ResolutionPreset.max). //TODO: Make editable.
 - vibrate (bool).
 - imageLabeling (bool).
 - imageLabelingConfidence (double).
 - objectDetection (bool).
 - objectDetectionConfidence
 - textDetection (bool).
 - focalLength (double)
 - hasShownGettingStarted (bool).


Desktop settings:

Global settings:
 - colorModeEnabled (bool).
 - iserVersion (int).
 - currentSpacePath (String).
 - defaultBarcodeSize (double) this defines both size and width at this time.
- containerFilters (List```(String)```).


## Additional information
Some parts depend on tswiri_database.


## Dependencies

Mobile:
 - cupertino_icons: ^1.0.2
 - camera: ^0.10.0+1
 - provider: ^6.0.3
 - google_mlkit_barcode_scanning: ^0.3.0
 - google_mlkit_image_labeling: ^0.3.0
 - google_mlkit_object_detection: ^0.4.0
 - google_mlkit_text_recognition: ^0.3.0
 - image: ^3.2.0
 - string_similarity: ^2.0.0
 - path_provider: ^2.0.11
 - numberpicker: ^2.1.1
 - intl: ^0.17.0
 - shared_preferences: ^2.0.15
 
Desktop:
 - cupertino_icons: ^1.0.2
 - provider: ^6.0.3
 - shared_preferences: ^2.0.15
 - intl: ^0.17.0
 - 
 - 