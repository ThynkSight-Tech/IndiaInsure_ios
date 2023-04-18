//
//  SelectAddressMD_VC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 15/10/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class SelectAddressMD_VC: UIViewController,UITableViewDelegate,UITableViewDataSource,AddNewAddressForMedicineProtocol {
  
    

    @IBOutlet weak var btnAddNewAddress: UIButton!
    
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnReviewOrder: UIButton!
    @IBOutlet weak var lblUploads: UILabel!

    var selectedAddIndex = -1
    var addressModelArray = [AddressModel_MD]()
    var memberInfoObj : FamilyDetailsModel?
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Delivery Address"
        lblUploads.text = String(format: "%@ Uploads", String(imageArray.count))
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        let addBtn =  UIBarButtonItem(image:UIImage(named: "addressIcon") , style: .plain, target: self, action: #selector(addNewAddressClick))
        navigationItem.rightBarButtonItems = [addBtn]

        self.tableView.tableFooterView = UIView()
        
        
        setColors()
        
        getAddressFromServer()
        
        print("In \(self.title ?? "Delivery Address") SelectAddressMD_VC")
    }
    @objc func addNewAddressClick() {
        let vc = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier: "AddNewAddressMD_VC") as! AddNewAddressMD_VC
        vc.isEdit = 0
        vc.addAddedDelegateObj = self
        vc.addressModelArray = self.addressModelArray
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func setColors() {
        //btnAddNewAddress.backgroundColor = Color.buttonBackgroundGreen.value
        btnChange.backgroundColor = Color.buttonBackgroundGreen.value
        btnReviewOrder.backgroundColor = Color.buttonBackgroundGreen.value
        
        //btnAddNewAddress.layer.cornerRadius = btnAddNewAddress.bounds.height / 2
        btnChange.layer.cornerRadius = btnChange.bounds.height / 2
        btnReviewOrder.layer.cornerRadius = btnReviewOrder.bounds.height / 2

    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func topChangeDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Review Order
    @IBAction func reviewOrderDidTapped(_ sender: Any) {
        
        if selectedAddIndex == -1 {
            if addressModelArray.count == 0 {
                self.displayActivityAlert(title: "Please add new address")
            }
            self.displayActivityAlert(title: "Please select address")
        }
        else {
        let vc = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier: "ReviewOrderDetailsVC") as! ReviewOrderDetailsVC
        if selectedAddIndex < addressModelArray.count {
        vc.addressObj = addressModelArray[selectedAddIndex]
        }
        vc.memberInfoObj = memberInfoObj
        vc.imageArray = imageArray

        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func addNewAddressTapped(_ sender: Any) {
    }
    
    //MARK:- Delegate Methods
    func newAddressAdded(modelObj: [AddressModel_MD]) {
        self.addressModelArray.removeAll()
        self.addressModelArray = modelObj
        self.tableView.reloadData()
    }
 
    
    //MARK:- TableView Delegate and Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressModelArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForAddressListMDCell", for: indexPath) as! CellForAddressListMDCell
        if selectedAddIndex == indexPath.row {
            cell.btnRadioButton.setImage(UIImage(named: "radio_selected"), for: .normal)
            cell.editButton.isHidden = false
            
        }
        else {
            cell.btnRadioButton.setImage(UIImage(named: "radio"), for: .normal)
            cell.editButton.isHidden = true

        }
        
        //Radio Button
        cell.btnRadioButton.tag = indexPath.row
        cell.btnRadioButton.addTarget(self, action: #selector(radioButtonDidTapped(_:)), for: .touchUpInside)
        
        //Edit Button
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(editButtonDidYapped(_:)), for: .touchUpInside)
        
        let obj = self.addressModelArray[indexPath.row]
        cell.lblAddress.text = String(format: "%@,%@,%@,%@,%@",obj.FlatHouse ?? "",obj.Area ?? "", obj.Landmark ?? "",obj.Pincode ?? "",obj.City ?? "",obj.State ?? "")
        cell.lblMobNo.text = obj.Mobile ?? ""
        cell.lblEmailId.text = obj.EmailId ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedAddIndex = indexPath.row
        self.tableView.reloadData()
    }
    
    
    
    //Radio Button Tapped...
    @objc private func radioButtonDidTapped(_ sender: UIButton) {
        self.selectedAddIndex = sender.tag
        self.tableView.reloadData()

    }

    //Edit Button Tapped...
    @objc private func editButtonDidYapped(_ sender : UIButton) {
        let vc = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier: "AddNewAddressMD_VC") as! AddNewAddressMD_VC
        vc.isEdit = 1
        vc.arrayIndex = sender.tag
        vc.addressModelArray = addressModelArray
        vc.addAddedDelegateObj = self
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    private func getAddressFromServer() {
        
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
            return
        }
        
        
        let url = APIEngine.shared.getFamilyAddressURL(familySrNo: familySrNo as! String)
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            
           
                
                if let status = response?["Status"].bool
                {
                    if status == true {
                        
                        
                        if let addressArray = response?["Address"].arrayValue {
                            //To Remove relation duplicates
                            self.addressModelArray.removeAll()
                            
                            
                            for add in addressArray {
                                let obj = AddressModel_MD.init(FlatHouse: add["FlatHouse"].string, Area: add["Area"].string, Landmark: add["Landmark"].string, Pincode: add["Pincode"].string, City: add["City"].string, State: add["State"].string, EmailId: add["EmailId"].string, Mobile: add["Mobile"].string)
                                self.addressModelArray.append(obj)
                            }
                            self.tableView.reloadData()
                            
                        }
                        
                    }
                    else {
                        //Address record not found
                    }
                }
            
        }
    }
}



extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
extension UILabel {
    func setBottomBorder() {
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        
        
    }
}


