part of 'file_picker_cubit.dart';

abstract class FilePickerState extends Equatable {}

class FilePickerInitial extends FilePickerState {
  @override
  List<Object?> get props => [];
}

class FilePickerDataLoading extends FilePickerState {
  @override

  List<Object?> get props => [];
}


class FilesPickedState extends FilePickerState {
  final List<File> files;
  final String fileName;
  final String fileExtension;


  FilesPickedState(this.files, this.fileName, this.fileExtension);

  @override
  List<Object> get props => [files, fileName, fileExtension];

}


class OnlyImageFilesPickedState extends FilePickerState {
  final List<XFile> files;
  final String fileName;
  final String fileExtension;


  OnlyImageFilesPickedState(this.files, this.fileName, this.fileExtension);

  @override
  List<Object> get props => [files, fileName, fileExtension];

}


class MultiImageFilesPickedState extends FilePickerState {
  final List<XFile> files;
  final String fileName;
  final String fileExtension;


  MultiImageFilesPickedState(this.files, this.fileName, this.fileExtension);

  @override
  List<Object> get props => [files, fileName, fileExtension];

}

class FilesRemovedState extends FilePickerState {
  int removeIndex;

  FilesRemovedState(this.removeIndex);

  @override
  List<Object?> get props => [this.removeIndex];
}

class FilesLoading extends FilePickerState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FilePickerErrorState extends FilePickerState {
  final String errorMessage;

  FilePickerErrorState(this.errorMessage);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class EnableSelection extends FilePickerState {

  EnableSelection();

  @override
  List<Object?> get props => [];
}

class DisableSelection extends FilePickerState {

  DisableSelection();

  @override
  List<Object?> get props => [];
}
