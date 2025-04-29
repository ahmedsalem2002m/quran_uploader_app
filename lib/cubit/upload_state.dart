// sheikh_state.dart
abstract class UploadState {}

class UploadInitial extends UploadState {}

class UploadLoading extends UploadState {}

class UploadSuccess extends UploadState {
  final String message;
  UploadSuccess(this.message);
}

class UploadFailure extends UploadState {
  final String errorMessage;
  UploadFailure(this.errorMessage);
}
