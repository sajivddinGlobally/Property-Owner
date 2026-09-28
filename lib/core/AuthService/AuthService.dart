import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:property_care/core/Data/Model/BodyModel/loginBodyModel.dart';
import 'package:property_care/core/Data/Model/BodyModel/registerBodyModel.dart';
import 'package:property_care/core/Data/Model/BodyModel/resetPassBodyModel.dart';
import 'package:property_care/core/Data/Model/BodyModel/selectPropertyBodyModel.dart';
import 'package:property_care/core/Data/Model/BodyModel/verifyOtpBodyModel.dart';
import 'package:property_care/core/Data/Model/ResponseModel/availableFlatModel.dart';
import 'package:property_care/core/Data/Model/ResponseModel/consolidatedStateModel.dart';
import 'package:property_care/core/Data/Model/ResponseModel/documentDetialsModel.dart';
import 'package:property_care/core/Data/Model/ResponseModel/forgotPassResModel.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getDocumentListModel.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getInspectionReportModel.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getProfileModel.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getServiceRequestDetailsModel.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getServiceRequestModel.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getTenantDetailsModel.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getTenantListModel.dart';
import 'package:property_care/core/Data/Model/ResponseModel/logoutModel.dart';
import 'package:property_care/core/Data/Model/ResponseModel/ownerDashboardModel.dart';
import 'package:property_care/core/Data/Model/ResponseModel/propertyDetailsModel.dart';
import 'package:property_care/core/Data/Model/ResponseModel/propertyListModel.dart';
import 'package:property_care/core/Data/Model/ResponseModel/resetPassResModel.dart';
import 'package:property_care/core/Data/Model/ResponseModel/verifyOtpResModel.dart';
import 'package:property_care/core/Network/ApiStateNetwork.dart';
import '../Data/Model/BodyModel/addPropertyRequestBodyModel.dart';
import '../Data/Model/BodyModel/aiAssistanceBodyModel.dart';
import '../Data/Model/BodyModel/changePasswordBodyModel.dart';
import '../Data/Model/BodyModel/forgotPassBodyModel.dart';
import '../Data/Model/ResponseModel/addPropertyRequestResModel.dart';
import '../Data/Model/ResponseModel/changePassResModel.dart';
import '../Data/Model/ResponseModel/editProfileResModel.dart';
import '../Data/Model/ResponseModel/getInpectoinReportDetailsModel.dart';
import '../Data/Model/ResponseModel/getMaintenanceHistoryDetailsModel.dart';
import '../Data/Model/ResponseModel/getMaintenanceHistoryModel.dart';
import '../Data/Model/ResponseModel/getNotificaionListModel.dart';
import '../Data/Model/ResponseModel/getPropertyAssistantModel.dart';
import '../Data/Model/ResponseModel/getPropertyScoreModel.dart';
import '../Data/Model/ResponseModel/getTenantPaymentModel.dart';
import '../Data/Model/ResponseModel/gtUtilityStatusModel.dart';
import '../Data/Model/ResponseModel/loginResModel.dart';
import '../Data/Model/ResponseModel/maintenancePaymentStatusModel.dart';
import '../Data/Model/ResponseModel/registerResModel.dart';

class AuthService {
  final ApiStateNetwork api;

  AuthService(this.api);

  Future<RegisterResModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
    required String propertyNameNumber,
    required String confirmPassword,
  }) async {
    try {
      final body = RegisterBodyModel(
        email: email,
        password: password,
        phone: phone,
        name: name,
        role: role,
        propertyNameNumber: propertyNameNumber,
        confirmPassword: confirmPassword,
      );
      final response = await api.register(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<AvailableFlatsModel> getAvailableFlats() async {
    try {
      final response = await api.availableFlats();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginResModel> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final body = LoginBodyModel(login: email, password: password, role: role);
      final response = await api.login(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ForgotPassResModel> forgotPassword({required String email}) async {
    try {
      final body = ForgotPassBodyModel(email: email);
      final response = await api.forgotPass(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<VerifyOtpResModel> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      final body = VerifyOtpBodyModel(email: email, otp: otp);
      final response = await api.verifyOtp(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResetPassResModel> resetPassword({
    required String newPassword,
    required String confirmPassword,
    required String email,
  }) async {
    try {
      final body = ResetPassBodyModel(
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        email: email,
      );
      final response = await api.resetPassword(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetProfileModel> getProfileData({dynamic propertyId}) async {
    try {
      final response = await api.getProfileData(propertyId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<OwnerDashboardModel> getOwnerDashboardData({
    dynamic propertyId,
  }) async {
    try {
      final response = await api.getOwnerDashboardData(propertyId);
      return response;
    } catch (e, st) {
      log(st.toString());
      log(e.toString());
      rethrow;
    }
  }

  Future<PropertyDetailsModel> propertyDetails({dynamic propertyId}) async {
    try {
      final response = await api.propertyDetails(propertyId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<LogoutModel> logout() async {
    try {
      final response = await api.logout();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<PropertyListModel> getPropertyList({dynamic selectedId}) async {
    try {
      final response = await api.getProperyList(selectedId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetPropertyScoreModel> getPropertyScore({dynamic propertyId}) async {
    try {
      final response = await api.getPropertyScore(propertyId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> selectProperty({required int propertyId}) async {
    try {
      final body = SelectPropertyBodyModel(propertyId: propertyId);
      await api.selectProperty(body);
    } catch (e) {
      rethrow;
    }
  }

  Future<EditProfileResModel> editProfile({
    required String name,
    required String phone,
    required MultipartFile? image,
  }) async {
    try {
      final response = await api.editProfile(name, phone, image);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ConsolidatedStatusModel> propertyConsolidateStatus({
    dynamic propertyId,
  }) async {
    try {
      final response = await api.propertyConsolidateStatus(propertyId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createService({
    required String serviceCategory,
    required String? serviceType,
    required String title,
    required String details,
    required String? preferredDate,
    required String? preferredTime,
    required String priority,
    MultipartFile? attachment,
    required String type,
    int? propertyId,
  }) async {
    try {
      await api.createService(
        serviceCategory,
        serviceType,
        title,
        details,
        preferredDate,
        preferredTime,
        priority,
        attachment,
        type,
        propertyId,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<GetServiceRequestModel> getServiceRequest({
    required String statusFilter,
    required String search,
    required String type,
    dynamic propertyId,
  }) async {
    try {
      final response = await api.getServiceRequest(
        statusFilter,
        search,
        type,
        propertyId,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetServiceRequestDetailsModel> getServiceRequestDetails({
    required String id,
  }) async {
    try {
      final response = await api.getServiceRequestDetails(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetDocumentListModel> getDocumentList({
    required String category,
    dynamic propertyId,
  }) async {
    try {
      final response = await api.getDocumentList(category, propertyId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<DocumentDetailsModel> documentDetails({required String id}) async {
    try {
      final response = await api.documentDetails(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> addTenant({
    required int propertyId,
    required String name,
    required String phone,
    required String email,
    required String monthlyRent,
    required String securityDeposit,
    required String moveInDate,
    required String moveOutDate,
    required String tenantStatus,
    required String tenantType,
    MultipartFile? image,
  }) async {
    try {
      final response = await api.addTenant(
        propertyId,
        name,
        phone,
        email,
        monthlyRent,
        securityDeposit,
        moveInDate,
        moveOutDate,
        tenantStatus,
        tenantType,
        image,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetTenantListModel> getTenantList({dynamic propertyId}) async {
    try {
      final response = await api.getTenantList(propertyId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetTenantDetailsModel> getTenantDetails({
    required String id,
    dynamic propertyId,
  }) async {
    try {
      final response = await api.getTenantDetails(id, propertyId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> editTenant({
    required String id,
    required int propertyId,
    required String name,
    required String phone,
    required String email,
    required String monthlyRent,
    required String securityDeposit,
    required String moveInDate,
    required String moveOutDate,
    required String tenantStatus,
    required String tenantType,
    MultipartFile? image,
  }) async {
    try {
      final response = await api.editTenant(
        id,
        propertyId,
        name,
        phone,
        email,
        monthlyRent,
        securityDeposit,
        moveInDate,
        moveOutDate,
        tenantStatus,
        tenantType,
        image,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetTenantPaymentModel> getTenantPayment({required String id}) async {
    try {
      final response = await api.getTenantPayment(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetUtilityStatusModel> getUtilityStatus({required String id}) async {
    try {
      final response = await api.getUtilityStatus(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ChangePasswordResModel> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      final body = ChangePasswordBodyModel(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );
      final response = await api.changePassword(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetMaintenanceHistoryModel> maintenanceHistory({
    required String filter,
    dynamic propertyId,
  }) async {
    try {
      final response = await api.getMaintenanceHistory(filter, propertyId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetMaintenanceHistoryDetailsModel> getMaintenanceHistoryDetails({
    required String id,
  }) async {
    try {
      final response = await api.getMaintenanceHistoryDetails(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<MaintenancePaymentStatusModel> maintenancePaymentStatus({
    dynamic propertyId,
  }) async {
    try {
      final response = await api.maintenancePaymentStatus(propertyId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetNotificaionListModel> getNotificaionList({
    required String filter,
  }) async {
    try {
      final response = await api.getNotificaionList(filter);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetInspectionReportModel> getInspectionReport({
    required String filter,
    required String type,
    dynamic propertyId,
  }) async {
    try {
      final response = await api.getInspectionReport(filter, type, propertyId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetInspectionReportDetailsModel> getInspectionReportDetails({
    required String id,
  }) async {
    try {
      final response = await api.getInpectionReportDetails(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetPropertyAssistantModel> getPropertyAssistant() async {
    try {
      final response = await api.getPropertyAssistant();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<GetPropertyAssistantModel> sendMessageToAi({
    required String query,
  }) async {
    try {
      final body = AiAssistanceBodyModel(query: query);
      final response = await api.sendMessageToAi(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<AddPropertyRequestResModel> addProperyRequest({
    required String propertyNameNumber,
    required String propertyType,
    required String location,
    required String area,
    required String carePackage,
    required String complexes,
  }) async {
    try {
      final body = AddPropertyRequestBodyModel(
        propertyNameNumber: propertyNameNumber,
        propertyType: propertyType,
        location: location,
        area: area,
        carePackage: carePackage,
        complexes: complexes,
      );
      final response = await api.addPropertyRequest(body);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
