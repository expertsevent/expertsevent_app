import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/event/models/events_model.dart';
import 'package:expert_events/event/presentation/screens/guards/add_guard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import '../../../../../core/app_util.dart';
import '../../../../../core/ui/app_ui.dart';
import '../../../../../core/ui/components.dart';
import '../../../../../event/presentation/controller/guards/guards_cubit.dart';
import '../../../../../event/presentation/controller/guards/guards_states.dart';
import '../../../../../more/presentation/screens/pages/packages/package_screen.dart';
import '../../../../../more/presentation/screens/pages/static_page/static_page.dart';
import '../../../controller/add_event_cubit.dart';
import '../../../controller/add_event_states.dart';
import 'select_address_screen.dart';

class EventInfo extends StatefulWidget {
  final Event? event;
  const EventInfo({Key? key, this.event}) : super(key: key);

  @override
  State<EventInfo> createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
  Country? _selectedCountry = Country(
    phoneCode: '966',
    countryCode: 'SA',
    e164Sc: -1,
    geographic: false,
    level: -1,
    name: 'World Wide',
    example: '',
    displayName: 'World Wide (WW)',
    displayNameNoCountryCode: 'World Wide',
    e164Key: '',
  );
  List<int> guardIndexes = [];
  List<int> guardIds = [];

  late final AddEventCubit cubit;
  late final GuardsCubit guardsCubit;
  @override
  void initState() {
    super.initState();
    cubit = AddEventCubit.get(context);
    guardsCubit = GuardsCubit.get(context);

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: cubit.eventFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInput(
                  controller: cubit.eventName,
                  hint: "eventTitle".tr(),
                  textInputType: TextInputType.text,
                  fillColor: AppUI.whiteColor),
              const SizedBox(
                height: 15,
              ),

              Row(
                children: [
                  Expanded(
                      child: CustomInput(
                    controller: cubit.dob,
                    hint: "date".tr(),
                    suffixIcon: const Icon(Icons.calendar_today_outlined),
                    readOnly: true,
                    textInputType: TextInputType.url,
                    fillColor: AppUI.whiteColor,
                    onTap: () {
                      cubit.selectDate(context);
                    },
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: CustomInput(
                    controller: cubit.time,
                    hint: "time".tr(),
                    suffixIcon: const Icon(Icons.access_time),
                    readOnly: true,
                    textInputType: TextInputType.url,
                    fillColor: AppUI.whiteColor,
                    onTap: () {
                      cubit.selectTime(context);
                    },
                  )),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              CustomInput(
                  controller: cubit.address,
                  hint: "address".tr(),
                  textInputType: TextInputType.text,
                  fillColor: AppUI.whiteColor),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: () async {
                  await AppUtil.mainNavigator(
                      context, const SelectAddressScreen());
                  setState(() {});
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "${AppUI.iconPath}location.svg",
                      color: AppUI.buttonColor,
                      height: 18,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomText(
                      text: cubit.location == null
                          ? "selectOnMap".tr()
                          : "locationPicked".tr(),
                      textDecoration: TextDecoration.underline,
                      color: AppUI.mainColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              CustomInput(
                controller: cubit.desc,
                hint: "eventDescription".tr(),
                textInputType: TextInputType.multiline,
                fillColor: AppUI.whiteColor,
                maxLines: 4,
              ),
              // if(widget.event==null)
              const SizedBox(
                height: 5,
              ),
              if(widget.event==null)
              InkWell(
                onTap: () {
                  guardsBottomSheet(context);
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      color: AppUI.mainColor,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    CustomText(
                        text: "addGuard".tr(),
                        textDecoration: TextDecoration.underline,
                        color: AppUI.mainColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)
                  ],
                ),
              ),
              // if(widget.event==null)
              const SizedBox(
                height: 20,
              ),
              if(widget.event==null)
              BlocBuilder<AddEventCubit, AddEventState>(
                  buildWhen: (_, state) => state is ContactChangeState,
                  builder: (context, state) {
                    return Row(
                      children: [
                        const Icon(
                          Icons.add,
                          color: AppUI.mainColor,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        InkWell(
                          onTap: () async {
                            contactsBottomSheet(context);
                          },
                          child: CustomText(
                              text: "addVisitors".tr(),
                              textDecoration: TextDecoration.underline,
                              color: AppUI.mainColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            contactsSelectedBottomSheet(context);
                          },
                          child: CustomText(
                              text: "(${cubit.phones.length.toString()} ${"visitors".tr()})",
                              fontSize: 15,
                              color: AppUI.errorColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  }),

              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  BlocBuilder<AddEventCubit, AddEventState>(
                      buildWhen: (_, state) => state is CheckBoxChangeSate,
                      builder: (context, state) {
                        return InkWell(
                          onTap: () {
                            cubit.checkBox =  widget.event==null ? !cubit.checkBox : true;
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: AppUI.backgroundColor),
                                color: cubit.checkBox
                                    ? AppUI.buttonColor
                                    : AppUI.whiteColor),
                            child: const Icon(
                              Icons.check,
                              size: 12,
                              color: AppUI.whiteColor,
                            ),
                          ),
                        );
                      }),
                  const SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      CustomText(text: "${"accept".tr()} "),
                      InkWell(
                          onTap: () {
                            AppUtil.mainNavigator(
                                context, const StaticPage(title: 'terms'));
                          },
                          child: CustomText(
                            text: "terms".tr(),
                            textDecoration: TextDecoration.underline,
                          )),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                text: "next".tr(),
                onPressed: () {
                  if (cubit.eventFormKey.currentState!.validate()) {
                    if (!cubit.checkBox) {
                      AppUtil.errorToast(
                          context, "acceptTermsAndConditions".tr());
                      return;
                    }

                    if (widget.event == null) {
                      if (cubit.names.isEmpty) {
                        AppUtil.errorToast(context, "selectVisitors".tr());
                        return;
                      }
                      // if (guardsCubit.selectedGuardsIds.isEmpty) {
                      //   AppUtil.errorToast(context, "selectGuards".tr());
                      //   return;
                      // }
                    }
                    if (cubit.location == null) {
                      AppUtil.errorToast(context, "chooseLocation".tr());
                      return;
                    }
                    cubit.pageIndex = 1;
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  contactsBottomSheet(context) async {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: (context) {
          return BlocBuilder<AddEventCubit, AddEventState>(
              buildWhen: (_, state) => state is ContactsLoadedState,
              builder: (context, state) {
                return SizedBox(
                  height: AppUtil.responsiveHeight(context) * 0.85,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  text: "contacts".tr(),
                                  color: AppUI.blackColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                const Spacer(),
                                InkWell(
                                    onTap: () {
                                      AppUtil.dialog2(
                                          context, 'addContact'.tr(), [
                                        CustomInput(
                                            controller: cubit.contactName,
                                            hint: "name".tr(),
                                            textInputType: TextInputType.text),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        BlocBuilder<AddEventCubit,
                                                AddEventState>(
                                            buildWhen: (_, state) =>
                                                state is ContactsLoadedState,
                                            builder: (context, state) {
                                              return CustomInput(
                                                controller: cubit.contactPhone,
                                                hint: "phoneNumber".tr(),
                                                textInputType:
                                                    TextInputType.phone,
                                                prefixIcon: SizedBox(
                                                  width: 50,
                                                  child: InkWell(
                                                    onTap: () {
                                                      showCountryPicker(
                                                        context: context,
                                                        showPhoneCode: true,
                                                        countryListTheme:
                                                            CountryListThemeData(
                                                          flagSize: 25,
                                                          backgroundColor:
                                                              Colors.white,
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .blueGrey),
                                                          bottomSheetHeight:
                                                              500, // Optional. Country list modal height
                                                          //Optional. Sets the border radius for the bottomsheet.
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    20.0),
                                                          ),
                                                          //Optional. Styles the search field.
                                                          inputDecoration:
                                                              InputDecoration(
                                                            labelText: 'Search',
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        10),
                                                            hintText:
                                                                'Start typing to search',
                                                            prefixIcon:
                                                                const Icon(Icons
                                                                    .search),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              borderSide:
                                                                  BorderSide(
                                                                color: const Color(
                                                                        0xFF8C98A8)
                                                                    .withOpacity(
                                                                        0.2),
                                                              ),
                                                            ),
                                                          ),
                                                        ), // optional. Shows phone code before the country name.
                                                        onSelect:
                                                            (Country country) {
                                                          _selectedCountry =
                                                              country;
                                                          cubit.contactCountryCode
                                                                  .text =
                                                              _selectedCountry!
                                                                  .phoneCode;
                                                          cubit.emit(
                                                              ContactsLoadedState());
                                                        },
                                                      );
                                                    },
                                                    child: Row(
                                                      children: [
                                                        if (_selectedCountry !=
                                                            null)
                                                          CustomText(
                                                              text: _selectedCountry!
                                                                  .flagEmoji),
                                                        const Icon(
                                                          Icons.arrow_drop_down,
                                                          color:
                                                              AppUI.blackColor,
                                                        ),
                                                        Container(
                                                          height: 20,
                                                          width: 0.6,
                                                          color: AppUI
                                                              .disableColor,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CustomButton(
                                                text: "save".tr(),
                                                onPressed: () {
                                                  cubit.addContact();
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: CustomButton(
                                                text: "cancel".tr(),
                                                color: AppUI.whiteColor,
                                                textColor: AppUI.buttonColor,
                                                borderColor: AppUI.buttonColor,
                                                onPressed: () {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      ]);
                                    },
                                    child: SvgPicture.asset(
                                        "${AppUI.iconPath}add.svg"))
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                                height: 40,
                                child: CustomInput(
                                  controller: cubit.searchContact,
                                  onChange: (v) {
                                    // cubit.getContacts(search: v);
                                    cubit.emit(ContactsLoadedState());
                                  },
                                  hint: "search".tr(),
                                  borderColor: AppUI.secondColor,
                                  textInputType: TextInputType.text,
                                  prefixIcon: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.search,
                                        color: AppUI.secondColor,
                                      )),
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            BlocBuilder<AddEventCubit, AddEventState>(
                                buildWhen: (_, state) =>
                                    state is ContactChangeState,
                                builder: (context, state) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          CustomText(
                                            text:
                                                "${cubit.phones.length}/${cubit.contacts.where((element) => element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase())).toList().length} ${"selected".tr()}",
                                            fontWeight: FontWeight.bold,
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              InkWell(
                                                  onTap: () {
                                                    cubit.unSelectAllContacts();
                                                  },
                                                  child: CustomText(
                                                    text: "clear".tr(),
                                                    color: AppUI.errorColor,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                          ],
                        ),
                      ),
                      Container(
                        height: 5,
                        color: AppUI.backgroundColor,
                        width: double.infinity,
                      ),
                      BlocBuilder<AddEventCubit, AddEventState>(
                          buildWhen: (_, state) =>
                              state is ContactsLoadingState ||
                              state is ContactsLoadedState ||
                              state is ContactsErrorState ||
                              state is ContactsEmptyState,
                          builder: (context, state) {
                            if (state is ContactsLoadingState) {
                              return const LoadingWidget();
                            }
                            if (state is ContactsErrorState) {
                              return const ErrorFetchWidget();
                            }
                            if (state is ContactsEmptyState) {
                              return const EmptyWidget();
                            }
                            if (widget.event != null) {
                              int i = 0;
                              cubit.phones.clear();
                              cubit.names.clear();
                              for (var e in widget.event!.visitors) {
                                cubit.contactsCheck.add(e.phone);
                                cubit.phones.add(cubit.contacts
                                    .where((element) => element.displayName!
                                        .toLowerCase()
                                        .contains(cubit.searchContact.text
                                            .toLowerCase()))
                                    .toList()[i]
                                    .phones![0]
                                    .number!);
                                cubit.names.add(cubit.contacts
                                    .where((element) => element.displayName!
                                        .toLowerCase()
                                        .contains(cubit.searchContact.text
                                            .toLowerCase()))
                                    .toList()[i]
                                    .displayName!);
                                i++;
                              }
                              cubit.emit(ContactChangeState());
                            }

                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: "",
                                              width: 40,
                                              height: 40,
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                "${AppUI.imgPath}logo.png",
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.fill,
                                              ),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      "${AppUI.imgPath}logo.png",
                                                      width: 40,
                                                      height: 40,
                                                      fit: BoxFit.fill),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  text: cubit.contacts
                                                          .where((element) => element
                                                              .displayName!
                                                              .toLowerCase()
                                                              .contains(cubit
                                                                  .searchContact
                                                                  .text
                                                                  .toLowerCase()))
                                                          .toList()[index]
                                                          .displayName ??
                                                      "",
                                                  color: AppUI.blackColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                if (cubit.contacts
                                                        .where((element) => element
                                                            .displayName!
                                                            .toLowerCase()
                                                            .contains(cubit
                                                                .searchContact
                                                                .text
                                                                .toLowerCase()))
                                                        .toList()[index]
                                                        .phones!
                                                        .length ==
                                                    1)
                                                  Text(
                                                    cubit.contacts
                                                        .where((element) => element
                                                            .displayName!
                                                            .toLowerCase()
                                                            .contains(cubit
                                                                .searchContact
                                                                .text
                                                                .toLowerCase()))
                                                        .toList()[index]
                                                        .phones![0]
                                                        .number!,
                                                    style: const TextStyle(
                                                      color: AppUI.blackColor,
                                                    ),
                                                    textDirection:
                                                        ui.TextDirection.ltr,
                                                  ),
                                              ],
                                            ),
                                            const Spacer(),
                                            BlocBuilder<AddEventCubit,
                                                    AddEventState>(
                                                buildWhen: (_, state) =>
                                                    state is ContactChangeState,
                                                builder: (context, snapshot) {
                                                  if (cubit.contacts
                                                          .where((element) => element
                                                              .displayName!
                                                              .toLowerCase()
                                                              .contains(cubit
                                                                  .searchContact
                                                                  .text
                                                                  .toLowerCase()))
                                                          .toList()[index]
                                                          .phones!
                                                          .length ==
                                                      1) {
                                                    return Checkbox(
                                                        value: cubit.phones.contains(cubit
                                                                .contacts
                                                                .where((element) => element
                                                                    .displayName!
                                                                    .toLowerCase()
                                                                    .contains(cubit
                                                                        .searchContact
                                                                        .text
                                                                        .toLowerCase()))
                                                                .toList()[index]
                                                                .phones![0]
                                                                .number!)
                                                            ? true
                                                            : false,
                                                        onChanged: (v) {
                                                          cubit.setContactsCheck(
                                                              index,
                                                              cubit.contacts
                                                                  .where((element) => element
                                                                      .displayName!
                                                                      .toLowerCase()
                                                                      .contains(cubit
                                                                          .searchContact
                                                                          .text
                                                                          .toLowerCase()))
                                                                  .toList()[
                                                                      index]
                                                                  .phones![0]
                                                                  .number!);
                                                          if (v!) {
                                                            cubit.names.add(cubit
                                                                    .contacts
                                                                    .where((element) => element
                                                                        .displayName!
                                                                        .toLowerCase()
                                                                        .contains(cubit
                                                                            .searchContact
                                                                            .text
                                                                            .toLowerCase()))
                                                                    .toList()[
                                                                        index]
                                                                    .displayName ??
                                                                "");
                                                            cubit.phones.add(cubit
                                                                    .contacts
                                                                    .where((element) => element
                                                                        .displayName!
                                                                        .toLowerCase()
                                                                        .contains(cubit
                                                                            .searchContact
                                                                            .text
                                                                            .toLowerCase()))
                                                                    .toList()[
                                                                        index]
                                                                    .phones!
                                                                    .isEmpty
                                                                ? ""
                                                                : cubit.contacts
                                                                    .where((element) => element
                                                                        .displayName!
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            cubit.searchContact.text.toLowerCase()))
                                                                    .toList()[index]
                                                                    .phones![0]
                                                                    .number!);
                                                          } else {
                                                            cubit.names.remove(cubit
                                                                    .contacts
                                                                    .where((element) => element
                                                                        .displayName!
                                                                        .toLowerCase()
                                                                        .contains(cubit
                                                                            .searchContact
                                                                            .text
                                                                            .toLowerCase()))
                                                                    .toList()[
                                                                        index]
                                                                    .displayName ??
                                                                "");
                                                            cubit.phones.remove(cubit
                                                                    .contacts
                                                                    .where((element) => element
                                                                        .displayName!
                                                                        .toLowerCase()
                                                                        .contains(cubit
                                                                            .searchContact
                                                                            .text
                                                                            .toLowerCase()))
                                                                    .toList()[
                                                                        index]
                                                                    .phones!
                                                                    .isEmpty
                                                                ? ""
                                                                : cubit.contacts
                                                                    .where((element) => element
                                                                        .displayName!
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            cubit.searchContact.text.toLowerCase()))
                                                                    .toList()[index]
                                                                    .phones![0]
                                                                    .number!);
                                                          }
                                                        });
                                                  } else {
                                                    return const SizedBox(
                                                      width: 1,
                                                    );
                                                  }
                                                }),
                                          ],
                                        ),
                                        if (cubit.contacts
                                                .where((element) => element
                                                    .displayName!
                                                    .toLowerCase()
                                                    .contains(cubit
                                                        .searchContact.text
                                                        .toLowerCase()))
                                                .toList()[index]
                                                .phones!
                                                .length >
                                            1)
                                          ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index2) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                                      Text(
                                                        cubit.contacts
                                                            .where((element) => element
                                                                .displayName!
                                                                .toLowerCase()
                                                                .contains(cubit
                                                                    .searchContact
                                                                    .text
                                                                    .toLowerCase()))
                                                            .toList()[index]
                                                            .phones![index2]
                                                            .number!,
                                                        style: const TextStyle(
                                                          color:
                                                              AppUI.blackColor,
                                                        ),
                                                        textDirection: ui
                                                            .TextDirection.ltr,
                                                      ),
                                                      const Spacer(),
                                                      BlocBuilder<AddEventCubit,
                                                              AddEventState>(
                                                          buildWhen: (_,
                                                                  state) =>
                                                              state
                                                                  is ContactChangeState,
                                                          builder: (context,
                                                              snapshot) {
                                                            return Checkbox(
                                                                value: cubit.phones.contains(cubit
                                                                        .contacts
                                                                        .where((element) => element.displayName!.toLowerCase().contains(cubit
                                                                            .searchContact
                                                                            .text
                                                                            .toLowerCase()))
                                                                        .toList()[
                                                                            index]
                                                                        .phones![
                                                                            index2]
                                                                        .number!)
                                                                    ? true
                                                                    : false,
                                                                onChanged: (v) {
                                                                  cubit.setContactsCheck(
                                                                      index,
                                                                      cubit
                                                                          .contacts
                                                                          .where((element) => element.displayName!.toLowerCase().contains(cubit
                                                                              .searchContact
                                                                              .text
                                                                              .toLowerCase()))
                                                                          .toList()[
                                                                              index]
                                                                          .phones![
                                                                              index2]
                                                                          .number!);
                                                                  if (v!) {
                                                                    cubit.names.add(cubit
                                                                            .contacts
                                                                            .where((element) =>
                                                                                element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase()))
                                                                            .toList()[index]
                                                                            .displayName ??
                                                                        "");
                                                                    cubit.phones.add(cubit
                                                                            .contacts
                                                                            .where((element) => element.displayName!.toLowerCase().contains(cubit.searchContact.text
                                                                                .toLowerCase()))
                                                                            .toList()[
                                                                                index]
                                                                            .phones!
                                                                            .isEmpty
                                                                        ? ""
                                                                        : cubit
                                                                            .contacts
                                                                            .where((element) =>
                                                                                element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase()))
                                                                            .toList()[index]
                                                                            .phones![index2]
                                                                            .number!);
                                                                  } else {
                                                                    cubit.names.remove(cubit
                                                                            .contacts
                                                                            .where((element) =>
                                                                                element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase()))
                                                                            .toList()[index]
                                                                            .displayName ??
                                                                        "");
                                                                    cubit.phones.remove(cubit
                                                                            .contacts
                                                                            .where((element) => element.displayName!.toLowerCase().contains(cubit.searchContact.text
                                                                                .toLowerCase()))
                                                                            .toList()[
                                                                                index]
                                                                            .phones!
                                                                            .isEmpty
                                                                        ? ""
                                                                        : cubit
                                                                            .contacts
                                                                            .where((element) =>
                                                                                element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase()))
                                                                            .toList()[index]
                                                                            .phones![index2]
                                                                            .number!);
                                                                  }
                                                                });
                                                          }),
                                                    ],
                                                  )
                                                ],
                                              );
                                            },
                                            itemCount: cubit.contacts
                                                .where((element) => element
                                                    .displayName!
                                                    .toLowerCase()
                                                    .contains(cubit
                                                        .searchContact.text
                                                        .toLowerCase()))
                                                .toList()[index]
                                                .phones!
                                                .length,
                                          ),
                                      ],
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Divider();
                                  },
                                  itemCount: cubit.contacts
                                      .where((element) => element.displayName!
                                          .toLowerCase()
                                          .contains(cubit.searchContact.text
                                              .toLowerCase()))
                                      .length,
                                ),
                              ),
                            );
                          }),
                      //const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomButton(
                          text: 'done'.tr(),
                          onPressed: () {
                              Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                );
              });
        });
  }
  contactsSelectedBottomSheet(context) async {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: (context) {
          return BlocBuilder<AddEventCubit, AddEventState>(
              buildWhen: (_, state) => state is ContactsLoadedState,
              builder: (context, state) {
                return SizedBox(
                  height: AppUtil.responsiveHeight(context) * 0.85,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  text: "visitors".tr(),
                                  color: AppUI.blackColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            BlocBuilder<AddEventCubit, AddEventState>(
                                buildWhen: (_, state) =>
                                state is ContactChangeState,
                                builder: (context, state) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          CustomText(
                                            text:
                                            "${cubit.phones.length} ${"selected".tr()}",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                          ],
                        ),
                      ),
                      Container(
                        height: 5,
                        color: AppUI.backgroundColor,
                        width: double.infinity,
                      ),
                      BlocBuilder<AddEventCubit, AddEventState>(
                          buildWhen: (_, state) =>
                          state is ContactsLoadingState ||
                              state is ContactsLoadedState ||
                              state is ContactsErrorState ||
                              state is ContactsEmptyState,
                          builder: (context, state) {
                            if (state is ContactsLoadingState) {
                              return const LoadingWidget();
                            }
                            if (state is ContactsErrorState) {
                              return const ErrorFetchWidget();
                            }
                            if (state is ContactsEmptyState) {
                              return const EmptyWidget();
                            }
                            if (widget.event != null) {
                              int i = 0;
                              cubit.phones.clear();
                              cubit.names.clear();
                              for (var e in widget.event!.visitors) {
                                cubit.contactsCheck.add(e.phone);
                                cubit.phones.add(cubit.contacts
                                    .where((element) => element.displayName!
                                    .toLowerCase()
                                    .contains(cubit.names.toList()[i]
                                    .toLowerCase()))
                                    .toList()[i]
                                    .phones![0]
                                    .number!);
                                cubit.names.add(cubit.contacts
                                    .where((element) => element.displayName!
                                    .toLowerCase()
                                    .contains(cubit.names.toList()[i]
                                    .toLowerCase()))
                                    .toList()[i]
                                    .displayName!);
                                i++;
                              }
                              cubit.emit(ContactChangeState());
                            }

                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: "",
                                              width: 40,
                                              height: 40,
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                    "${AppUI.imgPath}logo.png",
                                                    width: 40,
                                                    height: 40,
                                                    fit: BoxFit.fill,
                                                  ),
                                              errorWidget: (context, url,
                                                  error) =>
                                                  Image.asset(
                                                      "${AppUI.imgPath}logo.png",
                                                      width: 40,
                                                      height: 40,
                                                      fit: BoxFit.fill),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  text: cubit.names[index],
                                                  color: AppUI.blackColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  cubit.phones[index],
                                                  style: const TextStyle(
                                                    color: AppUI.blackColor,
                                                  ),
                                                  textDirection:
                                                  ui.TextDirection.ltr,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                            // const Spacer(),
                                            // BlocBuilder<AddEventCubit,
                                            //     AddEventState>(
                                            //     buildWhen: (_, state) =>
                                            //     state is ContactChangeState,
                                            //     builder: (context, snapshot) {
                                            //         return Checkbox(
                                            //           activeColor: AppUI.errorColor,
                                            //             value: cubit.phones.contains(cubit
                                            //                 .contacts
                                            //                 .toList()[index]
                                            //                 .phones![0]
                                            //                 .value!)
                                            //                 ? true
                                            //                 : false,
                                            //             onChanged: (v) {
                                            //               cubit.setContactsCheck(
                                            //                   index,
                                            //                   cubit.contacts
                                            //                       .toList()[
                                            //                   index]
                                            //                       .phones![0]
                                            //                       .value!);
                                            //                 cubit.names.remove(cubit
                                            //                     .contacts
                                            //                     .toList()[
                                            //                 index]
                                            //                     .displayName ??
                                            //                     "");
                                            //                 cubit.phones.remove(cubit
                                            //                     .contacts
                                            //                     .toList()[
                                            //                 index]
                                            //                     .phones!
                                            //                     .isEmpty
                                            //                     ? ""
                                            //                     : cubit.contacts
                                            //                     .toList()[index]
                                            //                     .phones![0]
                                            //                     .value!);
                                            //             });
                                            //     }),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Divider();
                                  },
                                  itemCount: cubit.phones.length,
                                ),
                              ),
                            );
                          }),
                      //const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomButton(
                          text: 'done'.tr(),
                          onPressed: () {
                              Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                );
              });
        });
  }
  guardsBottomSheet(context) async {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: (context) {
          return BlocBuilder<GuardsCubit, GuardsSates>(
              buildWhen: (_, state) => state is GuardsLoadedState,
              builder: (context, state) {
                return SizedBox(
                  height: AppUtil.responsiveHeight(context) * 0.85,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  text: "guards".tr(),
                                  color: AppUI.blackColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                const Spacer(),
                                InkWell(
                                    onTap: () {
                                      AppUtil.mainNavigator(
                                          context, AddGuardScreen());
                                    },
                                    child: SvgPicture.asset(
                                        "${AppUI.iconPath}add.svg"))
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                CustomText(
                                  text:
                                      "${guardsCubit.guardsCheckTrue.length}/${guardsCubit.guardsModel!.data.length} ${"selected".tr()}",
                                  fontWeight: FontWeight.bold,
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          guardsCubit.selectAllGuards();
                                        },
                                        child: CustomText(
                                          text: "selectAll".tr(),
                                          color: AppUI.secondColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          guardsCubit.unSelectAllGuards();
                                        },
                                        child: CustomText(
                                          text: "clear".tr(),
                                          color: AppUI.errorColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 5,
                        color: AppUI.backgroundColor,
                        width: double.infinity,
                      ),
                      BlocBuilder<GuardsCubit, GuardsSates>(
                          buildWhen: (_, state) =>
                              state is GuardsLoadingState ||
                              state is GuardsLoadedState ||
                              state is GuardsErrorState ||
                              state is GuardsEmptyState,
                          builder: (context, state) {
                            if (state is GuardsLoadingState) {
                              return const LoadingWidget();
                            }
                            if (state is GuardsErrorState) {
                              return const ErrorFetchWidget();
                            }
                            if (state is GuardsEmptyState) {
                              return const EmptyWidget();
                            }

                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ListView(
                                  shrinkWrap: true,
                                  children: List.generate(
                                      guardsCubit.guardsModel!.data.length,
                                      (index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  text: guardsCubit.guardsModel!
                                                      .data[index].name,
                                                  color: AppUI.blackColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                    guardsCubit.guardsModel!
                                                        .data[index].phone,
                                                    style: const TextStyle(
                                                        color:
                                                            AppUI.blackColor),
                                                    textDirection:
                                                        ui.TextDirection.ltr)
                                              ],
                                            ),
                                            const Spacer(),
                                            Checkbox(
                                                value: guardsCubit
                                                    .guardsCheck[index],
                                                onChanged: (v) {
                                                  if (v!) {
                                                    guardsCubit
                                                        .selectedGuardsIds
                                                        .add(guardsCubit
                                                            .guardsModel!
                                                            .data[index]
                                                            .id);
                                                  } else {
                                                    guardsCubit
                                                        .selectedGuardsIds
                                                        .remove(guardsCubit
                                                            .guardsModel!
                                                            .data[index]
                                                            .id);
                                                  }
                                                  guardsCubit.setGuardsCheck(
                                                      index, v);
                                                })
                                          ],
                                        ),
                                        const Divider()
                                      ],
                                    );
                                  }),
                                ),
                              ),
                            );
                          }),
                      //const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomButton(
                          text: 'done'.tr(),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                );
              });
        });
  }

  getData() async {
    guardsCubit.selectedGuardsIds.clear();
    if (widget.event != null) {
      cubit.eventName.text = widget.event!.name;
      cubit.selectedType = cubit.eventTypesModel!.types
          .where((element) => element.id == widget.event!.type.id)
          .first;
      cubit.eventType.text = cubit.selectedType!.name;
      cubit.dob.text = widget.event!.dateFrom;
      cubit.time.text = widget.event!.timeFrom;
      cubit.address.text = widget.event!.location;
      cubit.desc.text = widget.event!.content;
      cubit.location = LatLng(double.parse(widget.event!.lat.toString()),
          double.parse(widget.event!.lang.toString()));
    }
    await cubit.askPermissions(context);
    await guardsCubit.getGuards();
    if (widget.event != null) {
      for (var g in widget.event!.guards) {
        guardIndexes.add(guardsCubit.guardsModel!.data
            .indexWhere((element) => element.phone == g.phone));
        guardIds.add(guardsCubit.guardsModel!.data
            .where((element) => element.phone == g.phone)
            .first
            .id);
      }
      for (var element in guardIndexes) {
        if (element != -1) {
          guardsCubit.guardsCheck[element] = true;
        }
      }
      for (var element in guardIds) {
        if (element != -1) {
          guardsCubit.selectedGuardsIds.add(element);
        }
      }
    }
  }
}
