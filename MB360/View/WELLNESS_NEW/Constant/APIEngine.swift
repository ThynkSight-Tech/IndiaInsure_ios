//
//  APIEngine.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 28/05/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class APIEngine: NSObject {
    
    static let shared = APIEngine()
    
    //MARK:- Health Checkup API
    //Testing
//   let baseURL = "http://mybenefits360.in/mbapi/api/v1/"
//    let jsonBaseURL = "http://mybenefits360.in/mb360api/api/"

    
    //Production
    //let baseURL = "http://core.mybenefits360.com/appservice/"
    let baseURL = "http://wellness.mybenefits360.com/mbapiv2/api/v1/"  //
    let jsonBaseURL = "https://portal.mybenefits360.com/mb360apiV2/api/"//"http://core.mybenefits360.com/mb360api/api/"
    
    //Production Portal
    let jsonBaseURLPortal = "https://portal.mybenefits360.com/mb360apiV2/api/"

    
    //Wellness URL
    let wellnessBaseURL = "http://wellness.mybenefits360.com/mbapiv2/api/v1/"
    
    
    
    //let groupCode = "stt"
    //API URLS
    let dashboardSequence_URL = "Wellness/GetDashboardLinks"
    let termsAndConditionText_URL = "Wellness/GetBasicInfo"
    let isEmployeePresent_URL = "Wellness/IsEmployeeDetailsPresent"
    let sendEmployeeInfoToServer_URL = "Wellness/InsertEmployeeDetails"
    let getFamilyDetails_URL = "Wellness/GetFamilyMembers"
    let deleteFamilyMember_URL = "Wellness/DeleteDependent"
    let getPackageDetails_URL = "HealthCheckup/GetPackageDetails"
    let getAllRelation_URL = "Wellness/GetAllrelations"
    let addDependent_URL = "Wellness/AddDependent"
    let addMemberMobileNumber_URL = "HealthCheckup/IsPersonAgree"
    let getHospitalsList_URL = "HealthCheckup/GetHealthCheckupCenter"
    let getLocationList_URL = "HealthCheckup/GetServicableCities"
    let scheduleAppointment_URL = "HealthCheckup/ScheduleAppointment"
    let getSummaryDetails_URL = "HealthCheckup/GetSummary"
    let fetchPaymentDetails_URL = "HealthCheckup/FetchPaymentDetails"
    let updatePaymentDetails_URL = "HealthCheckup/UpdatePaymentDetails"
    let getAppointmentList_URL = "HealthCheckup/GetScheduledAppointments"
    //Reschedule Apointment
    let rescheduleAppointment_URL = "HealthCheckup/FetchReschedulePaymentDetails"
    let updateReschedulePaymentDetails_URL = "HealthCheckup/UpdateReschedulePaymentDetails"
    let cancelAppointment_URL = "HealthCheckup/CancelAppointment"
    let getAppointmentHistory_URL = "HealthCheckup/GetHistroryofPerson"
    let cancelOngoingOrder_URL = "MedicineDelivery/CancelOngoingOrder"
    
    //Health checkup 2020
    let newHealthCheckup_URL = "Wellness/GetFamilyMembers"
    let canAddNewMember_URL = "Wellness/CanAddMember"
    let canAddNewMember_URL1 = "Wellness/CanAddMember1"

    //Get Servicable Tabs - Insurance,Wellness,Fitness
    let getServiceTabs = "Login/ShowHideButtonsforInsurance"
    
    //Wellnes New
    let buyDCPackage_url = "DoctorConsultation/BuyDCPackage"
    let getPkgPriceDM_url = "HomeHealthCare/GetPkgPriceDM"
    let newDCGetEmployeeDCPackages_URL = "DoctorConsultation/GetEmployeeDCPackages" //DoctorConsultation
    let newGetIsDCTermsAgreed_URL = "DoctorConsultation/GetIsDCTermsAgreed" //DoctorConsultation
    let acceptInsertDCTermsAgree_url = "DoctorConsultation/InsertDCTermsAgree"
    
    
    func getDashboardLinkURL(groupChildSrNo:String) -> String {
        //http://mybenefits360.in/mbapi/api/v1/Wellness/GetDashboardLinks?Agent=app&GroupChildSrNo=909
        return baseURL + dashboardSequence_URL + "?Agent=app&GroupChildSrNo=\(groupChildSrNo)"
    }
    
    func getBasicInfoURL(externalGroupSrNo:String,agent:String) -> String {
        return baseURL + termsAndConditionText_URL + "?ExternalGroupSrNo=\(externalGroupSrNo)&Agent=\(agent)"
    }
    
    func isEmployeePresentURL(empIdNo:String,groupCode:String) -> String{
        return baseURL + isEmployeePresent_URL + "?EmpIdNo=\(empIdNo)" + "&GroupCode=\(groupCode)"
    }
    
    func sendEmpInfoToServerURL() -> String {
        return baseURL + sendEmployeeInfoToServer_URL
    }
    
    func getFamilyDetailsURL(extGroupSRNo:String,empIDNo:String) -> String {
        //?ExtGroupSrNo=1&EmpIdNo=6012111
        return baseURL + getFamilyDetails_URL + "?ExtGroupSrNo=\(extGroupSRNo)" + "&EmpIdNo=\(empIDNo)"
    }
    
    func deleteFamilyMemberURL(personSRNo:String) -> String { //DELETE
        //http://www.mybenefits360.in/mbapi/api/v1/Wellness/DeleteDependent?PersonSrNo=31432
        return baseURL + deleteFamilyMember_URL + "?PersonSrNo=\(personSRNo)"
    }
    
    func getPackageDetailsURL(packageSrNo:String) -> String {
        //HealthCheckup/GetPackageDetails?PackageSrNo=5
        return baseURL + getPackageDetails_URL + "?PackageSrNo=" + packageSrNo
    }
    
    func getAllRelationsURL(familySrNo:String) -> String {
        return baseURL + getAllRelation_URL + "?FamilySrNo=" + familySrNo
    }
    
    func addMemberURL() -> String {
        return baseURL + addDependent_URL
    }
    
    func addMobileNumberURL() -> String { //PUT
        return baseURL + addMemberMobileNumber_URL
    }
    
    func getHealthCheckupURL(cityName:String) -> String {
        return baseURL + getHospitalsList_URL + "?City=\(cityName)"
    }
    
    func getLocationListURL() -> String {
        return baseURL + getLocationList_URL
    }
    
    func scheduleAppointmentURL() -> String {
        return baseURL + scheduleAppointment_URL
    }
    
    func getSummaryDetailsURL(familySRNo:String,groupCode:String) -> String {
        return baseURL + getSummaryDetails_URL + "?FamilySrNo=\(familySRNo)" + "&GroupCode=\(groupCode)"
    }
    
    func fetchPaymentDetailsURL(familySrNo:String,ExtGroupSrNo:String,EmpIdNo:String,TotalPayment:String,groupCode:String) -> String {
        
        return baseURL + fetchPaymentDetails_URL + "?FamilySrNo=\(familySrNo)" + "&ExtGroupSrNo=\(ExtGroupSrNo)" + "&EmpIdNo=\(EmpIdNo)" + "&TotalPayment=\(TotalPayment)&GroupCode=\(groupCode)"
    }
    
    func updatePaymentDetailsURL() -> String { //PUT
        return baseURL + updatePaymentDetails_URL
    }
    
    func getAppointmentListURL(FamilySrNo:String,ExtGroupSrNo:String,EmpIdNo:String,groupCode:String) -> String { //PUT
        return baseURL + getAppointmentList_URL + "?FamilySrNo=\(FamilySrNo)" + "&ExtGroupSrNo=\(ExtGroupSrNo)" + "&EmpIdNo=\(EmpIdNo)" + "&GroupCode=\(groupCode)"
    }
    
    func rescheduleAppointmentURL(FamilySrNo:String,AppointmentSrNo:String,TotalPayment:String) -> String {
        
        return baseURL + rescheduleAppointment_URL + "?FamilySrNo=\(FamilySrNo)" + "&AppointmentSrNo=\(AppointmentSrNo)" + "&TotalPayment=\(TotalPayment)"
    }
    
    func updateReschedulePaymentDetailsURL() -> String { //PUT
        return baseURL + updateReschedulePaymentDetails_URL
    }
    
    func cancelAppointmentURL() -> String { //PUT
        return baseURL + cancelAppointment_URL
    }
    
    func appointmentHistoryURL(familySrNo:String) -> String {
        return baseURL + getAppointmentHistory_URL + "?FamilySrNo=\(familySrNo)"
    }
    
    //April New URL - Wellness Health checkup - lockdown 2020
    func getHealthCheckupPackages(ExtGroupSrNo:String,GroupCode:String,EmpIdNo:String) -> String {
        return baseURL + newHealthCheckup_URL + "?ExtGroupSrNo=\(ExtGroupSrNo)" + "&GroupCode=\(GroupCode)" + "&EmpIdNo=\(EmpIdNo)"
    }
    
    func canAddMember(empId:String) -> String {
        return baseURL + canAddNewMember_URL + "?EmpIdNo=\(empId)"
    }
    func canAddMember1(groupCode:String) -> String {
        return baseURL + canAddNewMember_URL1 + "?GroupCode=\(groupCode)"
    }
    
    //MARK:- MEDICINE DELIVERY
    let checkPincode = "MedicineDelivery/IsPincodeServiceable"
    let address_URL = "MedicineDelivery/GetUsersAllAddressess"
    let addToCart_URL = "MedicineDelivery/AddToCart"
    let getAllCartNames_URL = "MedicineDelivery/GetCartOrders"
    let placeOrder_URL = "MedicineDelivery/PlaceOrder"
    let ongoingOrder_URL = "MedicineDelivery/GetOngoingOrder"
    let medicineHistory_URL = "MedicineDelivery/GetOrderHistory"
    let removeCartProduct_URL = "MedicineDelivery/RemoveFromCart"
    
    //Below MD API Updated By Charudatta After Dec 2020
    let getMemberListMD_URL = "MedicineDelivery/GetAllMembers"
    let getTokenMD_URL = "MedicineDelivery/GetAccessToken"
    
    func checkPincodeURL(pincode:String) -> String {
        return baseURL + checkPincode + "?Pincode=\(pincode)"
    }
    
    func getFamilyMemberMDListURL(empId:String,groupCode:String) -> String {
        return baseURL + getMemberListMD_URL + "?EmpID=\(empId)" + "&GroupCode=\(groupCode)"
    }
    
    func getFamilyAddressURL(familySrNo:String) -> String {
        return baseURL + address_URL + "?FamilySrNo=\(familySrNo)"
    }
    
    func addToCartURL() -> String {
        return baseURL + addToCart_URL
    }
    
    func getAllCartNamesURL(familySrNo:String) -> String {
        return baseURL + getAllCartNames_URL + "?FamilySrNo=\(familySrNo)"
    }
    
    func placeOrderURL() -> String {
        return baseURL + placeOrder_URL
    }
    
    func placeOrderURL(token:String,orderCount:String) -> String {
        return baseURL + placeOrder_URL + "?Token=\(token)" + "&OrdCount=\(orderCount)"
    }
    
    func getOngoinfOrdersURL(familySrNo:String) -> String {
        return baseURL + ongoingOrder_URL + "?FamilySrNo=\(familySrNo)"
    }
    
    func getCancelOngoinfOrderURL() -> String {
        return baseURL + cancelOngoingOrder_URL
    }
    
    func getMedicineHistoryURL(familySrNo:String) -> String {
        return baseURL + medicineHistory_URL + "?FamilySrNo=\(familySrNo)"
    }
    
    func removeCartProduct() -> String {
        return baseURL + removeCartProduct_URL
    }
    
    func getTokenForMDURL() -> String {
        return baseURL + getTokenMD_URL
    }
    
    
    //ENROLLMENT NEW JSON URL's
    // www.mybenefits360.in/mb360api/api/
    // Login/LoadSessionValues?mobileno=9665664202
    
    
    //NEW ENROLLMENT API - 20th MARCH 2020
    //without OTP
    let jsonLoadSession_URL = "Login/LoadSessionValues"
    let jsonLoadSession_EmailURL = "Login/LoadSessionValuesWithEmailD"
    
    //With OTP
    let jsonLoadSessionOTP_MobileURL = "Login/LoadSessionValueswithOTP"
    let jsonLoadSessionOTP_EmailURL = "Login/LoadSessionValuesEmailwithOTP"
    
    let jsonLoadSession_WebURL = "Login/LoadSessionByUniqueID"
    let jsonAdminSettings_URL = "EnrollmentDetails/GetAdminSettings"
    let json_AddDependant_URL = "EnrollmentDetails/AddDependant"
    let json_DeleteDependant_URL = "EnrollmentDetails/DeleteDependants"
    let json_OptRemoveTopUp_URL = "EnrollmentDetails/OptRemoveTopupData"
    let json_HealthPackagesURL = "HealthCheckup/GetHCPackageDepInfo"
    let getDependantListURL = "EnrollmentDetails/GetDependants"
    let deleteDependantURL = "EnrollmentDetails/DeleteDependant"
    let updateDependantURL = "EnrollmentDetails/UpdateDependant"
    let getParentalListURL = "EnrollmentDetails/GetParentalDependants"
    let deleteParentalDependantURL = "EnrollmentDetails/DeleteParentalDependant"
    let summaryInfoURL = "EnrollmentDetails/GetEnrollmentSummary"
   let optHealthCheckupPackage = "HealthCheckup/OptHCPackage"
   let removeHealthCheckupPackage = "HealthCheckup/DeOptHCPackage"
   let allocateWalletURL = "EnrollmentDetails/AllocateWallet"
    let printSummaryURL = "PrintSummary/PrintSummary"
   let allSumInsuredURL = "EnrollmentDetails/GetAllSumInsured"
    
    //NEW ENROLLMENT API - 19th MARCH 2021 by geeta
    let updateEmrgContactURL = "EnrollmentDetails/UpdateEmployeeEmergencyNo"
    let getDifferentlyAbledChildURL = "EnrollmentDetails/GetDifferentlyAbledChild"
    let updateDifferentlyAbledChildURL = "EnrollmentDetails/UpdateDifferentlyAbledChild"
    let deleteDifferentlyAbledChildURL = "EnrollmentDetails/DeleteDifferentlyAbledChild"
    
    
    func updateEmployeeEmergencyJsonURL(Employeesrno:String,ContactNo:String) -> String {
     return jsonBaseURL + updateEmrgContactURL + "?employeesrno=\(Employeesrno)" + "&EmergencyContactNo=\(ContactNo)"
    }
    /*
    func getLoadSessionJsonURL(mobileNo:String) -> String {
        return jsonBaseURL + jsonLoadSession_URL + "?mobileno=\(mobileNo)"
        //return "http://mybenefits360.in/mb360api/api/Login/LoadSessionValues?mobileno=9665664202"
    }
    */
    
    //Portal Load session
    func getLoadSessionJsonURLPortal(mobileNo:String) -> String {
        return jsonBaseURLPortal + jsonLoadSession_URL + "?mobileno=\(mobileNo)"
        //return "http://mybenefits360.in/mb360api/api/Login/LoadSessionValues?mobileno=9665664202"
    }
    
    func getLoadSessionJsonURLPortal(emailId:String) -> String {
        return jsonBaseURLPortal + jsonLoadSession_EmailURL + "?EmailId=\(emailId)"
        //return "http://mybenefits360.in/mb360api/api/Login/LoadSessionValues?mobileno=9665664202"
    }
    
    func getLoadSessionJsonURLPortal(webLogin:String) -> String {
        return jsonBaseURLPortal + jsonLoadSession_WebURL + "?LoginId=\(webLogin)"
        //return "http://mybenefits360.in/mb360api/api/Login/LoadSessionValues?mobileno=9665664202"
    }
    
    //Portal Loadsession with OTP
    func getLoadSessionOTPJsonURLPortal(mobileNo:String,otp:String) -> String {
        return jsonBaseURLPortal + jsonLoadSessionOTP_MobileURL + "?mobileno=\(mobileNo)&OTP=\(otp)"
       
    }
    
    func getLoadSessionOTPJsonURLPortal(emailId:String,otp:String) -> String {
        return jsonBaseURLPortal + jsonLoadSessionOTP_EmailURL + "?EmailId=\(emailId)&OTP=\(otp)"
       
    }
    
    
    func getAdminSettingsJsonURL(grpchildsrno:String,oegrpbasinfosrno:String) -> String {
        //http://www.mybenefits360.in/mb360api/api/EnrollmentDetails/GetAdminSettings?grpchildsrno=909&oegrpbasinfosrno=280
        return jsonBaseURL + jsonAdminSettings_URL + "?grpchildsrno=\(grpchildsrno)&oegrpbasinfosrno=\(oegrpbasinfosrno)"
    }
    
    
    /*func getAdminSettingsJsonURLPortal(grpchildsrno:String,oegrpbasinfosrno:String) -> String {
        //http://www.mybenefits360.in/mb360api/api/EnrollmentDetails/GetAdminSettings?grpchildsrno=909&oegrpbasinfosrno=280
        return jsonBaseURLPortal + jsonAdminSettings_URL + "?grpchildsrno=\(grpchildsrno)&oegrpbasinfosrno=\(oegrpbasinfosrno)"
    }
     */
    
    
    func getNewTopUpOptionsJsonURL(grpchildsrno:String,oegrpbasinfosrno:String,employeesrno:String,empIdenetificationNo:String) -> String {
        
       // return "http://www.mybenefits360.in/mb360api/api/Test/TestAdminSettings?employeesrno=\(employeesrno)&empidentification=\(empIdenetificationNo)&grpchildsrno=\(grpchildsrno)&oegrpbasinfsrno=\(oegrpbasinfosrno)"
        
        return "http://localhost:3000/getTopUp_details"
        //Commented Shubham
        //return jsonBaseURL + allSumInsuredURL + "?employeesrno=\(employeesrno)&GroupChildSrNo=\(grpchildsrno)&OeGrpBasInfSrNo=\(oegrpbasinfosrno)"
        //"http://www.mybenefits360.in/mb360api/api/EnrollmentDetails/GetAllSumInsured?employeesrno=\(employeesrno)&GroupChildSrNo=\(grpchildsrno)&OeGrpBasInfSrNo=\(oegrpbasinfosrno)"
        
        // return "http://www.mybenefits360.in/mb360api/api/Test/TestAdminSettings?employeesrno=36427&empidentification=6004396&grpchildsrno=1275&oegrpbasinfsrno=757"
    }
    
    
    func getAddNewDependantJsonURL(Employeesrno:String,Relationid:String,Personname:String,Dateofmarriage:String,Windowperiodactive:String,Grpchildsrno:String,Oegrpbasinfosrno:String,Gender:String,IsTwins:String,ParentalPremium:String,Age:String,Dateofbirth:String) -> String {
       
        return jsonBaseURL + json_AddDependant_URL + "?Employeesrno=\(Employeesrno)" + "&Relationid=\(Relationid)" + "&Personname=\(Personname)" + "&Dateofmarriage=\(Dateofmarriage)" + "&Windowperiodactive=\(Windowperiodactive)" + "&Grpchildsrno=\(Grpchildsrno)" + "&Oegrpbasinfosrno=\(Oegrpbasinfosrno)" + "&Gender=\(Gender)"+"&IsTwins=\(IsTwins)"+"&ParentalPremium=\(ParentalPremium)" + "&Age=\(Age)" + "&Dateofbirth=\(Dateofbirth)"
    }
    func getEditNewDependantJsonURL(Employeesrno:String,Relationid:String,Personname:String,Dateofmarriage:String,Windowperiodactive:String,Grpchildsrno:String,Oegrpbasinfosrno:String,Gender:String,IsTwins:String,ParentalPremium:String,Age:String,Dateofbirth:String,personSRNo:String) -> String {
          
          
        return jsonBaseURL + updateDependantURL + "?Personsrno=\(personSRNo)" + "&Age=\(Age)" + "&Dependantname=\(Personname)" + "&Dateofbirth=\(Dateofbirth)" + "&RelationId=\(Relationid)" + "&Gender=\(Gender)"
       }
    
    func getAddNewDependantJsonURLNew(Employeesrno:String,Relationid:String,Personname:String,Dateofmarriage:String,Windowperiodactive:String,Grpchildsrno:String,Oegrpbasinfosrno:String,Gender:String,IsTwins:String,ParentalPremium:String,Age:String,Dateofbirth:String) -> String {
        
        return jsonBaseURL + json_AddDependant_URL + "?Employeesrno=\(Employeesrno)" + "&Relationid=\(Relationid)" + "&Personname=\(Personname)" + "&Dateofmarriage=\(Dateofmarriage)" + "&Windowperiodactive=\(Windowperiodactive)" + "&Grpchildsrno=\(Grpchildsrno)" + "&Oegrpbasinfosrno=\(Oegrpbasinfosrno)" + "&Gender=\(Gender)"+"&IsTwins=\(IsTwins)"+"&ParentalPremium=\(ParentalPremium)" + "&Age=\(Age)" + "&Dateofbirth=\(Dateofbirth)"
    }
    
    func getEditNewDependantJsonURLNew(Employeesrno:String,Relationid:String,Personname:String,Dateofmarriage:String,Windowperiodactive:String,Grpchildsrno:String,Oegrpbasinfosrno:String,Gender:String,IsTwins:String,ParentalPremium:String,Age:String,Dateofbirth:String,personSRNo:String) -> String {
          
          
        return jsonBaseURL + updateDependantURL + "?Personsrno=\(personSRNo)" + "&Age=\(Age)" + "&Dependantname=\(Personname)" + "&Dateofbirth=\(Dateofbirth)" + "&RelationId=\(Relationid)" + "&Gender=\(Gender)"
       }
    
    func deleteDependantJsonURL() -> String {
        return jsonBaseURL + json_DeleteDependant_URL
    }
    
    func getOptRemoveTopUpJsonURL() -> String {
        return jsonBaseURL + json_OptRemoveTopUp_URL
    }
    
    func getHealthPackages(EmpSrNo:String,GroupChildSrNo:String,OeGrpBasInfSrNo:String,ExtGrpsrNo:String) -> String {
        return jsonBaseURL + json_HealthPackagesURL + "?EmpSrNo=\(EmpSrNo)&GroupChildSrNo=\(GroupChildSrNo)&OeGrpBasInfSrNo=\(OeGrpBasInfSrNo)&ExtGrpsrNo=\(ExtGrpsrNo)"
    }

    func getDependantListJSONURL(Windowperiodactive:String,GroupChildSrNo:String,OeGrpBasInfSrNo:String,EmpSrNo:String) -> String {
        
        return "http://localhost:3000/getDependent_details"
        //Shubham Commented
        //return jsonBaseURL + getDependantListURL + "?Windowperiodactive=\(Windowperiodactive)&Grpchildsrno=\(GroupChildSrNo)&Oegrpbasinfsrno=\(OeGrpBasInfSrNo)&EmpSrNo=\(EmpSrNo)"
    }
    
    
    func getDifferentlyAbledChildJSONURL(EmployeeSrNo:String) -> String {
        return jsonBaseURL + getDifferentlyAbledChildURL + "?EmployeeSrNo=\(EmployeeSrNo)"
    }
    
    func updateDifferentlyAbledChildJSONURL() -> String {
        return jsonBaseURL + updateDifferentlyAbledChildURL
    }
    
    func deleteDifferentlyAbledChildJSONURL(PersonSrNo:String) -> String {
        return jsonBaseURL + deleteDifferentlyAbledChildURL + "?PersonSrNo=\(PersonSrNo)"
    }
    
    //EmployeeSrNo=36471&GrpChildSrNo=1275&PersonSrNo=4357929
    func deleteDependantJsonURL(GroupChildSrNo:String,EmpSrNo:String,PersonSrNo:String) -> String {
        return jsonBaseURL + deleteDependantURL + "?EmployeeSrNo=\(EmpSrNo)"+"&GrpChildSrNo=\(GroupChildSrNo)"+"&PersonSrNo=\(PersonSrNo)"
    }
    
    func deleteParent(GroupChildSrNo:String,EmpSrNo:String,PersonSrNo:String,OeGrpBasInfSrNo:String,RelationID:String,parentalPremium:String) -> String {
    
        return jsonBaseURL + deleteParentalDependantURL + "?EmployeeSrNo=\(EmpSrNo)" + "&GrpChildSrNo=\(GroupChildSrNo)" + "&PersonSrNo=\(PersonSrNo)" + "&OeGrpBasInfSrNo=\(OeGrpBasInfSrNo)" + "&RelationID=\(RelationID)" + "&parentalPremium=\(parentalPremium)"


    }

    
    func getParentalListJSONURL(Windowperiodactive:String,GroupChildSrNo:String,OeGrpBasInfSrNo:String,EmpSrNo:String,parentalPremium:String) -> String {
        
        return "http://localhost:3000/getParental_details"
        
        //return jsonBaseURL + getParentalListURL + "?IsWindowPeriodActive=\(Windowperiodactive)&GroupChildSrNo=\(GroupChildSrNo)&OeGrpBasInfSrNo=\(OeGrpBasInfSrNo)&EmpSrNo=\(EmpSrNo)&parentalPremium=\(parentalPremium)"
    }
    
    
    func getSummaryDataURL(empSrNo:String) -> String {
        //Shubham Commented
        //return jsonBaseURL + summaryInfoURL + "?EmpSrNo=\(empSrNo)"
        return "http://localhost:3000/getSummary"
    }
    
  //http://www.mybenefits360.in/mb360api/api/HealthCheckup/OptHCPackage?EmpSrNo= 36470&PersonSrNo=4357731&PackageSrNo=13&Price=2800

    func optHealthCheckup(EmpSrNo:String,PersonSrNo:String,Price:String,PackageSrNo:String) -> String {
        return jsonBaseURL + optHealthCheckupPackage + "?EmpSrNo=\(EmpSrNo)" + "&PersonSrNo=\(PersonSrNo)" + "&PackageSrNo=\(PackageSrNo)" + "&Price=\(Price)"
    }
    
    //http://www.mybenefits360.in/mb360api/api/HealthCheckup/DeOptHCPackage?EmpSrNo= 36470&PersonSrNo=4357731&PackageSrNo=13&Price=0
    func removeHealthCheckup(EmpSrNo:String,PersonSrNo:String,Price:String,PackageSrNo:String) -> String {
        return jsonBaseURL + removeHealthCheckupPackage + "?EmpSrNo=\(EmpSrNo)" + "&PersonSrNo=\(PersonSrNo)" + "&PackageSrNo=\(PackageSrNo)" + "&Price=\(Price)"
    }
    
    
    func allocateWalletAPI(empSrNo:String) -> String {
        //http://mybenefits360.in/mb360api/api/EnrollmentDetails/AllocateWallet?EmpSrNo=36470
        return jsonBaseURL + allocateWalletURL + "?EmpSrNo=\(empSrNo)"
    }
    
    func printSummaryAPI() -> String {
        
        return jsonBaseURL + printSummaryURL
    }
    
    
    let getCities_URL = "HomeHealthCare/GetCities"
    let getCities_PNC_URL = "HomeHealthCare/GetCitiesNC"

    let nursingPackagePrice_URL = "HomeHealthCare/GetPkgPrice"
    let shortTermPackagePrice_URL = "HomeHealthCare/GetPkgPriceST"
    let longTermPackagePrice_URL = "HomeHealthCare/GetPkgPriceLT"
    let doctorServicesPackagePrice_URL = "HomeHealthCare/GetPkgPriceDS"
    let physiotherapyPackagePrice_URL = "HomeHealthCare/GetPkgPricePT"
    let postNatalPackagePrice_URL = "HomeHealthCare/GetPkgPriceNC"
    let elderCarePackagePrice_URL = "HomeHealthCare/GetPkgPriceEC"

    let scheduleNursingAttendant_URL = "HomeHealthCare/ScheduleAppointment"
    let schedulePhysiotherapy_URL = "HomeHealthCare/ScheduleAppointmentPT"
    
    //Fitness Onboarding
    let sendOnboardingDataToMBServer_URL = "UserProfile/UploadEmployeePhysicalInfo"
    let getFitnessProfileInfo_URL = "UserProfile/GetActivoEmployeeInfo"
    
    let overviewTextData_HHC_URL = "HomeHealthCare/GetOverviewDetails"
    let getHHCFamilyMembers = "HomeHealthCare/GetAllMembers"
    let scheduleShortTermNursing_URL = "HomeHealthCare/ScheduleAppointmentST"
    let doctorServicesNursing_URL = "HomeHealthCare/ScheduleAppointmentDS"
    let longTermNursing_ScheduleURL = "HomeHealthCare/ScheduleAppointmentLT"
    let postNatalCare_ScheduleURL = "HomeHealthCare/ScheduleAppointmentNC"
    let scheduleAppointment_URL_EC = "HomeHealthCare/ScheduleAppointmentEC"
    let scheduleDiabetesAppointment_URL = "HomeHealthCare/ScheduleAppointmentDM"
    let savePersonAddressMobileEmail_URL = "HomeHealthCare/SavePersonInfo" //save add contact email
    
    //ALL HHC Scheduled SUMMARY API
    let appointmentSummaryHHC_NA_URL = "HomeHealthCare/GetSummary"
    let appointmentSummaryHHC_ST_URL = "HomeHealthCare/GetSummaryST"
    let appointmentSummaryHHC_LT_URL = "HomeHealthCare/GetSummaryLT"
    let appointmentSummaryHHC_PT_URL = "HomeHealthCare/GetSummaryPT"
    let appointmentSummaryHHC_DS_URL = "HomeHealthCare/GetSummaryDS"
    let appointmentSummaryHHC_DM_URL = "HomeHealthCare/GetSummaryDM"
    let appointmentSummaryHHC_PNC_URL = "HomeHealthCare/GetSummaryNC"
    let appointmentSummaryHHC_EC_URL = "HomeHealthCare/GetSummaryEC"

    //Cancel HHC Scheduled API
    let cancelAppointmentHHC_NA_URL = "HomeHealthCare/CancelAppointment"
    let cancelAppointmentHHC_ST_URL = "HomeHealthCare/CancelAppointmentST"
    let cancelAppointmentHHC_LT_URL = "HomeHealthCare/CancelAppointmentLT"
    let cancelAppointmentHHC_PT_URL = "HomeHealthCare/CancelAppointmentPT"
    let cancelAppointmentHHC_DS_URL = "HomeHealthCare/CancelAppointmentDS"
    let cancelAppointmentHHC_DM_URL = "HomeHealthCare/CancelAppointmentDM"
    let cancelAppointmentHHC_PNC_URL = "HomeHealthCare/CancelAppointmentNC"
    let cancelAppointmentHHC_EC_URL = "HomeHealthCare/CancelAppointmentEC"
    
    //Covid 19 API
    let scheduleCovidTest_URL = "Covid19/AddcovidEmpDocuments"
    //http://mybenefits360.in/mbapi/api/v1/Covid19/CovidTestDetails
    let getCovidTestDetails_URL = "Covid19/CovidTestDetails"
}


//MARK:- WELLNESS OTHER FUNCTIONALITY
extension APIEngine {

    func getCityListForNursing(nursingType:NursingType) -> String {
        //http://mybenefits360.in/mbapi/api/v1/HomeHealthCare/GetCities
        if nursingType == .postNatelCare {
            return baseURL + getCities_PNC_URL
        }
        return baseURL + getCities_URL
    }
    
    func getNursingAttendantPackagesAPI() -> String {
        return baseURL + nursingPackagePrice_URL
    }
    func getLongTermPackagesAPI() -> String {
        return baseURL + longTermPackagePrice_URL
    }
    func getShortTermPackagesAPI() -> String {
        return baseURL + shortTermPackagePrice_URL
    }
    
    func getDoctorServicesPackagesAPI() -> String {
        return baseURL + doctorServicesPackagePrice_URL
    }
    func getPhysiotherapyPackagesAPI() -> String {
        return baseURL + physiotherapyPackagePrice_URL
    }
    
    func getPostNatalCarePackagesAPI() -> String {
        return baseURL + postNatalPackagePrice_URL
    }
    
    func getElderCarePackagesAPI() -> String {
           return baseURL + elderCarePackagePrice_URL
       }

    func getHHCOverviewText(WellSrNo:String) -> String {
        return baseURL + overviewTextData_HHC_URL + "?WellSrNo=\(WellSrNo)"
    }
    
    func scheduleNursingAttendant(PersonSrNo:String,FamilySrNo:String,ISRescheduled:String,RejtApptSrNo:String,PkgPriceSrNo:String,Date_Condition:String,Date_pref:String,From_date:String,To_date:String,RescSrNo:String,Remarks:String) -> String {
        //http://10.81.234.11/mbapi/api/v1/HomeHealthCare/ScheduleAppointment?PersonSrNo=25919&FamilySrNo=5568&ISRescheduled=0&RejtApptSrNo=-1&PkgPriceSrNo=8&Date_Condition=3&Date_pref=03/01/1990&From_date=23/03/2020&To_date=22/05/2020&RescSrNo=0&Remarks=test
                
        return baseURL + scheduleNursingAttendant_URL + "?PersonSrNo=\(PersonSrNo)" + "&FamilySrNo=\(FamilySrNo)" + "&ISRescheduled=\(ISRescheduled)" + "&RejtApptSrNo=\(RejtApptSrNo)" + "&PkgPriceSrNo=\(PkgPriceSrNo)" + "&Date_Condition=\(Date_Condition)" + "&Date_pref=\(Date_pref)" + "&From_date=\(From_date)" + "&To_date=\(To_date)" + "&RescSrNo=\(RescSrNo)" + "&Remarks=\(Remarks)"
    }
    
    func schedulePhysiotherapy(PersonSrNo:String,FamilySrNo:String,ISRescheduled:String,RejtApptSrNo:String,PkgPriceSrNo:String,Date_pref:String,Time_pref:String,RescSrNo:String,Remarks:String,From_date:String,To_date:String,Date_Condition:String) -> String {
        
        //http://mybenefits360.in/mbapi/api/v1/HomeHealthCare/ScheduleAppointmentPT?ISRescheduled=0&RejtApptSrNo=-1&RescSrNo=0&PersonSrNo=26089&FamilySrNo=5680&PkgPriceSrNo=21&Date_pref=05-Nov-2020&Time_pref=05:00:PM&Remarks=TestiOS&From_date=01-01-1990&To_date=01-01-1990&Date_Condition=1
        
       return baseURL + schedulePhysiotherapy_URL + "?PersonSrNo=\(PersonSrNo)" + "&FamilySrNo=\(FamilySrNo)" + "&ISRescheduled=\(ISRescheduled)" + "&RejtApptSrNo=\(RejtApptSrNo)" + "&PkgPriceSrNo=\(PkgPriceSrNo)" + "&Date_pref=\(Date_pref)" + "&Time_pref=\(Time_pref)" + "&RescSrNo=\(RescSrNo)" + "&Remarks=\(Remarks)" + "&From_date=\(From_date)" + "&To_date=\(To_date)" + "&Date_Condition=\(Date_Condition)"
        
        //return baseURL + schedulePhysiotherapy_URL + "?PersonSrNo=\(PersonSrNo)" + "&FamilySrNo=\(FamilySrNo)" + "&ISRescheduled=\(ISRescheduled)" + "&RejtApptSrNo=\(RejtApptSrNo)" + "&PkgPriceSrNo=\(PkgPriceSrNo)" + "&Date_pref=\(Date_pref)" + "&Time_pref=\(Time_pref)" + "&RescSrNo=\(RescSrNo)" + "&Remarks=\(Remarks)"

    }
    
    func scheduleShortTermNursing(PersonSrNo:String,FamilySrNo:String,ISRescheduled:String,RejtApptSrNo:String,PkgPriceSrNo:String,Date_pref:String,Time_pref:String,RescSrNo:String,Remarks:String) -> String {
        
        //http://mybenefits360.in/mbapi/api/v1/HomeHealthCare/ScheduleAppointmentST?PersonSrNo=26081&FamilySrNo=5680&ISRescheduled=0&RejtApptSrNo=-1&PkgPriceSrNo=2&Date_pref=22-Oct-2020&Time_pref=02:30:PM&RescSrNo=0&Remarks=
        
        return baseURL + scheduleShortTermNursing_URL + "?PersonSrNo=\(PersonSrNo)" + "&FamilySrNo=\(FamilySrNo)" + "&ISRescheduled=\(ISRescheduled)" + "&RejtApptSrNo=\(RejtApptSrNo)" + "&PkgPriceSrNo=\(PkgPriceSrNo)" + "&Date_pref=\(Date_pref)" + "&Time_pref=\(Time_pref)" + "&RescSrNo=\(RescSrNo)" + "&Remarks=\(Remarks)"
    }
    
    func scheduleDoctorServices(PersonSrNo:String,FamilySrNo:String,ISRescheduled:String,RejtApptSrNo:String,PkgPriceSrNo:String,Date_pref:String,Time_pref:String,RescSrNo:String,Remarks:String) -> String {
        
        //http://mybenefits360.in/mbapi/api/v1/HomeHealthCare/ScheduleAppointmentDS?PersonSrNo=26081&FamilySrNo=5680&ISRescheduled=0&RejtApptSrNo=-1&PkgPriceSrNo=2&Date_pref=22-Oct-2020&Time_pref=02:30:PM&RescSrNo=0&Remarks=
        
        return baseURL + doctorServicesNursing_URL + "?PersonSrNo=\(PersonSrNo)" + "&FamilySrNo=\(FamilySrNo)" + "&ISRescheduled=\(ISRescheduled)" + "&RejtApptSrNo=\(RejtApptSrNo)" + "&PkgPriceSrNo=\(PkgPriceSrNo)" + "&Date_pref=\(Date_pref)" + "&Time_pref=\(Time_pref)" + "&RescSrNo=\(RescSrNo)" + "&Remarks=\(Remarks)"
    }
    
    func scheduleLongTermNursingAttendant(PersonSrNo:String,FamilySrNo:String,ISRescheduled:String,RejtApptSrNo:String,PkgPriceSrNo:String,Date_Condition:String,Date_pref:String,From_date:String,To_date:String,RescSrNo:String,Remarks:String) -> String {
        
      //  http://mybenefits360.in/mbapi/api/v1/HomeHealthCare/ScheduleAppointmentLT?PersonSrNo=25608&FamilySrNo=5608&ISRescheduled=0&RejtApptSrNo=-1&PkgPriceSrNo=111&Date_Condition=4&Date_pref=01/01/2090&From_date=12/10/2020&To_date=26/10/2020&RescSrNo=0&Remarks=test
        
        return baseURL + longTermNursing_ScheduleURL + "?PersonSrNo=\(PersonSrNo)" + "&FamilySrNo=\(FamilySrNo)" + "&ISRescheduled=\(ISRescheduled)" + "&RejtApptSrNo=\(RejtApptSrNo)" + "&PkgPriceSrNo=\(PkgPriceSrNo)" + "&Date_Condition=\(Date_Condition)" + "&Date_pref=\(Date_pref)" + "&From_date=\(From_date)" + "&To_date=\(To_date)" + "&RescSrNo=\(RescSrNo)" + "&Remarks=\(Remarks)"
    }
    
    func schedulePostNatalCareAttendant(PersonSrNo:String,FamilySrNo:String,ISRescheduled:String,RejtApptSrNo:String,PkgPriceSrNo:String,Date_Condition:String,Date_pref:String,From_date:String,To_date:String,RescSrNo:String,Remarks:String) -> String
        
    {
        //http://mybenefits360.in/mbapi/api/v1/HomeHealthCare/ScheduleAppointmentNC?PersonSrNo=26558&FamilySrNo=5822&PkgPriceSrNo=14&Date_condition=2&Date_pref=01/01/1990&From_Date=01/11/2020&To_Date=15/11/2020&RescSrNo=0&Remarks=test
        
        return baseURL + postNatalCare_ScheduleURL + "?PersonSrNo=\(PersonSrNo)" + "&FamilySrNo=\(FamilySrNo)" + "&PkgPriceSrNo=\(PkgPriceSrNo)" + "&Date_Condition=\(Date_Condition)" + "&Date_pref=\(Date_pref)" + "&From_date=\(From_date)" + "&To_date=\(To_date)" + "&RescSrNo=\(RescSrNo)" + "&Remarks=\(Remarks)"

    }


    //http://mybenefits360.in/mbapi/api/v1/HomeHealthCare/GetAllMembers?EmpID=2212060&GroupCode=FCAT&WellSrNo=9
    func getFamilyMembersHHC_API(empId:String,groupCode:String,WellSrNo:String) -> String {
        return baseURL + getHHCFamilyMembers + "?EmpID=\(empId)" + "&GroupCode=\(groupCode)" + "&WellSrNo=\(WellSrNo)"
    }
    
        //http://mybenefits360.in/mbapi/api/v1/HomeHealthCare/ScheduleAppointmentEC?PersonSrNo=26562&FamilySrNo=5822&PkgPriceSrNo=1&RescSrNo=0&Remarks=Test
    
    func scheduleElderCareHHC_API(PersonSrNo:String,FamilySrNo:String, PkgPriceSrNo:String,RescSrNo:String, Remarks:String) -> String
        {
        return baseURL + scheduleAppointment_URL_EC + "?PersonSrNo=\(PersonSrNo)" + "&FamilySrNo=\(FamilySrNo)" + "&PkgPriceSrNo=\(PkgPriceSrNo)" + "&RescSrNo=\(RescSrNo)" + "&Remarks=\(Remarks)"
        }
    
    func scheduleDiabetes_API(PersonSrNo:String,FamilySrNo:String,PkgPriceSrNo:String,RescSrNo:String,Remarks:String) -> String {
           //http://mybenefits360.in/mbapi/api/v1/HomeHealthCare/ScheduleAppointmentDM?PersonSrNo=26557&FamilySrNo=5822&PkgPriceSrNo=1&RescSrNo=0&Remarks=Test
        return baseURL + scheduleDiabetesAppointment_URL + "?PersonSrNo=\(PersonSrNo)" + "&FamilySrNo=\(FamilySrNo)" + "&PkgPriceSrNo=\(PkgPriceSrNo)" + "&RescSrNo=\(RescSrNo)" + "&Remarks=\(Remarks)"
       }
    
    func sendMobileAddressEmailHHC_API(LINE1:String,LINE2:String,LANDMARK:String,CITY:String,STATE:String,PINCODE:String,MobileNumber:String,EmailId:String,WellSerSrno:String,PersonSrNo:String) -> String {
        //http://mybenefits360.in/mbapi/api/v1/HomeHealthCare/SavePersonInfo?LINE1=fsdfdsfdsfdsfs&LINE2=sfdsfsfdsfs&LANDMARK=mumbai&CITY=mumbai&STATE=MAH&PINCODE=400077&MobileNumber=8989998887&EmailId=test@t.com&WellSerSrno=16&PersonSrNo=26557
        return baseURL + savePersonAddressMobileEmail_URL + "?LINE1=\(LINE1)" + "&LINE2=\(LINE2)" +
            "&LANDMARK=\(LANDMARK)" +  "&CITY=\(CITY)" + "&STATE=\(STATE)" + "&PINCODE=\(PINCODE)" + "&MobileNumber=\(MobileNumber)" + "&EmailId=\(EmailId)" + "&WellSerSrno=\(WellSerSrno)" + "&PersonSrNo=\(PersonSrNo)"
    }
    
   
    
    func getScheduledHHCAppointmentsURL(type:NursingType,familySrNo:String) -> String {
        switch type {
        case .trainedAttendants:
            return baseURL + appointmentSummaryHHC_NA_URL + "?FamilySrNo=\(familySrNo)"

        case .longTerm:
            return baseURL + appointmentSummaryHHC_LT_URL + "?FamilySrNo=\(familySrNo)"

        case .shortTerm:
            return baseURL + appointmentSummaryHHC_ST_URL + "?FamilySrNo=\(familySrNo)"

        case .doctorServices:
            return baseURL + appointmentSummaryHHC_DS_URL + "?FamilySrNo=\(familySrNo)"

        case .physiotherapy:
            return baseURL + appointmentSummaryHHC_PT_URL + "?FamilySrNo=\(familySrNo)"

        case .diabetesManagement:
            return baseURL + appointmentSummaryHHC_DM_URL + "?FamilySrNo=\(familySrNo)"

        case .postNatelCare:
            return baseURL + appointmentSummaryHHC_PNC_URL + "?FamilySrNo=\(familySrNo)"

        case .elderCare:
            return baseURL + appointmentSummaryHHC_EC_URL + "?FamilySrNo=\(familySrNo)"

        default:
            return ""
            break
        }
        
    }
    
    
    //get three tabs services - Insurance, Wellness, Fitness
//    func getServicableTabs(strGroupChildSrno:String) -> String {
//        //http://mybenefits360.in/mb360api/api/Login/ShowHideButtonsforInsurance?strGroupChildSrno=1275
//        return jsonBaseURL + getServiceTabs + "?strGroupChildSrno=\(strGroupChildSrno)"
//    }
    
    //CANCEL HHC APPOINTMENT
    func cancelScheduledHHCAppointmentURL(type:NursingType,appointmentSrNo:String) -> String {
        let parameterStr = "?ApptInfoSrNo=\(appointmentSrNo)"
        switch type {
        case .trainedAttendants:
            return baseURL + cancelAppointmentHHC_NA_URL + parameterStr

        case .longTerm:
            return baseURL + cancelAppointmentHHC_LT_URL + parameterStr

        case .shortTerm:
            return baseURL + cancelAppointmentHHC_ST_URL + parameterStr

        case .doctorServices:
            return baseURL + cancelAppointmentHHC_DS_URL + parameterStr

        case .physiotherapy:
            return baseURL + cancelAppointmentHHC_PT_URL + parameterStr

        case .diabetesManagement:
            return baseURL + cancelAppointmentHHC_DM_URL + parameterStr

        case .postNatelCare:
            return baseURL + cancelAppointmentHHC_PNC_URL + parameterStr

        case .elderCare:
            return baseURL + cancelAppointmentHHC_EC_URL + parameterStr

        default:
            return ""
            break
        }
        
    }
    
    //MARK:- Covid API
    func sendCovidDetailsToServer() -> String {
        return baseURL + scheduleCovidTest_URL
    }
    
    func getCovidTestDetails(personSrNo:String) -> String {
        return baseURL + getCovidTestDetails_URL + "?EXT_PERSON_SR_NO=\(personSrNo)"
    }
}


//MARK:- FITNESS URL'S
extension APIEngine {
    func sendOnboardingDataToServerAPI() -> String {
        //http://mybenefits360.in/mb360api/api/UserProfile/UploadEmployeePhysicalInfo
        return jsonBaseURL + sendOnboardingDataToMBServer_URL
    }
    
    func getFitnessUserInfo(strEmpSrno:String) -> String {
        //http://mybenefits360.in/mb360api/api/UserProfile/GetActivoEmployeeInfo?strEmpSrno=36471
        return jsonBaseURL + getFitnessProfileInfo_URL + "?strEmpSrno=\(strEmpSrno)"
    }
    
    //get three tabs services - Insurance, Wellness, Fitness
    func getServicableTabs(strGroupChildSrno:String) -> String {
        //http://mybenefits360.in/mb360api/api/Login/ShowHideButtonsforInsurance?strGroupChildSrno=1275
        //return jsonBaseURL + getServiceTabs + "?strGroupChildSrno=\(strGroupChildSrno)"
        return jsonBaseURLPortal + getServiceTabs + "?strGroupChildSrno=\(strGroupChildSrno)"

    }
    
    
    //Wellness New 15March2023
    
    func getBuyDCPackageURL(PersonSrNo:String,EmployeeSrNo:String,PackageSrNo:String) -> String {
           return wellnessBaseURL + buyDCPackage_url + "?PersonSrNo=\(PersonSrNo)&EmployeeSrNo=\(EmployeeSrNo)&PackageSrNo=\(PackageSrNo)"
       }
    
    func getPkgPriceDMURL() -> String{ //get
            return wellnessBaseURL + getPkgPriceDM_url
        }
    
    func getEmployeeDCPackages(EmployeeSrNo:String,VendorSrNo:String) -> String {
            return wellnessBaseURL + newDCGetEmployeeDCPackages_URL + "?EmployeeSrNo=\(EmployeeSrNo)" + "&VendorSrNo=\(VendorSrNo)"
        }
    
    func getIsDCTermsAgreed(EmployeeSrNo:String,VendorSrNo:String) -> String {
            return wellnessBaseURL + newGetIsDCTermsAgreed_URL + "?EmployeeSrNo=\(EmployeeSrNo)" + "&VendorSrNo=\(VendorSrNo)"
        }
    
    
    func scheduleShortTermNursing(PersonSrNo:String,FamilySrNo:String,ISRescheduled:String,RejtApptSrNo:String,PkgPriceSrNo:String,Date_pref:String,Time_pref:String,RescSrNo:String,Remarks:String,DateCond:String,from_date:String,to_date:String) -> String {
        
        //http://mybenefits360.in/mbapi/api/v1/HomeHealthCare/ScheduleAppointmentST?PersonSrNo=26081&FamilySrNo=5680&ISRescheduled=0&RejtApptSrNo=-1&PkgPriceSrNo=2&Date_pref=22-Oct-2020&Time_pref=02:30:PM&RescSrNo=0&Remarks=
    //http://wellness.mybenefits360.com/mbapiv2/api/v1/HomeHealthCare/ScheduleAppointmentST?PersonSrNo=60641&FamilySrNo=17128&ISRescheduled=0&RejtApptSrNo=-1&PkgPriceSrNo=1&Date_Condition=1&Date_pref=10/01/2023&From_date=01-01-1990&To_date=01-01-1990&RescSrNo=0&Remarks=Test
        
        return wellnessBaseURL + scheduleShortTermNursing_URL + "?PersonSrNo=\(PersonSrNo)" + "&FamilySrNo=\(FamilySrNo)" + "&ISRescheduled=\(ISRescheduled)" + "&RejtApptSrNo=\(RejtApptSrNo)" + "&PkgPriceSrNo=\(PkgPriceSrNo)" + "&Date_Condition=\(DateCond)" + "&Date_pref=\(Date_pref)" + "&Time_pref=\(Time_pref)" +  "&RescSrNo=\(RescSrNo)" + "&Remarks=\(Remarks)"
    }
    
    func acceptInsertDCTermsAgreeURL() -> String { //post
            return wellnessBaseURL + acceptInsertDCTermsAgree_url
        }
}

//Commented 29 april 2021
//enum NursingType {
//    case shortTerm
//    case longTerm
//    case trainedAttendants
//    case doctorServices
//    case physiotherapy
//    case diabetesManagement
//    case postNatelCare
//    case elderCare
//}


/*
 
 if(isConnectedToNetWithAlert())
 {
 
 let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
 if(userArray.count>0)
 {
 m_employeedict=userArray[0]
 
 var oe_group_base_Info_Sr_No = String()
 var groupChildSrNo = String()
 
 if let empNo = m_employeedict?.oe_group_base_Info_Sr_No
 {
 oe_group_base_Info_Sr_No = String(empNo)
 }
 if let groupChlNo = m_employeedict?.groupChildSrNo
 {
 groupChildSrNo=String(groupChlNo)
 }
 
 
 let url = APIEngine.shared.getAdminSettingsJsonURL(grpchildsrno:"909", oegrpbasinfosrno: "280")
 let urlreq = NSURL(string : url)
 
 //self.showPleaseWait(msg: "")
 print(url)
 
 EnrollmentServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (data, error) in
 
 if error != nil
 {
 print("error ",error!)
 //self.hidePleaseWait()
 self.displayActivityAlert(title: m_errorMsg)
 }
 else
 {
 // self.hidePleaseWait()
 print("found Admin Setting....")
 
 do {
 print("Started parsing Admin Settings Session...")
 print(data)
 
 if let jsonResult = data as? NSDictionary
 {
 print("Admin Data Found")
 if let msgDict = jsonResult.value(forKey: "message") as? NSDictionary {
 if let status = msgDict.value(forKey: "Status") as? Bool {
 
 if status == true
 {
 }
 else {
 //No Data found
 }
 }//status
 }//msgDict
 }//jsonResult
 }//do
 
 catch let JSONError as NSError
 {
 print(JSONError)
 }
 }//else
 }//server call
 }//userArray
 }
 
 */
