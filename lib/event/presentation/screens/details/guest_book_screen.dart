import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui' as ui;

import '../../../../core/app_util.dart';
import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../controller/events/events_cubit.dart';
import '../../controller/events/events_states.dart';

class GreetingsPage extends StatefulWidget {
  final String id;
  GreetingsPage({ Key? key,required this.id}) : super(key: key);

  @override
  _GreetingsPageState createState() => _GreetingsPageState();
}

class _GreetingsPageState extends State<GreetingsPage> {
  late final cubit = EventsCubit.get(context);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit.getGreetings(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  title: 'greetings_book'.tr(),
                  backgroundColor: Colors.transparent,
                  actions: [
                    InkWell(
                        onTap: (){
                          var greetingController = TextEditingController();
                          AppUtil.dialog2(context, 'addGreeting'.tr(), [
                            CustomInput(controller: greetingController, textInputType: TextInputType.text,
                            hint: 'addGreeting'.tr(),maxLines: 4,),
                            const SizedBox(height: 20,),
                            BlocBuilder<EventsCubit,EventsStates>(
                                buildWhen: (_,state) => state is AddGreetingLoadingState || state is AddGreetingLoadedState,
                                builder: (context, state) {
                                  if(state is AddGreetingLoadingState){
                                    return const LoadingWidget();
                                  }
                                  return CustomButton(text: 'addGreeting'.tr(),onPressed: (){
                                    cubit.addGreetings(context,greetingController.text, id: widget.id.toString());
                                  },);
                                }
                            )
                          ]);
                        },
                        child: SvgPicture.asset("${AppUI.iconPath}add.svg")
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ]),
              Expanded(
                child : BlocBuilder<EventsCubit,EventsStates>(
                    buildWhen: (_,state) => state is GreetingsLoadingState || state is GreetingsLoadedState || state is GreetingsEmptyState || state is GreetingsErrorState,
                    builder: (context, state) {
                      if(state is GreetingsLoadingState){
                        return const LoadingWidget();
                      }
                      if(state is GreetingsEmptyState){
                        return const EmptyWidget();
                      }
                      if(state is GreetingsErrorState){
                        return const ErrorFetchWidget();
                      }
                    return ListView.builder(
                      padding: const EdgeInsets.all(30.0),
                      itemCount: cubit.greetingsModel!.data!.length,
                      itemBuilder: (context, index) {
                        return GreetingCard(
                          photo: cubit.greetingsModel!.data![index].userPhoto ?? "${AppUI.imgPathNet}images/logoevent.png",
                          name:cubit.greetingsModel!.data![index].userName,
                          date:cubit.greetingsModel!.data![index].createdAt,
                          comment:cubit.greetingsModel!.data![index].comment,);
                      },
                    );
                  }
                ),
              ),
            ],
          ),
      ],
      ),
    );
  }
}

class GreetingCard extends StatelessWidget {
  final String? photo;
  final String? name;
  final String? date;
  final String? comment;

  GreetingCard(
      {required this.photo, required this.name, required this.date, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Add a Container with fixed height to the Stack so it can be laid out
              Container(
                height: 40,
                // Give it enough height for the image to fit inside and outside
                child: Stack(
                  clipBehavior: Clip.none, // Allow the image to overflow
                  children: [
                    // The image (half inside, half outside the card)
                    Positioned(
                      top: -40, // Pull the image upwards
                      left: MediaQuery
                          .of(context)
                          .size
                          .width / 2 - 80, // Center the image
                      child: CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(photo!),
                      ),
                    ),
                  ],
                ),
              ),
              // Display the message text
              Text(
                comment!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 8),
              // Display the sender's name in teal color
              Text(
                name!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              // Display the date in grey color
              Text(
                date!,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        )
      ],
    );
  }
}
