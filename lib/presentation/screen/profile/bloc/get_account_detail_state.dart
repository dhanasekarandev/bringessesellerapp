import 'package:bringessesellerapp/model/response/account_detail_model.dart';
import 'package:bringessesellerapp/model/response/dashboard_model.dart';
import 'package:bringessesellerapp/model/response/view_profile_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class GetAccountDetailState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final AccountDetailModel accountDetailModel;

  const GetAccountDetailState(
      {required this.networkStatusEnum, required this.accountDetailModel});

  factory GetAccountDetailState.initial() => GetAccountDetailState(
        networkStatusEnum: NetworkStatusEnum.initial,
        accountDetailModel: AccountDetailModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, accountDetailModel];

  GetAccountDetailState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      AccountDetailModel? accountDetailModel}) {
    return GetAccountDetailState(
        accountDetailModel: accountDetailModel ?? this.accountDetailModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
