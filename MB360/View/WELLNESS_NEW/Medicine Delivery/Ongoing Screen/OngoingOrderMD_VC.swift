//
//  OngoingOrderMD_VC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 23/10/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import SkeletonView

protocol CancelOngoingOrderProtocol {
    func isCancelOngoingOrder()
}

class OngoingOrderMD_VC: UIViewController,UITableViewDelegate,UITableViewDataSource,CancelOngoingOrderProtocol {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.estimatedRowHeight = 130.0
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    var ongoingModelArray = [OngoingMedicineModel]()
    var isLoaded = 0
    var selectedRow = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.applyGradient()
        self.navigationController?.navigationBar.navBarDropShadow()
        self.navigationItem.title = "Ongoing Orders"
        self.navigationController?.navigationBar.changeFont()
        print("In \(navigationItem.title ?? "Ongoing orders") OngoingOrderMD_VC")

        tableView.isSkeletonable = true
        let nibName = UINib(nibName: "shimeerDefaultCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "shimeerDefaultCell")
        
        
        let cartBtn =  UIBarButtonItem(image:UIImage(named: "cartW") , style: .plain, target: self, action: #selector(cartTapped))
        cartBtn.imageInsets =  UIEdgeInsetsMake(0, 0, 0, 0)
        
        navigationItem.rightBarButtonItems = [cartBtn]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isLoaded = 0
        self.tabBarController?.tabBar.isHidden = false
        menuButton.isHidden = false
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.showSkeleton()
        tableView.startSkeletonAnimation()
        getOngoingOrdersFromServer()
        
    }
    
    //MARK:- Delegate
    func isCancelOngoingOrder()
    {
        getOngoingOrdersFromServer()
        
    }
    
    @objc func cartTapped() {
        let summaryVC : ViewCartMD_VC = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier:"ViewCartMD_VC") as! ViewCartMD_VC
        menuButton.isHidden = true
        tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(summaryVC, animated: true)
    }
    
    //MARK:- Tableview Delegate And Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ongoingModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForOngoingMDCell", for: indexPath) as! CellForOngoingMDCell
        let obj = ongoingModelArray[indexPath.row]
        cell.lblName.text = obj.Name
        cell.lblOrderNo.text = obj.PeOrderId
        cell.lblOrderDate.text = obj.PlacedOrderDate
        cell.lblAddress.text = obj.Address
        cell.lblEstimatedDate.text = obj.EstimatedDate
        
        if obj.isExpand == true {
            if obj.Status.count > 0 {
                //cell.heightViewDetails.constant = CGFloat((obj.Status.count * 50) - 30)
                cell.heightViewDetails.constant = CGFloat((obj.Status.count * 50)  + 4)
                
            }
            else {
                cell.heightViewDetails.constant = 100
                
            }
            //cell.isExpand = true
            
            //cell.showProgressBar()
        }
        else {
            cell.heightViewDetails.constant = 26
            //cell.isExpand = false
            //cell.hideProgressBar()
            
        }
        
        if obj.Status.count > 0 {
            let txt = String(format: "%@", obj.Status[obj.Status.count - 1].Status ?? "    ")
            cell.lblOrderStatus.setTitle(txt, for: .normal)
        }
        
        //cell.btnDetails.tag = indexPath.row
        //cell.btnDetails.addTarget(self, action: #selector(viewDetailsTapped(_:)), for: .touchUpInside)
        
        cell.btnCancelOrder.tag = indexPath.row
        cell.btnCancelOrder.addTarget(self, action: #selector(cancelOrderTapped(_:)), for: .touchUpInside)
        
        
        if obj.isExpand == true {
            
            print(obj.Status.description)
            var yset = 30
            
            for i in 0..<obj.Status.count {
                print(i)
                let viewPro:ProgressView = ProgressView.instanceFromNib() as! ProgressView
                if i == 0 {
                    yset = 30
                }
                else {
                    yset += 50
                }
                viewPro.lblStatus.text = String(format: "%@   %@", obj.Status[i].Status ?? "", obj.Status[i].Date ?? "")
                
                
                print(yset)
                viewPro.frame = CGRect(x: 0, y:yset, width: Int(cell.viewDetailsView.bounds.width), height: 50)
                
                //hide line on last cell
                if obj.Status.count - 1 == i {
                    viewPro.progressView.isHidden = true
                }
                else {
                    viewPro.progressView.isHidden = false
                }
                viewPro.tag = 100
   
                
                if indexPath.row == selectedRow {
                    Timer.scheduledTimer(withTimeInterval: TimeInterval(1 * i), repeats: false) { timer in
                        UIView.animate(withDuration: 1.0, delay: 0, options: [.transitionFlipFromTop, .transitionFlipFromTop], animations: {
                            print("Start Animation")
                            viewPro.circleView.backgroundColor = Color.buttonBackgroundGreen.value
                            // Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                            UIView.animate(withDuration: 0.5, delay: 0.5, options: [.transitionFlipFromTop, .transitionFlipFromTop], animations: {
                                
                                viewPro.progressView.backgroundColor = Color.buttonBackgroundGreen.value
                            })
                            // }
                            
                        }) { (Bool) in
                            print("Complete Animation")
               
                            self.selectedRow = -1
                        }
                    }
                }
                else {
                    viewPro.circleView.backgroundColor = Color.buttonBackgroundGreen.value
                    viewPro.progressView.backgroundColor = Color.buttonBackgroundGreen.value
                    
                }

                
                cell.viewDetailsView.addSubview(viewPro)
            }
            
            
        }
        else {
      
            //cell.viewDetailsView.subviews.forEach { $0.removeFromSuperview() }
            
            for subview in cell.viewDetailsView.subviews {
                if (subview.tag == 100) {
                    subview.removeFromSuperview()
                }
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDetailsTapped(_:)))
        cell.viewDetailsView.tag = indexPath.row
        cell.viewDetailsView.isUserInteractionEnabled = true
        cell.viewDetailsView.addGestureRecognizer(tap)
        
        cell.viewDetailsView.clipsToBounds = true

        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoaded == 0 {
            return 120
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    @objc private func viewDetailsTapped(_ sender : UITapGestureRecognizer ) {
        guard let indexTapped = sender.view?.tag else { return  }
        
        if self.ongoingModelArray[indexTapped].isExpand == true {
            self.ongoingModelArray[indexTapped].isExpand = false
        }
        else {
            self.ongoingModelArray[indexTapped].isExpand = true
            self.selectedRow = indexTapped
        }
        
        let index = IndexPath(row: indexTapped, section: 0)
        var indArray = [IndexPath]()
        indArray.append(index)
        self.tableView.reloadRows(at: indArray, with: .fade)
    }
    
    
    @objc private func cancelOrderTapped(_ sender : UIButton ) {
        let VC : CancelOngoingOrderMD_VC = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier:"CancelOngoingOrderMD_VC") as! CancelOngoingOrderMD_VC
        
        //        menuButton.isHidden = true
        //        tabBarController?.tabBar.isHidden = true
        //        bottomConstraint.constant = 0
        VC.modalPresentationStyle = .overFullScreen
        VC.modalTransitionStyle = .crossDissolve
        VC.ongoingModelObj = self.ongoingModelArray[sender.tag]
        VC.cancelDelegateObj = self
        self.navigationController?.present(VC, animated: true, completion: nil)
    }
    
    //MARK:- Get Data From Server
    private func getOngoingOrdersFromServer() {
        
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
            return
        }
        
        let url = APIEngine.shared.getOngoinfOrdersURL(familySrNo: familySrNo as! String)
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServerWithoutLoader(url: url, view: self) { (response, error) in
            
            if let status = response?["Status"].bool
            {
                if status == true {
                    self.isLoaded = 1
                    self.ongoingModelArray.removeAll()
                    if let ordersArray = response?["OrderDetails"].arrayValue {
                        //To Remove relation duplicates
                        
                        for orderObj in ordersArray {
                            
                            //IMAGES
                            var imgModelArray = [PrescriptionImages]()
                            if let imgArray = orderObj["Images"].array {
                                
                                for img in imgArray {
                                    let obj = PrescriptionImages.init(imageUrl: img.string)
                                    imgModelArray.append(obj)
                                }
                            }
                            
                            //STATUS
                            var statusModelArray = [StatusModel]()
                            
                            if let statusArray = orderObj["Status"].array {
                                for statusObj in statusArray {
                                    let objStatus = StatusModel.init(Date: statusObj["Date"].string, Status: statusObj["Status"].string)
                                    statusModelArray.append(objStatus)
                                }
                            }
                            
                            //Orderinfo
                            var orderInfo = OrderInfoModel()
                            if let orderInfoDict = orderObj["Orderinfo"].dictionary {
                                orderInfo = OrderInfoModel.init(OrderInfoSrNo: orderInfoDict["OrderInfoSrNo"]?.string, EstimatedDate: orderInfoDict["EstimatedDate"]?.string, DiscountAmount: orderInfoDict["DiscountAmount"]?.string, TotalAmount: orderInfoDict["TotalAmount"]?.string, MovementDoneOn: orderInfoDict["MovementDoneOn"]?.string, PayableAmount: orderInfoDict["PayableAmount"]?.string, OrderStatus: orderInfoDict["OrderStatus"]?.string, DeliveryCharge: orderInfoDict["DeliveryCharge"]?.string)
                            }
                            
                            let orderModelObj = OngoingMedicineModel.init(Name: orderObj["Name"].string, EstimatedDate: orderObj["EstimatedDate"].string, PlacedOrderDate: orderObj["PlacedOrderDate"].string, CustomerId: orderObj["CustomerId"].string, PeOrderId: orderObj["PeOrderId"].string, Address: orderObj["Address"].string, OrderInfoSrNo: orderObj["OrderInfoSrNo"].string, Images: imgModelArray, Status: statusModelArray,isExpand: false,orderInfoModel: orderInfo,RXId: orderObj["RXId"].string)
                            
                            self.ongoingModelArray.append(orderModelObj)
                            
                        }//for
                        
                        self.tableView.hideSkeleton()
                        self.tableView.stopSkeletonAnimation()
                        self.tableView.reloadData()

                        if self.ongoingModelArray.count > 0 {
                            
                        }
                        else {
                            self.tableView.setEmptyView(title: "Ongoing orders not found", message: "")
                        }
                    }
                    
                }
                else {
                    //Address record not found
                    self.tableView.hideSkeleton()
                    
                    self.tableView.stopSkeletonAnimation()
                    self.tableView.reloadData()
                    
                }
            }
            else {
                self.tableView.stopSkeletonAnimation()
                self.tableView.reloadData()
                
            }
            
        }
    }
    
}


class CellForOngoingMDCell: UITableViewCell {
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblOrderStatus: UIButton!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblEstimatedDate: UILabel!
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var viewCancelOrder: UIView!
    @IBOutlet weak var viewDetailsView: UIView!
    @IBOutlet weak var viewBackground: UIView!
    
    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var btnCancelOrder: UIButton!
    
    @IBOutlet weak var heightViewDetails: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        self.viewBackground.layer.cornerRadius = 4.0
        //        self.viewBackground.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        //        self.viewBackground.layer.borderWidth = 1.0
        //
        setBottomShadow(view: self.viewBackground)
        self.lblOrderStatus.makeCicular()
        self.lblOrderStatus.titleLabel?.textColor = Color.textDarkGreen.value
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setBottomShadow(view:UIView)
    {
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        view.layer.shadowOpacity = 30
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.cornerRadius = cornerRadiusForView//8
    }
    
}
extension OngoingOrderMD_VC: SkeletonTableViewDataSource {
    
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "shimeerDefaultCell"
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int
    { if isLoaded == 0
    { return 6 }
    else {
        return 0
        }
    }
    
}
