import '../../core/network_helper.dart';

class WalletRepository{
  static getPackages() async {
    return await NetworkHelper.repo('packages', 'get');
  }

  static pay(formData) async {
    return await NetworkHelper.repo("packages_payment", 'post', formData: formData);
  }

  static getWallet() async {
    return await NetworkHelper.repo("get_wallet", 'get');
  }
}