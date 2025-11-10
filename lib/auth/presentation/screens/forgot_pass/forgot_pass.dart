import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/app_util.dart';
import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../controller/auth/auth_cubit.dart';
import '../../controller/auth/auth_states.dart';
class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
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
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customAppBar(title: "forgetPass".tr(),backgroundColor: Colors.transparent),
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
                            CustomText(text: "Enter your phone number to reset password".tr(),fontSize: 16,color: AppUI.bottomBarColor,textAlign: TextAlign.center,),
                            const SizedBox(height: 40,),
                            CustomInput(controller: cubit.loginPhone,suffixIcon: SvgPicture.asset("${AppUI.iconPath}mobile.svg"),hint: "phoneNumber".tr(), textInputType: TextInputType.phone,prefixIcon: SizedBox(
                              width: 50,
                              child: InkWell(
                                onTap: (){
                                  showCountryPicker(
                                    countryFilter: <String>['SA','EG','AE'],
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
                    cubit.forgetPass(context);
                  },);
                }
              ),
              const SizedBox()

            ],
          )
        ],
      ),
    );
  }
}
