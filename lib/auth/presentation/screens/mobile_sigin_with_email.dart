import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/app_util.dart';
import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../../core/cash_helper.dart';
import '../controller/auth/auth_cubit.dart';
import '../controller/auth/auth_states.dart';
class MobileSignWithEmail extends StatefulWidget {
  const MobileSignWithEmail({Key? key}) : super(key: key);

  @override
  State<MobileSignWithEmail> createState() => _MobileSignWithEmailState();
}

class _MobileSignWithEmailState extends State<MobileSignWithEmail> {
  Country? _selectedCountry;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedCountry = Country(
      phoneCode: '+966',
      countryCode: 'SA',
      e164Sc: -1,
      geographic: false,
      level: -1,
      name: 'Saudi Arabia',
      example: '',
      displayName: 'World Wide (WW)',
      displayNameNoCountryCode: 'World Wide',
      e164Key: '',
    );
  }
  @override
  Widget build(BuildContext context) {
    var cubit = AuthCubit.get(context);
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customAppBar(title: "Verify Phone Number",backgroundColor: Colors.transparent,textColor: AppUI.mainColor),
                Column(
                  children: [
                    Image.asset("${AppUI.imgPath}forgot.png",height: AppUtil.responsiveHeight(context)*0.3,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomCard(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              CustomText(text: "Successfully login",fontWeight: FontWeight.bold,fontSize: 20,color: AppUI.mainColor,textAlign: TextAlign.center,),
                              const SizedBox(height: 10,),
                              CustomText(text: "Successfully login using your Email Account",fontSize: 16,color: AppUI.bottomBarColor,textAlign: TextAlign.center,),
                              const SizedBox(height: 10,),
                              CustomText(text: "Enter your phone number",fontSize: 16,color: AppUI.bottomBarColor,textAlign: TextAlign.center,),
                              const SizedBox(height: 40,),
                              CustomInput(controller: cubit.loginPhone,suffixIcon: SvgPicture.asset("${AppUI.iconPath}mobile.svg"),hint: "phoneNumber".tr(), textInputType: TextInputType.phone,prefixIcon: SizedBox(
                                width: 50,
                                child: InkWell(
                                  onTap: (){
                                    showCountryPicker(
                                      countryFilter: <String>['SA'],
                                      context: context,
                                      showPhoneCode: true,
                                      showSearch: false,
                                      countryListTheme: CountryListThemeData(
                                        flagSize: 25,
                                        backgroundColor: Colors.white,
                                        textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                                        bottomSheetHeight: 150, // Optional. Country list modal height
                                        //Optional. Sets the border radius for the bottomsheet.
                                        borderRadius: const BorderRadius.only(
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
                                        cubit.loginPhoneCode.text = _selectedCountry!.phoneCode;
                                        setState(() {
            
                                        });
                                        print('Select country: ${country}');
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
                              ),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                BlocBuilder<AuthCubit,AuthState>(
                    buildWhen: (_,state) => state is PhoneLoadingState || state is PhoneLoadedState,
                    builder: (context, state) {
                      if(state is PhoneLoadingState){
                        return const LoadingWidget();
                      }
                      return CustomButton(text: "next".tr(),onPressed: (){
                        cubit.forgetPass(context,type: "siginEmail");
                      },);
                    }
                ),
                const SizedBox(height: 15,),
                InkWell(
                  onTap: () {
                    AppUtil.dialog2(
                        context, 'تسجيل الخروج', [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30,right: 30),
                            child: Lottie.asset("${AppUI.imgPath}1717510460425.json",width: 100,height: 100),
                          ),
                          CustomText(
                            text: "هل ترغب في الخروج من التطبيق ؟",
                            color: AppUI.mainColor,
                            fontSize: 15,
                          ),
                          SizedBox(height: 25,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(width: 120,height: 40,text: "yes".tr(),
                                onPressed: (){
                                  CashHelper.logOut(context);
                                  Navigator.of(context,rootNavigator: true).pop();
                                },),
                              SizedBox(width: 10,),
                              CustomButton(width: 120,height: 40,text: "no".tr(),
                                onPressed: (){
                                  Navigator.of(context,rootNavigator: true).pop();                                },textColor: AppUI.mainColor,
                                borderColor:AppUI.mainColor ,
                                color: Colors.white,),
                            ],
                          )
                        ],
                      ),
                    ]);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("${AppUI.iconPath}logout.svg",color: AppUI.errorColor,),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomText(
                        text: "logout".tr(),
                        color: AppUI.errorColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15,),
            
              ],
            ),
          )
        ],
      ),
    );
  }
}
