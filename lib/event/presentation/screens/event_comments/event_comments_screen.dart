import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/event/models/comments_model.dart';
import 'package:expert_events/event/presentation/controller/events/events_cubit.dart';
import 'package:expert_events/event/presentation/controller/events/events_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/app_util.dart';
import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
class EventCommentsScreen extends StatefulWidget {
  final String id;
  const EventCommentsScreen({Key? key,required this.id}) : super(key: key);

  @override
  State<EventCommentsScreen> createState() => _EventCommentsScreenState();
}

class _EventCommentsScreenState extends State<EventCommentsScreen> {
  late final cubit = EventsCubit.get(context);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit.getComments(widget.id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
            children: [
              Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
              Column(
                children: [
                  customAppBar(title: "comments".tr()),
                  Expanded(
                    child: BlocBuilder<EventsCubit,EventsStates>(
                        buildWhen: (_,state) => state is CommentLoadingState || state is CommentEmptyState || state is CommentErrorState || state is CommentLoadedState,
                        builder: (context, state) {
                          if(state is CommentLoadingState){
                            return const LoadingWidget();
                          }
                          if(state is CommentEmptyState){
                            return const EmptyWidget();
                          }
                          if(state is CommentErrorState){
                            return const ErrorFetchWidget();
                          }

                          return ListView(
                          children: List.generate(cubit.comments!.data!.length, (index) {
                            return CustomCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // CachedNetworkImage(
                                      //   imageUrl: "",
                                      //   width: 40,
                                      //   height: 40,
                                      //   placeholder: (context, url) => Image.asset("${AppUI.imgPath}avatar.png",width: 40,height: 40,fit: BoxFit.fill,),
                                      //   errorWidget: (context, url, error) => Image.asset("${AppUI.imgPath}avatar.png",width: 40,height: 40,fit: BoxFit.fill),
                                      // ),
                                      const SizedBox(width: 10,),
                                      CustomText(text: cubit.comments!.data![index].user!.name!,color: AppUI.blackColor,fontWeight: FontWeight.bold,)
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: CustomText(text: cubit.comments!.data![index].comment!,fontSize: 16,color: AppUI.disableColor,),
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      SvgPicture.asset("${AppUI.iconPath}comment.svg",color: AppUI.mainColor,),
                                      const SizedBox(width: 5,),
                                      CustomText(text: "${cubit.comments!.data![index].replies!.length} comments"),
                                      const SizedBox(width: 30,),
                                      InkWell(
                                        onTap: (){
                                          if(cubit.comments!.data![index].userLike!){
                                            cubit.comments!.data![index].likes = (int.parse(cubit.comments!.data![index].likes??"0")-1).toString();
                                          }else{
                                            cubit.comments!.data![index].likes = (int.parse(cubit.comments!.data![index].likes??"0")+1).toString();
                                          }
                                          cubit.comments!.data![index].userLike = !cubit.comments!.data![index].userLike!;
                                          cubit.emit(CommentLoadedState());
                                          cubit.addLike(cubit.comments!.data![index].id);
                                        },
                                          child: Icon(cubit.comments!.data![index].userLike!? Icons.favorite : Icons.favorite_outline,color: cubit.comments!.data![index].userLike!?AppUI.errorColor:AppUI.mainColor,size: 18,)),
                                      CustomText(text: "${cubit.comments!.data![index].likes??0} likes"),
                                      const Spacer(),
                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                  CustomInput(controller: cubit.replyControllers[index], hint: "addComment".tr(), textInputType: TextInputType.text,suffixIcon: InkWell(
                                    onTap: () async {
                                      AppUtil.dialog2(context, '', [
                                        const LoadingWidget(),
                                        const SizedBox(height: 30,)
                                      ]);
                                      cubit.addComment(context, cubit.replyControllers[index].text, widget.id,id: cubit.comments!.data![index].id.toString());
                                    },
                                      child: CustomText(text: "reply".tr())),),
                                  const Divider(),
                                  ListView(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(0),
                                    physics: const NeverScrollableScrollPhysics(),
                                    children: List.generate(cubit.comments!.data![index].replies!.length, (index2) {
                                      return CustomCard(
                                        color: AppUI.inputColor,
                                        elevation: 0,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const SizedBox(width: 10,),
                                                CustomText(text: cubit.comments!.data![index].replies![index2].user!.name!,color: AppUI.blackColor,fontWeight: FontWeight.bold,)
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: CustomText(text: cubit.comments!.data![index].replies![index2].comment!,fontSize: 16,color: AppUI.disableColor,),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  )
                                ],
                              ),
                            );
                          }),
                        );
                      }
                    ),
                  )
                ],
              )
            ],
          ),
    );
  }
}
