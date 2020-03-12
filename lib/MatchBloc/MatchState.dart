import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class MatchState extends Equatable {
  MatchState([List props = const []]) : super();
}

class LoadingState extends MatchState {
  @override
  List<Object> get props => [];
}

class LoadUserState extends MatchState {
  final Stream<QuerySnapshot> matchedList;
  final Stream<QuerySnapshot> selectedList;

  LoadUserState({this.matchedList, this.selectedList});

  @override
  List<Object> get props => [matchedList, selectedList];
}
