//
//  ViewCartMD_VC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 19/10/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit



class ViewCartMD_VC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnPlaceOrder: UIButton!

    @IBOutlet weak var loader: UIActivityIndicatorView!
    var cartModelArray = [ViewCartMD_Model]()
    
    var isComplete = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cart Details"
        print("In \(self.title ?? "Cart Details") ViewCartMD_VC")
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn

        btnPlaceOrder.backgroundColor = Color.buttonBackgroundGreen.value
        btnPlaceOrder.makeCicular()

        getCartDataFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ConstantAPICallMD.sharedInstance.getNewToken_MD(view: self)
        
    }
    
    @objc func backTapped() {
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: FamilyMemberListMD_VC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            
            if controller.isKind(of: OngoingOrderMD_VC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            
            if controller.isKind(of: MedicineHistoryMD_VC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        
    }
    
    //MARK:- Tableview Delegate and Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return cartModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForCartCell", for: indexPath) as! CellForCartCell
        
        
        cell.lblPersonName.text = self.cartModelArray[indexPath.row].PersonName
        if self.cartModelArray[indexPath.row].statusIsPlaced == "0" { //No Action
            cell.spinner.stopAnimating()
            cell.spinner.isHidden = true
            cell.btnCross.setImage(UIImage(named: "crossGray"), for: .normal)
            cell.btnCross.isHidden = false


        }
        else if self.cartModelArray[indexPath.row].statusIsPlaced == "1" { //Placed on Success
            cell.spinner.stopAnimating()
            cell.spinner.isHidden = true

            cell.btnCross.setImage(UIImage(named: "correctGreen"), for: .normal)
            cell.btnCross.isHidden = false

        }
        else if self.cartModelArray[indexPath.row].statusIsPlaced == "2" { //Running Show Loader
            cell.btnCross.isHidden = true
            cell.spinner.isHidden = false

            cell.spinner.startAnimating()
        }

        else { //Failed to Place Order
            cell.spinner.stopAnimating()
            cell.spinner.isHidden = true

            cell.btnCross.setImage(UIImage(named: "crossRed"), for: .normal)
            cell.btnCross.isHidden = false

        }
        
        cell.btnCross.tag = indexPath.row
        cell.btnCross.addTarget(self, action: #selector(cancelOrderTapped(_:)), for: .touchUpInside)

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    
    @objc private func cancelOrderTapped(_ sender : UIButton ) {
        let obj = cartModelArray[sender.tag]
        let dictionary = ["CartId" : obj.CartId]
        
        removeCartOrder(parameter: dictionary as NSDictionary)
    }
    
    //MARK:- Get cart Data
    private func getCartDataFromServer() {
        
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
            return
        }
        
        let url = APIEngine.shared.getAllCartNamesURL(familySrNo: familySrNo as! String)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            print(response ?? "")
            
            if let status = response?["Status"].bool
            {
                if status == true {
                    
                    self.cartModelArray.removeAll()
                    if let cartArray = response?["CartOrders"].arrayValue {
                        
                        for cartObj in cartArray {
                            
                            var imgModelArray = [PrescriptionImages]()
                            if let imgArray = response?["Images"].arrayValue {
                                
                                for img in imgArray {
                                let obj = PrescriptionImages.init(imageUrl: img.string)
                                    imgModelArray.append(obj)
                                }
                            }

                            
                            let obj = ViewCartMD_Model.init(FamilySrNo: cartObj["FamilySrNo"].string, PersonName: cartObj["PersonName"].string, TempOrderID: cartObj["TempOrderID"].string, PersonSrNO: cartObj["PersonSrNO"].string, FlatHouse: cartObj["FlatHouse"].string, Area: cartObj["Area"].string, Landmark: cartObj["Landmark"].string, Pincode: cartObj["Pincode"].string, City: cartObj["City"].string, State: cartObj["State"].string, EmailId: cartObj["EmailId"].string, Mobile: cartObj["Mobile"].string, Remark: cartObj["Remark"].string, CartId: cartObj["CartId"].intValue.description, Images: imgModelArray,statusIsPlaced:"0",AddCartOn:cartObj["AddCartOn"].string)
                            self.cartModelArray.append(obj)
                        }
                        
                        if cartArray.count == 0 {
                            self.btnPlaceOrder.isHidden = true
                            self.displayActivityAlert(title: "Cart is empty")
                        }
                        else {
                            self.btnPlaceOrder.isHidden = false

                        }
                        }
                    
                        self.tableView.reloadData()
                    
                    
                }
            }
        }
    }
    
    
    //MARK:- Place Order API
    private func placeOrderAPI(parameter : NSDictionary,index:Int,ordCount:String) {
        
        guard let tokenMD = UserDefaults.standard.value(forKey: "tokenMD") as? String else {
            displayActivityAlert(title: m_errorMsg)
            ConstantAPICallMD.sharedInstance.getNewToken_MD(view: self)
            return
        }
        
        let url = APIEngine.shared.placeOrderURL(token: tokenMD, orderCount: ordCount)
        print(url)
        ServerRequestManager.serverInstance.postDataToServerWithoutLoader(url: url, dictionary: parameter, view: self, onComplition: { (response, error) in
            
            if let status = response?["Status"].bool
            {
                if status == true {
                    // self.dismiss(animated: true, completion: nil)
                    //self.tabBarController?.selectedIndex = 2
                    
//                    self.dismiss(animated: true, completion: {
//                        print("Dismiss...")
                    
                        if index < self.cartModelArray.count {
                        self.cartModelArray[index].statusIsPlaced = "1"
                        }
                    
                    if index == self.cartModelArray.count {
                        self.btnPlaceOrder.isHidden = true
                    }
                    
                    let indexP = IndexPath(row: index, section: 0)
                    var indArray = [IndexPath]()
                    indArray.append(indexP)
                    self.tableView.reloadRows(at: indArray, with: .none)
                    //self.tableView.reloadData()
                    
                  
                    //})
                }
                else {
                    //Failed to send member info
                    let msg = response?["Message"].stringValue
                    self.displayActivityAlert(title: msg ?? "")
                    
                    if index < self.cartModelArray.count {
                        self.cartModelArray[index].statusIsPlaced = "2"
                    }
                    
                    if index == self.cartModelArray.count {
                        self.btnPlaceOrder.isHidden = true
                    }
                    
                    let indexP = IndexPath(row: index, section: 0)
                    var indArray = [IndexPath]()
                    indArray.append(indexP)
                    self.tableView.reloadRows(at: indArray, with: .none)
                    //self.tableView.reloadData()
                    
                    
                }
            }
        })
        
    }
    
    @IBAction func placeOrderDidTapped(_ sender: Any) {
        
        var i = 0
        for  data in cartModelArray {
           

            
            let param = ["FamilySrNo" : data.FamilySrNo ?? "",
                         "PersonName": data.PersonName ?? "",
                         "PersonSrNO": data.PersonSrNO ?? "",
                         "FlatHouse": data.FlatHouse ?? "",
                         "Area": data.Area ?? "",
                         "Landmark": data.Landmark ?? "",
                         "Pincode": data.Pincode ?? "",
                         "City": data.City ?? "",
                         "State": data.State ?? "",
                         "EmailId": data.EmailId ?? "",
                         "Mobile": data.Mobile ?? "",
                         "Remark": data.Remark ?? "",
                         "CartId": data.CartId ?? "","Images":data.Images, "AddCartOn":data.AddCartOn ?? ""] as [String : Any]
            
            placeOrderAPI(parameter: param as NSDictionary,index:i, ordCount: cartModelArray.count.description)
            i += 1
            
        } //for
        
        if i == cartModelArray.count {
            self.btnPlaceOrder.isHidden = true
            self.tableView.reloadData()
        }
        
    }
    
    private func removeCartOrder(parameter:NSDictionary) {
        print("Remove From Cart")
        
        let url = APIEngine.shared.removeCartProduct()
        print(url)
        ServerRequestManager.serverInstance.postDataToServer(url: url, dictionary: parameter, view: self, onComplition: { (response, error) in
            
            if let status = response?["Status"].bool
            {
                if status == true {
                    let msg = response?["Message"].stringValue
                    self.displayActivityAlert(title: msg ?? "")
                    self.getCartDataFromServer()

                }
                else {
                    //Failed to send member info
                    let msg = response?["Message"].stringValue
                    print(msg)
                    self.displayActivityAlert(title: m_errorMsg ?? "")
                    
                }
            }
        })
    }

}



class CellForCartCell: UITableViewCell
{
    
    @IBOutlet weak var lblPersonName: UILabel!
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var btnCross: UIButton!

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // var shimmer = ShimmerButton()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
