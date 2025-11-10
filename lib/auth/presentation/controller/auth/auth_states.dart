import 'package:flutter/material.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}
class LoginVisibilityChangeState extends AuthState {}
class ConditionsAgreeChangeState extends AuthState {}
class RegisterVisibilityChangeState extends AuthState {}
class RegisterConfirmVisibilityChangeState extends AuthState {}
class PrivacyCheckChangeState extends AuthState {}
class GenderCheckChangeState extends AuthState {}

class ProfileLoadingState extends AuthState {}
class ProfileLoadedState extends AuthState {}
class ProfileErrorState extends AuthState {}

class EditProfileLoadedState extends AuthState {}
class EditProfileLoadingState extends AuthState {}

class LoginLoadingState extends AuthState{}
class LoginLoadedState extends AuthState{}
class LoginErrorState extends AuthState{}

class LoginemailLoadingState extends AuthState{}
class LoginemailLoadedState extends AuthState{}
class LoginemailErrorState extends AuthState{}

class RegisterLoadingState extends AuthState{}
class RegisterLoadedState extends AuthState{}

class CheckLoadingState extends AuthState{}
class CheckLoadedState extends AuthState{}

class SecChangeState extends AuthState{}

class PhoneLoadingState extends AuthState{}
class PhoneLoadedState extends AuthState{}


class UpdateProfileLoadingState extends AuthState{}
class UpdateProfileLoadedState extends AuthState{}
class UpdateProfileErrorState extends AuthState{}

class ForgotPasswordLoadingState extends AuthState{}
class ForgotPasswordLoadedState extends AuthState{}
class ForgotPasswordErrorState extends AuthState{}
class ForgotPasswordVisibilityChangeState extends AuthState {}
class ForgotPasswordConfirmVisibilityChangeState extends AuthState {}


class ChangePasswordLoadingState extends AuthState{}
class ChangePasswordLoadedState extends AuthState{}
class ChangePasswordErrorState extends AuthState{}


class UserPhotoChangeState extends AuthState{}