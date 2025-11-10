import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../add_event/presentation/controller/add_event_cubit.dart';
import '../../../../core/app_util.dart';
import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../controller/events/events_cubit.dart';
import '../../controller/events/events_states.dart';

class ShareBtn extends StatefulWidget {
  final String id;
  const ShareBtn({Key? key, required this.id}) : super(key: key);

  @override
  State<ShareBtn> createState() => _ShareBtnState();
}

class _ShareBtnState extends State<ShareBtn> {
  late final EventsCubit cubit;
  @override
  void initState() {
    super.initState();
    cubit = EventsCubit.get(context);
    cubit.selectType.text = "public";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: AppUI.whiteColor,
      ),
      height: AppUtil.responsiveHeight(context) * 0.45,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 30,
              ),
              CustomText(
                text: "Upload Event photo".tr(),
                color: AppUI.blackColor,
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppUI.blackColor,
                  ))
            ],
          ),
          CustomText(
            text: "You can upload 5 photos only".tr(),
            color: AppUI.blackColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                CustomText(
                  text: "Who can Show".tr(),
                  color: AppUI.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 4,
                ),
                CustomInput(
                  controller: cubit.selectType,
                  hint: "choose".tr(),
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                  textInputType: TextInputType.url,
                  fillColor: AppUI.inputColor,
                  readOnly: true,
                  onTap: () {
                    AppUtil.dialog2(context, "choose".tr(), [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () {
                                cubit.selectType.text = "public";
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              child: const CustomText(
                                text: 'public',
                                fontWeight: FontWeight.w600,
                                color: AppUI.bottomBarColor,
                              )),
                          const Divider(),
                          InkWell(
                              onTap: () {
                                cubit.selectType.text = "event hoster";
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              child: const CustomText(
                                text: 'event hoster',
                                fontWeight: FontWeight.w600,
                                color: AppUI.bottomBarColor,
                              )),
                          const Divider(),
                          InkWell(
                              onTap: () {
                                cubit.selectType.text = "me only";
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              child: const CustomText(
                                text: 'me only',
                                fontWeight: FontWeight.w600,
                                color: AppUI.bottomBarColor,
                              )),
                        ],
                      ),
                    ]);
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                BlocBuilder<EventsCubit, EventsStates>(
                    buildWhen: (_, state) => state is EventPhotoChangeState,
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomCard(
                            padding: 5,
                            onTap: () {
                              cubit.chooseImageDialog(context, 0);
                            },
                            height: 60,
                            width: 60,
                            elevation: 0,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              padding: const EdgeInsets.all(2),
                              dashPattern: const [6, 3],
                              color: AppUI.disableColor,
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                child: SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: cubit.eventPhoto == null
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                  "${AppUI.iconPath}camera.svg"),
                                            ],
                                          )
                                        : Image.file(File(
                                            cubit.eventPhoto!.path,
                                          ))),
                              ),
                            ),
                          ),
                          CustomCard(
                            padding: 5,
                            onTap: () {
                              cubit.chooseImageDialog(context, 1);
                            },
                            height: 60,
                            width: 60,
                            elevation: 0,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              padding: const EdgeInsets.all(2),
                              dashPattern: const [6, 3],
                              color: AppUI.disableColor,
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                child: SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: cubit.eventPhoto1 == null
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                  "${AppUI.iconPath}camera.svg"),
                                            ],
                                          )
                                        : Image.file(File(
                                            cubit.eventPhoto1!.path,
                                          ))),
                              ),
                            ),
                          ),
                          CustomCard(
                            padding: 5,
                            onTap: () {
                              cubit.chooseImageDialog(context, 2);
                            },
                            height: 60,
                            width: 60,
                            elevation: 0,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              padding: const EdgeInsets.all(2),
                              dashPattern: const [6, 3],
                              color: AppUI.disableColor,
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                child: SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: cubit.eventPhoto2 == null
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                  "${AppUI.iconPath}camera.svg"),
                                            ],
                                          )
                                        : Image.file(File(
                                            cubit.eventPhoto2!.path,
                                          ))),
                              ),
                            ),
                          ),
                          CustomCard(
                            padding: 5,
                            onTap: () {
                              cubit.chooseImageDialog(context, 3);
                            },
                            height: 60,
                            width: 60,
                            elevation: 0,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              padding: const EdgeInsets.all(2),
                              dashPattern: const [6, 3],
                              color: AppUI.disableColor,
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                child: SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: cubit.eventPhoto3 == null
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                  "${AppUI.iconPath}camera.svg"),
                                            ],
                                          )
                                        : Image.file(File(
                                            cubit.eventPhoto3!.path,
                                          ))),
                              ),
                            ),
                          ),
                          CustomCard(
                            padding: 5,
                            onTap: () {
                              cubit.chooseImageDialog(context, 4);
                            },
                            height: 60,
                            width: 60,
                            elevation: 0,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              padding: const EdgeInsets.all(2),
                              dashPattern: const [6, 3],
                              color: AppUI.disableColor,
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                child: SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: cubit.eventPhoto4 == null
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                  "${AppUI.iconPath}camera.svg"),
                                            ],
                                          )
                                        : Image.file(File(
                                            cubit.eventPhoto4!.path,
                                          ))),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ],
            ),
          ),
          BlocBuilder<EventsCubit, EventsStates>(
              buildWhen: (_, state) =>
                  state is AddMomentLoadingState ||
                  state is AddMomentLoadedState,
              builder: (context, state) {
                if (state is AddMomentLoadingState) {
                  return const LoadingWidget();
                }
                return CustomButton(
                  text: "Add".tr(),
                  onPressed: () {
                    Navigator.of(context,rootNavigator: true).pop();
                    cubit.addMoments(context, id: widget.id);
                  },
                );
              }),
        ],
      ),
    );
  }
}
