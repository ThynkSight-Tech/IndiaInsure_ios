//
//  AppointmentHistory.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 12/06/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import SkeletonView

class AppointmentHistory: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var historyModelArray = [AppointmentHistoryModel]()
    var isLoaded = 0
    
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.estimatedRowHeight = 180.0
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    @IBOutlet weak var lblNoHistoryHeader: UILabel!
    @IBOutlet weak var btnScheduleNow: UIButton!
    @IBOutlet weak var lblInstructionLbl: UILabel!
    
    @IBOutlet weak var noHistoryView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isSkeletonable = false

        self.noHistoryView.isHidden = true
        self.navigationItem.title = "Appointment History"
        print("In \(navigationItem.title ?? "") AppointmentHistory")
        self.navigationController?.navigationBar.changeFont()
        self.navigationController?.navigationBar.applyGradient()
        self.navigationController?.navigationBar.navBarDropShadow()

        setColors()
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn

    }
    
    private func setColors() {
        self.btnScheduleNow.dropShadow()
        self.btnScheduleNow.layer.cornerRadius = btnScheduleNow.frame.size.height / 2
        self.btnScheduleNow.backgroundColor = Color.buttonBackgroundGreen.value
        self.btnScheduleNow.setTitleColor(UIColor.white, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isLoaded = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //view.showAnimatedSkeleton()
        let animation = GradientDirection.leftRight.slidingAnimation()
        view.startSkeletonAnimation(animation)

        
        getHistoryDataFromServer()


    }
   
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- TableView Delegate and Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForAppointmentHistory", for: indexPath) as! CellForAppointmentHistory
        cell.lblPersonName.text = historyModelArray[indexPath.row].PersonName
        cell.lblRelation.text = historyModelArray[indexPath.row].RelationName?.uppercased()
        if historyModelArray[indexPath.row].SponserdBy == "COMPANY SPONSORED" {
            cell.btnSponsored.isHidden = false
            cell.shimmer.isHidden = false
            cell.shimmer.addShimmerAnimation()
        }
        else {
            cell.btnSponsored.isHidden = true
            cell.shimmer.isHidden = true
        }
        
        cell.btnViewPackage.tag = indexPath.row
        cell.btnViewPackage.addTarget(self, action: #selector(self.viewPackageDidTapped(_:)), for: .touchUpInside)
        
        cell.btnViewDetails.tag = indexPath.row
        cell.btnViewDetails.addTarget(self, action: #selector(self.viewDetailsDidTapped(_:)), for: .touchUpInside)

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 140
        if isLoaded == 0 {
            return 120
            
        }
        return UITableViewAutomaticDimension
        
    }
    
    //MARK:- Package Content Tapped
    @objc func viewPackageDidTapped(_ sender : UIButton) {
        
        if historyModelArray[sender.tag].PackageSrNo != "" {
            let vc = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"PackageIncludesViewController") as! PackageIncludesViewController
            vc.packageSrNo = historyModelArray[sender.tag].PackageSrNo ?? ""
            vc.packageName = historyModelArray[sender.tag].PackageName ?? ""
            let nav:UINavigationController = UINavigationController.init(rootViewController: vc)
            self.present(nav, animated: true)
        }
       
    }
    
    @objc func viewDetailsDidTapped(_ sender : UIButton) {
        let vc = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"HistoryDetailsVC") as! HistoryDetailsVC
        vc.historyModelObject = historyModelArray[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:- Get Data From Server
    private func getHistoryDataFromServer() {
        
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
            return
        }
        
        let url = APIEngine.shared.appointmentHistoryURL(familySrNo: familySrNo as! String)
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            
            if let messageDictionary = response?["message"].dictionary
            {
                if let status = messageDictionary["Status"]?.bool
                {
                    if status == true {
                        self.historyModelArray.removeAll()
                        
                        if let historyArray = response?["AppointmentList"].arrayValue {
                            
                            for history in historyArray {
                                let obj = AppointmentHistoryModel.init(RelationID: history["RelationID"].stringValue, Age: history["Age"].stringValue, IsBooking: history["IsBooking"].stringValue, CellPhoneNumber: history["CellPhoneNumber"].stringValue, PaymentConfFlag: history["PaymentConfFlag"].stringValue, ApptSrInfoNo: history["ApptSrInfoNo"].stringValue, Price: history["Price"].stringValue, Amount: history["Amount"].stringValue, ExtPersonSRNo: history["ExtPersonSRNo"].stringValue, PackageName: history["PackageName"].stringValue, IsMobEmailConf: history["IsMobEmailConf"].stringValue, DateOfBirth: history["DateOfBirth"].stringValue, PersonName: history["PersonName"].stringValue, BookingStatus: history["BookingStatus"].stringValue, PersonSRNo: history["PersonSRNo"].stringValue, FamilySrNo: history["FamilySrNo"].stringValue, CanBeDeletedFalg: history["CanBeDeletedFalg"].stringValue, PackageSrNo: history["PackageSrNo"].stringValue, RelationName: history["RelationName"].stringValue, SponserdBy: history["SponserdBy"].stringValue, Gender: history["Gender"].stringValue, EmailID: history["EmailID"].stringValue)
                                
                                self.historyModelArray.append(obj)
                            }
                            
                            if self.historyModelArray.count == 0 {
                                self.isLoaded = 1
                                //self.view.stopSkeletonAnimation()
                                //self.view.hideSkeleton()
                             self.noHistoryView.isHidden = false
                            self.tableView.isHidden = true

                            }
                            else {
                                self.isLoaded = 1
                                //self.view.stopSkeletonAnimation()
                                //self.view.hideSkeleton()

                                self.noHistoryView.isHidden = true
                                self.tableView.isHidden = false
                            self.tableView.reloadData()
                            }
                        }
                    }
                    else {
                        self.view.stopSkeletonAnimation()
                        self.view.hideSkeleton()
                        
                        let msg = messageDictionary["Message"]?.stringValue
                        self.displayActivityAlert(title: msg ?? "History Not Found")

                        //employee record not found
                    }
                }
            } //msgDic
        }
    }

}

extension AppointmentHistory: SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        // return "CellForFamilyDetailsCell1"
        return "shimmerCell"
        
    }
    
    
}
