import 'package:flutter_bloc/flutter_bloc.dart';

class AppTabCubit extends Cubit<int> {
  AppTabCubit() : super(0);

  void setTab(int index) => emit(index);
}
