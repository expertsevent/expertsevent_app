import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../auth/presentation/controller/auth/auth_cubit.dart';
import '../../../../../auth/presentation/controller/auth/auth_states.dart';
import '../../../../../core/ui/app_ui.dart';
import '../../../../../core/ui/components.dart';
import '../../../controller/more_cubit.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
    final cubit = MoreCubit.get(context);
    final authCubit = AuthCubit.get(context);
    return Scaffold(
      key: authCubit.scaffoldKey,
      body: Stack(
        children: [
          Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
          Column(
            children: [
              customAppBar(title: "editProfile".tr(),backgroundColor: Colors.transparent),
              const SizedBox(height: 20,),
              BlocBuilder<AuthCubit,AuthState>(
                buildWhen: (_,state) => state is ProfileLoadingState || state is ProfileLoadedState || state is ProfileErrorState,
                builder: (context, state) {
                  if(state is ProfileLoadingState){
                    return const LoadingWidget();
                  }
                  if(state is ProfileErrorState){
                    return const ErrorFetchWidget();
                  }
                  authCubit.editProfileName.text  = authCubit.profileModel!.data!.name!;
                  authCubit.editProfilephone.text  = authCubit.profileModel!.data!.phone!;
                  authCubit.birthDate.text  = authCubit.profileModel!.data!.birthdate!;

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        BlocBuilder<AuthCubit, AuthState>(
                            buildWhen: (_,state) => state is UserPhotoChangeState,
                            builder: (context, state) {
                            return Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                authCubit.userPhoto == null ?
                                CachedNetworkImage(
                                  imageUrl: authCubit.profileModel!.data!.photo.toString(),
                                  width: 112,
                                  height: 112,
                                  placeholder: (context, url) =>  Image.asset("${AppUI.imgPath}avatar.png" ,width: 112,height: 112,fit: BoxFit.fill,),
                                  errorWidget: (context, url, error) => Image.asset("${AppUI.imgPath}avatar.png",width: 112,height: 112,fit: BoxFit.fill),
                                ) : Image.file(File(authCubit.userPhoto!.path),
                                    width: 112,
                                    height: 112,
                                  fit: BoxFit.fill),
                                InkWell(
                                  onTap: () async {
                                    authCubit.chooseImageDialog(authCubit.scaffoldKey.currentContext!);
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: AppUI.whiteColor,
                                    child: Icon(Icons.camera_alt),
                                  ),
                                )
                              ],
                            );
                          }
                        ),
                        const SizedBox(height: 20,),
                        CustomInput(controller: authCubit.editProfileName,hint: "fullName".tr(), textInputType: TextInputType.name),
                        const SizedBox(height: 15,),
                        CustomInput(controller: authCubit.birthDate, hint: "birthDate".tr(), textInputType: TextInputType.name,suffixIcon: const Icon(Icons.calendar_month,color: AppUI.mainColor,),readOnly: true,onTap: (){
                          authCubit.pickData(context);
                        },),
                        const SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: (){
                                authCubit.genderMaleCheck = 1;
                                authCubit.genderFemaleCheck = 2;
                                authCubit.gender = "male";
                                print(authCubit.gender);
                              },
                              child: CustomCard(
                                elevation: 0,
                                color: AppUI.inputColor,
                                padding: 15,
                                child: Row(
                                  children: [
                                    BlocBuilder<AuthCubit,AuthState>(
                                        buildWhen: (_,state) => state is GenderCheckChangeState,
                                        builder: (context, state) {
                                          return SizedBox(
                                            height: 20,width: 23,
                                            child: Radio(value:  authCubit.genderMaleCheck,groupValue: 1, onChanged: (v){
                                              authCubit.genderMaleCheck = 1;
                                              authCubit.genderFemaleCheck = 2;
                                              authCubit.gender = "male";
                                              print(authCubit.gender);
                                            }),
                                          );
                                        }
                                    ),
                                    const SizedBox(width: 15,),
                                    CustomText(text: "Male".tr(),color: AppUI.greyColor,fontSize: 16,textAlign: TextAlign.center,)
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                authCubit.genderMaleCheck = 2;
                                authCubit.genderFemaleCheck = 1;
                                authCubit.gender = "female";
                                print(authCubit.gender);
                              },
                              child: CustomCard(
                                elevation: 0,
                                color: AppUI.inputColor,
                                padding: 15,
                                child: Row(
                                  children: [
                                    BlocBuilder<AuthCubit,AuthState>(
                                        buildWhen: (_,state) => state is GenderCheckChangeState,
                                        builder: (context, state) {
                                          return SizedBox(
                                            height: 20,width: 23,
                                            child: Radio(value: authCubit.genderFemaleCheck,groupValue: 1, onChanged: (v){
                                              authCubit.genderMaleCheck = 2;
                                              authCubit.genderFemaleCheck = 1;
                                              authCubit.gender = "female";
                                              print(authCubit.gender);
                                            }),
                                          );
                                        }
                                    ),
                                    const SizedBox(width: 15,),
                                    CustomText(text: "Female".tr(),color: AppUI.greyColor,fontSize: 16,textAlign: TextAlign.center,)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15,),
                        CustomInput(controller: authCubit.editProfilephone,hint: "phoneNumber".tr(), textInputType: TextInputType.phone,readOnly: true,),
                      ],
                    ),
                  );
                }
              ),
              const Spacer(),
              BlocBuilder<AuthCubit,AuthState>(
                  buildWhen: (_,state) => state is EditProfileLoadingState || state is EditProfileLoadedState,
                  builder: (context, state) {
                    if(state is EditProfileLoadingState){
                      return const LoadingWidget();
                    }
                    return CustomButton(text: 'submit'.tr(),onPressed: (){
                      authCubit.editProfile(context);
                  },);
                }
              ),
              const SizedBox(height: 25,),
            ],
          )
        ],
      ),
    );
  }
}
