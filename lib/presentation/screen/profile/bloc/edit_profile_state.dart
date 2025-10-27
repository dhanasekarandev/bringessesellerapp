import 'package:bringessesellerapp/model/edit_profile_model.dart';
import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class EditProfileState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final EditProfileModel editProfile;

  const EditProfileState(
      {required this.networkStatusEnum, required this.editProfile});

  factory EditProfileState.initial() => EditProfileState(
        networkStatusEnum: NetworkStatusEnum.initial,
        editProfile: EditProfileModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, editProfile];

  EditProfileState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      EditProfileModel? editProfile}) {
    return EditProfileState(
        editProfile: editProfile ?? this.editProfile,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
