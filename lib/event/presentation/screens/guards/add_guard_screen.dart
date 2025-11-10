import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/event/presentation/controller/guards/guards_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;
import '../../../../core/app_util.dart';
import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../controller/guards/guards_cubit.dart';
class AddGuardScreen extends StatefulWidget {

  const AddGuardScreen({Key? key}) : super(key: key);

  @override
  State<AddGuardScreen> createState() => _AddGuardScreenState();
}

class _AddGuardScreenState extends State<AddGuardScreen> {
  late final cubit = GuardsCubit.get(context);

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit.countryCodeController.text = _selectedCountry!.phoneCode;

    cubit.getContacts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
          SingleChildScrollView(
            child: Column(
              children: [
                customAppBar(title: "addGuard".tr(),backgroundColor: Colors.transparent),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomCard(
                    // height: AppUtil.responsiveHeight(context)*0.82,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        children: [
                          SvgPicture.asset("${AppUI.iconPath}guard.svg"),
                          const SizedBox(height: 40,),
                          Row(
                            children: [
                              InkWell(onTap: (){
                                contactsBottomSheet(context);
                              },child: CustomText(text: 'addPhoneNumberFromContacts'.tr(),textDecoration: TextDecoration.underline,fontWeight: FontWeight.bold,fontSize: 12,)),
                            ],
                          ),
                          const SizedBox(height: 10,),

                          CustomInput(controller: cubit.nameController,hint: "fullName".tr(), textInputType: TextInputType.name),
                          const SizedBox(height: 15,),
                          CustomInput(controller: cubit.phoneController,hint: "phoneNumber".tr(), textInputType: TextInputType.phone,prefixIcon: SizedBox(
                            width: 50,
                            child: InkWell(
                              onTap: (){
                                showCountryPicker(
                                  context: context,
                                  showSearch: false,
                                  countryFilter: <String>['SA','EG','AE'],
                                  showPhoneCode: true,
                                  countryListTheme: const CountryListThemeData(
                                    flagSize: 25,
                                    backgroundColor: Colors.white,
                                    textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                                    bottomSheetHeight: 160, // Optional. Country list modal height
                                    //Optional. Sets the border radius for the bottomsheet.
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                    ),
                                    //Optional. Styles the search field.
                                    // inputDecoration: InputDecoration(
                                    //   labelText: 'Search',
                                    //   contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                    //   hintText: 'Start typing to search',
                                    //   prefixIcon: const Icon(Icons.search),
                                    //   border: OutlineInputBorder(
                                    //     borderRadius: BorderRadius.circular(30),
                                    //     borderSide: BorderSide(
                                    //       color: const Color(0xFF8C98A8).withOpacity(0.2),
                                    //     ),
                                    //   ),
                                    // ),
                                  ),// optional. Shows phone code before the country name.
                                  onSelect: (Country country) {
                                    _selectedCountry = country;
                                    cubit.countryCodeController.text = _selectedCountry!.phoneCode;
                                    setState(() {

                                    });
                                    print('Select country: ${country.flagEmoji}');
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  const SizedBox(width: 5,),
                                  if(_selectedCountry!=null)
                                    CustomText(text:_selectedCountry!.flagEmoji),
                                  const Icon(Icons.arrow_drop_down,color: AppUI.blackColor,),
                                  Container(height: 20,width: 0.6,color: AppUI.disableColor,)
                                ],
                              ),
                            ),
                          ),),
                          // CustomInput(controller: TextEditingController(),hint: "email".tr(), textInputType: TextInputType.emailAddress),
                          const SizedBox(height: 15,),
                          BlocBuilder<GuardsCubit,GuardsSates>(
                            buildWhen: (_,state) => state is AddGuardsLoadingState || state is AddGuardsLoadedState,
                            builder: (context, state) {
                              if(state is AddGuardsLoadingState){
                                return const LoadingWidget();
                              }
                              return CustomButton(text: "save".tr(),onPressed: (){
                                cubit.addGuard(context);
                                // AppUtil.mainNavigator(context, const VerificationScreen());
                              },);
                            }
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  contactsBottomSheet(context) async {
    return showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
    ), builder: (context){
      return BlocBuilder<GuardsCubit,GuardsSates>(
          buildWhen: (_,state) => state is ContactsGuardLoadedState,
          builder: (context, state) {
            return SizedBox(
              height: AppUtil.responsiveHeight(context)*0.85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CustomText(text: "contacts".tr(),color: AppUI.blackColor,fontSize: 17,fontWeight: FontWeight.bold,),
                            const Spacer(),
                            InkWell(
                                onTap: (){
                                  AppUtil.dialog2(context, 'addContact'.tr(), [
                                    CustomInput(controller: cubit.contactName, hint: "name".tr(), textInputType: TextInputType.text),
                                    const SizedBox(height: 10,),
                                    BlocBuilder<GuardsCubit,GuardsSates>(
                                        buildWhen: (_,state) => state is ContactsGuardLoadedState,
                                        builder: (context, state) {
                                          return CustomInput(controller:cubit.contactPhone,hint: "phoneNumber".tr(), textInputType: TextInputType.phone,prefixIcon: SizedBox(
                                            width: 50,
                                            child: InkWell(
                                              onTap: (){
                                                showCountryPicker(
                                                  context: context,
                                                  showPhoneCode: true,
                                                  countryListTheme: CountryListThemeData(
                                                    flagSize: 25,
                                                    backgroundColor: Colors.white,
                                                    textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                                                    bottomSheetHeight: 500, // Optional. Country list modal height
                                                    //Optional. Sets the border radius for the bottomsheet.
                                                    borderRadius: const BorderRadius.only(
                                                      topLeft: Radius.circular(20.0),
                                                      topRight: Radius.circular(20.0),
                                                    ),
                                                    //Optional. Styles the search field.
                                                    inputDecoration: InputDecoration(
                                                      labelText: 'Search',
                                                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                                      hintText: 'Start typing to search',
                                                      prefixIcon: const Icon(Icons.search),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(30),
                                                        borderSide: BorderSide(
                                                          color: const Color(0xFF8C98A8).withOpacity(0.2),
                                                        ),
                                                      ),
                                                    ),
                                                  ),// optional. Shows phone code before the country name.
                                                  onSelect: (Country country) {
                                                    _selectedCountry = country;
                                                    cubit.contactCountryCode.text = _selectedCountry!.phoneCode;
                                                    cubit.emit(ContactsGuardLoadedState());
                                                  },
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  if(_selectedCountry!=null)
                                                    CustomText(text:_selectedCountry!.flagEmoji),
                                                  const Icon(Icons.arrow_drop_down,color: AppUI.blackColor,),
                                                  Container(height: 20,width: 0.6,color: AppUI.disableColor,)
                                                ],
                                              ),
                                            ),
                                          ),);
                                        }
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomButton(text: "save".tr(),onPressed: (){
                                            cubit.addContact();
                                            Navigator.of(context,rootNavigator: true).pop();
                                          },),
                                        ),
                                        const SizedBox(width: 10,),
                                        Expanded(
                                          child: CustomButton(text: "cancel".tr(),color: AppUI.whiteColor,textColor: AppUI.buttonColor,borderColor: AppUI.buttonColor,onPressed: (){
                                            Navigator.of(context,rootNavigator: true).pop();
                                          },),
                                        ),
                                      ],
                                    )
                                  ]);
                                },
                                child: SvgPicture.asset("${AppUI.iconPath}add.svg"))
                          ],
                        ),
                        const SizedBox(height: 20,),
                        SizedBox(height: 40,child: CustomInput(controller: cubit.searchContact,onChange: (v){
                          // cubit.getContacts(search: v);
                          cubit.emit(ContactsGuardLoadedState());
                        }, hint: "search".tr(), borderColor: AppUI.secondColor, textInputType: TextInputType.text,prefixIcon: IconButton(onPressed: (){}, icon: const Icon(Icons.search,color: AppUI.secondColor,)),)),
                        const SizedBox(height: 20,),
                  Container(height: 5,color: AppUI.backgroundColor,width: double.infinity,),
                  BlocBuilder<GuardsCubit,GuardsSates>(
                      buildWhen: (_,state) => state is ContactsGuardLoadingState || state is ContactsGuardLoadedState || state is ContactsGuardErrorState || state is ContactsGuardEmptyState,
                      builder: (context, state) {
                        if(state is ContactsGuardLoadingState){
                          return const LoadingWidget();
                        }
                        if(state is ContactsGuardErrorState){
                          return const ErrorFetchWidget();
                        }
                        if(state is ContactsGuardEmptyState){
                          return const EmptyWidget();
                        }

                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child:
                          SizedBox(
                            width: AppUtil.responsiveWidth(context)*0.99,height: AppUtil.responsiveHeight(context)*0.85-174,
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: cubit.contacts[index].phones!.length == 1 ? (){
                                    cubit.nameController.text = cubit
                                        .contacts.where((element) => element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase())).toList()[index]
                                        .displayName ?? "";
                                    cubit.phoneController.text = cubit
                                        .contacts.where((element) => element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase())).toList()[index]
                                        .phones!.isEmpty
                                        ? ""
                                        : cubit
                                        .contacts.where((element) => element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase())).toList()[index]
                                        .phones![0].value!;
                                    Navigator.pop(context);

                                  }:null,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: "",
                                            width: 40,
                                            height: 40,
                                            placeholder: (context, url) => Image.asset("${AppUI.imgPath}logo.png",width: 40,height: 40,fit: BoxFit.fill,),
                                            errorWidget: (context, url, error) => Image.asset("${AppUI.imgPath}logo.png",width: 40,height: 40,fit: BoxFit.fill),
                                          ),
                                          const SizedBox(width: 10,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomText(text: cubit.contacts.where((element) => element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase())).toList()[index].displayName??"",color: AppUI.blackColor,fontWeight: FontWeight.bold,),
                                              const SizedBox(height: 5,),
                                              if(cubit.contacts.where((element) => element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase())).toList()[index].phones!.length == 1)
                                                Text(cubit.contacts.where((element) => element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase())).toList()[index].phones![0].value!,style: const TextStyle(
                                                  color: AppUI.blackColor,
                                                ),textDirection: ui.TextDirection.ltr,),
                                            ],
                                          ),
                                        ],
                                      ),
                                      if(cubit.contacts.where((element) => element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase())).toList()[index].phones!.length > 1)
                                        ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context, int index2) {
                                            return InkWell(
                                              onTap: (){
                                                cubit.nameController.text = cubit
                                                    .contacts.where((element) => element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase())).toList()[index]
                                                    .displayName ?? "";
                                                cubit.phoneController.text = cubit
                                                    .contacts[index]
                                                    .phones!.isEmpty
                                                    ? ""
                                                    : cubit
                                                    .contacts.where((element) => element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase())).toList()[index]
                                                    .phones![index2].value!;
                                                Navigator.pop(context);
                                              },
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const SizedBox(width: 40,height: 40,),
                                                      Text(cubit.contacts.where((element) => element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase())).toList()[index].phones![index2].value!,style: const TextStyle(
                                                        color: AppUI.blackColor,
                                                      ),textDirection: ui.TextDirection.ltr,),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                          itemCount: cubit.contacts.where((element) => element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase())).toList()[index].phones!.length,
                                        ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return const Divider();
                              },
                              itemCount: cubit.contacts.where((element) => element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase())).length,
                            ),
                          ),
                        );
                      }
                  ),
                  //const Spacer(),
                ],
              ),
            )])
            );
          }
      );
    });
  }

  // contactsBottomSheet(context) async {
  //   return showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
  //   ), builder: (context){
  //     return BlocBuilder<GuardsCubit,GuardsSates>(
  //         buildWhen: (_,state) => state is ContactsGuardLoadedState,
  //         builder: (context, state) {
  //           return SizedBox(
  //             height: AppUtil.responsiveHeight(context)*0.85,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(16.0),
  //                   child: Column(
  //                     children: [
  //                       Row(
  //                         children: [
  //                           CustomText(text: "contacts".tr(),color: AppUI.blackColor,fontSize: 17,fontWeight: FontWeight.bold,),
  //                           const Spacer(),
  //                           InkWell(
  //                               onTap: (){
  //                                 AppUtil.dialog2(context, 'addContact'.tr(), [
  //                                   CustomInput(controller: cubit.contactName, hint: "name".tr(), textInputType: TextInputType.text),
  //                                   const SizedBox(height: 10,),
  //                                   BlocBuilder<GuardsCubit,GuardsSates>(
  //                                       buildWhen: (_,state) => state is ContactsGuardLoadedState,
  //                                       builder: (context, state) {
  //                                         return CustomInput(controller:cubit.contactPhone,hint: "phoneNumber".tr(), textInputType: TextInputType.phone,prefixIcon: SizedBox(
  //                                           width: 50,
  //                                           child: InkWell(
  //                                             onTap: (){
  //                                               showCountryPicker(
  //                                                 context: context,
  //                                                 showPhoneCode: true,
  //                                                 countryListTheme: CountryListThemeData(
  //                                                   flagSize: 25,
  //                                                   backgroundColor: Colors.white,
  //                                                   textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
  //                                                   bottomSheetHeight: 500, // Optional. Country list modal height
  //                                                   //Optional. Sets the border radius for the bottomsheet.
  //                                                   borderRadius: const BorderRadius.only(
  //                                                     topLeft: Radius.circular(20.0),
  //                                                     topRight: Radius.circular(20.0),
  //                                                   ),
  //                                                   //Optional. Styles the search field.
  //                                                   inputDecoration: InputDecoration(
  //                                                     labelText: 'Search',
  //                                                     contentPadding: const EdgeInsets.symmetric(vertical: 10),
  //                                                     hintText: 'Start typing to search',
  //                                                     prefixIcon: const Icon(Icons.search),
  //                                                     border: OutlineInputBorder(
  //                                                       borderRadius: BorderRadius.circular(30),
  //                                                       borderSide: BorderSide(
  //                                                         color: const Color(0xFF8C98A8).withOpacity(0.2),
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ),// optional. Shows phone code before the country name.
  //                                                 onSelect: (Country country) {
  //                                                   _selectedCountry = country;
  //                                                   cubit.contactCountryCode.text = _selectedCountry!.phoneCode;
  //                                                   cubit.emit(ContactsGuardLoadedState());
  //                                                 },
  //                                               );
  //                                             },
  //                                             child: Row(
  //                                               children: [
  //                                                 if(_selectedCountry!=null)
  //                                                   CustomText(text:_selectedCountry!.flagEmoji),
  //                                                 const Icon(Icons.arrow_drop_down,color: AppUI.blackColor,),
  //                                                 Container(height: 20,width: 0.6,color: AppUI.disableColor,)
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),);
  //                                       }
  //                                   ),
  //                                   const SizedBox(height: 20,),
  //                                   Row(
  //                                     children: [
  //                                       Expanded(
  //                                         child: CustomButton(text: "save".tr(),onPressed: (){
  //                                           cubit.addContact();
  //                                           Navigator.of(context,rootNavigator: true).pop();
  //                                         },),
  //                                       ),
  //                                       const SizedBox(width: 10,),
  //                                       Expanded(
  //                                         child: CustomButton(text: "cancel".tr(),color: AppUI.whiteColor,textColor: AppUI.buttonColor,borderColor: AppUI.buttonColor,onPressed: (){
  //                                           Navigator.of(context,rootNavigator: true).pop();
  //                                         },),
  //                                       ),
  //                                     ],
  //                                   )
  //                                 ]);
  //                               },
  //                               child: SvgPicture.asset("${AppUI.iconPath}add.svg"))
  //                         ],
  //                       ),
  //                       const SizedBox(height: 20,),
  //                       SizedBox(height: 40,child: CustomInput(controller: cubit.searchContact,onChange: (v){
  //                         cubit.getContacts(search: v);
  //                       }, hint: "search".tr(), borderColor: AppUI.secondColor, textInputType: TextInputType.text,prefixIcon: IconButton(onPressed: (){}, icon: const Icon(Icons.search,color: AppUI.secondColor,)),)),
  //                       const SizedBox(height: 20,),
  //                     ],
  //                   ),
  //                 ),
  //                 Container(height: 5,color: AppUI.backgroundColor,width: double.infinity,),
  //                 BlocBuilder<GuardsCubit,GuardsSates>(
  //                     buildWhen: (_,state) => state is ContactsGuardLoadingState || state is ContactsGuardLoadedState || state is ContactsGuardErrorState || state is ContactsGuardEmptyState,
  //                     builder: (context, state) {
  //                       if(state is ContactsGuardLoadingState){
  //                         return const LoadingWidget();
  //                       }
  //                       if(state is ContactsGuardErrorState){
  //                         return const ErrorFetchWidget();
  //                       }
  //                       if(state is ContactsGuardEmptyState){
  //                         return const EmptyWidget();
  //                       }
  //
  //                       return Expanded(
  //                         child: Padding(
  //                           padding: const EdgeInsets.all(16.0),
  //                           child: ListView(
  //                             shrinkWrap: true,
  //                             children: List.generate(cubit.contacts.length, (index) {
  //                               return Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Row(
  //                                     children: [
  //                                       CachedNetworkImage(
  //                                         imageUrl: "",
  //                                         width: 40,
  //                                         height: 40,
  //                                         placeholder: (context, url) => Image.asset("${AppUI.imgPath}logo.png",width: 40,height: 40,fit: BoxFit.fill,),
  //                                         errorWidget: (context, url, error) => Image.asset("${AppUI.imgPath}logo.png",width: 40,height: 40,fit: BoxFit.fill),
  //                                       ),
  //                                       const SizedBox(width: 10,),
  //                                       InkWell(
  //                                         onTap: cubit.contacts[index].phones!.length == 1 ? (){
  //                                           cubit.nameController.text = cubit
  //                                               .contacts[index]
  //                                               .displayName ?? "";
  //                                           cubit.phoneController.text = cubit
  //                                               .contacts[index]
  //                                               .phones!.isEmpty
  //                                               ? ""
  //                                               : cubit
  //                                               .contacts[index]
  //                                               .phones![0].value!;
  //                                           Navigator.pop(context);
  //
  //                                         }:null,
  //                                         child: Column(
  //                                           crossAxisAlignment: CrossAxisAlignment.start,
  //                                           children: [
  //                                             CustomText(text: cubit.contacts[index].displayName??"",color: AppUI.blackColor,fontWeight: FontWeight.bold,),
  //                                             const SizedBox(height: 5,),
  //                                             if(cubit.contacts[index].phones!.length == 1)
  //                                               Text(cubit.contacts[index].phones![0].value!,style: const TextStyle(
  //                                                 color: AppUI.blackColor,
  //                                               ),textDirection: ui.TextDirection.ltr,),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                   if(cubit.contacts[index].phones!.length > 1)
  //                                     Column(
  //                                       children:  List.generate(cubit.contacts[index].phones!.length, (index2) {
  //                                         return InkWell(
  //                                           onTap: (){
  //                                             cubit.nameController.text = cubit
  //                                                 .contacts[index]
  //                                                 .displayName ?? "";
  //                                             cubit.phoneController.text = cubit
  //                                                 .contacts[index]
  //                                                 .phones!.isEmpty
  //                                                 ? ""
  //                                                 : cubit
  //                                                 .contacts[index]
  //                                                 .phones![index2].value!;
  //                                             Navigator.pop(context);
  //                                           },
  //                                           child: Column(
  //                                             crossAxisAlignment: CrossAxisAlignment.start,
  //                                             children: [
  //                                               Row(
  //                                                 children: [
  //                                                   const SizedBox(width: 40,height: 40,),
  //                                                   Text(cubit.contacts[index].phones![index2].value!,style: const TextStyle(
  //                                                     color: AppUI.blackColor,
  //                                                   ),textDirection: ui.TextDirection.ltr,),
  //                                                 ],
  //                                               )
  //                                             ],
  //                                           ),
  //                                         );
  //                                       }),
  //                                     ),
  //                                   const Divider()
  //                                 ],
  //                               );
  //                             }),
  //                           ),
  //                         ),
  //                       );
  //                     }
  //                 ),
  //                 //const Spacer(),
  //               ],
  //             ),
  //           );
  //         }
  //     );
  //   });
  // }

}
