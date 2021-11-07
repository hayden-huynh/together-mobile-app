# Check-In Mobile Application

A mobile application developed with the Flutter framework as part of my thesis project at The University of Queensland, Australia.

## About Check-In

The purpose of Check-In is to collect data from people possibly suffering from loneliness for research purposes by:
  - Sending a specially composed questionnaire by the School of Psychology, UQ and collecting participants' responses every two hours starting at 8AM and ending at 8PM.
  - Logging GPS data, in form of latitude-longitude pairs, along with the according timestamps throughout the day (User's permission is required)

## How to navigate in this project
### The `lib` Directory
- This directory is where all source codes are stored. The structure as well as names of child directories/files within this directory are the same as discussed in the thesis report

### The `pubspec.yaml` Configuration File
- This file is where the Flutter version, Dart environment, and all plugins used within the project are configured
- Before running the project in DEBUG mode, save this file again (Ctrl+S or Cmd+S) to trigger the installation of all necessary plugin dependencies

### The `assets` Directory
- This directory is where all the fonts and images used inside the application are stored

### The `android` and `ios` Directories
- These directories are where you can configure the project in its native environment, either Android or iOS
- The `android` and `ios` directories should be respectively opened in Android Studio and Xcode so that you can access the specific configurations for each platform
