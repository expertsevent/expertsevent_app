
import '../../core/network_helper.dart';

class AuthRepository {
  static login(formData) async {
    return await NetworkHelper.repo("logins", 'post',formData: formData);
  }

  static loginwithEmail(formData) async {
    return await NetworkHelper.repo("logins_with_email", 'post',formData: formData);
  }

  static register(formData) async {
    return await NetworkHelper.repo("signup-user", 'post',formData: formData);
  }

  static forgetPass(formData) async {
    return await NetworkHelper.repo("Forget-Password",'post',formData: formData);
  }

  static verifyPhone(formData) async {
    return await NetworkHelper.repo("verify",'post',formData: formData);
  }

  static verifyForgetPass(formData) async {
    return await NetworkHelper.repo("Verify-Forget-Password",'post',formData: formData);
  }

  static resetPass(formData) async {
    return await NetworkHelper.repo("Rest-Password",'post',formData: formData);
  }

}