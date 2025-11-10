import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/core/app_util.dart';
import 'package:expert_events/more/presentation/controller/wallet/wallet_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../layout/presentation/screens/layout_screen.dart';
import '../../../data/wallet_repository.dart';
import '../../../models/package_model.dart';
import '../../../models/wallet_model.dart';
import '../../screens/pages/packages/hyperpay_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class WalletCubit extends Cubit<WalletStates>{
  WalletCubit(): super(PackageInitState());
  static WalletCubit get(context) => BlocProvider.of(context);
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var email = TextEditingController();
  var phone = TextEditingController();
  var _paymentBrand = "VISA MASTER";
  get paymentBrand => _paymentBrand;
  set paymentBrand(value) {
    _paymentBrand = value;
    emit(PaymentBrandChangeState());
  }
  String walletView = '';


  String endPoint = '';
  PackageModel? packageModel;

  getPackages() async {
    emit(PackageLoadingState());
    try{
      Map<String,dynamic> response = await WalletRepository.getPackages();
      packageModel = PackageModel.fromJson(response);
      if(packageModel!.data!.isEmpty){
        emit(PackageEmptyState());
      }else {
        emit(PackageLoadedState());
      }
    }catch(e){
      emit(PackageErrorState());
      print(e.toString());
      return Future.error(e);
    }
  }

  pay(context,{price = 0,packageId = 0,numVisitors = 0,is_Change = "no"}) async {
    if (phone == null || phone.text.isEmpty) {
      AppUtil.errorToast(context, 'Phone is required'.tr());
      return ;
    }else if(email.text.isEmpty){
      AppUtil.errorToast(context, 'Email is required'.tr());
      return ;
    }

    final RegExp saudiPhoneReg = RegExp(r'^05\d{8}$');

    if (!saudiPhoneReg.hasMatch(phone.text)) {
      AppUtil.errorToast(context, 'Enter a valid Saudi phone number'.tr());
      return ;
    }
    Map<String,String> formData = {
      "email": email.text,
      "phone": phone.text,
      "paymentBrand" : paymentBrand,
      "first_name": firstName.text,
      "last_name": lastName.text,
      "amount"   : price.toString(),
      "package_id"   : packageId.toString(),
      'num_visitors' : numVisitors.toString(),
      'is_Change'    : is_Change
    };
    emit(PayLoadingState());
    try{
      Map<String,dynamic> response = await WalletRepository.pay(formData);
      if(response['status']){
        AppUtil.successToast(context, response['msg']);
        walletView = response['redirect_url'];
        AppUtil.mainNavigator(context, HyperPayScreen(packageId: packageId.toString(),amount: price.toString()));
        //AppUtil.removeUntilNavigator(context, const LayoutScreen());
      }else{
        AppUtil.errorToast(context, response['msg']);
      }
      emit(PayLoadedState());
    }catch(e){
      emit(PayLoadedState());
      return Future.error(e);
    }
  }


  WalletModel? walletModel;

  getWallet() async {
    emit(WalletLoadingState());
    try{
      Map<String,dynamic> response = await WalletRepository.getWallet();
      walletModel = WalletModel.fromJson(response);
      if(walletModel!.status!){
        emit(WalletLoadedState());
      }
      if(walletModel!.transactions!.isEmpty){
        emit(TransactionsWalletEmptyState());
      }
    }catch(e){
      emit(WalletErrorState());
      print(e.toString());
      return Future.error(e);
    }
  }
}