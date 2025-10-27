import 'package:bringessesellerapp/model/response/view_profile_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class ViewProfileState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final ViewProfileModel viewProfile;

  const ViewProfileState(
      {required this.networkStatusEnum, required this.viewProfile});

  factory ViewProfileState.initial() => ViewProfileState(
        networkStatusEnum: NetworkStatusEnum.initial,
        viewProfile: ViewProfileModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, viewProfile];

  ViewProfileState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      ViewProfileModel? viewProfile}) {
    return ViewProfileState(
        viewProfile: viewProfile ?? this.viewProfile,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
