import 'dart:io';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import '../../../add_event/presentation/controller/add_event_cubit.dart';
import '../../../core/app_util.dart';
import '../../../core/ui/app_ui.dart';
import '../../../core/ui/components.dart';
import '../../../intro/presentation/screens/on_boarding_screen4.dart';
import '../../../more/presentation/screens/pages/static_page/static_page.dart';
import '../controller/auth/auth_cubit.dart';
import '../controller/auth/auth_states.dart';
import 'forgot_pass/forgot_pass.dart';
import 'register_screen.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  ValueNotifier userCredential = ValueNotifier('');
  Country? _selectedCountry;
  late AppsflyerSdk _appsflyerSdk;
  Map _deepLinkData = {};
  Map _gcd = {};

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
    afStart();
  }

  void afStart() async {
    // SDK Options
    final AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: "HD7GQojLRGobHMFApdaSGZ",
        appId: Platform.isAndroid ? "com.expert_events.expert_events" : "id1661312796",
        showDebug: true,
        timeToWaitForATTUserAuthorization: 15,
        manualStart: true);
    _appsflyerSdk = AppsflyerSdk(options);

    // Init of AppsFlyer SDK
    await _appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);

    // Conversion data callback
    _appsflyerSdk.onInstallConversionData((res) {
      print("onInstallConversionData res: " + res.toString());
      // setState(() {
      _gcd = res;
      // });
    });

    // App open attribution callback
    _appsflyerSdk.onAppOpenAttribution((res) {
      print("onAppOpenAttribution res: " + res.toString());
      // setState(() {
      _deepLinkData = res;
      // });
    });

    // Deep linking callback
    _appsflyerSdk.onDeepLinking((DeepLinkResult dp) {
      switch (dp.status) {
        case Status.FOUND:
          print(dp.deepLink?.toString());
          print("deep link value: ${dp.deepLink?.deepLinkValue}");
          break;
        case Status.NOT_FOUND:
          print("deep link not found");
          break;
        case Status.ERROR:
          print("deep link error: ${dp.error}");
          break;
        case Status.PARSE_ERROR:
          print("deep link status parsing error");
          break;
      }
      print("onDeepLinking res: " + dp.toString());
      // setState(() {
      _deepLinkData = dp.toJson();
      // });
    });

    //_appsflyerSdk.anonymizeUser(true);
    if (Platform.isAndroid) {
      _appsflyerSdk.performOnDeepLinking();
    }
    // setState(() {}); // Call setState to rebuild the widget


    _appsflyerSdk.startSDK(
      onSuccess: () {
        print("AppsFlyer SDK initialized successfully.");
      },
      onError: (int errorCode, String errorMessage) {
        print("Error initializing AppsFlyer SDK: Code $errorCode - $errorMessage");
      },
    );
    final String eventName = "af_login";
    final Map eventValues = {
    };
    await _appsflyerSdk.logEvent(eventName, eventValues);
  }

  @override
  Widget build(BuildContext context) {
    var cubit = AuthCubit.get(context);
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
                CustomText(text: "signIn".tr(),fontSize: 22,fontWeight: FontWeight.bold,),
                const SizedBox(width: 30,)
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset("${AppUI.imgPath}logo.png",height: AppUtil.responsiveHeight(context)*0.3,),
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          CustomInput(controller: cubit.loginPhone,suffixIcon: SvgPicture.asset("${AppUI.iconPath}mobile.svg"),hint: "phoneNumber".tr(), textInputType: TextInputType.phone,prefixIcon: SizedBox(
                            width: 50,
                            child: InkWell(
                              onTap: (){
                                showCountryPicker(
                                  countryFilter: <String>['SA'],
                                  context: context,
                                  showSearch: false,
                                  showPhoneCode: true,
                                  countryListTheme: const CountryListThemeData(
                                    flagSize: 25,
                                    backgroundColor: Colors.white,
                                    textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                                    bottomSheetHeight: 160, // Optional. Country list modal height
                                    //Optional. Sets the border radius for the bottomsheet.
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                    ),
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
                          if (!AddEventCubit.get(context).iosD)
                            const SizedBox(height: 15,),
                          if (!AddEventCubit.get(context).iosD)
                             CustomInput(controller: cubit.loginPassword,suffixIcon: const Icon(Icons.lock,size: 20,),hint: "pass".tr(), textInputType: TextInputType.visiblePassword),
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
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                BlocBuilder<AuthCubit,AuthState>(
                                    buildWhen: (_,state) => state is LoginLoadingState || state is LoginLoadedState,
                                    builder: (context, state) {
                                      if(state is LoginLoadingState){
                                        return const LoadingWidget();
                                      }
                                        if (!AddEventCubit.get(context).iosD){
                                        return CustomButton(
                                          text: "signIn",
                                          onPressed: () {
                                            cubit.login(context);
                                          },);
                                      }else{
                                        return CustomButton(
                                          text: "signInWhatsapp".tr(),
                                          onPressed: () {
                                            cubit.login(context);
                                          },);
                                      }
                                    }
                                ),
                                //Start sign in with google and apple
                                const SizedBox(height: 10,),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     CustomText(text: "-------------------- ",color: AppUI.greyColor,),
                                //     CustomText(text: " or "),
                                //     CustomText(text: " -------------------- ",color: AppUI.greyColor,),
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
                                //       onTap: () async {
                                //         userCredential.value = await cubit.signInWithGoogle();
                                //         if (userCredential.value != null) {
                                //           print("User Data : ${userCredential.value.user!}");
                                //           //displayName | email | isEmailVerified | phoneNumber | photoURL
                                //           cubit.loginwithEmail(context,userCredential.value.user!.displayName ?? '',userCredential.value.user!.email ?? '',userCredential.value.user!.phoneNumber ?? 0);
                                //         }
                                //       },
                                //       child: Container(
                                //         padding: const EdgeInsets.symmetric(horizontal: 30),
                                //         height: 50,
                                //         decoration: BoxDecoration(
                                //           border: Border.all(color: AppUI.mainColor),
                                //           borderRadius: BorderRadius.all(Radius.circular(35)),
                                //         ),
                                //         child: Row(
                                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //           children: [
                                //             CustomText(text: "signIn with google",fontSize: 15,),
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
                                //     },
                                //   child: Container(
                                //     padding: const EdgeInsets.symmetric(horizontal: 40),
                                //     height: 50,
                                //     decoration: BoxDecoration(
                                //       color: AppUI.blackColor,
                                //       borderRadius: BorderRadius.all(Radius.circular(35)),
                                //     ),
                                //     child: Row(
                                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //       children: [
                                //         CustomText(text: "signIn with apple",fontSize: 15,color: AppUI.whiteColor,),
                                //         SizedBox(width: 10,),
                                //         SvgPicture.asset("${AppUI.iconPath}login-apple.svg",width: 30,height: 30,),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                //end sign in with google and apple
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25,),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
