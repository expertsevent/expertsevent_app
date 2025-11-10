import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/ui/app_ui.dart';
import '../../../../../../core/ui/components.dart';
class AllVisitorsTap extends StatelessWidget {
  const AllVisitorsTap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: List.generate(4, (index) {
          return Column(
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
                    children: const [
                      CustomText(text: "Mohamed Elsamman",color: AppUI.blackColor,fontWeight: FontWeight.bold,),
                      SizedBox(height: 5,),
                      CustomText(text: "01123344543",color: AppUI.blackColor,),
                    ],
                  ),
                ],
              ),
              const Divider()
            ],
          );
        }),
      ),
    );
  }
}
