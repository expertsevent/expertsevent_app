import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/ui/app_ui.dart';
import '../../../../../core/ui/components.dart';
import 'dart:ui' as ui;
class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("${AppUI.imgPath}splash.png", height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,),
          Column(
            children: [
              customAppBar(
                  title: 'contactUs'.tr(), backgroundColor: Colors.transparent),
              const SizedBox(height: 20,),
              Expanded(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 60, bottom: 40, left: 16, right: 16),
                      child: CustomCard(
                        height: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 80,),
                            // CustomCard(
                            //   radius: 7,
                            //   child: InkWell(
                            //     onTap: ()  {
                            //       setState(() async {
                            //         final url = Uri.parse("tel:+966558247639");
                            //         if(await canLaunchUrl(url)){
                            //           await launchUrl(url);  //forceWebView is true now
                            //         }else {
                            //           throw 'Could not launch $url';
                            //         }
                            //       });
                            //     },
                            //     child: Row(
                            //       children: [
                            //         SvgPicture.asset("${AppUI.iconPath}call.svg"),
                            //         const SizedBox(width: 20,),
                            //         Column(
                            //           crossAxisAlignment: CrossAxisAlignment.start,
                            //           children: [
                            //             CustomText(text: "callUs".tr(),color: const Color(0xffFFA310),),
                            //             const SizedBox(height: 5,),
                            //             const CustomText(text: "00966551000079",color: AppUI.blackColor,),
                            //           ],
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            // ),

                            CustomCard(
                              radius: 7,
                              child: InkWell(
                                onTap: () {
                                  setState(() async {
                                    const url = "mailto:hello@expertsevent.com";
                                    if (await canLaunch(url)) {
                                      await launch(
                                          url); //forceWebView is true now
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  });
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: const Color(
                                            0xffB1FFDD),
                                        child: SvgPicture.asset(
                                            "${AppUI.iconPath}email2.svg")),
                                    const SizedBox(width: 20,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        CustomText(text: "email".tr(),
                                          color: Colors.green,),
                                        const SizedBox(height: 5,),
                                        const CustomText(
                                          text: "hello@expertsevent.com",
                                          color: AppUI.blackColor,)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),

                            CustomCard(
                              radius: 7,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    var url = Uri.parse(
                                        "whatsapp://send?phone=966559282199");
                                    launchUrl(url);
                                  });
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        "${AppUI.iconPath}whats.svg"),
                                    const SizedBox(width: 20,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        CustomText(text: "whatsapp".tr(),
                                          color: Colors.green.withOpacity(
                                              0.5),),
                                        const SizedBox(height: 5,),
                                        const Text("+966559282199"
                                            , style: TextStyle(
                                                color: AppUI.blackColor
                                            ),
                                            textDirection: ui.TextDirection
                                                .ltr),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // const SizedBox(height: 20,),
                            // CustomText(text: "ourSocialMedia".tr(),color: AppUI.bottomBarColor,),
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() async {
                                        const url = "https://twitter.com/expertsevent";
                                        if (await canLaunch(url)) {
                                          await launch(
                                              url); //forceWebView is true now
//forceWebView is true now
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      });
                                    },
                                    child: SvgPicture.asset(
                                      "${AppUI.iconPath}twitter.svg", width: 30,
                                      height: 30,)
                                ),
                                const SizedBox(width: 15,),
                                InkWell(
                                    onTap: () {
                                      setState(() async {
                                        const url = "https://web.facebook.com/expertsevent.sa";
                                        if (await canLaunch(url)) {
                                          await launch(
                                              url); //forceWebView is true now
//forceWebView is true now
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      });
                                    },
                                    child: SvgPicture.asset(
                                      "${AppUI.iconPath}face.svg", width: 30,
                                      height: 30,)
                                ),
                                const SizedBox(width: 15,),
                                InkWell(
                                    onTap: () {
                                      setState(() async {
                                        const url = "https://www.instagram.com/experts_event";
                                        if (await canLaunch(url)) {
                                          await launch(
                                              url); //forceWebView is true now
//forceWebView is true now
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      });
                                    },
                                    child: SvgPicture.asset(
                                      "${AppUI.iconPath}insta.svg", width: 30,
                                      height: 30,)
                                ),
                                const SizedBox(width: 20,),
                                InkWell(
                                    onTap: () {
                                      setState(() async {
                                        const url = "https://www.linkedin.com/company/experts-event/";
                                        if (await canLaunch(url)) {
                                          await launch(
                                              url); //forceWebView is true now
//forceWebView is true now
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      });
                                    },
                                    child: SvgPicture.asset(
                                      "${AppUI.iconPath}linkedin.svg",
                                      width: 30, height: 30,)
                                ),
                                const SizedBox(width: 15,),
                                InkWell(
                                    onTap: () {
                                      setState(() async {
                                        const url = "https://www.tiktok.com/@expertsevent";
                                        if (await canLaunch(url)) {
                                          await launch(
                                              url); //forceWebView is true now
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      });
                                    },
                                    child: SvgPicture.asset(
                                      "${AppUI.iconPath}tiktok.svg", width: 30,
                                      height: 30,)
                                ),
                                const SizedBox(width: 15,),
                                InkWell(
                                    onTap: () {
                                      setState(() async {
                                        const url = "https://www.snapchat.com/add/expertsevent";
                                        if (await canLaunch(url)) {
                                          await launch(
                                              url); //forceWebView is true now
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      });
                                    },
                                    child: SvgPicture.asset(
                                        "${AppUI.iconPath}snapchat.svg",
                                        width: 30,
                                        height: 30,
                                        color: Colors.yellow)
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}