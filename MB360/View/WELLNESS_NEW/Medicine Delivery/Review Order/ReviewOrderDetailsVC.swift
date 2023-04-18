//
//  ReviewOrderDetailsVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 17/10/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices

class ReviewOrderDetailsVC: UIViewController {

    @IBOutlet weak var lblMemberName: UILabel!
    @IBOutlet weak var lblMobileNo: UILabel!
    @IBOutlet weak var lblEmailId: UILabel!
    @IBOutlet weak var lblPrescription: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblUserAddress: UILabel!
    
    @IBOutlet weak var lblRemarks: UILabel!
    
    @IBOutlet weak var txtViewRemarks: UITextView!
    
    @IBOutlet weak var txtMemberName: UITextField!
    
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var txtEmailId: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var btnCart: UIButton!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRIght: UIButton!
    
    var addressObj : AddressModel_MD?
    var memberInfoObj : FamilyDetailsModel?
    var imageArray = [UIImage]()

    var imgIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Review Order"
        print("In \(self.title ?? "") ReviewOrderDetailsVC")
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn

        txtMemberName.setBottomBorder()
        txtEmailId.setBottomBorder()
        txtMobileNo.setBottomBorder()
        txtEmailId.setBottomBorder()
        
        lblUserAddress.setBottomBorder()
        
        setLabelColor(label: lblAddress)
        setLabelColor(label: lblMemberName)
        setLabelColor(label: lblMobileNo)
        setLabelColor(label: lblEmailId)
        setLabelColor(label: lblRemarks)
        setLabelColor(label: lblPrescription)

        lblUserAddress.text = String(format: "%@,%@,%@,%@,%@",addressObj?.FlatHouse ?? "",addressObj?.Area ?? "", addressObj?.Landmark ?? "",addressObj?.Pincode ?? "",addressObj?.City ?? "",addressObj?.State ?? "")
        txtMobileNo.text = addressObj?.Mobile
        txtEmailId.text = addressObj?.EmailId
        txtMemberName.text = memberInfoObj?.PersonName
        
        self.backgroundView.layer.cornerRadius = 4.0
        self.txtViewRemarks.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.txtViewRemarks.layer.borderWidth = 1.0
        
        self.btnCart.makeCicular()
        self.btnCart.backgroundColor = Color.buttonBackgroundGreen.value
        
        if imageArray.count > 0 {
            imgView.image = imageArray[0]
            btnLeft.isHidden = true
        }
        
        if imageArray.count <= 1 {
            btnLeft.isHidden = true
            btnRIght.isHidden = true
        }
    }
    
    private func setLabelColor(label:UILabel)
    {
        label.textColor = Color.fontColor.value
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterNotifications()
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        scrollView.contentInset.bottom = 0
    }
    
    @objc private func keyboardWillShow(notification: NSNotification){
        guard let keyboardFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        //scrollView.scrollToBottom(animated: true)
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }
    
    @objc private func keyboardWillHide(notification: NSNotification){
        scrollView.contentInset.bottom = 0
    }
    
    //MARK:- Left Button
    @IBAction func leftButtonDidTapped(_ sender: Any) {
        print(imgIndex)
//        var tag = btnLeft.tag
//        if tag < imageArray.count && tag > 0 {
//            tag = tag - 1
//            imgView.image = self.imageArray[tag]
//            btnLeft.tag = tag
//            btnRIght.tag = tag
//        }
      
        let index = imgIndex - 1
        if index <= imageArray.count - 1 && index >= 0 {
            imgView.image = imageArray[index]
            imgIndex = index
        }
        
        if imgIndex == 0 {
            btnLeft.isHidden = true
            btnRIght.isHidden = false
        }
        else {
            btnLeft.isHidden = false
            btnRIght.isHidden = false

        }
    }
    
    
    //MARK:- Right Button
    @IBAction func rightButtonDidTapped(_ sender: Any) {
        print(imgIndex)

//        var tag = btnRIght.tag
//        if tag < imageArray.count && tag > 0 {
//            tag = tag + 1
//            imgView.image = self.imageArray[tag]
//            btnLeft.tag = tag
//            btnRIght.tag = tag
//        }

        let index = imgIndex + 1
        if index <= imageArray.count - 1 {
            imgView.image = imageArray[index]
            imgIndex = index

        }
        
        if imgIndex == imageArray.count - 1 {
            btnRIght.isHidden = true
            btnLeft.isHidden = false
        }
        else {
            btnRIght.isHidden = false
            btnLeft.isHidden = false

        }
//        btnLeft.isHidden = false
        
    }
    
    
    private func addToCartAPI(parameter:NSDictionary) {
        print("Insert EMP Info")
        
        let url = APIEngine.shared.addToCartURL()
        print(url)
        ServerRequestManager.serverInstance.postDataToServer(url: url, dictionary: parameter, view: self, onComplition: { (response, error) in
            
            if let status = response?["Status"].bool
            {
                if status == true {
                    // self.dismiss(animated: true, completion: nil)
                    //self.tabBarController?.selectedIndex = 2
                    
                    self.dismiss(animated: true, completion: {
                        print("Dismiss...")

                    })
                }
                else {
                    //Failed to send member info
                    let msg = response?["Message"].stringValue
                    self.displayActivityAlert(title: msg ?? "")
                    
                }
            }
        })
        
    }
    
    @IBAction func addToCartTapped(_ sender: Any) {
        
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
            return
        }
        
        self.showPleaseWait(msg: "Please Wait")
        
        /* {
         "familySrNo": 5707,
         "personName": "ARADHYA PAWAR",
         "personSrNO": 26352,
         "flatHouse": "301",
         "area": "Sukhda colony, dange chowk",
         "landmark": "near HP petrol pump",
         "pincode": "411057",
         "city": "Pune",
         "state": "Maharashtra",
         "emailId": "xyz@gmail.com",
         "mobile": "",
         "remark": "Test",
         "cartId": 0
         }
         */
        
        let parameters : [String:String] = ["familySrNo":familySrNo as! String,
                                            "personName":txtMemberName.text ?? "",
                                            "personSrNO":memberInfoObj?.ExtPersonSRNo ?? "",
                                            "flatHouse":addressObj?.FlatHouse ?? "",
                                            "area":addressObj?.Area ?? "",
                                            "landmark":addressObj?.Landmark ?? "",
                                            "pincode":addressObj?.Pincode ?? "",
                                            "city":addressObj?.City ?? "",
                                            "state": addressObj?.State ?? "",
                                            "emailId":addressObj?.EmailId ?? "",
                                            "mobile":addressObj?.Mobile ?? "",
                                            "remark":txtViewRemarks.text ?? ""]
        
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
        
        //let url = NSURL(string: "http://www.mybenefits360.in/mbapi/api/v1/MedicineDelivery/AddToCart")
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            // multipartFormData.append(UIImageJPEGRepresentation(self.imageArray[0], 0.5)!, withName: "Image", fileName: "Image.jpg", mimeType: "image/jpg")
            
            
            multipartFormData.append(paramStr.data(using: String.Encoding.utf8)!, withName: "CartData")
            
            var i = 0
            for image in self.imageArray {
                multipartFormData.append(UIImageJPEGRepresentation(image, 0.5)!, withName: "Image", fileName: "Image\(i).jpg", mimeType: "image/jpg")
                i += 1
            }
            
            //            for (key, value) in parameters {
            //                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            //            }
            
        }, to:APIEngine.shared.addToCartURL())
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
                    //print(response.response) // URL response
                    //print(response.data)     // server data
                    //print(response.result)   // result of response serialization
                    //                        self.showSuccesAlert()
                    //self.removeImage("frame", fileExtension: "txt")
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        
                        let dictionaryRes = JSON as? NSDictionary
                        
                        if let status = dictionaryRes?["Status"] as? Bool
                        {
                            if status == true {
                                //let msg = dictionaryRes?["Message"] as? String
                                //self.displayActivityAlert(title: msg ?? "")
                                
                                let vc = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier: "ViewCartMD_VC") as! ViewCartMD_VC
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            }
                            else {
                                let msg = dictionaryRes?["Message"] as? String
                                self.displayActivityAlert(title: msg ?? "")
                            }
                        }
                    }
                }
                
            case .failure(let encodingError):
                self.hidePleaseWait()
                //self.delegate?.showFailAlert()
                print(encodingError)
            }
            
        }
        
        // uploadImage(param: param as NSDictionary)
        
        //networkCall()
        
    }
    

}

extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}

extension ReviewOrderDetailsVC {
    private func createBody(with parameters: NSDictionary, filePathKey: String, fileUrlArray: [UIImage], boundary: String) throws -> Data
    {
        var body = Data()
        var uploadData: Data = NSKeyedArchiver.archivedData(withRootObject: parameters)
        uploadData = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        
        let jsonString = String(data: uploadData, encoding:.utf8 )
        let jsonData : String = jsonString!
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"QueryData\"\r\n\r\n")
        body.append("\(String(describing: jsonData))\r\n")
        
        
        print(jsonData)
        
        for path in fileUrlArray
        {
            //let fileUrl : URL = path as! URL
            //let filename = fileUrl.lastPathComponent
            let data =  UIImagePNGRepresentation(imageArray[0])
            let mimetype = "image/jpg"
            
            if(data != nil)
            {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"Image")
                body.append("Content-Type: \(mimetype)\r\n\r\n")
                body.append(data!)
                body.append("\r\n")
            }
            else
            {
                //displayActivityAlert(title: "")
            }
            
        }
        
        
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    
    private func mimeType(for path: String) -> String {
        let url = URL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }

}
