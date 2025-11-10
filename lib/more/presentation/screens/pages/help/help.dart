import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/ui/app_ui.dart';
import '../../../../../core/ui/components.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "${AppUI.imgPath}splash.png",
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Column(
            children: [
              customAppBar(
                  title: 'contactUs'.tr(), backgroundColor: Colors.transparent),
              Expanded(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 100, bottom: 40, left: 16, right: 16),
                      child: CustomCard(
                        height: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 90,
                            ),
                            CustomInput(
                                controller: TextEditingController(),
                                hint: "fullName".tr(),
                                fillColor: AppUI.inputColor,
                                textInputType: TextInputType.name),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomInput(
                              controller: TextEditingController(),
                              hint: "msg".tr(),
                              fillColor: AppUI.inputColor,
                              textInputType: TextInputType.name,
                              maxLines: 8,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomButton(text: 'send'.tr())
                          ],
                        ),
                      ),
                    ),
                    Image.asset(
                      "${AppUI.imgPath}help.png",
                      height: 200,
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
