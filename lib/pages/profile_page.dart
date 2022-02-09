import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/controllers/localization_controller.dart';
import 'package:todoz_app/controllers/user_controller.dart';
import 'package:todoz_app/services/database.dart';
import 'package:todoz_app/utils/styles.dart';
import 'package:todoz_app/widgets/menu_items.dart';

class ProfilePage extends GetWidget<UserController> {
  ProfilePage({Key? key}) : super(key: key);
  final TextEditingController _textEditingController = TextEditingController();

  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem(
      value: item,
      child: Row(
        children: [
          Icon(item.icon),
          const SizedBox(width: 10.0),
          Text(
            item.text,
            style: Styles.dateTimeItem,
          )
        ],
      ));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('profilePage'.tr, style: Styles.textStyleTitle),
              PopupMenuButton<MenuItem>(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  iconSize: 20.0,
                  onSelected: (item) => _onSelectedItem(context, item),
                  itemBuilder: (context) =>
                      [...MenuItems.listOne.map((buildItem)).toList()])
              // TextButton(
              //     style: ButtonStyle(
              //         padding: MaterialStateProperty.all(
              //             const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 5.0)),
              //         shape: MaterialStateProperty.all(RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(50))),
              //         backgroundColor: MaterialStateProperty.all(Colors.white)),
              //     onPressed: () => AuthController().signOut(),
              //     child: Text(
              //       'signOut'.tr,
              //       style: Styles.createNewTask.copyWith(color: Colors.black),
              //     )
              //     ),
            ],
          ),
          const SizedBox(height: 10.0),
          GetX<UserController>(initState: (_) async {
            Get.find<UserController>().userModel =
                await Database().getUser(Get.find<AuthController>().user!.uid);
          }, builder: (userController) {
            if (userController.userModel.name != null) {
              _textEditingController.text = userController.userModel.name!;
              return EditableText(
                maxLines: 1,
                textAlign: TextAlign.center,
                focusNode: FocusNode(),
                onSubmitted: (value) {
                  Database().updateUsername(controller.userModel.id!, value);
                },
                controller: _textEditingController,
                style: Styles.textStyleTitle,
                cursorColor: Colors.black,
                backgroundCursorColor: Colors.red,
              );
            } else {
              return Text('loading', style: Styles.textStyleTitle);
            }
          }),
          const SizedBox(height: 10.0),
          const CircleAvatar(radius: 80.0),
          const SizedBox(height: 15.0),
          TextButton.icon(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0))),
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFF6E4AFF))),
            onPressed: () {},
            label: Text('achievements'.tr, style: Styles.createNewTask),
            icon: const Icon(Icons.emoji_events_outlined,
                color: Colors.white, size: 20.0),
          ),
        ],
      ),
    );
  }
}

// Widget get bottomsheet {
//   LocalizationController _locCon =
//       Get.put<LocalizationController>(LocalizationController());
//   return BottomSheet(
//       enableDrag: false,
//       onClosing: () {},
//       builder: (context) {
//         return Scaffold(
//           body: Column(
//             children: [
//               Container(
//                 child: Obx(() => Text(_locCon.currentLocale.toLanguageTag())),
//               ),
//               TextButton(
//                   onPressed: () => _locCon.changeLanguage('ru', 'RU'),
//                   child: Text('russian'))
//             ],
//           ),
//         );
//       });

_onSelectedItem(BuildContext context, MenuItem item) {
  if (item == MenuItems.itemChangeLanguage) {
    return;
    //  return Get.bottomSheet(bottomsheet);
  } else if (item == MenuItems.itemAboutApp) {
    return;
  }
}
