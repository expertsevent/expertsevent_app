import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/event/models/events_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/app_util.dart';
import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../../../event/presentation/controller/guards/guards_cubit.dart';
import '../../controller/add_event_cubit.dart';
import '../../controller/add_event_states.dart';
import 'package:screenshot/screenshot.dart';

class Design extends StatefulWidget {
  final Event? event;
  const Design({Key? key, this.event}) : super(key: key);

  @override
  State<Design> createState() => _DesignState();
}

class _DesignState extends State<Design> {

  late final AddEventCubit cubit;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    cubit = AddEventCubit.get(context);
    cubit.selectedSubTypePackage = "0";
      cubit.selectedSubTypePhoto =
      'https://api.expertsevent.com/public/blue.png';
      cubit.eventSubTypes(context, 1); //widget.event!.id
      cubit.selectedSubTypePhoto =
      cubit.eventSubTypesModel!.types[0].templates!.isEmpty
          ? 'https://api.expertsevent.com/public/blue.png'
          : cubit.eventSubTypesModel!.types[0].templates![0].photo;
    cubit.selectedSubTypePackage =
    cubit.eventSubTypesModel!.types[0].templates!.isEmpty
        ? '0'
        : cubit.eventSubTypesModel!.types[0].templates![0].packageId.toString();
      cubit.selectedSubType = 0;
      cubit.eventType.text = cubit.eventTypesModel!.types[0].name;
      cubit.selectedType = cubit.eventTypesModel!.types[0];

  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<AddEventCubit, AddEventState>(
            buildWhen: (_, state) => state is UploadImageCheckChangeState,
            builder: (context, state) {
              return Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomInput(controller: cubit.eventType,hint: "eventType".tr(),suffixIcon: const Icon(Icons.arrow_drop_down), textInputType: TextInputType.url,fillColor: AppUI.whiteColor,readOnly: true,onTap: (){
                    AppUtil.dialog2(context, "eventType".tr(), [
                      BlocBuilder<AddEventCubit,AddEventState>(
                          buildWhen: (_,state) => state is EventSubTypesLoadingState || state is EventSubTypesLoadedState || state is EventSubTypesEmptyState || state is EventSubTypesErrorState,
                          builder: (context, state) {
                            if(state is EventSubTypesLoadingState){
                              return const LoadingWidget();
                            }
                            if(state is EventSubTypesEmptyState){
                              return const EmptyWidget();
                            }
                            if(state is EventSubTypesErrorState){
                              return const ErrorFetchWidget();
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(cubit.eventTypesModel!.types.length, (index) {
                                return InkWell(
                                  onTap: () async {
                                    cubit.selectedType = cubit.eventTypesModel!.types[index];
                                    cubit.eventType.text = cubit.eventTypesModel!.types[index].name;
                                    Navigator.of(context,rootNavigator: true).pop();
                                    await cubit.eventSubTypes(context,cubit.selectedType!.id); //widget.event!.id
                                    cubit.selectedSubTypePhoto = 'https://api.expertsevent.com/public/blue.png';
                                    cubit.selectedSubTypePackage = '0';
                                    cubit.selectedSubType = 0;
                                    cubit.selectedSubTypePhoto = cubit.eventSubTypesModel!.types[0].templates!.isEmpty? '' : cubit.eventSubTypesModel!.types[0].templates![0].photo ;
                                    cubit.selectedSubTypePackage = cubit.eventSubTypesModel!.types[0].templates!.isEmpty? '0' : cubit.eventSubTypesModel!.types[0].templates![0].packageId.toString() ;
                                    // cubit.eventSubTypes(context,cubit.eventSubTypesModel!.types[0].id);
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(text: cubit.eventTypesModel!.types[index].name,fontWeight: FontWeight.w600,color: AppUI.bottomBarColor,),
                                      if(index + 1 != cubit.eventTypesModel!.types.length)
                                        const Divider(),
                                    ],
                                  ),
                                );
                              }),
                            );
                          }
                      )
                    ]);
                  },),
                  const SizedBox(height: 15,),
                  Row(
                    children: [
                      BlocBuilder<AddEventCubit, AddEventState>(
                          buildWhen: (_, state) => state is UploadImageCheckChangeState,
                          builder: (context, state) {
                            return InkWell(
                              onTap: () {
                                cubit.uploadImageCheck = !cubit.uploadImageCheck;
                              },
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border:
                                    Border.all(color: AppUI.backgroundColor),
                                    color: cubit.uploadImageCheck
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
                      CustomText(text: "${"uploadImageFromDevice".tr()}"),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  if(cubit.uploadImageCheck)
                    BlocBuilder<AddEventCubit, AddEventState>(
                        buildWhen: (_,state) => state is EventPhotoChangeState,
                        builder: (context, state) {
                          return CustomCard(
                            onTap: (){
                              cubit.chooseImageDialog(cubit.scaffoldKey.currentContext!);
                            },
                            height: 150,elevation: 0,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              padding: const EdgeInsets.all(6),
                              dashPattern: const [6, 3],
                              color: AppUI.disableColor,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                child: SizedBox(
                                  height: 200,
                                  width: double.infinity,
                                  child:cubit.eventPhotoUpload == null ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset("${AppUI.iconPath}camera.svg"),
                                      const SizedBox(height: 10,),
                                      Text("uploadImageFromDevice".tr(),
                                        style: const TextStyle(
                                            color:AppUI.bottomBarColor,
                                            fontWeight: FontWeight.bold
                                        ),),
                                      Text("photoMustbeLetterThan2MB".tr(),
                                        style: const TextStyle(
                                            color:AppUI.errorColor,
                                            fontSize: 8
                                        ),),

                                    ],
                                  ):Image.file(File(cubit.eventPhotoUpload!.path,)),
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  // BlocBuilder<AddEventCubit,AddEventState>(
                  //     buildWhen: (_,state) => state is EventSubTypesLoadingState || state is EventSubTypesLoadedState || state is EventSubTypesEmptyState || state is EventSubTypesErrorState,
                  //     builder: (context, state) {
                  //       if(state is EventSubTypesLoadingState && (cubit.eventSubTypesModel == null || cubit.eventSubTypesModel!.types.isEmpty) ){
                  //         return const LoadingWidget();
                  //       }
                  //       if(state is EventSubTypesEmptyState){
                  //         return const EmptyWidget();
                  //       }
                  //       if(state is EventSubTypesErrorState){
                  //         return const ErrorFetchWidget();
                  //       }
                  //       if(cubit.eventSubTypesModel == null){
                  //         return const SizedBox();
                  //       }
                  //       return SizedBox(
                  //         height: 50,
                  //         child: ListView(
                  //           scrollDirection: Axis.horizontal,
                  //           children: List.generate(cubit.eventSubTypesModel!.types.length, (index) {
                  //             return InkWell(
                  //               onTap: (){
                  //                 cubit.selectedSubType = index;
                  //                 cubit.selectedSubTypePhoto = cubit.eventSubTypesModel!.types[index].templates!.isEmpty? '' : cubit.eventSubTypesModel!.types[index].templates![0].photo ;
                  //                 cubit.eventSubTypes(context,cubit.selectedType!.id);
                  //               },
                  //               child: Row(
                  //                   children: [
                  //                     Container(
                  //                       height:30 ,
                  //                       padding : const EdgeInsets.symmetric(
                  //                         horizontal: 20,
                  //                         vertical: 5,
                  //                       ),
                  //                       decoration: BoxDecoration(
                  //                         borderRadius: BorderRadius.circular(15),
                  //                         border: Border.all(color: Colors.grey),
                  //                         color: AppUI.mainColor.withOpacity(0.3),
                  //                       ),
                  //                       child: Text(cubit.eventSubTypesModel!.types[index].name),
                  //                     ),
                  //                     const SizedBox(width: 10,),
                  //                   ]
                  //               ),
                  //             );
                  //           }),
                  //         ),
                  //       );
                  //     }
                  // ),
                  if(!cubit.uploadImageCheck)
                    const SizedBox(height: 20,),
                  if(!cubit.uploadImageCheck)
                    Screenshot(
                      controller: screenshotController,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          BlocBuilder<AddEventCubit,AddEventState>(
                              buildWhen: (_,state) => state is EventSubTypesPhotoChangeState || state is EventSubTypesLoadedState,
                              builder: (context, state) {
                                // if(cubit.selectedSubTypePhoto == "" || cubit.selectedSubTypePhoto == null){
                                //   return const SizedBox();
                                // }
                                return Container(
                                  height: 350,
                                  width: 250,
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.grey),
                                    // color: cubit.selectedSubTypePhoto == "" || cubit.selectedSubTypePhoto == null?Colors.grey:null
                                  ),
                                  child:
                                  cubit.selectedSubTypePhoto == "" || cubit.selectedSubTypePhoto == null?null:Image.network(cubit.selectedSubTypePhoto!,
                                    height: 350,
                                    width: 250,fit: BoxFit.fill,),
                                );
                              }
                          ),
                          BlocBuilder<AddEventCubit,AddEventState>(
                              buildWhen: (_,state) => state is EventSubTypesTextChangeState,
                              builder: (context, state) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: Column(
                                    children: [
                                      if(cubit.selectedSubTypePackage != "3")
                                      SizedBox(width: 200,height: 30,child: CustomText(text: cubit.eventName.text,fontSize: 17,fontWeight: FontWeight.bold,textAlign: TextAlign.center,color: Colors.black.withOpacity(0.8),)),
                                      if(cubit.selectedSubTypePackage != "3")
                                      const SizedBox(height: 20,),
                                      if(cubit.selectedSubTypePackage != "3")
                                      SizedBox(width: 185,height: 125,child: CustomText(text: cubit.desc.text,textAlign: TextAlign.center,color: Colors.black.withOpacity(0.8),fontSize: cubit.desc.text.length<70 ? 14 : cubit.desc.text.length > 70 && cubit.desc.text.length < 160? 11:9,)),
                                      if(cubit.selectedSubTypePackage != "3")
                                      const SizedBox(height: 25,),
                                      if(cubit.selectedSubTypePackage != "3")
                                      SizedBox(width: 200,height: 20,child: CustomText(text: cubit.address.text,textAlign: TextAlign.center,color: Colors.black.withOpacity(0.8),)),
                                      if(cubit.selectedSubTypePackage != "3")
                                      const SizedBox(height: 25,),
                                      if(cubit.selectedSubTypePackage != "3")
                                      SizedBox(width: 200,height: 25,child: CustomText(text: cubit.dob.text,textAlign: TextAlign.center,color: Colors.black.withOpacity(0.8),)),

                                      if(cubit.selectedSubTypePackage == "3")
                                      const SizedBox(height: 130,),
                                      if(cubit.selectedSubTypePackage == "3")
                                        SizedBox(width: 200,height: 20,child: CustomText(text: cubit.eventName.text,fontSize: 17,fontWeight: FontWeight.bold,textAlign: TextAlign.center,color: Colors.black.withOpacity(0.8),)),
                                      if(cubit.selectedSubTypePackage == "3")
                                        const SizedBox(height: 10,),
                                      if(cubit.selectedSubTypePackage == "3")
                                        SizedBox(width: 185,height: 70,child: CustomText(text: cubit.desc.text,textAlign: TextAlign.center,color: Colors.black.withOpacity(0.8),fontSize: cubit.desc.text.length<70 ? 14 : cubit.desc.text.length > 70 && cubit.desc.text.length < 160? 11:9,)),
                                      if(cubit.selectedSubTypePackage == "3")
                                        const SizedBox(height: 10,),
                                      if(cubit.selectedSubTypePackage == "3")
                                        SizedBox(width: 200,height: 20,child: CustomText(text: cubit.address.text,textAlign: TextAlign.center,color: Colors.black.withOpacity(0.8),)),
                                      if(cubit.selectedSubTypePackage == "3")
                                        const SizedBox(height: 15,),
                                      if(cubit.selectedSubTypePackage == "3")
                                        SizedBox(width: 200,height: 20,child: CustomText(text: cubit.dob.text,textAlign: TextAlign.center,color: Colors.black.withOpacity(0.8),)),
                                    ],
                                  ),
                                );
                              }
                          ),
                        ],
                      ),
                    ),
                  if(!cubit.uploadImageCheck)
                    const SizedBox(height: 10,),
                  if(!cubit.uploadImageCheck)
                    BlocBuilder<AddEventCubit,AddEventState>(
                        buildWhen: (_,state) => state is EventSubTypesLoadingState || state is EventSubTypesLoadedState || state is EventSubTypesEmptyState || state is EventSubTypesErrorState,
                        builder: (context, state) {
                          if(state is EventSubTypesLoadingState){
                            return const LoadingWidget();
                          }
                          if(state is EventSubTypesEmptyState){
                            return const EmptyWidget();
                          }
                          if(state is EventSubTypesErrorState){
                            return const ErrorFetchWidget();
                          }
                          if(cubit.eventSubTypesModel == null){
                            return const SizedBox();
                          }
                          return SizedBox(
                            height: 150,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: List.generate(cubit.eventSubTypesModel!.types[cubit.selectedSubType!].templates!.length, (index) {
                                return InkWell(
                                  onTap: ()
                                  {
                                    cubit.selectedSubTypePhoto = cubit.eventSubTypesModel!.types[cubit.selectedSubType!].templates![index].photo;
                                    cubit.selectedSubTypePackage = cubit.eventSubTypesModel!.types[cubit.selectedSubType!].templates![index].packageId.toString();
                                    cubit.emit(EventSubTypesPhotoChangeState());
                                  },
                                  child: Row(
                                      children: [
                                        Container(
                                          height: 120,
                                          width: 100,
                                          padding : const EdgeInsets.symmetric(
                                            horizontal: 5,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(color: Colors.grey),
                                          ),
                                          child: Image.network(cubit.eventSubTypesModel!.types[cubit.selectedSubType!].templates![index].photo! ,height: 120,
                                            width: 100,),
                                        ),
                                        const SizedBox(width: 10,),
                                      ]
                                  ),
                                );
                              }),
                            ),
                          );
                        }
                    ),
                  if(!cubit.uploadImageCheck)
                    const SizedBox(height: 20,),
                  if(!cubit.uploadImageCheck)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomInput(controller: cubit.desc,hint: "Add live descriptin Here".tr(), textInputType: TextInputType.text,maxLines: 10,maxLength: 200,
                          onChange: (v){
                            cubit.desc.text = v;
                            cubit.changeText(context);
                          },),
                      ],
                    ),
                  const SizedBox(height: 20,),
                  Container(
                      color: AppUI.whiteColor,
                      child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(text: "previous".tr(),color: AppUI.whiteColor,textColor: AppUI.buttonColor,borderColor: AppUI.buttonColor,onPressed: (){
                                          cubit.pageIndex = 0;
                                        },),
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child: CustomButton(text: "next".tr(),onPressed: (){
                                          if(!cubit.uploadImageCheck) {
                                            screenshotController
                                                .capture(delay: const Duration(
                                                milliseconds: 0))
                                                .then((capturedImage) async {
                                              late final Directory tempDir;
                                              if (Platform.isIOS) {
                                                tempDir =
                                                await getApplicationDocumentsDirectory();
                                              } else {
                                                tempDir =
                                                await getTemporaryDirectory();
                                              }
                                              cubit.eventPhoto = await File(
                                                  '${tempDir.path}/image.png')
                                                  .create();
                                              cubit.eventPhoto!.writeAsBytesSync(
                                                  capturedImage!);
                                              print('hvnhhhh ${cubit.eventPhoto!
                                                  .path}');
                                              cubit.pageIndex = 2;
                                            });
                                          }else {
                                            print('hvnhhhh ${cubit.eventPhotoUpload!
                                                .path}');
                                            cubit.pageIndex = 2;
                                          }

                                        },),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ])),
                ],
              );
            }
        ),
      ),
    );
  }
}