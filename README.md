# Flutter Todozzz App

A simple todo app made with Flutter. ![pic](https://github.com/RusAntr/todoz_app/blob/master/lib/pics/todozzz_app.png)
## Table of Contents:
* [General Info](#general-info)
* [Features](#features)
* [How to install](#how-to-install)
* [Languages](#languages)
* [Technologies Used](#technologies-used)

## General info
This project is a simple todo app made with [Flutter](https://flutter.dev). The purpose of this this project is to try out GetX, Firebase, Firestore, Rive and Google SignIn. 
In this project I managed to implement:
1. User auth with Firebase and Google auth
2. Storing and syncing data to Firestore DB
3. Cute Sign up/ Log in animations made with Rive
4. Simple state-managment using GetX
5. Translations to 3 languages using Getx

UI inspired by: [Dmitry Lauretsky for Ronas IT | UI/UX Team](https://dribbble.com/shots/15963414-Task-Management-App)

## Features
#### Progressive tasks 
Track how much time you spend doing tasks
![pic](https://github.com/RusAntr/todoz_app/blob/master/lib/pics/progressive_feature.png)
#### Swipe rigth to delete, left to mark task as done/undone
![pic](https://github.com/RusAntr/todoz_app/blob/master/lib/pics/swipe_delete_feature.png) ![pic](https://github.com/RusAntr/todoz_app/blob/master/lib/pics/swipe_done_feature.png) ![pic](https://github.com/RusAntr/todoz_app/blob/master/lib/pics/swipe_undo_feature.png)
#### Track productivity
 ![pic](https://github.com/RusAntr/todoz_app/blob/master/lib/pics/productivity_feature.png)

#### Project folders
Keep your tasks in different project folders
![pic](https://github.com/RusAntr/todoz_app/blob/master/lib/pics/project_folder_feature.png) ![pic](https://github.com/RusAntr/todoz_app/blob/master/lib/pics/add_tasks_to_project_feature.png)

#### Change and preview your project
![pic](https://github.com/RusAntr/todoz_app/blob/master/lib/pics/change_preview_project_feature.png)
#### Track how many tasks you have/had yesterday-today-tomorrow
![pic](https://github.com/RusAntr/todoz_app/blob/master/lib/pics/yesterday_progress_feature.png) ![pic](https://github.com/RusAntr/todoz_app/blob/master/lib/pics/today_progress_feature.png) ![pic](https://github.com/RusAntr/todoz_app/blob/master/lib/pics/tomorrow_progress_feature.png)

## How to install
#### Step 1:

Fork this project

```
'git clone https://github.com/RusAntr/todoz_app.git'
```
#### Step 2:

Open the project folder with VS Code and execute the following command to install the dependency package:
```
flutter pub get
```
#### Step 3:

Open the main.dart file in the lib folder, F5 or Ctrl + F5 to run the project.
## Languages
* Russian (Русский)
* English
* Mandarin Chinese (普通话)

## Technologies used
* [Flutter](https://flutter.dev)
* [Dart](https://dart.dev)

#### Packages
* [get 4.3.8](https://pub.dev/packages/get) - state managment, DI, translations
* [firebase_auth](https://pub.dev/packages/firebase_auth) - user authentication
* [firebase_core 1.14.0](https://pub.dev/packages/firebase_core) - BaaS
* [cloud_firestore 3.1.0](https://pub.dev/packages/cloud_firestore) - Firestore DB
* [google_sign_in 5.2.3](https://pub.dev/packages/google_sign_in) - Google Sign In
* [rive 0.8.1](https://pub.dev/packages/rive) - animations
* [fl_chart: ^0.41.0](https://pub.dev/packages/fl_chart) - chart
