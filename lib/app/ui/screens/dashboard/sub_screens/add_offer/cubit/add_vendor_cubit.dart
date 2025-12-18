import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashrou3/app/bloc/common_api_services/common_api_cubit.dart';
import 'package:mashrou3/app/model/offers/my_offers_list_response_model.dart';
import 'package:mashrou3/app/model/property/currency_list_response_model.dart';
import 'package:mashrou3/app/ui/screens/dashboard/sub_screens/add_offer/model/vendor_add_offer_response_model.dart';
import 'package:mashrou3/config/utils.dart';

import '../../../../../../../config/network/network_constants.dart';
import '../../../../../../db/app_preferences.dart';
import '../../../../../../model/base/base_model.dart';
import '../../../../../../model/property/property_detail_response_model.dart';
import '../../../../../../repository/offers_management_repository.dart';
import '../../my_offers_list/cubit/my_offers_list_cubit.dart';
import '../model/add_vendor_response_model.dart' as CreateModel;

part 'add_vendor_state.dart';

class AddVendorOfferCubit extends Cubit<AddVendorOfferState> {
  OffersManagementRepository repository;

  AddVendorOfferCubit({required this.repository}) : super(AddVendorInitial());

  AppPreferences appPreferences = AppPreferences();

  TextEditingController titleCtl = TextEditingController();
  FocusNode titleFn = FocusNode();
  TextEditingController arabicTitleCtl = TextEditingController();
  FocusNode arabicTitleFn = FocusNode();
  TextEditingController costCtl = TextEditingController();
  FocusNode costFn = FocusNode();
  TextEditingController descriptionCtl = TextEditingController();
  FocusNode descriptionFn = FocusNode();
  TextEditingController arabicDescriptionCtl = TextEditingController();
  FocusNode arabicDescriptionFn = FocusNode();
  List<CurrencyListData>? currencyList = [];
  List<dynamic> documentsList = [];
  CurrencyListData selectedCurrency = CurrencyListData(
    sId: '5d441ff23b574544e86e97bf',
    currencySymbol: 'د.أ',
    currencyCode: 'JOD',
    currencyName: 'Jordanian Dinar',
  );
  OfferData? offerData;

  bool isUpdate = false;

  /// Get data initial data
  ///
  Future<void> getData(BuildContext context, OfferData model) async {
    descriptionCtl.clear();
    arabicDescriptionCtl.clear();
    costCtl.clear();
    titleCtl.clear();
    arabicTitleCtl.clear();
    documentsList.clear();
    currencyList?.clear();
    await getCurrencyList(context);
    isUpdate = model.sId != null && model.sId!.isNotEmpty;
    if (isUpdate) {
      offerData = model;
      await setEditData(context, model);
    }
  }

  Future<void> setEditData(BuildContext context, OfferData model) async {
    if (model.sId != null && model.sId!.isNotEmpty) {
      titleCtl.text = model.title ?? "";
      arabicTitleCtl.text = model.arTitle ?? "";
      selectedCurrency = currencyList!.firstWhere(
        (currency) => currency.currencyCode == model.price?.currencyCode,
        orElse: () => CurrencyListData(),
      );
      costCtl.text = model.price?.amount.toString() ?? "";
      descriptionCtl.text = model.description ?? "";
      arabicDescriptionCtl.text = model.arDescription ?? "";
      documentsList = model.documents ?? [];
    }

    emit(OfferDetailsLoaded());
  }

  void updateAttachments(List<dynamic> documents, BuildContext context) {
    // documentsList = documents;

    emit(AttachmentLoaded());
  }

  /// Currency List API
  ///
  Future<void> getCurrencyList(BuildContext context) async {
    emit(GetOfferCurrencyLoading());

    final response = await context.read<CommonApiCubit>().fetchCurrencyList();

    if (response is String) {
    } else {
      currencyList = response;
      printf("currencyList--------${currencyList?.length}");
      emit(GetOfferCurrencyLoaded());
    }
  }

  /// MULTIPART CREATE OFFER API
  ///
  Future<void> submitAddOffer() async {
    emit(SubmitOfferLoading());
    var formData = FormData();
    List<dynamic> httpDocumentsList = [];
    if (documentsList.isNotEmpty) {
      httpDocumentsList = documentsList.where((item) => item.startsWith('http')).toList();
    }

    formData = FormData.fromMap({
      NetworkParams.kTitle: jsonEncode({
        "en": titleCtl.text.trim(),
        "ar": arabicTitleCtl.text.trim(),
      }),
      NetworkParams.kDescription: jsonEncode({
        "en": descriptionCtl.text.trim(),
        "ar": arabicDescriptionCtl.text.trim(),
      }),
      NetworkParams.kDocuments: json.encode(httpDocumentsList),
      NetworkParams.kPrice: jsonEncode(
        Price(
          amount: costCtl.text.trim(),
          currencySymbol: selectedCurrency.currencySymbol ?? 'د.أ',
          currencyCode: selectedCurrency.currencyCode ?? 'JOD',
        ).toJson(),
      ),
    });

    if (documentsList.isNotEmpty) {
      for (var file in documentsList) {
        if (!file.startsWith('http') && file.length > 2) {
          final multipartFile = await MultipartFile.fromFile(file);
          formData.files.add(MapEntry(NetworkParams.kDocuments, multipartFile));
        }
      }
    }

    final createOfferResponse = await repository.addVendorOffer(requestModel: formData);

    if (createOfferResponse is FailedResponse) {
      emit(SubmitOfferFailure(createOfferResponse.errorMessage));
    } else if (createOfferResponse is SuccessResponse) {
      CreateModel.AddVendorOfferResponseModel responseModel = createOfferResponse.data as CreateModel.AddVendorOfferResponseModel;
      emit(SubmitOfferSuccess(responseModel.message ?? ""));
    }
  }

  /// MULTIPART UPDATE OFFER API
  ///
  Future<void> updateOffer(BuildContext context, String postId) async {
    emit(SubmitOfferLoading());
    var formData = FormData();
    List<dynamic> httpDocumentsList = [];
    if (documentsList.isNotEmpty) {
      httpDocumentsList = documentsList.where((item) => item.startsWith('http')).toList();
    }

    formData = FormData.fromMap({
      NetworkParams.kTitle: jsonEncode({
        "en": titleCtl.text.trim(),
        "ar": arabicTitleCtl.text.trim(),
      }),
      NetworkParams.kDescription: jsonEncode({
        "en": descriptionCtl.text.trim(),
        "ar": arabicDescriptionCtl.text.trim(),
      }),
      NetworkParams.kDocuments: json.encode(httpDocumentsList),
      NetworkParams.kPrice: jsonEncode(
        Price(
          amount: costCtl.text.trim(),
          currencySymbol: 'د.أ',
          currencyCode: 'JOD',
        ).toJson(),
      ),
    });

    if (documentsList.isNotEmpty) {
      for (var file in documentsList) {
        if (!file.startsWith('http') && file.length > 2) {
          final multipartFile = await MultipartFile.fromFile(file);
          formData.files.add(MapEntry(NetworkParams.kDocuments, multipartFile));
        }
      }
    }

    printf(formData);
    final updateOfferResponse = context.read<MyOffersListCubit>().tabCurrentIndex == 0
        ? await repository.updateVendorOffer(isDraftOffer: false, requestModel: formData, postId: postId)
        : await repository.updateVendorOffer(isDraftOffer: true, requestModel: formData, postId: postId);

    if (updateOfferResponse is FailedResponse) {
      emit(SubmitOfferFailure(updateOfferResponse.errorMessage));
    } else if (updateOfferResponse is SuccessResponse) {
      VendorOfferCreateResponseModel responseModel = updateOfferResponse.data as VendorOfferCreateResponseModel;
      emit(UpdateOfferSuccess(responseModel.message ?? ""));
    }
  }

  /// GET OFFER API
  ///
  Future<void> getOfferDetailsById(String id) async {
    emit(GetOfferDetailsLoading());

    final updateProjectResponse = await repository.getOfferById(feedId: id);

    if (updateProjectResponse is FailedResponse) {
      emit(SubmitOfferFailure(updateProjectResponse.errorMessage));
    } else if (updateProjectResponse is SuccessResponse) {
      offerData = (updateProjectResponse.data as SingleOfferResponse).data;
      _setDataToFields();
      emit(GetOfferDetailsLoaded());
    }
  }

  void _setDataToFields() {
    if (offerData != null) {
      titleCtl.text = offerData?.title ?? "";
      arabicTitleCtl.text = offerData?.arTitle ?? "";
      costCtl.text = offerData?.price?.amount ?? "";
      descriptionCtl.text = offerData?.description ?? "";
      arabicDescriptionCtl.text = offerData?.arDescription ?? "";
      offerData?.documents?.forEach((element) {
        documentsList.add(element);
      });
      emit(GetOfferDataLoaded());
    }
  }
}
