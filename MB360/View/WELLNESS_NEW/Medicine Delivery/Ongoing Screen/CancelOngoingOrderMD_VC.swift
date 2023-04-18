//
//  CancelOngoingOrderMD_VC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 23/10/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class CancelOngoingOrderMD_VC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var lblCancelOrder: UILabel!
    
    @IBOutlet weak var lblCancellationReason: UILabel!
    @IBOutlet weak var viewReason: UIView!
    
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var viewCancel: UIView!
    
    @IBOutlet weak var lblSelectReason: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    let relationDropDown = DropDown()
    var ongoingModelObj : OngoingMedicineModel?
    
    var cancelDelegateObj : CancelOngoingOrderProtocol? = nil

    @IBOutlet weak var txtReason: UITextField!
    
    var reasonArray = ["No longer need the medicine","Delivery is too late","Bought the medicine myself","Placed order by mistake"]
    
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In \(self.title ?? "") CancelOngoingOrderMD_VC")
        relationDropDown.dataSource = reasonArray
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
       
        self.viewCancel.layer.cornerRadius = 2.0
        self.viewCancel.backgroundColor = Color.buttonBackgroundGreen.value
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelTapped(_:)))
        viewCancel.addGestureRecognizer(tap)
        txtReason.delegate = self

       // txtReason.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)

        centerView.layer.cornerRadius = 4.0
        viewReason.layer.cornerRadius = 4.0
        setBottomShadow1(view: viewReason)
        
        lblCancellationReason.textColor = Color.fontColor.value
    }
    
    func setBottomShadow1(view:UIView)
    {
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        view.layer.shadowOpacity = 30
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.cornerRadius = cornerRadiusForView//8
    }
    
    
    //MARK:- Search Tapped
    @objc private func cancelTapped(_ sender: UITapGestureRecognizer)
    {
        if lblSelectReason.text == "" || lblSelectReason.text == "Select Reason" {
            self.displayActivityAlert(title: "Please Select Reason")
        }
        else {
            //API Call
            
            /*
             {
                 "OrderNo" :"1064",
                 "PeOrderNo" :"856",
                 "CancelId" :"1",
                 "CancelRemark":" Test Remark",
                 "CancelNote":" Test Note",
                 "RxId":"DRAFT4111SA",
              "AccessToken":"3d8747b6915c6ef1830b80848916818cd1cc1ac528550d02502076dbf2a7030bf2905a89304d527719de12115565f90817ee66603b53f70584929d77babd498af9f85f780819ead7f"
             }
             */
            
            guard let tokenMD = UserDefaults.standard.value(forKey: "tokenMD") as? String else {
                       displayActivityAlert(title: m_errorMsg)
                       ConstantAPICallMD.sharedInstance.getNewToken_MD(view: self)
                       return
                   }
            
            let dictionary = [ "OrderNo" :ongoingModelObj?.OrderInfoSrNo ?? "",
                "PeOrderNo" :ongoingModelObj?.PeOrderId ?? "",
                "CancelId" :String(selectedIndex), "CancelRemark" : lblCancellationReason.text ?? "","RxId":ongoingModelObj?.RXId ?? "","AccessToken": tokenMD,"CancelNote":""]
            
            cancelOngoingOrder(parameter: dictionary as NSDictionary)

            }
        
    }
    
    
    @IBAction func closeDidTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectReasonDidTapped(_ sender: Any) {
        relationDropDown.anchorView = self.viewReason
        relationDropDown.bottomOffset = CGPoint(x: 0, y: 25)
        //relationDropDown.width = viewReason.frame.size.width - 30
        relationDropDown.width = self.centerView.frame.size.width - 30

        relationDropDown.show()
        
        self.relationDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.lblSelectReason.text = item
            self.displayDropDownat(index: index, item: item)
            self.selectedIndex = index
        }

    }
    
    //MARK:- Select Relation
    func displayDropDownat(index:Int,item:String)
    {
            self.lblSelectReason.text = self.reasonArray[index]
    }
    
    private func cancelOngoingOrder(parameter:NSDictionary) {
        print("Insert EMP Info")
        
        let url = APIEngine.shared.getCancelOngoinfOrderURL()
        print(url)
        ServerRequestManager.serverInstance.postDataToServer(url: url, dictionary: parameter, view: self, onComplition: { (response, error) in
            
            if let status = response?["Status"].bool
            {
                if status == true {
                    // self.dismiss(animated: true, completion: nil)
                    //self.tabBarController?.selectedIndex = 2
                    
                    if self.cancelDelegateObj != nil {
                        self.cancelDelegateObj?.isCancelOngoingOrder()
                    }
                    
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
    

}
