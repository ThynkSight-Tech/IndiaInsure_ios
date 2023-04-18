//
//  FamilyMemberListMD_VC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 11/10/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import SkeletonView


class FamilyMemberListMD_VC: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITabBarDelegate,UITabBarControllerDelegate,NewMemberAddedProtocol,MobileNumberVerifyDelegate,UIScrollViewDelegate {
    
    var familyDetailsArray = [FamilyDetailsModel]()
    
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.estimatedRowHeight = 130.0
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    @IBOutlet weak var cartBottomView: UIView!
    
    @IBOutlet weak var lblNoOfItems: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var cartStackView: UIStackView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var isAddMember = 0
    var relationModelArray = [RelationDataModel]()
    var serverDate = ""
    var relationStringArray = [String]()
    
    var personDetailsModel = FamilyDetailsModel()
    var summaryModelObject = SummaryModel()
    
    var scrollOffset:CGFloat = 0
    var isLoaded = 0
    
    
    /*
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
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        isReloadFamilyDetails = 1
        
        //Hide bottom view first
        self.cartBottomView.isHidden = true
        //tableView.isSkeletonable = true
        let nibName = UINib(nibName: "shimeerDefaultCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "shimeerDefaultCell")
        
        self.navigationController?.navigationBar.applyGradient()
        self.navigationController?.navigationBar.navBarDropShadow()
        cartBottomView.backgroundColor = Color.bottomColor.value
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        let cartBtn =  UIBarButtonItem(image:UIImage(named: "cartW") , style: .plain, target: self, action: #selector(cartTapped))
        cartBtn.imageInsets =  UIEdgeInsetsMake(0, 0, 0, 0)
        //UIEdgeInsetsMake(4, 4, 6, 4)
        
        
        //let notiBtn =  UIBarButtonItem(image:UIImage(named: "notification") , style: .plain, target: self, action: #selector(notificationTapped))
        
        
        navigationItem.rightBarButtonItems = [cartBtn]
        
        self.navigationItem.title = "Family Details"
        self.navigationController?.navigationBar.changeFont()
        print("In \(navigationItem.title ?? "family details") FamilyMemberListMD_VC")

        //Add gesture on bottom stackview
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(cartTapped))
        self.cartStackView.addGestureRecognizer(gesture1)
        
        bottomConstraint.constant = 49
        
        setupMiddleButton()
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isLoaded = 0
        self.tabBarController?.tabBar.isHidden = false
        menuButton.isHidden = false
        bottomConstraint.constant = 49
        super.viewWillAppear(true)
        
        
    }
    
    //MARK- add Shimmer
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("VDA..")
        // view.startSkeletonAnimation()
        //let gradient = SkeletonGradient(baseColor: UIColor.silver)
        //view.showGradientSkeleton(usingGradient: gradient) // Gradient
        
        //let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topLeftBottomRight)
        //view.showAnimatedGradientSkeleton(usingGradient: SkeletonAppearance.default.gradient, animation: animation)
        
        //let animation = GradientDirection.leftRight.slidingAnimation()
        // view.showAnimatedGradientSkeleton(usingGradient: SkeletonAppearance.default.gradient, animation: animation)
        
        
        
        //Get Data from Server
        if isReloadFamilyDetails == 1 {
            view.showAnimatedSkeleton()
            view.startSkeletonAnimation()
            
            getFamilyDetailsFromServer(isMoveToHospitalList: false)
            
        }
        
        //Get Data for Bottom bar view
        getSummaryDataFromServer()
        
        if isAddMember == 1 {
            getRelationDataFromServer()
        }
        
        
    }
    
    
    
    
    //MARK:- Protocol Methods
    func newMemberAdded() {
        self.getFamilyDetailsFromServer(isMoveToHospitalList: false)
    }
    
    func mobileNumberVerified() {
        self.getFamilyDetailsFromServer(isMoveToHospitalList: true)
        
    }
    
    @objc func notificationTapped() {
        
    }
    
    
    
    
    @objc func cartTapped() {
        let summaryVC : ViewCartMD_VC = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier:"ViewCartMD_VC") as! ViewCartMD_VC
        
        menuButton.isHidden = true
        tabBarController?.tabBar.isHidden = true
        bottomConstraint.constant = 0
        self.navigationController?.pushViewController(summaryVC, animated: true)
    }
    
    //MARK:- SCROLL
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        if self.summaryModelObject.ShowConfirmButton == true {
//            let height = scrollView.frame.size.height
//
//            if scrollView == tableView {
//                let contentOffset = scrollView.contentOffset.y
//                print("contentOffset: ", contentOffset)
//                if (contentOffset > scrollOffset) { //HIDE Tab Bar, (rows going bottom to top), CO is increasing
//
//                    scrollOffset = contentOffset
//                    print("scrolling Down,",height)
//
//                    if height <= contentOffset { // for last position
//                        tabBarController?.tabBar.isHidden = true
//
//                        menuButton.isHidden = true
//                        if Device.IS_IPHONE_X || Device.IS_IPHONE_XsMax {
//                            bottomConstraint.constant = 15
//                        }
//                        else {
//                            bottomConstraint.constant = 0
//                        }
//                    }
//                    else if contentOffset <= 200 { //Always show for top at 0 position
//                        print("<= 100 FIRST")
//                        if Device.IS_IPHONE_X || Device.IS_IPHONE_XsMax {
//                            bottomConstraint.constant = (tabBarController?.tabBar.frame.height)!
//                        }
//                        else {
//                            bottomConstraint.constant = 49
//                        }
//                        menuButton.isHidden = false
//                        tabBarController?.tabBar.isHidden = false
//
//                    }
//                    else { //always hide tabbar
//                        tabBarController?.tabBar.isHidden = true
//                        menuButton.isHidden = true
//                        if Device.IS_IPHONE_X || Device.IS_IPHONE_XsMax {
//                            bottomConstraint.constant = 15
//                        }
//                        else {
//                            bottomConstraint.constant = 0
//                        }
//
//                    }
//                } else { //SHOW Tab Bar
//                    scrollOffset = contentOffset
//
//                    print("scrolling Up",height)
//
//                    if height - 200.0 <= contentOffset {
//                        tabBarController?.tabBar.isHidden = true
//                        menuButton.isHidden = true
//                        if Device.IS_IPHONE_X || Device.IS_IPHONE_XsMax {
//                            bottomConstraint.constant = 15
//                        }
//                        else {
//                            bottomConstraint.constant = 0
//                        }
//
//                    }
//                    else if contentOffset <= 200 { //Always show for top at 0 position
//                        print("<= 100 SECOND")
//
//                        if Device.IS_IPHONE_X || Device.IS_IPHONE_XsMax {
//                            bottomConstraint.constant = (tabBarController?.tabBar.frame.height)!
//                        }
//                        else {
//                            bottomConstraint.constant = 49
//                        }
//                        menuButton.isHidden = false
//                        tabBarController?.tabBar.isHidden = false
//
//                    }
//
//                    else {
//                        if Device.IS_IPHONE_X || Device.IS_IPHONE_XsMax {
//                            bottomConstraint.constant = (tabBarController?.tabBar.frame.height)!                     }
//                        else {
//                            bottomConstraint.constant = 49
//                        }
//                        menuButton.isHidden = false
//                        tabBarController?.tabBar.isHidden = false
//                    }
//
//                }
//            }
//        }
    }
   
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tableView {
            // print("lastKnowContentOfsset: ", scrollView.contentOffset.y)
            
        }
    }
    
    
    func changeTabBar(hidden:Bool, animated: Bool){
        guard let tabBar = self.tabBarController?.tabBar else { return; }
        if tabBar.isHidden == hidden{ return }
        let frame = tabBar.frame
        let offset = hidden ? frame.size.height : -frame.size.height
        let duration:TimeInterval = (animated ? 0.5 : 0.0)
        tabBar.isHidden = hidden
        menuButton.isHidden = hidden
        
        UIView.animate(withDuration: duration, animations: {
            tabBar.frame = frame.offsetBy(dx: 0, dy: offset)
        }, completion: { (true) in
            tabBar.isHidden = hidden
        })
        
    }
    
    //MARK:- ADD Member
    private func showAddMemberScreen() {
        if isAddMember == 1 {
            let vc = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier:"AddNewMemberMD_VC") as! AddNewMemberMD_VC
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
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
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
            isAddMember = 1
            tabBarController.selectedIndex = 2
            
            mekeMenuButtonGray()
            
            
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
    
    func mekeMenuButtonGray() {
        let origImage = UIImage(named:"Home-2")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        menuButton.setImage(tintedImage, for: .normal)
        menuButton.tintColor = UIColor.white
        
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
    
    //MARK:- TableView Delegate and Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.familyDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cityCell = tableView.dequeueReusableCell(withIdentifier: "CellForOverviewMD", for: indexPath) as! CellForOverviewMD
            cityCell.btnOverview.addTarget(self, action: #selector(overViewTapped1(_:)), for: .touchUpInside)
            cityCell.btnOrder.addTarget(self, action: #selector(overViewTapped2(_:)), for: .touchUpInside)
            cityCell.btnList.addTarget(self, action: #selector(overViewTapped3(_:)), for: .touchUpInside)

            return cityCell
            
        }
        else {
           // let familyInfoCell = tableView.dequeueReusableCell(withIdentifier: "CellForFamilyDetailsCell1", for: indexPath) as! CellForFamilyDetailsCell
            let familyInfoCell = tableView.dequeueReusableCell(withIdentifier: "CellForFamilyMDCell", for: indexPath) as! CellForFamilyMDCell

            familyInfoCell.lblPersonName.text = self.familyDetailsArray[indexPath.row].PersonName
            
            familyInfoCell.lblRelation.text = String(format: "%@ - %@ Years",self.familyDetailsArray[indexPath.row].RelationName?.uppercased() ?? "", self.familyDetailsArray[indexPath.row].Age ?? "")
            
            familyInfoCell.btnSelect.tag = indexPath.row
            familyInfoCell.btnSelect.addTarget(self, action: #selector(selectDidTapped(_:)), for: .touchUpInside)
            
            return familyInfoCell
        }
    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if isLoaded == 0 {
//            return 120
//        }
//        return UITableViewAutomaticDimension
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 60
        }else {
            if isLoaded == 0 {
                return 120
            }
            return UITableViewAutomaticDimension
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            print("Delete Tapped...")
        }
    }
    
    @objc func overViewTapped1(_ sender : UIButton) {
        showOverview(title: "first")
    }
  
    @objc func overViewTapped2(_ sender : UIButton) {
        showOverview(title: "second")
    }
    
    @objc func overViewTapped3(_ sender : UIButton) {
        showOverview(title: "third")
    }
    
    func showOverview(title:String)
    {
        let vc = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier:"InstructionsMedicineVC") as! InstructionsMedicineVC
        vc.tabString = title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:- Package Content Tapped
    @objc func viewPackageDidTapped(_ sender : UIButton) {
//        let vc = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"PackageIncludesViewController") as! PackageIncludesViewController
//        vc.packageSrNo = familyDetailsArray[sender.tag].PackageSrNo ?? ""
//        vc.packageName = familyDetailsArray[sender.tag].PackageName ?? ""
//        let nav:UINavigationController = UINavigationController.init(rootViewController: vc)
//        self.present(nav, animated: true)
    }
    
    
    //MARK:- Delete Button Code
    /*
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action =  UIContextualAction(style: .normal, title: "Delete", handler: { (action,view,completionHandler ) in
            //do stuff
            completionHandler(true)
            print("Delete...")
            if let personSrNo = self.familyDetailsArray[indexPath.row].PersonSRNo {
                self.deleteFamilyMember(personSRNo: personSrNo, indexPath: indexPath)
            }
            
        })
        
        action.image = UIImage(named: "deletew")
        action.backgroundColor = .red
        
        if self.familyDetailsArray[indexPath.row].CanBeDeletedFalg == "1" {
            let confrigation = UISwipeActionsConfiguration(actions: [action])
            return confrigation
            
        }
        else {
            let confrigation = UISwipeActionsConfiguration(actions: [])
            return confrigation
        }
        
        
        
    }
    */
    
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.tableView.subviews.forEach { subview in
            print("YourTableViewController: \(String(describing: type(of: subview)))")
            
            if (String(describing: type(of: subview)) == "UISwipeActionPullView") {
                if (String(describing: type(of: subview.subviews[0])) == "UISwipeActionStandardButton") {
                    var deleteBtnFrame = subview.subviews[0].frame
                    deleteBtnFrame.origin.y = 0
                    deleteBtnFrame.size.height = 110
                    // deleteBtnFrame.size.width = 200
                    
                    subview.subviews[0].backgroundColor = UIColor.red
                    
                    // Subview in this case is the whole edit View
                    subview.frame.origin.y =  subview.frame.origin.y + 0
                    subview.frame.size.height = 110
                    subview.subviews[0].frame = deleteBtnFrame
                    subview.backgroundColor = UIColor.red
                }
            }
        }
    }
    
    //MARK:- Select Tapped
    @objc func selectDidTapped(_ sender:UIButton) {
        let obj = familyDetailsArray[sender.tag]
        let vc = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier: "UploadPrescriptionMD_VC") as! UploadPrescriptionMD_VC
        vc.memberInfoObj = obj
        self.navigationController?.pushViewController(vc, animated: true)
        menuButton.isHidden = true
    }
    
    //MARK:- Delete Family Member
    private func deleteFamilyMember(personSRNo:String,indexPath:IndexPath) {
        print("Insert EMP Info")
        
        let url = APIEngine.shared.deleteFamilyMemberURL(personSRNo:personSRNo)
        print(url)
        
        ServerRequestManager.serverInstance.deleteDataToServer(url: url, view: self, onComplition: { (response, error) in
            
            if let status = response?["Status"].bool
            {
                if status == true {
                    self.familyDetailsArray.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
                else {
                    //Failed to delete person info
                }
            }
        })
    }
    
    //MARK:- Get Data From Server
    private func getFamilyDetailsFromServer(isMoveToHospitalList:Bool) {
        
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
        
        if let empID = m_employeedict?.empIDNo
        {
            empidNo=String(empID)
        }
        
        print(empidNo)
        
        //let url = APIEngine.shared.getFamilyDetailsURL(extGroupSRNo: groupSrNo as! String, empIDNo: empidNo)
        let url = APIEngine.shared.getFamilyMemberMDListURL(empId: empidNo, groupCode: getGroupCode())
        
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServerWithoutLoader(url: url, view: self) { (response, error) in
            
            if let messageDictionary = response?["message"].dictionary
            {
                
                if let status = messageDictionary["Status"]?.bool
                {
                    if status == true {
                        if let personArray = response?["FamilyMembers"].arrayValue {
                            self.familyDetailsArray.removeAll()
                            
                            for person in personArray {
                                
                               

                              
                                let modelObj = FamilyDetailsModel.init(PersonSRNo: person["PersonSRNo"].stringValue, FamilySrNo: person["FamilySrNo"].stringValue, ExtPersonSRNo: person["EXT_PERSON_SR_NO"].stringValue, IsBooking: person["IsBooking"].stringValue, PaymentConfFlag: person["PaymentConfFlag"].stringValue, ApptSrInfoNo: person["ApptSrInfoNo"].stringValue, IsMobEmailConf: person["IsMobEmailConf"].stringValue, Price: person["Price"].stringValue, Amount: person["Amount"].stringValue, BookingStatus: person["BookingStatus"].stringValue, CanBeDeletedFalg: person["CanBeDeletedFalg"].stringValue, SponserdBy: person["SponserdBy"].stringValue, PackageSrNo: person["PackageSrNo"].stringValue, PackageName: person["PackageName"].stringValue, PersonName: person["PERSON_NAME"].stringValue.capitalized, Age: person["AGE"].stringValue, DateOfBirth: person["DOB"].stringValue, EmailID: person["EMAIL_ID"].stringValue, CellPhoneNumber: person["CELLPHONE_NUMBER"].stringValue, Gender: person["GENDER"].stringValue, RelationID: person["RELATIONID"].stringValue, RelationName: person["RELATION_NAME"].stringValue)
                                
                                
                                //let age = person["Age"].stringValue
                               // if let ageInt = Int(age)
                                //{
                                   // if ageInt >= 18 {
                                        self.familyDetailsArray.append(modelObj)
                                  //  }
                               // }
                                
                                
                            }
                            
                            isReloadFamilyDetails = 0
                            
                            if isMoveToHospitalList == false
                            {
                                self.isLoaded = 1
                                self.tableView.hideSkeleton()
                                
                                self.tableView.reloadData()
                                self.scrollToFirstRow()
                            }
                            else {
                                self.isLoaded = 1
                                self.tableView.hideSkeleton()
                                
                                self.tableView.reloadData()
                                let vc = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"HospitalsListViewController") as! HospitalsListViewController
                                vc.isFromFamily = 1
                                vc.personDetailsModel = self.personDetailsModel
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        
                    }
                    else {
                        //employee record not found
                        self.view.stopSkeletonAnimation()
                        self.view.hideSkeleton()
                        let msg = messageDictionary["Message"]?.string
                        self.displayActivityAlert(title: msg ?? "")
                    }
                }else  {
                    print("status  if..let")
                    self.displayActivityAlert(title: "Unable to reach the server")
                }
            } else {
                print("msgdic if..let")
                self.displayActivityAlert(title: "Unable to reach the server")
            }//msgDic
            
        }
    }
    
    func scrollToFirstRow() {
        if familyDetailsArray.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
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
                                
                                //false to true
                                self.cartBottomView.isHidden = true
                                
                                if Device.IS_IPHONE_X || Device.IS_IPHONE_XsMax {
                                    self.bottomConstraint.constant = (self.tabBarController?.tabBar.frame.height)!
                                }
                                else {
                                    //Error found 1oct
                                    //Thread 1: EXC_BREAKPOINT (code=1, subcode=0x100861788)
                                   // self.bottomConstraint.constant = (self.tabBarController?.tabBar.frame.height)!
                                    
                                    if let height = self.tabBarController?.tabBar.frame.height {
                                        self.bottomConstraint.constant = height
                                    }
                                    else {
                                        print("Failed to get Height....")
                                    }
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
    
    
    
}


class CellForFamilyMDCell: UITableViewCell
{
    
    @IBOutlet weak var lblPersonName: UILabel!
    @IBOutlet weak var lblRelation: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    var shimmer = ShimmerButton()
    
    // var shimmer = ShimmerButton()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnSelect.dropShadow()
        //self.btnSelect.layer.cornerRadius = btnSelect.frame.size.height / 2
        //self.btnSelect.backgroundColor = Color.buttonBackgroundGreen.value
        self.btnSelect.makeHHCButton()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}


class CellForOverviewMD: UITableViewCell
{
    @IBOutlet weak var btnOverview: UIButton!
    @IBOutlet weak var btnOrder: UIButton!
    @IBOutlet weak var btnList: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        btnList.makeHHCCircularButton()
        btnOrder.makeHHCCircularButton()
        btnOverview.makeHHCCircularButton()
    }
}

extension FamilyMemberListMD_VC: SkeletonTableViewDataSource {
    
    
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

