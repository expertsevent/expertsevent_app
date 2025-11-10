import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/event/presentation/controller/events/events_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../controller/events/events_states.dart';

class PostponeEventScreen extends StatelessWidget {
  final int id;
  const PostponeEventScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = EventsCubit.get(context);
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "${AppUI.imgPath}splash.png",
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                customAppBar(
                    title: "postpone Event".tr(),
                    backgroundColor: Colors.transparent),
                CustomInput(
                  controller: cubit.reason,
                  hint: "reason".tr(),
                  textInputType: TextInputType.text,
                  maxLines: 5,
                  fillColor: AppUI.whiteColor,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomInput(
                  controller: cubit.dob,
                  hint: "date".tr(),
                  suffixIcon: const Icon(Icons.calendar_today_outlined),
                  readOnly: true,
                  textInputType: TextInputType.url,
                  fillColor: AppUI.whiteColor,
                  onTap: () {
                    cubit.selectDate(context);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomInput(
                  controller: cubit.time,
                  hint: "time".tr(),
                  suffixIcon: const Icon(Icons.access_time),
                  readOnly: true,
                  textInputType: TextInputType.url,
                  fillColor: AppUI.whiteColor,
                  onTap: () {
                    cubit.selectTime(context);
                  },
                ),
                const Spacer(),
                BlocBuilder<EventsCubit, EventsStates>(
                    buildWhen: (_, state) =>
                        state is CancelEventLoadingSate ||
                        state is CancelEventLoadedSate,
                    builder: (context, state) {
                      if (state is CancelEventLoadingSate) {
                        return const LoadingWidget();
                      }
                      return CustomButton(
                        text: 'Postpone'.tr(),
                        onPressed: () {
                          cubit.cancelEvent(context, id.toString(), 'postpone');
                        },
                      );
                    })
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //   child: SizedBox(
                //     height: AppUtil.responsiveHeight(context)*0.99,
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.all(16.0),
                //           child: Column(
                //             children: [
                //               Row(
                //                 children: [
                //                   CustomText(text: "contacts".tr(),color: AppUI.blackColor,fontSize: 17,fontWeight: FontWeight.bold,),
                //                   const Spacer(),
                //                   InkWell(
                //                       onTap: (){
                //                         AppUtil.dialog2(context, 'addGuest'.tr(), [
                //                           CustomInput(controller: TextEditingController(), hint: "name".tr(), textInputType: TextInputType.text),
                //                           const SizedBox(height: 10,),
                //                           CustomInput(controller: TextEditingController(), hint: "phoneNumber".tr(), textInputType: TextInputType.phone),
                //                           const SizedBox(height: 20,),
                //                           Row(
                //                             children: [
                //                               Expanded(
                //                                 child: CustomButton(text: "save".tr(),onPressed: (){
                //                                   Navigator.of(context,rootNavigator: true).pop();
                //                                 },),
                //                               ),
                //                               const SizedBox(width: 10,),
                //                               Expanded(
                //                                 child: CustomButton(text: "cancel".tr(),color: AppUI.whiteColor,textColor: AppUI.buttonColor,borderColor: AppUI.buttonColor,onPressed: (){
                //                                   Navigator.of(context,rootNavigator: true).pop();
                //                                 },),
                //                               ),
                //                             ],
                //                           )
                //                         ]);
                //                       },
                //                       child: SvgPicture.asset("${AppUI.iconPath}add.svg"))
                //                 ],
                //               ),
                //               const SizedBox(height: 20,),
                //               SizedBox(height: 40,child: CustomInput(controller: TextEditingController(), hint: "search".tr(), borderColor: AppUI.secondColor, textInputType: TextInputType.text,prefixIcon: IconButton(onPressed: (){}, icon: const Icon(Icons.search,color: AppUI.secondColor,)),)),
                //               const SizedBox(height: 20,),
                //               Row(
                //                 children: [
                //                   CustomText(text: "2/300 ${"selected".tr()}",fontWeight: FontWeight.bold,),
                //                   const Spacer(),
                //                   Row(
                //                     children: [
                //                       CustomText(text: "selectAll".tr(),color: AppUI.secondColor,fontWeight: FontWeight.bold,),
                //                       const SizedBox(width: 30,),
                //                       CustomText(text: "clear".tr(),color: AppUI.errorColor,fontWeight: FontWeight.bold,),
                //                     ],
                //                   ),
                //                 ],
                //               )
                //             ],
                //           ),
                //         ),
                //         Container(height: 5,color: AppUI.backgroundColor,width: double.infinity,),
                //         Expanded(
                //           child: Padding(
                //             padding: const EdgeInsets.all(16.0),
                //             child: ListView(
                //               shrinkWrap: true,
                //               children: List.generate(22, (index) {
                //                 return Column(
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     Row(
                //                       children: [
                //                         CachedNetworkImage(
                //                           imageUrl: "",
                //                           width: 40,
                //                           height: 40,
                //                           placeholder: (context, url) => Image.asset("${AppUI.imgPath}logo.png",width: 40,height: 40,fit: BoxFit.fill,),
                //                           errorWidget: (context, url, error) => Image.asset("${AppUI.imgPath}logo.png",width: 40,height: 40,fit: BoxFit.fill),
                //                         ),
                //                         const SizedBox(width: 10,),
                //                         Column(
                //                           crossAxisAlignment: CrossAxisAlignment.start,
                //                           children: const [
                //                             CustomText(text: "Mohamed Elsamman",color: AppUI.blackColor,fontWeight: FontWeight.bold,),
                //                             SizedBox(height: 5,),
                //                             CustomText(text: "01123344543",color: AppUI.blackColor,),
                //                           ],
                //                         ),
                //                         const Spacer(),
                //                         Checkbox(value: false, onChanged: (v){
                //
                //                         })
                //                       ],
                //                     ),
                //                     const Divider()
                //                   ],
                //                 );
                //               }),
                //             ),
                //           ),
                //         ),
                //         CustomButton(text: "postPone".tr()),
                //         const SizedBox(height: 20,),
                //         CustomButton(text: "delete".tr(),color: AppUI.errorColor,),
                //       ],
                //     ),
                //   ),
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}
