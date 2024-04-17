part of 'bottom_nav_bar_bloc.dart';

@immutable
sealed class BottomNavBarState {
  final int tabIndex;
  const BottomNavBarState({required this.tabIndex});
}

final class BottomNavBarInitial extends BottomNavBarState {
  const BottomNavBarInitial({required super.tabIndex});
}
