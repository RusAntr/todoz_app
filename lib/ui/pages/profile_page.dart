import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoz_app/controllers/auth_controller.dart';
import 'package:todoz_app/controllers/localization_controller.dart';
import 'package:todoz_app/controllers/user_controller.dart';
import 'package:todoz_app/ui/widgets/profile_page_menu_items.dart';
import '../../core/constants/constants.dart';
import '../ui_export.dart';

class ProfilePage extends GetWidget<UserController> {
  ProfilePage({Key? key}) : super(key: key);
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 0.0),
      child: Column(
        children: [
          _kindOfAppBar(),
          const SizedBox(height: 10.0),
          _userNameWidget(),
          const SizedBox(height: 10.0),
          CircleAvatar(
            radius: 60.0,
            backgroundColor: AppColors.accentBlue,
            child: Text(
              '🙇',
              style: AppTextStyles.blackHeader,
            ),
          ),
          const SizedBox(height: 15.0),
          _achivementsButton(),
        ],
      ),
    );
  }

  TextButton _achivementsButton() {
    return TextButton.icon(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.all(15.0),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(AppColors.mainPurple),
      ),
      onPressed: () {},
      label: Text(
        'achievements'.tr,
        style: AppTextStyles.createNewTask,
      ),
      icon: const Icon(
        Icons.emoji_events_outlined,
        color: Colors.white,
        size: 20.0,
      ),
    );
  }

  Widget _userNameWidget() {
    return GetX<UserController>(
      initState: (_) async => Get.find<UserController>(),
      builder: (userController) {
        if (userController.userModel.name != null) {
          _textEditingController.text = userController.userModel.name!;
          return EditableText(
            maxLines: 1,
            textAlign: TextAlign.center,
            focusNode: FocusNode(),
            onSubmitted: (value) => userController.updateUsername(value),
            controller: _textEditingController,
            style: AppTextStyles.textStyleTitle,
            cursorColor: Colors.black,
            backgroundCursorColor: Colors.black,
          );
        } else {
          return Text(
            'loading',
            style: AppTextStyles.textStyleTitle,
          );
        }
      },
    );
  }

  Row _kindOfAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'profilePage'.tr,
          style: AppTextStyles.textStyleTitle,
        ),
        PopupMenuButton<CustomMenuItem>(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          iconSize: 20.0,
          onSelected: (item) => _onSelectedItem(item),
          itemBuilder: (context) => [
            ...ProfilePageMenuItems.listOne.map((_buildItem)).toList(),
            const PopupMenuDivider(
              height: 5.0,
            ),
            ...ProfilePageMenuItems.listTwo.map((_buildItem)).toList()
          ],
        ),
      ],
    );
  }
}

PopupMenuItem<CustomMenuItem> _buildItem(CustomMenuItem item) => PopupMenuItem(
      value: item,
      child: Row(
        children: [
          Icon(item.icon),
          const SizedBox(width: 10.0),
          Text(
            item.text,
            style: AppTextStyles.dateTimeItem,
          )
        ],
      ),
    );

Widget _bottomsheet() {
  LocalizationController _locCon = Get.find<LocalizationController>();
  return BottomSheet(
    enableDrag: false,
    constraints: const BoxConstraints(
      minWidth: 100.0,
      maxHeight: 120.0,
    ),
    onClosing: () {},
    builder: (context) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Obx(
                    () => Text(
                      _locCon.currentLanguage,
                      style: AppTextStyles.blackTitleNormal.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 65,
                  width: Get.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      LanguageButton(languageCode: 'ru'),
                      LanguageButton(languageCode: 'en'),
                      LanguageButton(languageCode: 'zh'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

_onSelectedItem(CustomMenuItem item) {
  if (item == ProfilePageMenuItems.itemChangeLanguage) {
    return Get.bottomSheet(_bottomsheet());
  } else if (item == ProfilePageMenuItems.itemSingOut) {
    AuthController().signOut();
  }
}
