part of 'bottom_nav_bar_bloc.dart';

@immutable
sealed class BottomNavBarEvent {}

class TabChange extends BottomNavBarEvent {
  final int tabIndex;
  TabChange({required this.tabIndex});
}
