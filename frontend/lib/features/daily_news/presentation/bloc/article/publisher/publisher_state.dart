import 'package:equatable/equatable.dart';

abstract class PublisherState extends Equatable {
  const PublisherState();

  @override
  List<Object> get props => [];
}

class PublisherInitial extends PublisherState {}

class PublisherLoading extends PublisherState {}

class PublisherSuccess extends PublisherState {}

class PublisherError extends PublisherState {
  final String message;

  const PublisherError(this.message);

  @override
  List<Object> get props => [message];
}
