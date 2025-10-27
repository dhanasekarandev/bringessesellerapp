




import 'package:bringessesellerapp/model/response/login_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final LoginModel login;



  const LoginState({
    required this.networkStatusEnum,
    required this.login
  });

  factory LoginState.initial() =>  LoginState(
        networkStatusEnum: NetworkStatusEnum.initial,
       login: LoginModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum,login];

  LoginState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      LoginModel? login}) {
    return LoginState(
      login: login??this.login,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
        
  }
}
