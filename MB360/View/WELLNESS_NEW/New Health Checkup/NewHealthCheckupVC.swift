//
//  NewHealthCheckupVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 23/04/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit
import CenteredCollectionView

class NewHealthCheckupVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,DependantTappedProtocol,MobileNumberVerifyDelegate,NewMemberAddedProtocol,UITabBarDelegate,UITabBarControllerDelegate {
    
  
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cartBottomView: UIView!
    @IBOutlet weak var lblNoOfItems: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var cartStackView: UIStackView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var packageModelArray = [HealthCheckupModel]()
    var personDetailsModel = PersonCheckupModel()
    var hcPackageDetailsModel = HealthCheckupModel()
    var summaryModelObject = SummaryModel()

    //Add member
    var relationModelArray = [RelationDataModel]()
    var serverDate = ""
    var relationStringArray = [String]()
    var isAddMember = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        isReloadFamilyDetails = 1
        bottomConstraint.constant = 0
        setupFamilyDetails()
        
        // Get the reference to the CenteredCollectionViewFlowLayout (REQURED)
        centeredCollectionViewFlowLayout = (collectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout)
        
        // Modify the collectionView's decelerationRate (REQURED)
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        // Assign delegate and data source
        collectionView.delegate = self
        collectionView.dataSource = self
        let screenSize = UIScreen.main.bounds
       
        
        setupMiddleButton()
        
        centeredCollectionViewFlowLayout.itemSize = CGSize(
            //width: view.bounds.width - 50,
            width: view.bounds.width - 70,

            height: screenSize.height * 0.70
        )
        centeredCollectionViewFlowLayout.minimumLineSpacing = 24
        
        //Add gesture on bottom stackview
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(cartTapped))
        self.cartStackView.addGestureRecognizer(gesture1)

        //getPackagesWithFamilyDetailsFromServer(isMoveToHospitalList: false)
       // getSummaryDataFromServer()
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuButton.isHidden = false
        tabBarController?.tabBar.isHidden = false

    }
    
   //MARK- add Shimmer
   override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
       print("VDA..")
      
       //Get Data from Server
       if isReloadFamilyDetails == 1 {
           //view.showAnimatedSkeleton()
           //view.startSkeletonAnimation()

           getPackagesWithFamilyDetailsFromServer(isMoveToHospitalList: false)

       }
       
       //Get Data for Bottom bar view
       getSummaryDataFromServer()
       
       if isAddMember == 1 {
           getRelationDataFromServer()
       }
       

   }
    
    func setupFamilyDetails()
    {
        self.navigationController?.navigationBar.applyGradient()
        self.navigationController?.navigationBar.navBarDropShadow()
        //cartBottomView.backgroundColor = Color.bottomColor.value

        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        let cartBtn =  UIBarButtonItem(image:UIImage(named: "cartW") , style: .plain, target: self, action: #selector(cartTapped))
        cartBtn.imageInsets =  UIEdgeInsetsMake(0, 0, 0, 0)
            //UIEdgeInsetsMake(4, 4, 6, 4)

        
        let notiBtn =  UIBarButtonItem(image:UIImage(named: "notification") , style: .plain, target: self, action: #selector(notificationTapped))
        
        
        navigationItem.rightBarButtonItems = [cartBtn]
        
        self.navigationItem.title = "Available Packages for Family"
        self.navigationController?.navigationBar.changeFont()
        print("In \(navigationItem.title ?? "") NewHealthCheckupVC")
        //self.navigationController?.navigationBar.layer.shouldRasterize=false
        

    }
    
    @objc func notificationTapped() {

    }
    
    @objc func cartTapped() {
           let summaryVC : SummaryViewController = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"SummaryViewController") as! SummaryViewController
           
           menuButton.isHidden = true
           tabBarController?.tabBar.isHidden = true
           //bottomConstraint.constant = 0
           self.navigationController?.pushViewController(summaryVC, animated: true)
       }
    

   @objc func backTapped() {
       self.dismiss(animated: true, completion: nil)
   }
    
    func setupMiddleButton()
    {

        menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 55, height: 55))
        
        var menuButtonFrame = menuButton.frame
        var yValue = CGFloat()
        var xValue = CGFloat()
        
        if(Device.IS_IPAD)
        {
            yValue=(tabBarController?.view.bounds.height)! - (menuButtonFrame.height+15)
            xValue=(tabBarController?.view.bounds.width)!/2 - (menuButtonFrame.size.width/2)
        }
        else if(Device.IS_IPHONE_6)
        {
            yValue=(tabBarController?.view.bounds.height)! - (menuButtonFrame.height+10)
            xValue=(tabBarController?.view.bounds.width)!/2 - menuButtonFrame.size.width/2
        }
        else if(Device.IS_IPHONE_5 || Device.IS_IPHONE_4_OR_LESS)
        {
            yValue=(tabBarController?.view.bounds.height)! - (menuButtonFrame.height+10)
            xValue=(tabBarController?.view.bounds.width)!/2 - (menuButtonFrame.size.width/2)
        }
        else if(Device.IS_IPHONE_X)
        {
            yValue=(tabBarController?.view.bounds.height)! - (menuButtonFrame.height+50)
            xValue=(tabBarController?.view.bounds.width)!/2 - menuButtonFrame.size.width/2
            
            //            m_bottomViewHeightConstraint.constant=70
        }
            
        else if(Device.IS_IPHONE_XsMax)
        {
            yValue=(tabBarController?.view.bounds.height)! - (menuButtonFrame.height+50)
            xValue=(tabBarController?.view.bounds.width)!/2 - menuButtonFrame.size.width/2
        }
        else
        {
            yValue=(tabBarController?.view.bounds.height)! - (menuButtonFrame.height+10)
            xValue=(tabBarController?.view.bounds.width)!/2 - menuButtonFrame.size.width/2
        }
        
        menuButtonFrame.origin.y = yValue
        menuButtonFrame.origin.x = xValue
        menuButton.frame = menuButtonFrame
        menuButton.ShadowForView()
        menuButton.layer.masksToBounds=true
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        menuButton.backgroundColor = hexStringToUIColor(hex: hightlightColor)
        menuButton.setImage(UIImage(named:"Home-2"), for: .normal)

        //menuButton.setBackgroundImage(UIImage(named: "blueEsclip"), for: .normal)
        menuButton.backgroundColor = Color.buttonBackgroundGreen.value
        
        menuButton.contentMode = .scaleAspectFill
        //        menuButton.setGradientBackground(colorTop: hexStringToUIColor(hex: "819ff6"), colorBottom: hexStringToUIColor(hex: "4b66ea"))
        menuButton.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
        
        
        //menuButton.layer.borderWidth = 0.7
        //menuButton.layer.borderColor =  #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
        
        tabBarController?.view.addSubview(menuButton)
        //        view.layoutIfNeeded()
        
    }
    
    @objc private func homeButtonClicked(sender: UIButton)
    {
        tabBarController!.selectedIndex = 2
        //menuButton.backgroundColor = UIColor.red
        //Change menu button image
        let origImage = UIImage(named:"Home-2")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        menuButton.setImage(tintedImage, for: .normal)
       // menuButton.tintColor = Color.buttonBackgroundGreen.value
        menuButton.tintColor = UIColor.white
    }
    
    func getGroupName() -> String {
        //Get Group Info
        var groupNameStr = ""
        let groupMasterArray  =  DatabaseManager.sharedInstance.retrieveGroupChildMasterDetails(productCode:"")
        if groupMasterArray.count > 0 {
            groupNameStr = groupMasterArray[0].groupName!
            return groupNameStr
        }
        return groupNameStr
    }

    
    private func getPackagesWithFamilyDetailsFromServer(isMoveToHospitalList:Bool) {
        
        guard let groupSrNo = UserDefaults.standard.value(forKey: "ExtGroupSrNo") else {
            return
        }
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
            return
        }
        guard let orderMasterNo = UserDefaults.standard.value(forKey: "OrderMasterNo") else {
            return
        }
        
        
        var m_employeedict : EMPLOYEE_INFORMATION?
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        m_employeedict=userArray[0]
        var empidNo = String()
        var groupChildSrNo = ""
        if let empID = m_employeedict?.empIDNo
        {
            empidNo=String(empID)
        }
        if let groupChlNo = m_employeedict?.groupChildSrNo
        {
            groupChildSrNo=String(groupChlNo)
        }
        print(empidNo)
        
        
        let url = APIEngine.shared.getHealthCheckupPackages(ExtGroupSrNo: groupSrNo as! String, GroupCode: getGroupName(), EmpIdNo: empidNo)
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            
            print(response)
            if let messageDictionary = response?["message"].dictionary
            {
                
                if let status = messageDictionary["Status"]?.bool
                {
                    if status == true {
                        self.packageModelArray.removeAll()
                        if let packageArray = response?["PackagesList"].array {
                            for package in packageArray {
                                var personModelArray = [PersonCheckupModel]()

                                //create person object
                                if let personArray = package["Persons"].array {
                                    for person in personArray {
                                        let personModelObj = PersonCheckupModel.init(PersonSRNo: person["PersonSRNo"].int, FamilySrNo: person["FamilySrNo"].string, ExtPersonSRNo: person["ExtPersonSRNo"].string, IsBooking: person["IsBooking"].string, PaymentConfFlag: person["PaymentConfFlag"].string, ApptSrInfoNo: person["ApptSrInfoNo"].string, IsMobEmailConf: person["IsMobEmailConf"].int, Price: person["Price"].string, Amount: person["Amount"].string, BookingStatus: person["BookingStatus"].string, CanBeDeletedFalg: person["CanBeDeletedFalg"].int, SponserdBy: person["SponserdBy"].string, SponserdByFlag: person["SponserdByFlag"].string, PackageSrNo: person["PackageSrNo"].string, PackageName: person["PackageName"].string, PersonName: person["PersonName"].string, Age: person["Age"].string, DateOfBirth: person["DateOfBirth"].string, EmailID: person["EmailID"].string, CellPhoneNumber: person["CellPhoneNumber"].string, Gender: person["Gender"].string, RelationID: person["RelationID"].string, RelationName: person["RelationName"].string, IsBooked: person["IsBooked"].string, IsChbChecked: person["IsChbChecked"].string, IsDisabled: person["IsDisabled"].boolValue, AppointmentStatusBadge: person["AppointmentStatusBadge"].string, paidNotScheduled: person["paidNotScheduled"].string, tooltip: person["tooltip"].string, IsSelectedInWellness: person["IsSelectedInWellness"].string)
                                        
                                        let age = person["Age"].stringValue
                                        if let ageInt = Int(age)
                                        {
                                            if ageInt >= 18 {
                                                personModelArray.append(personModelObj)

                                            }
                                        }
                                    
                                    } //inner for
                                }
                                
                                if personModelArray.count > 0 {
                                let packageObj = HealthCheckupModel.init(PackageSrNo: package["PackageSrNo"].string, PackageName: package["PackageName"].string, IsAgeRestricted: package["IsAgeRestricted"].string, AgeText: package["AgeText"].string, MaxAge: package["MaxAge"].string, MinAge: package["MinAge"].string, IsGenderRestricted: package["IsGenderRestricted"].string, GenderText: package["GenderText"].string, Gender: package["Gender"].string, PackagePrice: package["PackagePrice"].string, payment: package["payment"].string, personModelArray: personModelArray)
                                
                                self.packageModelArray.append(packageObj)
                                }
                            }
                            self.collectionView.reloadData()
                            isReloadFamilyDetails = 0

                            if isMoveToHospitalList == false
                            {
                               // self.isLoaded = 1
                               // self.tableView.hideSkeleton()

                               // self.tableView.reloadData()
                              // self.scrollToFirstRow()
                            }
                            else {
                               // self.isLoaded = 1
                               // self.tableView.hideSkeleton()

                               // self.tableView.reloadData()
                                let vc = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"HospitalsListViewController") as! HospitalsListViewController
                                vc.isFromFamily = 1
                                vc.memberDetailsModel = self.personDetailsModel
                                vc.hcPackageDetailsModel = self.hcPackageDetailsModel
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            
                        }
                        
                    }
                }
            }
        }
    }

}



extension NewHealthCheckupVC {
    
    //MARK:- Protocol Method
    func dependantCellTapped(packageSr: String, depdantSrNo: Int, isSelected: Bool) {
        
        for i in 0..<packageModelArray.count {
            let packageObj = packageModelArray[i]
            if packageObj.PackageSrNo == packageSr {
                for j in 0..<packageObj.personModelArray.count {
                    let personObj = packageObj.personModelArray[j]
                    if personObj.PersonSRNo == depdantSrNo {
                        print("Before Update")
                        print(packageModelArray)

                        self.packageModelArray[i].personModelArray[j].isSelectedByUser = isSelected
                        
                        print("After Update")
                        print(packageModelArray)
                    }
                }
            }
        }
        
//        for obj in packageModelArray {
//            if obj.PackageSrNo == packageSr {
//                for personObj in obj.personModelArray {
//                    if personObj.PersonSRNo == depdantSrNo {
//                        personObj.isSelectedByUser = isSelected
//                    }
//                }
//            }
//        }
        
        
    }
    
    //MARK:- Mobile number Delegate
    func mobileNumberVerified() {
        //reload data
        getPackagesWithFamilyDetailsFromServer(isMoveToHospitalList: true)
    }
    //MARK:- Protocol Methods
    func newMemberAdded() {
        getPackagesWithFamilyDetailsFromServer(isMoveToHospitalList: false)
    }
    
    func scheduleNowTapped(packageSr:String,depdantSrNo:Int,packageInfo:HealthCheckupModel,isMoveToHospital:Bool,personCheckupModel:PersonCheckupModel)
    {
        if personCheckupModel.IsMobEmailConf != 1 {
            let vc = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"VerifyMobileNoViewController") as! VerifyMobileNoViewController
            vc.memberDetailsModel = personCheckupModel
            vc.modalPresentationStyle = .custom
            vc.mobileNumberDelegate = self
            self.personDetailsModel = personCheckupModel
            self.hcPackageDetailsModel = packageInfo

            self.navigationController?.present(vc, animated: true, completion: nil)
        }
        else {
            let vc = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"HospitalsListViewController") as! HospitalsListViewController
           // vc.personDetailsModel = personModelArray[index.row]
            vc.memberDetailsModel = personCheckupModel
            vc.hcPackageDetailsModel = packageInfo
            vc.isFromFamily = 1
            vc.hcPackageDetailsModel = packageInfo
            self.personDetailsModel = personCheckupModel
            self.hcPackageDetailsModel = packageInfo
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
   
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.packageModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: "CellForHCheckupCard"), for: indexPath) as! CellForHCheckupCard
        cell.lblPackageName.text = packageModelArray[indexPath.row].PackageName
        cell.lblAmount.text = packageModelArray[indexPath.row].PackagePrice
        cell.lblGender.text = packageModelArray[indexPath.row].GenderText
        cell.personModelArray = packageModelArray[indexPath.row].personModelArray
        cell.dependantTappedDelegate = self
        cell.packageInfo = packageModelArray[indexPath.row]
        cell.tableView.reloadData()
        
        cell.packageIncludesView.tag = indexPath.row
        cell.packageIncludesView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewPackageDidTapped(_:)))
        cell.packageIncludesView.addGestureRecognizer(tap)
        
        return cell
    }
    
    //MARK:- Package Content Tapped
       @objc func viewPackageDidTapped(_ sender : UITapGestureRecognizer) {
        let tag = sender.view?.tag
           let vc = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"PackageIncludesViewController") as! PackageIncludesViewController
           vc.packageSrNo = packageModelArray[tag!].PackageSrNo ?? ""
           vc.packageName = packageModelArray[tag!].PackageName ?? ""
           let nav:UINavigationController = UINavigationController.init(rootViewController: vc)
           self.present(nav, animated: true)
       }
}


extension NewHealthCheckupVC {
    
    private func getSummaryDataFromServer() {
        //http://mybenefits360.in/mbapi/api/v1/HealthCheckup/GetSummary?FamilySrNo=5560
        
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
            return
        }
        
        //let url = APIEngine.shared.getSummaryDetailsURL(familySRNo: familySrNo as! String, groupCode: "STT")
        let url = APIEngine.shared.getSummaryDetailsURL(familySRNo: familySrNo as! String, groupCode: self.getGroupCode())

        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServerWithoutLoader(url: url, view: self) { (response, error) in
            
            if let messageDictionary = response?["message"].dictionary
            {
                
                if let status = messageDictionary["Status"]?.bool
                {
                    if status == true {
                        if let summaryDict = response?["Summary"].dictionary {
                            
                            var companySponsoredArray = [PersonSummary]()
                            var selfSponsoredArray = [PersonSummary]()
                            
                            //Company Sponsored Array
                            if let companyArray = summaryDict["CompanySponseredPerson"]?.arrayValue {
                                for company in companyArray {
                                    let obj = PersonSummary.init(Name: company["Name"].stringValue, Price: company["Price"].stringValue)
                                    companySponsoredArray.append(obj)
                                }//for
                            }//companyArray
                            
                            if let selfArray = summaryDict["SelfSponseredPerson"]?.arrayValue {
                                for person in selfArray {
                                    let obj = PersonSummary.init(Name: person["Name"].stringValue, Price: person["Price"].stringValue)
                                    selfSponsoredArray.append(obj)
                                }//for
                            }//selfArray
                            
                            
                            let total = summaryDict["Total"]?.stringValue
                            let paid = summaryDict["paid"]?.stringValue
                            let youpay = summaryDict["Youpay"]?.stringValue
                            let confirmbutton = summaryDict["ShowConfirmButton"]?.boolValue
                            
                            if let payAmt = summaryDict["Youpay"]?.string {
                                //self.youPayAmount = Double(payAmt) as! Double
                                
                                //Currency Converter
                                if let myDouble = Double(payAmt) {
                                let currencyFormatter = NumberFormatter()
                                currencyFormatter.usesGroupingSeparator = true
                                currencyFormatter.numberStyle = .currency
                                // localize to your grouping and decimal separator
                                currencyFormatter.locale = Locale.current
                                // We'll force unwrap with the !, if you've got defined data you may need more error checking
                                var priceString = currencyFormatter.string(from: NSNumber(value: myDouble))
                                
                                    priceString = priceString?.replacingOccurrences(of: ".00", with: "")
                                    self.lblAmount.text = String(format: "%@",priceString ?? "")
                                }//if let
                            }
                            
                            
                            self.summaryModelObject = SummaryModel.init(Total: total, paid: paid, Youpay: youpay, ShowConfirmButton: confirmbutton ?? true, CompanySponsoredArray: companySponsoredArray, SelfSponsoredArray: selfSponsoredArray)
                            
                            
                            if self.summaryModelObject.ShowConfirmButton == true {
                                self.cartBottomView.isHidden = false
                                
                                if Device.IS_IPHONE_X || Device.IS_IPHONE_XsMax {
                                    //self.bottomConstraint.constant = (self.tabBarController?.tabBar.frame.height)!
                                    self.bottomConstraint.constant = 40

                                }
                                else {
                                    //Error found 1oct
                                    //Thread 1: EXC_BREAKPOINT (code=1, subcode=0x100861788)
                                    self.bottomConstraint.constant = (self.tabBarController?.tabBar.frame.height)!
                                }
                                
                                
                              //  self.lblAmount.text = String(format: "₹%@",self.summaryModelObject.Youpay ?? "")
                                
                                let noOfItems = self.summaryModelObject.CompanySponsoredArray.count + self.summaryModelObject.SelfSponsoredArray.count
                                
                                if noOfItems > 1 {
                                    self.lblNoOfItems.text = String(format: "%@ Items",String(noOfItems))
                                }
                                else {
                                    self.lblNoOfItems.text = String(format: "%@ Item",String(noOfItems))
                                }

                            }
                            else {
                                self.cartBottomView.isHidden = true
                            }
                            
                        }
                        
                        
                    }//true
                    else {
                        //Summary record not found
                    }
                }
            }//msgDic
        }
    }
    
    private func getRelationDataFromServer() {
        
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
            return
        }
        
        
        let url = APIEngine.shared.getAllRelationsURL(familySrNo: familySrNo as! String)
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            
            if let messageDictionary = response?["message"].dictionary
            {
                
                if let status = messageDictionary["Status"]?.bool
                {
                    if status == true {
                        
                        if let date = response?["ServerDate"]["Date"].stringValue {
                            self.serverDate = date
                        }
                        
                        if let relationArray = response?["Relations"].arrayValue {
                            //To Remove relation duplicates
                            self.relationModelArray.removeAll()
                            self.relationStringArray.removeAll()
                            
                            
                            for relation in relationArray {
                                let obj = RelationDataModel.init(relationId: relation["RelationId"].stringValue, relationName: relation["RelationName"].stringValue)
                                self.relationStringArray.append(relation["RelationName"].stringValue)
                                self.relationModelArray.append(obj)
                            }
                            
                            //Move to add Member screen
                            self.showAddMemberScreen()
                        }
                        
                    }
                    else {
                        //Relations record not found
                    }
                }
            }//msgDic
        }
    }
    
    //MARK:- ADD Member
    private func showAddMemberScreen() {
        if isAddMember == 1 {
            let vc = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"AddMemberViewController") as! AddMemberViewController
            vc.relationDropDown.dataSource = self.relationStringArray
            vc.dataSourceArray = self.relationStringArray
            vc.serverDate = self.serverDate
            vc.relationModelArray = self.relationModelArray
            vc.modalPresentationStyle = .custom
            vc.memberDelegate = self
            
            self.navigationController?.present(vc, animated: true, completion: nil)
            isAddMember = 0
        }
    }
}


extension NewHealthCheckupVC {
    
    func mekeMenuButtonGray() {
        let origImage = UIImage(named:"Home-2")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        menuButton.setImage(tintedImage, for: .normal)
        menuButton.tintColor = UIColor.white

    }
    
      //MARK:- Tab bar delegate
        func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            print("Selected item")
            // item.badgeColor = #colorLiteral(red: 0.2431372549, green: 0.8509803922, blue: 0.6941176471, alpha: 1)
            //tabBar.selectedItem?.badgeColor = UIColor.red
        }
        
        // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected item")
        
        if tabBarController.selectedIndex == 0 { //Add member
            if let canAdd = UserDefaults.standard.value(forKey: "canAddMember") as? Bool {
                if canAdd == true {
                    isAddMember = 1
                    tabBarController.selectedIndex = 2
                    mekeMenuButtonGray()
                }
                else {
                    self.showAlert(message: "Add Family Member Functionality is not available for your Policy")
                }
            }
            else {
                self.showAlert(message: "Add Family Member Functionality is not available for your Policy")
            }
        }
            
        else if tabBarController.selectedIndex == 1 { //History
            //displayActivityAlert(title: "Not Available")
            
            mekeMenuButtonGray()
            
        }
            
        else if tabBarController.selectedIndex == 3 { //Appointments
            
            mekeMenuButtonGray()
            
        }
            
        else if tabBarController.selectedIndex == 4 { //Profile
            
            //displayActivityAlert(title: "Not Available")
            
            mekeMenuButtonGray()
            
        }
            
            
            
        }
}
