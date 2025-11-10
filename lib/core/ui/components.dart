import 'dart:math';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/invitations/presentation/controller/invitations_cubit.dart';
import 'package:expert_events/invitations/presentation/controller/invitations_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

import '../../event/models/events_model.dart';
import '../../event/presentation/screens/details/event_details_screen.dart';
import '../../invitations/presentation/screens/invitation_details_screen.dart';
import '../../invitations/presentation/screens/qr_code_screen.dart';
import '../app_util.dart';
import 'app_ui.dart';

class GradientCircularProgressIndicator extends StatelessWidget {
  final double? radius;
  final List<Color>? gradientColors;
  final double strokeWidth;

  const GradientCircularProgressIndicator({
    Key? key,
    @required this.radius,
    @required this.gradientColors,
    this.strokeWidth = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromRadius(radius!),
      painter: GradientCircularProgressPainter(
        radius: radius!,
        gradientColors: gradientColors!,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class GradientCircularProgressPainter extends CustomPainter {
  GradientCircularProgressPainter({
    @required this.radius,
    @required this.gradientColors,
    @required this.strokeWidth,
  });
  final double? radius;
  final List<Color>? gradientColors;
  final double? strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    size = Size.fromRadius(radius!);
    double offset = strokeWidth! / 2;
    Rect rect = Offset(offset, offset) &
        Size(size.width - strokeWidth!, size.height - strokeWidth!);
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth!;
    paint.shader = SweepGradient(
            colors: gradientColors!, startAngle: 0.0, endAngle: 2 * pi)
        .createShader(rect);
    canvas.drawArc(rect, 0.0, 2 * pi, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

AppBar customAppBar(
    {required title,
    Widget? leading,
    List<Widget>? actions,
    int elevation = 0,
    Widget? bottomChild,
    Color? backgroundColor,
    bottomChildHeight,
    leadingWidth,
    toolbarHeight,
    textColor}) {
  return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    backgroundColor: backgroundColor ?? AppUI.whiteColor,
    elevation: double.parse(elevation.toString()),
    toolbarHeight: toolbarHeight,
    title: title is Widget
        ? title
        : CustomText(
            text: title,
            fontSize: 18.0,
            color: textColor ?? AppUI.blackColor,
            fontWeight: FontWeight.w500,
          ),
    centerTitle: true,
    leading: leading,
    // leadingWidth: leadingWidth??110,
    actions: actions,
    bottom: bottomChild == null
        ? null
        : PreferredSize(
            preferredSize: Size.fromHeight(bottomChildHeight ?? 120),
            child: bottomChild,
          ),
  );
}

class CustomAppBar extends StatelessWidget {
  final String title;
  final Widget? leading;
  const CustomAppBar({Key? key, required this.title, this.leading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
      ),
      child: Container(
        height: 110,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40)),
          color: AppUI.whiteColor,
        ),
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    !AppUtil.rtlDirection(context)
                        ? Icons.arrow_forward_ios
                        : Icons.arrow_back_ios,
                    color: AppUI.blackColor,
                    size: 19,
                  )),
              CustomText(
                text: title,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              leading ??
                  const SizedBox(
                    width: 20,
                  )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final TextAlign? textAlign;
  final FontWeight fontWeight;
  final Color? color;
  final TextDecoration? textDecoration;
  const CustomText(
      {Key? key,
      required this.text,
      this.fontSize = 14,
      this.textAlign,
      this.fontWeight = FontWeight.w400,
      this.color,
      this.textDecoration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ??
          (AppUtil.rtlDirection(context) ? TextAlign.right : TextAlign.left),
      style: TextStyle(
          color: color ?? AppUI.mainColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          decoration: textDecoration),
      textDirection: AppUtil.rtlDirection(context)
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
    );
  }
}

class CustomButton extends StatelessWidget {
  final Color? color;
  final int radius;
  final String text;
  final Color? textColor, borderColor;
  final Function()? onPressed;
  final double? width, height;
  final Widget? child;
  const CustomButton(
      {Key? key,
      required this.text,
      this.onPressed,
      this.color,
      this.borderColor,
      this.radius = 35,
      this.textColor = Colors.white,
      this.width,
      this.child,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
          height: height ?? 50,
          width: width ?? AppUtil.responsiveWidth(context) * 0.91,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(double.parse("$radius")),
              color: color ?? AppUI.buttonColor,
              border:
                  borderColor == null ? null : Border.all(color: borderColor!)),
          alignment: Alignment.center,
          child: child ??
              CustomText(
                text: text,
                fontSize: 16.0,
                fontWeight: FontWeight.w100,
                color: textColor,
              )),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Widget child;
  final double? height, width;
  final Color? color;
  final double? elevation, radius, padding;
  final Color? border;
  final Function()? onTap;
  const CustomCard(
      {Key? key,
      required this.child,
      this.height,
      this.width,
      this.color,
      this.elevation,
      this.border,
      this.onTap,
      this.radius,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 15)),
        elevation: elevation ?? 1,
        child: Container(
          padding: EdgeInsets.all(padding ?? 15),
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 15),
            border: border != null ? Border.all(color: border!) : null,
            color: color ?? AppUI.whiteColor,
          ),
          child: child,
        ),
      ),
    );
  }
}

class CustomInput extends StatelessWidget {
  final String? hint, lable;
  final TextEditingController controller;
  final TextInputType textInputType;
  final Function()? onTap;
  final Function(String v)? onChange, onSubmit;
  final bool obscureText, readOnly, autofocus, validation;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines, maxLength;
  final double radius;
  final TextAlign? textAlign;
  final Color? borderColor, fillColor;
  final List<TextInputFormatter> inputFormatters;
  const CustomInput(
      {Key? key,
      required this.controller,
      this.inputFormatters = const [],
      this.hint,
      this.onSubmit,
      this.lable,
      required this.textInputType,
      this.obscureText = false,
      this.prefixIcon,
      this.suffixIcon,
      this.onTap,
      this.onChange,
      this.maxLines,
      this.textAlign,
      this.readOnly = false,
      this.autofocus = false,
      this.radius = 25.0,
      this.maxLength,
      this.validation = true,
      this.borderColor,
      this.fillColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onTap: onTap,
      readOnly: readOnly,
      // maxLength: maxLength,
      keyboardType: textInputType,
      textAlign: textAlign != null
          ? textAlign!
          : AppUtil.rtlDirection(context)
              ? TextAlign.right
              : TextAlign.left,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      validator: validation
          ? (v) {
              if (v!.isEmpty) {
                return "fieldRequired".tr();
              }
              return null;
            }
          : null,
      autofocus: autofocus,
      maxLines: maxLines ?? 1,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppUI.disableColor),
        suffixIcon: suffixIcon,
        labelText: lable,
        // labelStyle: TextStyle(color: AppUI.disableColor),
        filled: true,
        fillColor: fillColor ?? AppUI.inputColor,
        suffixIconConstraints:
            suffixIcon == null ? null : const BoxConstraints(minWidth: 35),
        prefixIcon: prefixIcon,
        prefixIconConstraints: const BoxConstraints(minWidth: 50),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                bottomLeft: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
                topRight: Radius.circular(radius)),
            borderSide: BorderSide(color: borderColor ?? AppUI.inputColor)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                bottomLeft: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
                topRight: Radius.circular(radius)),
            borderSide: BorderSide(color: borderColor ?? AppUI.inputColor)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                bottomLeft: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
                topRight: Radius.circular(radius)),
            borderSide:
                BorderSide(color: borderColor ?? AppUI.inputColor, width: 0.5)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                bottomLeft: Radius.circular(radius),
                bottomRight: Radius.circular(radius)),
            borderSide: BorderSide(color: borderColor ?? AppUI.inputColor)),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class ErrorFetchWidget extends StatelessWidget {
  const ErrorFetchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomText(
        text: "errorFetch".tr(),
        fontSize: 18,
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  final String? text;
  const EmptyWidget({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomText(
        text: text ?? "noDataAvailable".tr(),
        fontSize: 18,
      ),
    );
  }
}

class InternetConnectionWidget extends StatelessWidget {
  const InternetConnectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomText(
        text: "checkYourInternetConnection".tr(),
        fontSize: 18,
      ),
    );
  }
}

class CustomDropDownMenu extends StatelessWidget {
  final Function()? onTapElement;
  final element;
  const CustomDropDownMenu({Key? key, this.onTapElement, this.element})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppUI.mainColor),
      ),
      constraints: const BoxConstraints(maxHeight: 140),
      child: ListView(
        shrinkWrap: true,
        children: List.generate(8, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: onTapElement,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: element ?? "الرياض"),
                  if (index != 7) const Divider()
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  final String type;
  const EventCard({Key? key, required this.event, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppUtil.mainNavigator(
            context, EventDetailsScreen(event: event, type: type)
        );
      },
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: event.photo,
            width: double.infinity,
            height: 182,
            placeholder: (context, url) => Image.asset(
              "${AppUI.imgPath}event.png",
              width: double.infinity,
              height: 182,
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => Image.asset(
                "${AppUI.imgPath}event.png",
                width: double.infinity,
                height: 182,
                fit: BoxFit.fill),
          ),
          Stack(
            alignment: AppUtil.rtlDirection(context)
                ? Alignment.topLeft
                : Alignment.topRight,
            children: [
              Container(
                height: 58,
                width: 50,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    color: AppUI.buttonColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text:
                          "${event.dateFrom.split('-')[2]}\n${event.dateFrom.split('-')[1] == "01" ? "Jen" : event.dateFrom.split('-')[1] == "02" ? "Feb" : event.dateFrom.split('-')[1] == "03" ? "Mar" : event.dateFrom.split('-')[1] == "04" ? "Apr" : event.dateFrom.split('-')[1] == "05" ? "May" : event.dateFrom.split('-')[1] == "06" ? "Jun" : event.dateFrom.split('-')[1] == "07" ? "Jul" : event.dateFrom.split('-')[1] == "08" ? "Aug" : event.dateFrom.split('-')[1] == "09" ? "Sep" : event.dateFrom.split('-')[1] == "10" ? "Oct" : event.dateFrom.split('-')[1] == "11" ? "Nov" : event.dateFrom.split('-')[1] == "12" ? "Dec" : ""}",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                      color: AppUI.whiteColor,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 110,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      CustomText(
                        text: event.name,
                        color: AppUI.blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: 300,
                        child: Text(
                          event.location,
                          style: const TextStyle(
                            color: AppUI.blackColor,
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      CustomText(
                        text: "${event.dateFrom} at ${event.timeFrom}",
                        color: AppUI.errorColor,
                        fontSize: 12,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          // Container(
                          //   height: 30,
                          //   alignment: Alignment.center,
                          //   child: ListView.builder(
                          //       scrollDirection: Axis.horizontal,
                          //       itemCount: 3,
                          //       shrinkWrap: true,
                          //       physics: const NeverScrollableScrollPhysics(),
                          //       itemBuilder: (context, index) {
                          //         return Align(
                          //           // heightFactor: 0.1,
                          //           widthFactor: 0.6,
                          //           alignment: Alignment.centerRight,
                          //           child: ClipRRect(
                          //             borderRadius:
                          //             BorderRadius.circular(12.5),
                          //             child: CachedNetworkImage(
                          //               imageUrl: "",
                          //               width: 20,
                          //               height: 20,
                          //               placeholder: (context, url) => Image.asset("${AppUI.imgPath}avatar2.png",height: 30,width: 30,fit: BoxFit.fill,),
                          //               errorWidget: (context, url, error) => Image.asset("${AppUI.imgPath}avatar2.png",height: 30,width: 30,fit: BoxFit.fill),
                          //             ),
                          //           ),
                          //         );
                          //       }),
                          // ),
                          const SizedBox(
                            width: 20,
                          ),
                          CustomText(
                            text:
                                "${event.acceptvisitorCount}/${event.countvisitor} ${"accepted".tr()}",
                            color: AppUI.secondColor,
                          ),
                          const Spacer(),
                          CustomButton(
                            text: type,
                            width: 110,
                            height: 35,
                            textColor: AppUI.secondColor,
                            color: AppUI.secondColor.withOpacity(0.16),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class InvitationCard extends StatelessWidget {
  final Event event;
  final bool? wait;
  final bool? isActive;
  const InvitationCard({Key? key, required this.event, this.wait,this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(isActive!){
          AppUtil.mainNavigator(
              context,  InvitationDetailsScreen(event: event)
          );
        }else{
          AppUtil.mainNavigator(
            context,
            Scaffold(
              appBar: customAppBar(title: event.name),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: event.photo,
                    width: double.infinity,
                    placeholder: (context, url) => Image.asset(
                      "${AppUI.imgPath}logo.png",
                      height: 124,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      "${AppUI.imgPath}logo.png",
                      height: 124,
                      width: double.infinity,
                      fit: BoxFit.fill
                    ),
                  ),
                ],
              ),
            )
          );
        }
      },
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: event.photo,
                  height: 124,
                  width: double.infinity,
                  placeholder: (context, url) => Image.asset(
                    "${AppUI.imgPath}logo.png",
                    height: 124,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                      "${AppUI.imgPath}logo.png",
                      height: 124,
                      width: double.infinity,
                      fit: BoxFit.fill),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0xffFFEFAE)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppUI.whiteColor,
                            child: CachedNetworkImage(
                              imageUrl: event.type.photo,
                              height: 20,
                              placeholder: (context, url) => SvgPicture.asset(
                                "${AppUI.iconPath}party.svg",
                                height: 20,
                                fit: BoxFit.fill,
                              ),
                              errorWidget: (context, url, error) =>
                                  SvgPicture.asset("${AppUI.iconPath}party.svg",
                                      height: 20, fit: BoxFit.fill),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomText(
                            text: event.type.name,
                            fontSize: 11,
                            color: const Color(0xffE3B800),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: AppUI.whiteColor,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  CustomText(
                    text: event.name,
                    color: AppUI.blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomText(
                    text: event.location,
                    color: AppUI.blackColor,
                    fontSize: 12,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  CustomText(
                    text:
                        "${event.dateFrom.split('-')[2]} ${event.dateFrom.split('-')[1] == "01" ? "Jen" : event.dateFrom.split('-')[1] == "02" ? "Feb" : event.dateFrom.split('-')[1] == "03" ? "Mar" : event.dateFrom.split('-')[1] == "04" ? "Apr" : event.dateFrom.split('-')[1] == "05" ? "May" : event.dateFrom.split('-')[1] == "06" ? "Jun" : event.dateFrom.split('-')[1] == "07" ? "Jul" : event.dateFrom.split('-')[1] == "08" ? "Aug" : event.dateFrom.split('-')[1] == "09" ? "Sep" : event.dateFrom.split('-')[1] == "10" ? "Oct" : event.dateFrom.split('-')[1] == "11" ? "Nov" : event.dateFrom.split('-')[1] == "12" ? "Dec" : ""} ${event.timeFrom}",
                    color: AppUI.errorColor,
                    fontSize: 12,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (wait != null && wait == true)
                    Row(
                      children: [
                        BlocBuilder<InvitationsCubit, InvitationsStates>(
                            buildWhen: (_, state) =>
                                state is AcceptLoadingState ||
                                state is AcceptLoadedState,
                            builder: (context, state) {
                              if (state is AcceptLoadingState) {
                                return const LoadingWidget();
                              }
                              return CustomButton(
                                text: "approve".tr(),
                                width: AppUtil.responsiveWidth(context) * 0.25,
                                height: 35,
                                textColor: AppUI.secondColor,
                                color: AppUI.secondColor.withOpacity(0.16),
                                onPressed: () {
                                  InvitationsCubit.get(context)
                                      .respond(context, event.id, "accept",
                                      eventName: event.name,
                                      eventDate : event.dateFrom,
                                      eventTime : event.timeFrom,
                                      eventLocation : event.location,
                                      eventContent :event.content);
                                },
                              );
                            }),
                        const SizedBox(
                          width: 7,
                        ),
                        BlocBuilder<InvitationsCubit, InvitationsStates>(
                            buildWhen: (_, state) =>
                                state is RejectLoadingState ||
                                state is RejectLoadedState,
                            builder: (context, state) {
                              if (state is RejectLoadingState) {
                                return const LoadingWidget();
                              }
                              return CustomButton(
                                text: "reject".tr(),
                                width: AppUtil.responsiveWidth(context) * 0.25,
                                height: 35,
                                textColor: AppUI.errorColor,
                                color: AppUI.whiteColor,
                                borderColor: AppUI.errorColor,
                                onPressed: () {
                                  InvitationsCubit.get(context)
                                      .respond(context, event.id, "reject");
                                },
                              );
                            }),
                      ],
                    )
                  else if (wait != null && wait == false)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              AppUtil.mainNavigator(
                                  context,
                                  QrCodeScreen(
                                    id: event.id.toString(),
                                  ));
                            },
                            icon: const Icon(Icons.qr_code)),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: () async {
                              String googleUrl =
                                  'https://www.google.com/maps/search/?api=1&query=${event.lat},${event.lang}';
                              if (await canLaunch(googleUrl)) {
                                await launch(googleUrl);
                              } else {
                                throw 'Could not open the map.';
                              }
                            },
                            icon: const Icon(Icons.person_pin_circle)),
                      ],
                    ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
