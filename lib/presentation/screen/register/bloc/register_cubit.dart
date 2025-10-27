// import 'package:bringessesellerapp/presentation/repository/auth_repo.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'register_state.dart';

// class RegisterCubit extends Cubit<RegisterState> {
//   final AuthRepository authRepository;

//   RegisterCubit({required this.authRepository}) : super(RegisterInitial());

//   Future<void> register({
//     required String name,
//     required String email,
//     required String password,
//     required String contactNo,
//   }) async {
//     emit(RegisterLoading());
//     try {
//       await authRepository.register(
//           name: name, email: email, password: password, contactNo: contactNo);
//       emit(RegisterSuccess());
//     } catch (e) {
//       emit(RegisterError(e.toString()));
//     }
//   }
// }
