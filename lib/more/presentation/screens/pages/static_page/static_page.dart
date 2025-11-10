import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/more/presentation/controller/more_cubit.dart';
import 'package:expert_events/more/presentation/controller/more_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/app_ui.dart';
import '../../../../../core/ui/components.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class StaticPage extends StatelessWidget {
  final String title;
  const StaticPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = MoreCubit.get(context);
    cubit.staticPage(title);
    return Scaffold(
        backgroundColor: AppUI.whiteColor,
        appBar: customAppBar(
            title: title == "terms" ? "terms".tr() : title.tr(),
            backgroundColor: AppUI.mainColor,
            textColor: AppUI.whiteColor),
        body: Container(
          color: AppUI.whiteColor,
          child: BlocBuilder<MoreCubit, MoreStates>(
              buildWhen: (_, state) =>
                  state is StaticPageLoadingState ||
                  state is StaticPageLoadedState,
              builder: (context, state) {
                if (state is StaticPageLoadingState) {
                  return const LoadingWidget();
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // CustomText(text: about,color: AppUI.secondColor,),
                        HtmlWidget(cubit.content),
                        const SizedBox(
                          height: 10,
                        ),
                        title == 'aboutUs'
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: title.tr(),
                                    fontSize: 16,
                                    color: AppUI.mainColor,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomText(
                                    text: "aboutUsDescription".tr(),
                                    fontSize: 16,
                                    color: AppUI.blackColor,
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  CustomText(
                                    text: "aboutCompanyTitle".tr(),
                                    fontSize: 16,
                                    color: AppUI.mainColor,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomText(
                                    text: "aboutCompanyDescription".tr(),
                                    fontSize: 16,
                                    color: AppUI.blackColor,
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                );
              }),
        ));
  }
}
