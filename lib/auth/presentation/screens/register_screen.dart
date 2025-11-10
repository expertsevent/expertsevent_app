import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/app_util.dart';
import '../../../core/ui/app_ui.dart';
import '../../../core/ui/components.dart';
import '../../../intro/presentation/screens/on_boarding_screen4.dart';
import '../../../more/presentation/screens/pages/static_page/static_page.dart';
import '../controller/auth/auth_cubit.dart';
import '../controller/auth/auth_states.dart';
import 'sign_in_screen.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  ValueNotifier userCredential = ValueNotifier('');
  Country? _selectedCountry = Country(
    phoneCode: '966',
    countryCode: 'SA',
    e164Sc: -1,
    geographic: false,
    level: -1,
    name: 'World Wide',
    example: '',
    displayName: 'World Wide (WW)',
    displayNameNoCountryCode: 'World Wide',
    e164Key: '',
  );

  @override
  Widget build(BuildContext context) {
    final cubit = AuthCubit.get(context);
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: MediaQuery.of(context).padding.top),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: AppUI.whiteColor,
                  child: IconButton(onPressed: (){
                    AppUtil.removeUntilNavigator(context, const OnBoardingScreen4());
                  }, icon: const Icon(Icons.arrow_back,color: AppUI.greyColor,)),
                ),
                CustomText(text: "signUp".tr(),fontSize: 22,fontWeight: FontWeight.bold,),
                const SizedBox(width: 30,)
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomCard(
                height: AppUtil.responsiveHeight(context)*0.8,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                     CircleAvatar(
                       radius: 46,
                       backgroundColor: AppUI.inputColor,
                       //child: Icon(Icons.camera_alt,color: AppUI.blackColor,size: 40,),
                       child : Image.asset("${AppUI.imgPath}logo.png",height: AppUtil.responsiveHeight(context)*0.3,),
                      ),
                      const SizedBox(height: 20,),
                      CustomInput(controller: cubit.registerName,hint: "fullName".tr(), textInputType: TextInputType.name),
                      const SizedBox(height: 15,),
                      CustomInput(controller:cubit.registerPhone,hint: "phoneNumber".tr(), textInputType: TextInputType.phone,prefixIcon: SizedBox(
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
                                bottomSheetHeight: 160, // Optional. Country list modal height
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
                                cubit.registerPhoneCode.text = _selectedCountry!.phoneCode;
                                setState(() {
                                });
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
                      //const SizedBox(height: 15,),
                      //CustomInput(controller: cubit.referralCode,hint: "Add referral code here", textInputType: TextInputType.text),
                      const SizedBox(height: 30,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<AuthCubit,AuthState>(
                            buildWhen: (_,state) => state is PrivacyCheckChangeState,
                            builder: (context, state) {
                              return SizedBox(
                                height: 20,width: 23,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Checkbox(value: cubit.privacyCheck, onChanged: (v){
                                    cubit.privacyCheck = v!;
                                  }),
                                ),
                              );
                            }
                          ),
                          const SizedBox(width: 15,),
                          Expanded(child: InkWell(
                            onTap: (){
                              AppUtil.mainNavigator(context, const StaticPage(title: 'terms'));
                            },
                              child: CustomText(text: "By creating an account you agree to our Terms of Service and Privacy Policy".tr(),color: AppUI.greyColor,fontSize: 16,textAlign: TextAlign.center,textDecoration: TextDecoration.underline,)))
                        ],
                      ),
                      const SizedBox(height: 15,),
                      BlocBuilder<AuthCubit,AuthState>(
                          buildWhen: (_,state) => state is RegisterLoadingState || state is RegisterLoadedState,
                          builder: (context, state) {
                            if(state is RegisterLoadingState){
                              return const LoadingWidget();
                            }
                            return CustomButton(text: "signUp".tr(),onPressed: (){
                            cubit.register(context);
                          },);
                        }
                      ),
                      //Start sign up with google and apple
                      SizedBox(height: 20,),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     CustomText(text: "------------------------ ",color: AppUI.greyColor,),
                      //     CustomText(text: " or "),
                      //     CustomText(text: " ----------------------- ",color: AppUI.greyColor,),
                      //
                      //   ],
                      // ),
                      // if (!Platform.isIOS)
                      // const SizedBox(height: 10,),
                      // if (!Platform.isIOS)
                      // BlocBuilder<AuthCubit,AuthState>(
                      //     buildWhen: (_,state) => state is LoginemailLoadingState || state is LoginemailLoadedState,
                      //     builder: (context, state) {
                      //       if(state is LoginemailLoadingState){
                      //         return const LoadingWidget();
                      //       }
                      //     return InkWell(
                      //       onTap: () async{
                      //         userCredential.value = await cubit.signInWithGoogle();
                      //         if (userCredential.value != null)
                      //           print("User Data : ${userCredential.value.user!}");
                      //         //displayName | email | isEmailVerified | phoneNumber | photoURL
                      //         cubit.loginwithEmail(context,userCredential.value.user!.displayName ?? '',userCredential.value.user!.email ?? '',userCredential.value.user!.phoneNumber ?? 0);
                      //       },
                      //       child: Container(
                      //         padding: const EdgeInsets.symmetric(horizontal: 50),
                      //         height: 50,
                      //         decoration: BoxDecoration(
                      //           border: Border.all(color: AppUI.mainColor),
                      //           borderRadius: BorderRadius.all(Radius.circular(35)),
                      //         ),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             CustomText(text: "signUp with google",fontSize: 15,),
                      //             SizedBox(width: 10,),
                      //             Image.asset("${AppUI.imgPath}login-google.png",width: 25,height: 25,),
                      //           ],
                      //         ),
                      //       ),
                      //     );
                      //   }
                      // ),
                      // if (Platform.isIOS)
                      // const SizedBox(height: 10,),
                      // if (Platform.isIOS)
                      // InkWell(
                      //   onTap: () async {
                      //     final credential = await SignInWithApple.getAppleIDCredential(
                      //       scopes: [
                      //         AppleIDAuthorizationScopes.email,
                      //         AppleIDAuthorizationScopes.fullName,
                      //       ],
                      //     );
                      //     cubit.loginwithEmail(context, credential.givenName ?? "", credential.email ?? "", 0);
                      //   },
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(horizontal: 50),
                      //     height: 50,
                      //     decoration: BoxDecoration(
                      //       color: AppUI.blackColor,
                      //       borderRadius: BorderRadius.all(Radius.circular(35)),
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         CustomText(text: "signUp with apple",fontSize: 15,color: AppUI.whiteColor,),
                      //         SizedBox(width: 10,),
                      //         SvgPicture.asset("${AppUI.iconPath}login-apple.svg",width: 30,height: 30,),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      //End sign up with google and apple
                      const SizedBox(height: 25,),
                      InkWell(
                        onTap: (){
                          AppUtil.mainNavigator(context, const SignInScreen());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(text: 'haveAnAccount'.tr(),color: AppUI.greyColor,fontSize: 16,),
                            const SizedBox(width: 10,),
                            CustomText(text: 'signIn'.tr(),fontSize: 16,fontWeight: FontWeight.bold,),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25,),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
