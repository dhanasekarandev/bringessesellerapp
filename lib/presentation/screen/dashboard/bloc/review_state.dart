import 'package:bringessesellerapp/model/response/review_res_model.dart';

import 'package:bringessesellerapp/utils/enums.dart';
import 'package:equatable/equatable.dart';

class ReviewState extends Equatable {
  final NetworkStatusEnum networkStatusEnum;
  final ReviewResponseModel reviewResponseModel;

  const ReviewState(
      {required this.networkStatusEnum, required this.reviewResponseModel});

  factory ReviewState.initial() => ReviewState(
        networkStatusEnum: NetworkStatusEnum.initial,
        reviewResponseModel: ReviewResponseModel(),
      );

  @override
  List<Object?> get props => [networkStatusEnum, reviewResponseModel];

  ReviewState copyWith(
      {NetworkStatusEnum? networkStatusEnum,
      NetworkStatusEnum? childNetworkStatusEnum,
      int? currentPage,
      ReviewResponseModel? reviewResponseModel}) {
    return ReviewState(
        reviewResponseModel: reviewResponseModel ?? this.reviewResponseModel,
        networkStatusEnum: networkStatusEnum ?? this.networkStatusEnum);
  }
}
