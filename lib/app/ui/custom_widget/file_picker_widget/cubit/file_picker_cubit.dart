import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mashrou3/app/navigation/app_router.dart';
import 'package:mashrou3/config/utils.dart';
import 'package:mashrou3/utils/app_localization.dart';

part 'file_picker_state.dart';

class FilePickerCubit extends Cubit<FilePickerState> {
  FilePickerCubit() : super(FilePickerInitial());
  List<dynamic> attachmentList = [];
  String fileNameStr = "";
  String fileExtensionStr = "";
  int maxAllowedFiles = 1;
  late List<String> allowedExtension;

  static const imageExtension = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'heif',
    'heic',
  ];
  static const imageExtensionView = [
    ...imageExtension,
  ];

  static const allFilesExtension = [
    ...imageExtension,
    'pdf',
    'doc',
    'docx',
    'xls',
    'xlsx'
  ];

  void setAttachments(
      List<dynamic> imageList, int maxAllowed, List<String>? allowedExtension) {
    attachmentList = imageList;
    maxAllowedFiles = maxAllowed;
    this.allowedExtension = allowedExtension ?? allFilesExtension;
    if (attachmentList.length == maxAllowedFiles) {
      emit(DisableSelection());
    }
  }

  Future<void> pickFiles(List<dynamic> imageList, bool isImageTypeOnly,
      String fileName, String fileExtension, BuildContext dataContext) async {
    emit(FilePickerDataLoading());
    BuildContext context = AppRouter.rootNavigatorKey.currentContext ?? dataContext;
    try {
      List<XFile> selectedXFiles = [];
      List<File> selectedFiles = [];
      FilePickerResult? result;
      if (isImageTypeOnly) {
        if (maxAllowedFiles == 1) {
          final pickedFile = await ImagePicker()
              .pickImage(source: ImageSource.gallery, imageQuality: 70);
          if (pickedFile != null) {
            selectedXFiles.add(pickedFile);
          }
          debugPrint("ImagePath => ${selectedXFiles[0].path}");
          emit(OnlyImageFilesPickedState(
              selectedXFiles, fileName, fileExtension));
        } else {
          selectedXFiles = await ImagePicker().pickMultiImage(imageQuality: 70);
          debugPrint("Multi ImagePath Length=> ${selectedXFiles.length}");
          SchedulerBinding.instance.addPostFrameCallback((_) {
            emit(MultiImageFilesPickedState(
                selectedXFiles, fileName, fileExtension));
          });
        }
      } else {
        result = await FilePicker.platform.pickFiles(
          allowMultiple: maxAllowedFiles != 1,
          type: FileType.custom,
          readSequential: true,
          withReadStream: true,
          allowedExtensions:
              isImageTypeOnly == true ? imageExtension : allowedExtension,
        );
        printf("Doc result ====> ${result?.paths.length}");
      }

      if ((isImageTypeOnly && selectedXFiles.isNotEmpty) || result != null) {
        List<File> selectedFiles = [];
        List<File>? files = isImageTypeOnly
            ? convertXFileListToFilesList(selectedXFiles)
            : result?.paths.map((path) => File(path!)).toList();
        if (files!.isNotEmpty) {
          int totalSelectedFiles = attachmentList.length + files.length;
          if (totalSelectedFiles <= maxAllowedFiles) {
            for (var i = 0; i < files.length; i++) {
              File imageFile = File(files[i].path);
              String newFileName = "";
              String newFileExtension = "";
              if (isImageTypeOnly) {
                newFileName = imageFile.path.split('/').last;
                fileNameStr = newFileName.toString();
                newFileExtension = newFileName.split('.').last;
                fileExtensionStr = newFileExtension.toString();
              } else {
                PlatformFile file = result!.files[i];
                newFileName = file.name;
                fileNameStr = file.name.toString();
                newFileExtension = file.extension ?? "";
                fileExtensionStr = file.extension.toString();
              }

              // Perform file size validation here
              int maxSizeInBytes = 20 * 1024 * 1024; // 20 MB
              if (imageFile.lengthSync() <= maxSizeInBytes) {
                imageList.add(imageFile.path);

                selectedFiles.add(imageFile);
                fileName = newFileName;
                fileExtension = newFileExtension;
              } else {
                if (!context.mounted) return;
                Utils.showErrorMessage(
                  context: context,
                  message: appStrings(context).fileTooLarge(
                    20,
                  ),
                );
              }
            }
            SchedulerBinding.instance.addPostFrameCallback((_) {
              emit(FilesPickedState(selectedFiles, fileName, fileExtension));

              /// Disable selection if reaches max allowed files length
              ///
              if (totalSelectedFiles >= maxAllowedFiles) {
                emit(DisableSelection());
              } else {
                emit(EnableSelection());
              }
            });
          } else {
            if (!context.mounted) return;
            Utils.showErrorMessage(
              context: context,
              message: appStrings(context).selectOnlyMaxFiles(maxAllowedFiles),
            );
          }
        } else {
          emit(FilePickerErrorState(appStrings(context).fileIsEmpty));
        }
        if (attachmentList.length >= maxAllowedFiles) {
          emit(DisableSelection());
        } else {
          emit(EnableSelection());
        }
      }
    } catch (e) {
      emit(FilePickerErrorState("Error picking files: $e"));
    }
  }

  void removeAttachment({required int index, bool localDelete = true}) {
    if (attachmentList.isNotEmpty) {
      if (localDelete) {
        attachmentList.removeAt(index);
      }
      emit(FilesLoading());
      emit(FilesRemovedState(index));
    }
  }

  List<File> convertXFileListToFilesList(List<XFile> xFiles) {
    return xFiles.map((xFile) => File(xFile.path)).toList();
  }
}
