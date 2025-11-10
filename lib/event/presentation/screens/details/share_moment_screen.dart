import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../controller/events/events_cubit.dart';
import '../../controller/events/events_states.dart';
 class ShareMomentScreen extends StatefulWidget {
   final String id;
   const ShareMomentScreen({Key? key, required this.id}) : super(key: key);
 
   @override
   State<ShareMomentScreen> createState() => _ShareMomentScreenState();
 }
 
 class _ShareMomentScreenState extends State<ShareMomentScreen> {
   late final cubit = EventsCubit.get(context);
   @override
   void initState() {
     // TODO: implement initState
     super.initState();
     cubit.getMoments(widget.id);
   }
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       body: Stack(
               children:[
                 Image.asset(
                   "${AppUI.imgPath}splash.png", height: double.infinity,
                   width: double.infinity,
                   fit: BoxFit.fill,),
                 Column(
                 children:[
                   customAppBar(title: "Share your Moment".tr()),
                   BlocBuilder<EventsCubit, EventsStates>(
                       buildWhen: (_, state) =>
                       state is MomentsLoadingState || state is MomentsEmptyState ||
                           state is MomentsErrorState || state is MomentsLoadedState,
                       builder: (context, state) {
                         if (state is MomentsLoadingState) {
                           return const LoadingWidget();
                         }
                         if (state is MomentsEmptyState) {
                           return const EmptyWidget();
                         }
                         if (state is MomentsErrorState) {
                           return const ErrorFetchWidget();
                         }
                       return Expanded(
                         child: GridView.builder(
                           itemCount: cubit.momentModel!.data.length,
                           padding: const EdgeInsets.all(10),
                           gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                             maxCrossAxisExtent: 200,
                             childAspectRatio: 7 / 8,
                             mainAxisSpacing: 15,
                             crossAxisSpacing: 10,
                           ),
                           itemBuilder: (context,index) =>
                           Column(
                             children: [
                               CustomCard(
                                   elevation: 1,
                                   padding: 0,
                                   radius: 15,
                                   height: 210,
                                   child: Column(
                                       children: [
                                         const SizedBox(height: 5,),
                                       Row(
                                         children: [
                                           CachedNetworkImage(
                                             imageUrl: "",
                                             width: 25,
                                             height: 25,
                                             placeholder: (context, url) => Image.asset("${AppUI.imgPath}avatar.png",width: 40,height: 40,fit: BoxFit.fill,),
                                             errorWidget: (context, url, error) => Image.asset("${AppUI.imgPath}avatar.png",width: 40,height: 40,fit: BoxFit.fill),
                                           ),
                                           const SizedBox(width: 10,),
                                           CustomText(
                                             text: cubit.momentModel!.data[index].username,
                                             fontSize: 18,
                                             fontWeight: FontWeight.bold,
                                             color: AppUI.blackColor,
                                           ),
                                         ],
                                       ),
                                         const SizedBox(height: 5,),
                                         Image.network(cubit.momentModel!.data[index].photo,height: 160,fit: BoxFit.cover,),
                                      ],
                                   ),
                               ),
                             ],
                           ),
                         ),
                       );
                     }
                   ),
                 ],
             ),
              ],
             ),
     );
   }
 }