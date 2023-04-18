//
//  CovidTestBookingVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 11/11/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit
import Alamofire

//Schedule Covid Test Booking
class CovidTestBookingTVC: UITableViewController {
    
    @IBOutlet weak var testInformationCell: UITableViewCell!
    @IBOutlet weak var lbl_TI_UserName: UILabel!
    @IBOutlet weak var lbl_TI_typeOfTest: UILabel!
    @IBOutlet weak var lbl_TI_ReasonForTest: UILabel!
    
    @IBOutlet weak var lbl_TI_DiagnoticsCenter: UILabel!

    //Display Documents
    @IBOutlet weak var viewUploadedDocs: UIView!
    @IBOutlet weak var lblFirstDocument: UILabel!
    @IBOutlet weak var lblSecondDocument: UILabel!
    @IBOutlet weak var img_TI_First: UIImageView!
    @IBOutlet weak var img_TI_Second: UIImageView!
    @IBOutlet weak var heightForUploadsView: NSLayoutConstraint!
    @IBOutlet weak var viewFirst_TI_BackView: UIView!
    @IBOutlet weak var viewSecond_TI_BackView: UIView!
    
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var btnSchedule: UIButton!
    @IBOutlet weak var btnUploadID: UIButton!
    @IBOutlet weak var btnUploadPrescription: UIButton!
    var remarkText = ""
    
    @IBOutlet weak var btnAadhaar: UIButton!
    @IBOutlet weak var btnPassport: UIButton!
    
    @IBOutlet weak var txtPincode: SkyFloatingLabelTextField!
    @IBOutlet weak var btnRTPCR: UIButton!
    @IBOutlet weak var btnAntigen: UIButton!
    @IBOutlet weak var btnAntibody: UIButton!
    
    @IBOutlet weak var btnDeletePrescription: UIButton!
    
    @IBOutlet weak var heightForSelectedImageView: NSLayoutConstraint!
    
    @IBOutlet weak var heightForSelectId: NSLayoutConstraint!
    //    @IBOutlet weak var btnDeletePrescription: UIButton!
    @IBOutlet weak var imgPrescription: UIImageView!
    @IBOutlet weak var btnDeleteId: UIButton!
    @IBOutlet weak var imgID: UIImageView!
    //First
    @IBOutlet weak var txtDob: SkyFloatingLabelTextField!
    @IBOutlet weak var txtGender: SkyFloatingLabelTextField!
    @IBOutlet weak var txtName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAddress: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCity: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLocation: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtMobileNumber: SkyFloatingLabelTextField!
    //Second
    @IBOutlet weak var txtEmailId: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAge: SkyFloatingLabelTextField!
    
    @IBOutlet weak var selectedPrescriptionView: UIView!
    @IBOutlet weak var selectedIdView: UIView!
    
    
    
    var isPrescriptionSelected = false
    var idSelected = false
    var isPrescription = false //for set image
    var personalIdType = 1 //set aadhar/passport
    var idType = "1" //for 1 aadhar, 2 passport
    var personSerialNumber = ""
    var prescriptionImgFormat = ".JPG"
    var idImgFormat = ".JPG"
    var isScheduled = false
    
    var isLoaded = false
    
    var covidTestStatus = "" //if TestStatus ==1 then Employee is requested for test. if TestStatus ==2 then Test Request is confirm and Diagnostic center is asiigned.if TestStatus==3 then Test is completed.User can apply for test.if test==0 then employee does not applied for test yet.
    //Enable button for status 3 & 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.heightForUploadsView.constant = 0.0
        self.viewFirst_TI_BackView.isHidden = true
        self.viewSecond_TI_BackView.isHidden = true

        self.navigationItem.title = "Covid - 19 Test Registration"
        print("In \(navigationItem.title ?? "") CovidTestBookingTVC")

       // self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.txtView.layer.cornerRadius = 6.0
        self.txtView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.txtView.layer.borderWidth = 1.0
        self.txtView.text = remarkText
        //self.tableView.layer.borderColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        //self.tableView.layer.borderWidth = 1.2
        
        setData()
        
        btnSchedule.makeHHCButton()
        btnUploadPrescription.makeHHCButton()
        btnUploadID.makeHHCButton()
        heightForSelectedImageView.constant = 0
        selectedPrescriptionView.isHidden = true
        
        heightForSelectId.constant = 0
        selectedIdView.isHidden = true
        
        //self.view.backgroundColor = UIColor.white
        
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        if #available(iOS 13.0, *) {
            let notiBtn =  UIBarButtonItem(image:UIImage(systemName: "info.circle.fill") , style: .plain, target: self, action: #selector(notificationTapped))
            navigationItem.rightBarButtonItems = [notiBtn]

        } else {
            // Fallback on earlier versions
        }

        
        self.navigationController?.navigationBar.applyGradient()
        self.navigationController?.navigationBar.navBarDropShadow()
        self.navigationController?.navigationBar.changeFont()
        self.navigationController?.navigationBar.isHidden = false
        addDoneButtonOnKeyboard()
        getFamilyDetailsFromServer()
        
        
        //add gestures
        self.img_TI_Second.isUserInteractionEnabled = true
        self.img_TI_First.isUserInteractionEnabled = true
        
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(uploadPrescriptionTapped1(_:)))
        self.img_TI_First.addGestureRecognizer(gesture1)
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(uploadIDTapped1(_:)))
        self.img_TI_Second.addGestureRecognizer(gesture2)

    }
    
    @objc func uploadPrescriptionTapped1(_ sender: UITapGestureRecognizer) {
        if self.img_TI_First.image != nil {
        let vc = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"ImageViewerVC") as! ImageViewerVC
        vc.image = self.img_TI_First.image ?? UIImage()
        //vc.imgView.image = self.img_TI_First.image
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func uploadIDTapped1(_ sender: UITapGestureRecognizer) {
        if self.img_TI_Second.image != nil {
        let vc = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"ImageViewerVC") as! ImageViewerVC
        vc.image = self.img_TI_Second.image ?? UIImage()
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func notificationTapped() {
        let vc  = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"CovidInstructionsVC") as! CovidInstructionsVC

        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    //MARK:- Add Done Button On Keyboard
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = Color.buttonBackgroundGreen.value
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        // doneToolbar.tintColor = #colorLiteral(red: 0.2431372549, green: 0.8509803922, blue: 0.6941176471, alpha: 1)
        
        txtLocation.inputAccessoryView = doneToolbar
        txtAddress.inputAccessoryView = doneToolbar
        txtCity.inputAccessoryView = doneToolbar
        txtMobileNumber.inputAccessoryView = doneToolbar
        txtEmailId.inputAccessoryView = doneToolbar
        txtPincode.inputAccessoryView = doneToolbar
        txtView.inputAccessoryView = doneToolbar
        //txtFlatNo.inputAccessoryView = doneToolbar
        //txtArea.inputAccessoryView = doneToolbar
        //txtLandmark.inputAccessoryView = doneToolbar
        //txtState.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonAction(){
        self.view.endEditing(true)
    }
    
    
    
    
    private func setData() {
        print("##GETPROFILEDATA...")
        let m_profilearray =  DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode:"GMC", relationName: "EMPLOYEE")
        
        var m_profileDict = PERSON_INFORMATION()
        
        if m_profilearray.count > 0 {
            m_profileDict = m_profilearray[0]
        }
        

        
        print(m_profileDict)
        txtName.text=m_profileDict.personName ?? ""
        
        
        if m_profileDict.gender?.lowercased() == "male"
        {
            txtGender.text = "Male"
        }
        else {
            txtGender.text = "Female"
        }
        
        txtDob.text = m_profileDict.dateofBirth
        
        let age = m_profileDict.age.description
        txtAge.text = "\(age) Years"
        txtEmailId.text = m_profileDict.emailID ?? ""
        txtMobileNumber.text = m_profileDict.cellPhoneNUmber ?? ""

        
        let empArray = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        if empArray.count > 0 {
            txtEmailId.text = empArray[0].officialEmailID
        }
        
        
    }
    
    @objc func backTapped() {
        //self.navigationController?.popViewController(animated: true)
         self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnScheduleTapped(_ sender: UIButton) {
        
        if txtMobileNumber.text?.count ?? 0 == 0 {
            self.displayActivityAlert(title: "Please Enter Mobile Number")
        }
        else if txtMobileNumber.text?.count ?? 0 != 10 {
            self.displayActivityAlert(title: "Please Enter Valid 10 Digit Mobile Number")
        }
        else if txtEmailId.text?.count ?? 0 == 0 {
            self.displayActivityAlert(title: "Please Enter E-Mail ID")
        }
        else if !(isValidEmail(emailStr:txtEmailId.text!)) {
            self.displayActivityAlert(title: "Please Enter Valid E-Mail ID")
        }
        else if txtAddress.text?.count ?? 0 == 0 {
            self.displayActivityAlert(title: "Please Enter Address")
        }
        else if txtCity.text?.count ?? 0 == 0 {
            self.displayActivityAlert(title: "Please Enter City")
        }
        else if txtLocation.text?.count ?? 0 == 0 {
            self.displayActivityAlert(title: "Please Enter Location")
        }
        else if txtPincode.text?.count ?? 0 == 0 {
            self.displayActivityAlert(title: "Please Enter Pincode")
        }
        else if txtPincode.text?.count ?? 0 != 6 {
            self.displayActivityAlert(title: "Please Enter Valid Pincode")
        }
//        else if !idSelected {
//            self.displayActivityAlert(title: "Please Select Aadhaar/Passport Id")
//        }
        else if txtView.text?.count ?? 0 == 0 {
            self.displayActivityAlert(title: "Please Enter Reason For Test")
        }
        else {
           scheduleCovidTestAPI()
        }
    }
    
    //MARK:- Schedule API
    private func scheduleCovidTestAPI() {
        /*
         {
         "pI_EXT_PERSON_SR_NO": "25741",
         "pI_REASON_FOR_TESTING": "TEst",
         "pI_TYPE_OF_TEST": "1",
         "pI_TEST_LOCATION": "Pune",
         "pI_EMAIL": "TESTING@SEMANTICTECH.IN",
         "pI_CELLPHONE_NUMBER": "98745821458",
         "emp_Name": "Test",
         "emp_Address": "PUNE",
         "pI_LOCATION": "Pune",
         "pI_CITY": "Pune",
         "pI_PINCODE": "400124",
         "pI_EXTGRPPEROTHTESTINFO_SR_NO": null,
         "pI_PRESCRIPTION_PATH": "pI_PRESCRIPTION_PATH",
         "pI_PERSONAL_ID_TYPE":"2",
         "pI_PERSONAL_ID_PATH": "pI_PERSONAL_ID_PATH",
         "prescriptionFile": "precn.png",
         "uploadIdFile": "uid.png"
         }
         */
        
        
        
        let typeOfTest = "1"
        if personSerialNumber != "" {
            var prescriptionFileName = ""
            var idFileName = ""
            if isPrescriptionSelected {
                prescriptionFileName = "precn" + "\(prescriptionImgFormat)"
            }
            if idSelected {
               idFileName = "uid" + "\(idImgFormat)"
            }
            
        //add Pincode,pI_EXT_PERSON_SR_NO,pI_EXTGRPPEROTHTESTINFO_SR_NO,
        let dictionary = ["pI_EXT_PERSON_SR_NO":personSerialNumber,
                          "pI_REASON_FOR_TESTING":txtView.text!,
                          "pI_TYPE_OF_TEST": typeOfTest,
                          "pI_TEST_LOCATION": "1",
                          "pI_EMAIL": txtEmailId.text!,
                          "pI_CELLPHONE_NUMBER": txtMobileNumber.text!,
                          "emp_Name": txtName.text!,
                          "emp_Address": txtAddress.text ?? "",
                          "pI_LOCATION": txtLocation.text ?? "",
                          "pI_CITY": txtCity.text ?? "",
                          "pI_PINCODE": txtPincode.text ?? "",
                          "pI_EXTGRPPEROTHTESTINFO_SR_NO": "",
                          "pI_PRESCRIPTION_PATH": "",
                          "pI_PERSONAL_ID_TYPE":personalIdType.description,
                          "pI_PERSONAL_ID_PATH": "",
                          "prescriptionFile": prescriptionFileName,
                          "uploadIdFile": idFileName]
            print(dictionary)
        self.uploadRegistrationDataToServer(parameters: dictionary as NSDictionary)
        }
        else {
            print("Person Serial Number Not Found")
        }
    }
    
    @IBAction func uploadID(_ sender: UIButton)
    { //top 2 buttons
        if sender.tag == 0 {
            btnAadhaar.setImage(UIImage(named: "radio_selected"), for: .normal)
            btnPassport.setImage(UIImage(named: "radio"), for: .normal)
            personalIdType = 1
        }
        else {
            btnPassport.setImage(UIImage(named: "radio_selected"), for: .normal)
            btnAadhaar.setImage(UIImage(named: "radio"), for: .normal)
            personalIdType = 2
            
        }
    }
    
    @IBAction func testingType(_ sender: UIButton)
    {//bottom 3 buttons
        if sender.tag == 0 {
            btnRTPCR.setImage(UIImage(named: "radio_selected"), for: .normal)
            btnAntigen.setImage(UIImage(named: "radio"), for: .normal)
            btnAntibody.setImage(UIImage(named: "radio"), for: .normal)
            
        }
        else if sender.tag == 1 {
            btnRTPCR.setImage(UIImage(named: "radio"), for: .normal)
            btnAntigen.setImage(UIImage(named: "radio_selected"), for: .normal)
            btnAntibody.setImage(UIImage(named: "radio"), for: .normal)
        }
        else {
            btnRTPCR.setImage(UIImage(named: "radio"), for: .normal)
            btnAntigen.setImage(UIImage(named: "radio"), for: .normal)
            btnAntibody.setImage(UIImage(named: "radio_selected"), for: .normal)
            
        }
    }
    
    @IBAction func deletePrescriptionTapped(_ sender: UIButton) {
        self.imgPrescription.image = UIImage(named: "")
        self.btnUploadPrescription.setTitle("Upload Prescription", for: .normal)
        selectedPrescriptionView.isHidden = true
        heightForSelectedImageView.constant = 0.0
        
        isPrescriptionSelected = false
        
        self.tableView.reloadData()
    }
    
    @IBAction func deleteIDTapped(_ sender: UIButton) {
        self.imgID.image = UIImage(named: "")
        self.btnUploadID.setTitle("Upload ID", for: .normal)
        selectedIdView.isHidden = true
        heightForSelectId.constant = 0.0
        idSelected = false
        self.tableView.reloadData()
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if !isLoaded {
            return 0
        }
        else {
            
            
            if indexPath.row == 14 {
                return 15
            }
            else {
                if isScheduled {
                    if indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12 {
                        return 0
                    }
                    return UITableViewAutomaticDimension
                }
                else {
                    if indexPath.row == 4 && isPrescriptionSelected {
                        return 50
                    }
                    else if indexPath.row == 13 {
                        return 0
                    }
                    return UITableViewAutomaticDimension
                }
                
            }
        }
    }
    
    
    
    
    @IBAction func uploadPrescriptionTapped(_ sender: UIButton) {
        isPrescription = true
        openGallary()
    }
    
    @IBAction func uploadIDTapped(_ sender: UIButton) {
        isPrescription = false
        openGallary()
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
}

//MARK:- Image Selection
extension CovidTestBookingTVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
    
    func openGallary()
    {
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            
            
            imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            imagePicker.allowsEditing = true
            
            
            self.getTopMostViewController()?.present(imagePicker, animated: true, completion: nil)
        }
        //self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        var fileURL: URL!
        
        if #available(iOS 11.0, *) {
            fileURL = info[UIImagePickerControllerImageURL] as? URL
            
        } else
        {
            // Fallback on earlier versions
        }
        
        let assetPath = info[UIImagePickerControllerReferenceURL] as! NSURL
        if (assetPath.absoluteString?.hasSuffix("JPG"))! {
            print("JPG")
            if isPrescription {
                prescriptionImgFormat = ".JPG"
            }
            else {
                idImgFormat = ".JPG"
            }
        }
        else if (assetPath.absoluteString?.hasSuffix("PNG"))! {
            print("PNG")
            if isPrescription {
                prescriptionImgFormat = ".PNG"
            }
            else {
                idImgFormat = ".PNG"
            }
        }
        else {
            print("Unknown")
        }

        
        let uploadedImage = image
        if isPrescription {
            imgPrescription.image = uploadedImage
            selectedPrescriptionView.isHidden = false
            heightForSelectedImageView.constant = 55.0
            self.btnUploadPrescription.setTitle("Change Prescription", for: .normal)
            isPrescriptionSelected = true
        }
        else
        {
            idSelected = true
            imgID.image = image
            selectedIdView.isHidden = false
            heightForSelectId.constant = 55.0
            self.btnUploadID.setTitle("Change ID", for: .normal)
        }
        self.tableView.reloadData()
        //       uploadProfileImageToServer()
        //isSelected = true
    }
    
}

//MARK:- API CALL
extension CovidTestBookingTVC {
    func uploadRegistrationDataToServer(parameters:NSDictionary) {
        self.showPleaseWait(msg: "Please Wait")
        
        var paramStr = ""
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: parameters,
            options: .prettyPrinted
            ),
            let theJSONText = String(data: theJSONData,
                                     encoding: String.Encoding.ascii) {
            
            paramStr = theJSONText
            print("JSON string = \n\(theJSONText)")
            print(paramStr.data(using: String.Encoding.utf8)!)
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(paramStr.data(using: String.Encoding.utf8)!, withName: "DataObj")
            
            //set Prescription Image
            if self.isPrescriptionSelected {
                multipartFormData.append(UIImageJPEGRepresentation(self.imgPrescription.image!, 0.5)!, withName: "precn", fileName: "precn.jpg", mimeType: "image/jpg")
            }
            //"prescriptionFile": "precn.png",
           // "uploadIdFile": "uid.png"

            //Set ID Document
            if self.idSelected {
                multipartFormData.append(UIImageJPEGRepresentation(self.imgID.image!, 0.5)!, withName: "uid", fileName: "uid.jpg", mimeType: "image/jpg")
            }
            
        }, to:APIEngine.shared.sendCovidDetailsToServer())
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                self.hidePleaseWait()
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    //self.delegate?.showSuccessAlert()
                    print(response.request)  // original URL request
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                       if let dictionaryRes = JSON as? NSDictionary
                       { if let status = dictionaryRes["STATUS"] as? String {
                        if status == "Success" {
                            self.displayActivityAlert(title: "Your request is submitted successfully")
                        }
                        else {
                            self.displayActivityAlert(title: m_errorMsg)
                        }
                        }
                       else {
                        self.displayActivityAlert(title: m_errorMsg)

                        }
                        }
                        else {
                        self.displayActivityAlert(title: m_errorMsg)

                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.dismiss(animated: true, completion: nil)
                            //self.navigationController?.popViewController(animated: true)
                        }
                        /*
                        if let errorDict = dictionaryRes?["message"] as? NSDictionary {
                            let status = errorDict["Status"] as? Bool
                            if status == true
                            {
                                if let msg = errorDict["Message"] as? String {
                                    self.displayActivityAlert(title: msg)
                                }
                                 DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                }
                            }
                            else {
                                
                                if let msg = errorDict["Message"] as? String {
                                    self.displayActivityAlert(title: "Failed to upload documents.")
                                }
                                self.dismiss(animated: true, completion: nil)
                                
                            }
                        }//if let
                        
                        */
                    }
                }
                
            case .failure(let encodingError):
                self.hidePleaseWait()
                //self.delegate?.showFailAlert()
                print(encodingError)
            }
            
        }
        
    }
    
}


extension CovidTestBookingTVC {
        //MARK:- Get Data From Server
         func getFamilyDetailsFromServer() {
         
            guard let orderMasterNo = UserDefaults.standard.value(forKey: "OrderMasterNo") else {
                return
            }
            
            var m_employeedict : EMPLOYEE_INFORMATION?
            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
            m_employeedict=userArray[0]
            var empidNo = String()
            
            if let empID = m_employeedict?.empIDNo
            {
                empidNo=String(empID)
            }
            
            print(empidNo)
            let url = APIEngine.shared.getFamilyMembersHHC_API(empId: empidNo, groupCode:self.getGroupCode(), WellSrNo: "10")
            print(url)
            ServerRequestManager.serverInstance.getRequestDataFromServerWithoutLoader(url: url, view: self) { (response, error) in
                
                if let messageDictionary = response?["message"].dictionary
                {
                    if let status = messageDictionary["Status"]?.bool
                    {
                        if status == true {
                            if let personArray = response?["FamilyMembers"].arrayValue {
                                //self.personDetailsArray.removeAll()
                                
                                for person in personArray {
                                    
                                    let modelObj = FamilyDetailsModelHHC.init(PersonName: person["PERSON_NAME"].stringValue, DateOfBirth: person["DOB"].stringValue, Gender: person["GENDER"].stringValue, RelationID: person["RELATIONID"].stringValue, RelationName: person["RELATION_NAME"].stringValue, EXT_EMPLOYEE_SR_NO: person["EXT_EMPLOYEE_SR_NO"].stringValue, ExtPersonSRNo: person["EXT_PERSON_SR_NO"].stringValue, CellPhoneNumber: person["CELLPHONE_NUMBER"].stringValue, EmailID: person["EMAIL_ID"].stringValue, IS_ADDRESS_SAVED: person["IS_ADDRESS_SAVED"].stringValue,AGE:person["AGE"].stringValue)
                                        
                                    if modelObj.RelationName?.lowercased() == "employee" || modelObj.RelationName?.lowercased() == "self" {
                                        self.personSerialNumber = modelObj.ExtPersonSRNo ?? ""
                                        self.getCovidTestDetailsFromServer()
                                        break
                                    }
                                }
                            }
                        }
                        else {
                            //let msg = messageDictionary["Message"]?.string
                            self.displayActivityAlert(title: m_errorMsg )
                        }
                    }else {
                        self.displayActivityAlert(title: m_errorMsg )
                    }
                }else {
                    self.displayActivityAlert(title: m_errorMsg )
                }//msgDic
            }
        }
}


//MARK:- Get Covid Test Details
extension CovidTestBookingTVC {
    func getCovidTestDetailsFromServer() {
        if personSerialNumber != "" {
            let url = APIEngine.shared.getCovidTestDetails(personSrNo:personSerialNumber)
            
            print(url)
            ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response1, error) in
                if let messageDictionary = response1?["message"].dictionary
                {
                    
                    if let status = messageDictionary["Status"]?.bool
                    {
                        if status == true {
                            if let response = response1?["TestInfo"].dictionary {
                                
                                if let testStatus = response["TestStatus"]?.string {
                                    self.covidTestStatus = testStatus
                                    
                                    //if TestStatus ==1 then Employee is requested for test. if TestStatus ==2 then Test Request is confirm and Diagnostic center is asiigned.if TestStatus==3 then Test is completed.User can apply for test.if test==0 then employee does not applied for test yet.
                                    //Enable button for status 3 & 0
                                    
                                    switch self.covidTestStatus {
                                    case "0": //does not applied for test yet
                                        self.isScheduled = false
                                        // self.btnSchedule.makeRoundedBorderGreen()
                                        break
                                    case "1": //requested for test
                                        self.isScheduled = true
                                        
                                        //self.btnSchedule.disabledButton()
                                        break
                                    case "2": //Test Request is confirm and Diagnostic center is asiigned
                                        // self.btnSchedule.disabledButton()
                                        self.isScheduled = true
                                        
                                        break
                                    case "3": //Test is completed.User can apply for test
                                        // self.btnSchedule.makeRoundedBorderGreen()
                                        self.isScheduled = false
                                        
                                        break
                                    default:
                                        break
                                    }
                                }
                                
                                if self.covidTestStatus == "1" || self.covidTestStatus == "2" {
                                    self.testInformationCell.isHidden = false
                                    //Add if condition for testStatus
                                    if let PI_REASON_FOR_TESTING = response["PI_REASON_FOR_TESTING"]?.string {
                                        self.txtView.text = PI_REASON_FOR_TESTING
                                        self.lbl_TI_ReasonForTest.text = "Reason for test : " + PI_REASON_FOR_TESTING
                                    }
                                    
                                    if let PI_EMAIL = response["PI_EMAIL"]?.string {
                                        self.txtEmailId.text = PI_EMAIL
                                    }
                                    
                                    if let PI_CELLPHONE_NUMBER = response["PI_CELLPHONE_NUMBER"]?.string {
                                        self.txtMobileNumber.text = PI_CELLPHONE_NUMBER
                                    }
                                    
                                    if let Emp_Name = response["Emp_Name"]?.string {
                                        self.txtName.text = Emp_Name
                                       // self.lbl_TI_UserName.text = "Name : " + Emp_Name
                                    }
                                    
                                    if let Emp_Address = response["Emp_Address"]?.string {
                                        self.txtAddress.text = Emp_Address
                                    }
                                    
                                    if let PI_LOCATION = response["PI_LOCATION"]?.string {
                                        self.txtLocation.text = PI_LOCATION
                                    }
                                    
                                    if let PI_CITY = response["PI_CITY"]?.string {
                                        self.txtCity.text = PI_CITY
                                    }
                                    
                                    if let PI_PINCODE = response["PI_PINCODE"]?.string {
                                        self.txtPincode.text = PI_PINCODE
                                    }
                                    
                                    if let PI_PRESCRIPTION_IMAGE = response["PI_PRESCRIPTION_PATH"]?.string {
                                        //set image to prescription
if PI_PRESCRIPTION_IMAGE != "" && !(PI_PRESCRIPTION_IMAGE.contains("/NA")) {
                                            self.selectedIdView.isHidden = false
                                            self.viewFirst_TI_BackView.isHidden = false
                                            self.img_TI_First.sd_setImage(with: URL(string: PI_PRESCRIPTION_IMAGE), placeholderImage: UIImage(named: ""))
                                            //cell.imageHeight.constant = 130
                                            self.heightForUploadsView.constant = 100.0
                                        }
                                        else {
                                            self.viewFirst_TI_BackView.isHidden = true
                                        }
                                    }
                                    else {
                                        self.viewFirst_TI_BackView.isHidden = true
                                    }
                                    
                                    if let PI_PERSONAL_ID_IMAGE = response["PI_PERSONAL_ID_PATH"]?.string {
                                        //set image to ID
                                        if PI_PERSONAL_ID_IMAGE != "" && !(PI_PERSONAL_ID_IMAGE.contains("/NA")) {
                                            self.selectedIdView.isHidden = false
                                            self.viewSecond_TI_BackView.isHidden = false

                                            self.img_TI_Second.sd_setImage(with: URL(string: PI_PERSONAL_ID_IMAGE), placeholderImage: UIImage(named: ""))
                                            self.heightForUploadsView.constant = 100.0
                                        }
                                        else {
                                            self.viewSecond_TI_BackView.isHidden = true
                                        }
                                    }
                                    else {
                                        self.viewSecond_TI_BackView.isHidden = true
                                    }
                                    
                                    if self.covidTestStatus == "2" {
                                        if let DIAG_CENTRE_NAME = response["DIAG_CENTRE_NAME"]?.string {
                                            self.lbl_TI_DiagnoticsCenter.text = "Diagnostic Center : " + DIAG_CENTRE_NAME
                                        }
                                        //DIAG_CENTRE_NAME
                                    }
                                    //Disable TextFields and clear TextField Line Color
                                    self.txtView.isUserInteractionEnabled = false
                                    self.txtEmailId.isUserInteractionEnabled = false
                                    self.txtMobileNumber.isUserInteractionEnabled = false
                                    self.txtAddress.isUserInteractionEnabled = false
                                    self.txtLocation.isUserInteractionEnabled = false
                                    self.txtCity.isUserInteractionEnabled = false
                                    self.txtPincode.isUserInteractionEnabled = false
                                    self.btnAadhaar.isUserInteractionEnabled = false
                                    self.btnPassport.isUserInteractionEnabled = false
                                    self.btnUploadID.isUserInteractionEnabled = false
                                    self.btnUploadPrescription.isUserInteractionEnabled = false
                                    self.txtEmailId.lineColor = UIColor.clear
                                    self.txtMobileNumber.lineColor = UIColor.clear
                                    self.txtAddress.lineColor = UIColor.clear
                                    self.txtLocation.lineColor = UIColor.clear
                                    self.txtCity.lineColor = UIColor.clear
                                    self.txtPincode.lineColor = UIColor.clear
                                }
                                
                                self.isLoaded = true
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }//msgDic
        }
    }
}
 /*
     "TestStatus": "1",
     "PI_EXT_PERSON_SR_NO": "26089",
     "PI_REASON_FOR_TESTING": "High Fever",
     "PI_TYPE_OF_TEST": "Antigen",
     "PI_TEST_LOCATION": "1",
     "PI_EMAIL": "pranit.hirve@gmail.com",
     "PI_CELLPHONE_NUMBER": "9665664202",
     "Emp_Name": "Pranit Hirve",
     "Emp_Address": "SR Nagar",
     "PI_LOCATION": "Pimple Gurav",
     "PI_CITY": "Pune",
     "PI_PINCODE": null,
     "PI_EXTGRPPEROTHTESTINFO_SR_NO": "358",
     "PI_PRESCRIPTION_PATH": null,
     "PI_PRESCRIPTION_IMAGE": null,
     "PI_PERSONAL_ID_TYPE": null,
     "PI_PERSONAL_ID_PATH": null,
     "PI_PERSONAL_ID_IMAGE": null,
     "EXT_GRP_PER_C19TEST_DC_SR_NO": null,
     "EXT_PERSON_SR_NO": null,
     "DIAG_CENTRE_NAME": null,
     "CITY_NAME": null,
     "LOCATION_NAME": null,
     "DIAG_CEN_ADDRESS": null,
     "PIN_CODE": null,
     "EXT_GRP_PER_C19TEST_TIME_SR_NO": null,
     "TEST_DATE": null,
     "TEST_TIME": null,
     "REMARK": null
 */


extension CovidTestBookingTVC {
//    func colorSection(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("TEST COVID 19")
//        let cornerRadius: CGFloat = 0.0
//        cell.backgroundColor = UIColor.red
//        let layer: CAShapeLayer = CAShapeLayer()
//        let pathRef: CGMutablePath = CGMutablePath()
//        //dx leading an trailing margins
//        let bounds: CGRect = cell.bounds.insetBy(dx: 0, dy: 0)
//        var addLine: Bool = false
//
//        if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
//            pathRef.__addRoundedRect(transform: nil, rect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
//        } else if indexPath.row == 0 {
//            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
//            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY),
//                           tangent2End: CGPoint(x: bounds.midX, y: bounds.minY),
//                           radius: cornerRadius)
//
//            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY),
//                           tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY),
//                           radius: cornerRadius)
//            pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
//            addLine = true
//        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
//            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
//            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY),
//                           tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY),
//                           radius: cornerRadius)
//
//            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY),
//                           tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY),
//                           radius: cornerRadius)
//            pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
//        } else {
//            pathRef.addRect(bounds)
//            addLine = true
//        }
//
//        layer.path = pathRef
//        layer.strokeColor = UIColor.lightGray.cgColor
//        layer.lineWidth = 0.5
//        layer.fillColor = UIColor.orange.cgColor
//
//        if addLine == true {
//            let lineLayer: CALayer = CALayer()
//            let lineHeight: CGFloat = (1 / UIScreen.main.scale)
//            lineLayer.frame = CGRect(x: bounds.minX, y: bounds.size.height - lineHeight, width: bounds.size.width, height: lineHeight)
//            lineLayer.backgroundColor = UIColor.clear.cgColor
//            layer.addSublayer(lineLayer)
//        }
//
//        let backgroundView: UIView = UIView(frame: bounds)
//        backgroundView.layer.insertSublayer(layer, at: 0)
//        backgroundView.backgroundColor = .green
//        cell.backgroundView = backgroundView
//    }
}

