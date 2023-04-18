//
//  NursingMemberListVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 10/09/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit
import SkeletonView

enum NursingType {
    case shortTerm
    case longTerm
    case trainedAttendants
    case doctorServices
    case physiotherapy
    case diabetesManagement
    case postNatelCare
    case elderCare
    case dental
}


class NursingMemberListVC: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITabBarDelegate,UITabBarControllerDelegate,NewMemberAddedProtocol,UIScrollViewDelegate, CityNursingNameSelectedProtocol, MobileEmailVerifyProtocol {
    
    

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
    
    @IBOutlet weak var btnOverview: UIButton!
    
    var isAddMember = 0
    var relationModelArray = [RelationDataModel]()
    var serverDate = ""
    var relationStringArray = [String]()
    
    var personDetailsModel = FamilyDetailsModel()
    var summaryModelObject = SummaryModel()
    
    var scrollOffset:CGFloat = 0
    private var isLoaded = 0
    var selectedCityName = ""
    var personDetailsArray = [FamilyDetailsModelHHC]()
    var selectedPersonObject = FamilyDetailsModelHHC()

    var cityModelArray = [CityListModel]()

    //var personDetailsArray = Array<PERSON_INFORMATION>()
    var sortedPersonDetailsArray = Array<PERSON_INFORMATION>()
    var m_policyDetailsArray = Array<OE_GROUP_BASIC_INFORMATION>()
    
    var selectedCityObject = CityListModel()
    var selectedNursingType : NursingType?
    var selectedPersonObj = FamilyDetailsModelHHC()

    var addressLocation = ""
    var isRemoveLocation = false
    
    var isDateRange = false
    var selectedPackageIndex = -1
    var cartBarButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //To set Nav bar color
        navigationController?.view.applyGradient(colours: [Color.greenTop.value, Color.greenBottom.value], locations: nil)
       
        isReloadFamilyDetails = 1
        
        self.tabBarController?.tabBar.inActiveTintColorGreen()
        
        //Hide bottom view first
        self.cartBottomView.isHidden = true
        tableView.isSkeletonable = true
        let nibName = UINib(nibName: "shimeerDefaultCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "shimeerDefaultCell")
        
        tableView.register(ChangeCityCell_W.self, forCellReuseIdentifier: "ChangeCityCell_W")
        tableView.register(UINib (nibName: "ChangeCityCell_W", bundle: nil), forCellReuseIdentifier: "ChangeCityCell_W")

        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn

        
        self.navigationController?.navigationBar.applyGradient()
        self.navigationController?.navigationBar.navBarDropShadow()
        cartBottomView.backgroundColor = Color.bottomColor.value
        
        if #available(iOS 13.0, *) {
            let notiBtn =  UIBarButtonItem(image:UIImage(systemName: "info.circle.fill") , style: .plain, target: self, action: #selector(notificationTapped))
            //let notiBtn: UIBarButtonItem = UIBarButtonItem(title: "Overview", style: .done, target: self, action: #selector(self.notificationTapped))
            notiBtn.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Poppins-SemiBold", size: 17.0)!], for: .normal)

            notiBtn.tintColor = UIColor.white
            //navigationItem.rightBarButtonItems = [notiBtn]

        } else {
            // Fallback on earlier versions
        }
        
        
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
            lbNavTitle.textColor = UIColor.white
            lbNavTitle.numberOfLines = 0
            lbNavTitle.center = CGPoint(x: 0, y: 0)
            lbNavTitle.textAlignment = .left
            lbNavTitle.font = UIFont(name:"Poppins-SemiBold", size: 17.0)

        self.cartBarButton =  UIBarButtonItem(image:UIImage(named: "cartW") , style: .plain, target: self, action: #selector(cartTapped))
        self.cartBarButton.imageInsets =  UIEdgeInsetsMake(0, 0, 0, 0)
        navigationItem.rightBarButtonItem = cartBarButton
        
        switch selectedNursingType {
        
        case .trainedAttendants:
            lbNavTitle.text = "Trained Attendant"
            self.navigationItem.titleView = lbNavTitle
          
           // self.navigationItem.title = "Trained Attendant"
            
        case .longTerm:
            lbNavTitle.text = "Long Term Nursing"
            self.navigationItem.titleView = lbNavTitle
            //self.navigationItem.title = "Long Term Nursing"
            
        case .shortTerm:
            lbNavTitle.text = "Short Term Nursing"
            self.navigationItem.titleView = lbNavTitle
            //self.navigationItem.title = "Short Term Nursing"
            
        case .doctorServices:
            lbNavTitle.text = "Doctor Services"
            self.navigationItem.titleView = lbNavTitle
            //self.navigationItem.title = "Doctor Services"
            
        case .physiotherapy:
            lbNavTitle.text = "Physiotherapy"
            self.navigationItem.titleView = lbNavTitle
            //self.navigationItem.title = "Physiotherapy"
            
        case .diabetesManagement:
            if #available(iOS 16.0, *) {
                                navigationItem.rightBarButtonItem?.isHidden = true
                            } else {
                                // Fallback on earlier versions
                                navigationItem.rightBarButtonItem = nil
                            }
            lbNavTitle.text = "Diabetes Management"
            self.navigationItem.titleView = lbNavTitle
            //self.navigationItem.title = "Diabetes Management"
            
        case .postNatelCare:
            lbNavTitle.text = "Post Natal Care"
            self.navigationItem.titleView = lbNavTitle
            //self.navigationItem.title = "Post Natal Care"
            
        case .elderCare:
            lbNavTitle.text = "Elder Care"
            self.navigationItem.titleView = lbNavTitle
            //self.navigationItem.title = "Elder Care"
            
        case .dental:
            lbNavTitle.text = "Dental"
            self.navigationItem.titleView = lbNavTitle
            //self.navigationItem.title = "Dental"
            
        default:
            break
        }
        print("In \(navigationItem.title ?? "") NursingMemberListVC")

        self.navigationController?.navigationBar.changeFont()
        
        //Add gesture on bottom stackview
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(cartTapped))
        self.cartStackView.addGestureRecognizer(gesture1)
        
        bottomConstraint.constant = 49
        
        setupMiddleButton()
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
        
        getFamilyDetailsFromServer(isMoveToSelectOptions: false)
        
        //setUpRightBarButton()
        //getCovragesDetails() //Offline members
        getNursingLocationListFromServer()
       // checkServisableCity()
        btnOverview.makeHHCCircularButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isLoaded = 1
        self.tabBarController?.tabBar.isHidden = false
        menuButton.isHidden = false
        bottomConstraint.constant = 49
        super.viewWillAppear(true)
    }
    
    //MARK:- Get Colored Text
    func getColoredText(string_to_color:String,color:UIColor,fullString:String) -> NSMutableAttributedString {
        
        let range = (string_to_color as NSString).range(of: string_to_color)
        let attribute = NSMutableAttributedString.init(string: fullString)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        
        return attribute
    }
    
    func setUpRightBarButton() {
        
        let cartBtn =  UIBarButtonItem(image:UIImage(named: "cartW") , style: .plain, target: self, action: #selector(cartTapped))
        cartBtn.imageInsets =  UIEdgeInsetsMake(0, 0, 0, 0)
        //UIEdgeInsetsMake(4, 4, 6, 4)
       navigationItem.rightBarButtonItems = [cartBtn]

        
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 12, height: 12)

        menuBtn.setImage(UIImage(named:"cartW"), for: .normal)
        menuBtn.addTarget(self, action: #selector(self.rightButtonClicked), for: UIControlEvents.touchUpInside)
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        menuBarItem.imageInsets =  UIEdgeInsetsMake(4, 4, 4, 4)

        //navigationItem.rightBarButtonItems = [cartBtn,menuBarItem]

    }

    @IBAction func btnOverviewAct(_ sender: Any) {
        showOverview(isPrice: false)
    }
    
    func showOverview(isPrice : Bool)
    {
        let vc = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier: "WellnessOverviewVC") as! WellnessOverviewVC
        vc.selectedNursingType = self.selectedNursingType
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        if isPrice {
            vc.isPackagePrice = true
        }
        else {
            vc.isPackagePrice = false
        }
        navigationController?.pushViewController(vc, animated: true)
        //self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    //MARK:- Check Serviceable City
    private func checkServisableCity(){
        if !isRemoveLocation {
        if addressLocation == "" || !(self.cityModelArray.contains(where: {$0.City?.lowercased() == self.addressLocation.lowercased()})) {
            
            let alert = UIAlertController(title: "Please select city", message: "", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                self.navigationController?.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Change City", style: .default, handler: { action in
                self.moveToChangeCity()

            }))

            self.present(alert, animated: true)

        }
        else {
            //self.lbl =
            selectedCityName = addressLocation
            print("LOCATION=\(addressLocation)")
            let filterArray = self.cityModelArray.filter({$0.City?.lowercased() == self.addressLocation.lowercased()})
            if filterArray.count > 0 {
                 self.selectedCityObject = filterArray[0]
            }
            self.tableView.reloadData()
        }
        }
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
            
            //uncomment later - Nursing
            //view.showAnimatedSkeleton()
            //view.startSkeletonAnimation()
            
            getFamilyDetailsFromServer(isMoveToSelectOptions: false)
            
        }
        
        //Get Data for Bottom bar view
        //getSummaryDataFromServer()
        
        if isAddMember == 1 {
            getRelationDataFromServer()
        }
        
        
    }
    
    
    //MARK:- Protocol Methods
    func newMemberAdded() {
        self.getFamilyDetailsFromServer(isMoveToSelectOptions: false)
    }
    
    func isMobileEmailVerified(isSuccess: Bool, selectedPersonObj: FamilyDetailsModelHHC) {
       // moveToSelectOptions(personObj: selectedPersonObj)
        getFamilyDetailsFromServer(isMoveToSelectOptions: true)
//        let vc = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier: "SelectOptionsVC_WN") as! SelectOptionsVC_WN
//        vc.selectedCityObject = self.selectedCityObject
//        //vc.memberInfoObj = obj
//        vc.selectedPersonObj = selectedPersonObj
//        vc.selectedNursingType = self.selectedNursingType
//
//        self.navigationController?.pushViewController(vc, animated: true)

    }

//    func mobileNumberVerified() {
//        self.getFamilyDetailsFromServer(isMoveToHospitalList: true)
//
//    }
    
    @objc func notificationTapped() {
        showOverview(isPrice: false)
        
    }
    
    
    
    
    @objc func cartTapped() {
        //let summaryVC : ViewCartMD_VC = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier:"ViewCartMD_VC") as! ViewCartMD_VC
        
        //menuButton.isHidden = true
        //tabBarController?.tabBar.isHidden = true
       // bottomConstraint.constant = 0
        //self.navigationController?.pushViewController(summaryVC, animated: true)
        let vc = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier: "NursingReviewVC_WN") as! NursingReviewVC_WN
        vc.isDataPresent = false
        //bottomConstraint.constant = 0
        self.navigationController?.pushViewController(vc, animated: true)
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
            //let vc = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier:"AddNewMemberMD_VC") as! AddNewMemberMD_VC
            
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
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Tab bar delegate
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item")
        
        // item.badgeColor = #colorLiteral(red: 0.2431372549, green: 0.8509803922, blue: 0.6941176471, alpha: 1)
        //tabBar.selectedItem?.badgeColor = UIColor.red
    }
    
    
    func tabBarController(_: UITabBarController, shouldSelect: UIViewController) -> Bool
    {
        print("Should Select")
        return true
    }
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected item")
        //Commented by Shubham
        
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
        //menuButton.setGradientBackground(colorTop: hexStringToUIColor(hex: "819ff6"), colorBottom: hexStringToUIColor(hex: "4b66ea"))
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.familyDetailsArray.count + 1
//        if section == 0 {
//            return 1 //for overview cell
//        }
        
        return personDetailsArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let cityCell = tableView.dequeueReusableCell(withIdentifier: "CellForOverviewHHC", for: indexPath) as! CellForOverviewHHC
//            cityCell.btnOverview.addTarget(self, action: #selector(overViewTapped(_:)), for: .touchUpInside)
//
//            cityCell.btnRates.addTarget(self, action: #selector(packagePriceTapped(_:)), for: .touchUpInside)
//            cityCell.btnRates.isHidden = true
//            return cityCell
//        }
//        else {
        
        if indexPath.row == 0 {
            let cityCell = tableView.dequeueReusableCell(withIdentifier: "ChangeCityCell_W", for: indexPath) as! ChangeCityCell_W
            cityCell.lblCityName.text = selectedCityName
                //+ " \u{25BE}"
           // if cityCell.lblCityName.text! == "" {
           // }
            cityCell.btnCity.addTarget(self, action: #selector(changeLocationTapped(_:)), for: .touchUpInside)

            if isRemoveLocation {
                cityCell.isHidden = true
            }
            else {
                cityCell.isHidden = false
            }
            return cityCell
        }
            
        else {
            let familyInfoCell = tableView.dequeueReusableCell(withIdentifier: "CellForNursingMemberList", for: indexPath) as! CellForNursingMemberList
           
            familyInfoCell.lblPersonName.text = personDetailsArray[indexPath.row - 1].PersonName?.capitalized
            familyInfoCell.lblRelation.text = personDetailsArray[indexPath.row - 1].RelationName?.capitalized
            
            //Set Age
            if let age = personDetailsArray[indexPath.row - 1].AGE {
                if age != "" {
                    if age == "0" || age == "1" {
                        familyInfoCell.lblAge.text = String(format: "%@ Year",personDetailsArray[indexPath.row - 1].AGE ?? "")
                        
                    }
                    else {
                        familyInfoCell.lblAge.text = String(format: "%@ Years",personDetailsArray[indexPath.row - 1].AGE ?? "")
                    }
                }
                else {
                    familyInfoCell.lblAge.text = ""

                }
            }
            familyInfoCell.lblAge.isHidden = true
            familyInfoCell.lblRelation.text = "\(familyInfoCell.lblRelation.text!) (\(familyInfoCell.lblAge.text!))"
            
//            if personDetailsArray[indexPath.row - 1].IS_ADDRESS_SAVED == "0" {
//                familyInfoCell.lblViewDetails.text = "Add Address"
//            }
//            else {
//                familyInfoCell.lblViewDetails.text = "Select Package"
//            }
            
            familyInfoCell.btnSelect.tag = indexPath.row - 1
            familyInfoCell.btnSelect.addTarget(self, action: #selector(selectDidTapped(_:)), for: .touchUpInside)
            
            familyInfoCell.lblViewDetails.tintColor = Color.buttonBackgroundGreen.value
            if indexPath.row == selectedPackageIndex {
                //familyInfoCell.cellForViewDetailsView.isHidden = false
                //familyInfoCell.imgTickView.isHidden = false
                familyInfoCell.imgTickView.image = UIImage(named: "Check Box - Checked-1")
                //familyInfoCell.heightForViewDetails.constant = 50
                if personDetailsArray[indexPath.row - 1].IS_ADDRESS_SAVED == "0" {
                    familyInfoCell.lblViewDetails.text = "Add Address"
                }
                else {
                    familyInfoCell.lblViewDetails.text = "Get Package"
                    
                }
            }
            else
            {
               // familyInfoCell.cellForViewDetailsView.isHidden = true
                //familyInfoCell.imgTickView.isHidden = false
               // familyInfoCell.heightForViewDetails.constant = 0
                familyInfoCell.imgTickView.image = UIImage(named: "Check Box - Unchecked-1")
                familyInfoCell.lblViewDetails.text = "Select Member"

            }
            
            return familyInfoCell
        }
        //}
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
//        if indexPath.section == 0 {
//            return 80
//
//        }
//        else {
        
            //        if isLoaded == 0 {
            //            return 120
            //        }
        
            if indexPath.row == 0 {
                if isRemoveLocation {
                return 0
                }
                return 70
            }
            return 135
        //}
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if indexPath.section != 0 {
            //self.selectedMemberIndex = indexPath.row
           // self.tableView.reloadData()
        //}
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            print("Delete Tapped...")
        }
    }
    
    //MARK:- Change Location
       //When user tap on change location
       @objc func changeLocationTapped(_ sender : UIButton) {
           moveToChangeCity()
       }
    
    @objc func overViewTapped(_ sender : UIButton) {
        showOverview(isPrice: false)
    }
    
    @objc func packagePriceTapped(_ sender : UIButton) {
        showOverview(isPrice: true)
    }

    private func moveToChangeCity(){
        let vc : SelectLocationViewController = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier: "SelectLocationViewController") as! SelectLocationViewController
        vc.selectedCity = selectedCityName
        vc.cityNursingDelegate = self
        vc.isFromNursing = true
        vc.nursingType = selectedNursingType
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
        //MARK:- City Selection Delegate
    func citySelected(cityName: String, cityModel: CityListModel) {
                  //isFromLocation = 1
        self.selectedCityName = cityName
        self.addressLocation = cityName
        self.selectedCityObject = cityModel
        print(selectedCityObject)
        let indexPath = IndexPath.init(row: 0, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
       }
    
    
    
    //MARK:- Package Content Tapped
    @objc func viewPackageDidTapped(_ sender : UIButton) {
//        let vc = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"PackageIncludesViewController") as! PackageIncludesViewController
//        vc.packageSrNo = familyDetailsArray[sender.tag].packageSrNo ?? ""
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
    
    //MARK:- Select Tapped goto Package List
    @objc func selectDidTapped(_ sender:UIButton) {
//        if selectedNursingType == NursingType.diabetesManagement {
//            let vc  = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"DiabetesManagementVC") as! DiabetesManagementVC
//            vc.selectedPersonObj = self.personDetailsArray[sender.tag]
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//
//        else {
        
        //self.selectedMemberIndex = sender.tag
        print(sender.tag)
        if (selectedPackageIndex - 1) == sender.tag {
        if !isRemoveLocation {
        if addressLocation == "" || !(self.cityModelArray.contains(where: {$0.City?.lowercased() == self.addressLocation.lowercased()})) {

            let alert = UIAlertController(title: "Please select city", message: "", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                self.navigationController?.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Change City", style: .default, handler: { action in
                self.moveToChangeCity()

            }))

            self.present(alert, animated: true)

        }
        else {
            let filterArray = self.cityModelArray.filter({$0.City?.lowercased() == self.addressLocation.lowercased()})
            if filterArray.count > 0 {
                 self.selectedCityObject = filterArray[0]
                self.selectedCityName = self.selectedCityObject.City ?? ""
            }
            
            
            let personObj = self.personDetailsArray[sender.tag]
            self.selectedPersonObj = personObj
//            if selectedNursingType == NursingType.elderCare {
//
//                self.moveToElderCarePackages(personObj: personObj)
//            }
//            else {
                
            if personObj.IS_ADDRESS_SAVED == "0" {
                let vc  = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier:"EnterAddressVC_HHCC") as! EnterAddressVC_HHC
                vc.selectedCityObject = self.selectedCityObject
                vc.personDetailsDict = personObj
                vc.selectedNursingType = self.selectedNursingType
                vc.delegateObject = self
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .custom
                navigationController?.present(vc, animated: true, completion: nil)
            }
            else {
                    if selectedNursingType == NursingType.elderCare {
                        self.moveToElderCarePackages(personObj: personObj)
                    }else if selectedNursingType == NursingType.dental{
                        self.moveToDentalPackages(personObj: personObj)
                    }
                    else {
                        moveToSelectOptions(personObject: personObj)
                    }
                }
                
            //}

        //menuButton.isHidden = true
        }
        }
        else { //Move To diabetes
            let personObj = self.personDetailsArray[sender.tag]
            self.selectedPersonObj = personObj

            if personObj.IS_ADDRESS_SAVED == "0" {
                let vc  = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier:"EnterAddressVC_HHCC") as! EnterAddressVC_HHC
                vc.selectedCityObject = self.selectedCityObject
                vc.personDetailsDict = personObj
                vc.selectedNursingType = self.selectedNursingType
                vc.delegateObject = self
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .custom
                navigationController?.present(vc, animated: true, completion: nil)
            }
            else {
                    moveToDiabetes()
                }
        }
       // }
        }
        else {
            selectedPackageIndex = sender.tag + 1
            self.tableView.reloadData()
        }
    }
    
    private func moveToDiabetes() {
        let vc  = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"DiabetesManagementVC") as! DiabetesManagementVC
        vc.selectedPersonObj = self.selectedPersonObj
        vc.selectedCityObject = self.selectedCityObject
        vc.selectedNursingType = self.selectedNursingType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //When mobile number is verified -> delegate method is called -> moveToSelectOptions is called
    private func moveToSelectOptions(personObject:FamilyDetailsModelHHC) {
        if selectedNursingType == NursingType.elderCare {
            moveToElderCarePackages(personObj:personObject)
        }
        else {
        let vc = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier: "SelectOptionsVC_WN") as! SelectOptionsVC_WN
            print(selectedCityObject)
        vc.selectedCityObject = self.selectedCityObject
        //vc.memberInfoObj = obj
        vc.selectedPersonObj = personObject
        vc.selectedNursingType = self.selectedNursingType

        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func moveToElderCarePackages(personObj:FamilyDetailsModelHHC) {
        let vc  = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"ElderCarePackageSeletionVC") as! ElderCarePackageSeletionVC
        vc.selectedCityObject = self.selectedCityObject
        
        vc.selectedPersonObj = personObj
        vc.selectedNursingType = self.selectedNursingType
        
        if selectedCityObject.Is_metro == "0" {
            vc.isMetroCities = false
        }
        else {
            vc.isMetroCities = true
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func moveToDentalPackages(personObj:FamilyDetailsModelHHC) {
        let vc  = UIStoryboard.init(name: "Dental", bundle: nil).instantiateViewController(withIdentifier:"DentalPackagesNewViewController") as! DentalPackagesNewViewController
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:- getServiceId
    //Delete Family Member
//    private func deleteFamilyMember(personSRNo:String,indexPath:IndexPath) {
//        print("Insert EMP Info")
//
//        let url = APIEngine.shared.deleteFamilyMemberURL(personSRNo:personSRNo)
//        print(url)
//
//        ServerRequestManager.serverInstance.deleteDataToServer(url: url, view: self, onComplition: { (response, error) in
//
//            if let status = response?["Status"].bool
//            {
//                if status == true {
//                    self.familyDetailsArray.remove(at: indexPath.row)
//                    self.tableView.reloadData()
//                }
//                else {
//                    //Failed to delete person info
//                }
//            }
//        })
//    }
    
    private func getServiceId() -> String {
        /*
         10                NURSING ATTENDANT=
         11                LONG TERM NURSING=
         12                SHORT TERM NURSING
         13                DOCTOR SERVICES
         14                PHYSIOTHERAPY
         15                DIABETESE MANAGEMENT
         16                ELDER CARE
         17                POST NATAL CARE
         */
        switch selectedNursingType {
        case .trainedAttendants:
            return "10"//"18"//
            
        case .longTerm:
            return "11"
            
        case .shortTerm:
            return "12"
            
        case .doctorServices:
            return "13"
            
        case .physiotherapy:
            return "14"
            
        case .diabetesManagement:
            return "15"
            
        case .postNatelCare:
            return "16"
            
        case .elderCare:
            return "17"
        
        case .dental:
            return "10"//"18"//
            
            
        default:
            return ""
            break
        }
        
    }
    
    //MARK:- Get Data From Server
    private func getFamilyDetailsFromServer(isMoveToSelectOptions:Bool) {
     
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
        let serviceId = getServiceId()
        let url = APIEngine.shared.getFamilyMembersHHC_API(empId: empidNo, groupCode:self.getGroupCode(), WellSrNo: serviceId)
        //let url = APIEngine.shared.getFamilyMembersHHC_API(empId: "NAYASA02", groupCode:"NAYASA1", WellSrNo: serviceId)
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            
            if let messageDictionary = response?["message"].dictionary
            {
                
                if let status = messageDictionary["Status"]?.bool
                {
                    if status == true {
                        if let personArray = response?["FamilyMembers"].arrayValue {
                            self.personDetailsArray.removeAll()
                            //print(personArray)
                            for person in personArray {
                                
                                let modelObj = FamilyDetailsModelHHC.init(PersonName: person["PERSON_NAME"].stringValue.capitalized, DateOfBirth: person["DOB"].stringValue, Gender: person["GENDER"].stringValue, RelationID: person["RELATIONID"].stringValue, RelationName: person["RELATION_NAME"].stringValue.capitalized, EXT_EMPLOYEE_SR_NO: person["EXT_EMPLOYEE_SR_NO"].stringValue, ExtPersonSRNo: person["EXT_PERSON_SR_NO"].stringValue, CellPhoneNumber: person["CELLPHONE_NUMBER"].stringValue, EmailID: person["EMAIL_ID"].stringValue, IS_ADDRESS_SAVED: person["IS_ADDRESS_SAVED"].stringValue,AGE:person["AGE"].stringValue)
                                    
                                let age = person["AGE"].stringValue
                                let relationID = person["RELATIONID"].stringValue
                                let gender = person["GENDER"].stringValue
                                let ext_emplyee_sr_no = person["EXT_EMPLOYEE_SR_NO"].stringValue
                                
                                print("age:::",age)
                                print("relationID:::",relationID)
                                let ageInt = Int(age)
                                
                                if let relationIDInt = Int(relationID)
                                    {
                                    if self.selectedNursingType == NursingType.elderCare{
                                        if relationIDInt == 1 || relationIDInt == 2 || relationIDInt == 5 || relationIDInt == 6{
                                            self.personDetailsArray.append(modelObj)
                                        }
                                    }
                                    else if self.selectedNursingType == NursingType.postNatelCare{
                                        /*if (relationIDInt == 2 || relationIDInt == 4 || relationIDInt == 6 || relationIDInt == 11) && ageInt ?? 0 >= 18{
                                            self.personDetailsArray.append(modelObj)
                                        }*/
                                        
                                        if gender.uppercased() == "FEMALE" && ageInt ?? 0 >= 18{
                                            self.personDetailsArray.append(modelObj)
                                        }
                                    }
                                    else{
                                        self.personDetailsArray.append(modelObj)
                                    }
                                    
                                    //self
                                    if relationID == "17" && ext_emplyee_sr_no != ""{
                                        print("ext_emplyee_sr_no ",ext_emplyee_sr_no)
                                    }
                                }

                            }
                            if self.personDetailsArray.isEmpty{
                                print("personDetailsArray list isEmpty")
                                self.displayActivityAlert(title: "No members found!")
                            }
                            
                            isReloadFamilyDetails = 0
                            
                            if isMoveToSelectOptions == false
                            {
                                self.tableView.reloadData()
                                self.scrollToFirstRow()
                            }
                            else {
                                
                                if self.selectedNursingType == NursingType.diabetesManagement {
                                    self.tableView.reloadData()
                                    self.moveToDiabetes()
                                }
                                else {
                                    self.tableView.reloadData()
                                    self.moveToSelectOptions(personObject: self.selectedPersonObj)
                                }
                                
//                                let vc = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"HospitalsListViewController") as! HospitalsListViewController
//                                vc.isFromFamily = 1
//                                vc.personDetailsModel = self.personDetailsModel
//                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        
                    }
                    else {
                        //employee record not found
                        self.view.stopSkeletonAnimation()
                        self.view.hideSkeleton()
                        //let msg = messageDictionary["Message"]?.string
                        self.displayActivityAlert(title: m_errorMsg )
                    }
                }
            }//msgDic
        }
    }
    
    func scrollToFirstRow() {
        if personDetailsArray.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    //MARK:- Get Relations
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
    

    //MARK:- Get Summary Data
    private func getSummaryDataFromServer() {
        //http://mybenefits360.in/mbapi/api/v1/HealthCheckup/GetSummary?FamilySrNo=5560
        
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
            return
        }
        
        //let url = APIEngine.shared.getSummaryDetailsURL(familySRNo: familySrNo as! String, groupCode: "STT")
        let url = APIEngine.shared.getSummaryDetailsURL(familySRNo: familySrNo as! String, groupCode: self.getGroupCode())

        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            
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




extension NursingMemberListVC: SkeletonTableViewDataSource {
    
    
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



extension NursingMemberListVC {
       //Get Data From Server
    private func getNursingLocationListFromServer() {

        let url = APIEngine.shared.getCityListForNursing(nursingType: selectedNursingType!)
           print(url)
           ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
               
               if let messageDictionary = response?["message"].dictionary
               {
                   if let status = messageDictionary["Status"]?.bool
                   {
                       if status == true {
                          
                        
                           if let citiesArray = response?["Cities"].arrayValue {
                               
                               for city in citiesArray {
                                   let obj = CityListModel.init(City: city["City"].stringValue, Is_metro: city["Is_metro"].stringValue, Srno: city["Srno"].stringValue)
                                self.cityModelArray.append(obj)
                               }
                            
                            if self.cityModelArray.count > 0 {
                               // self.selectedCityObject = self.cityModelArray[0]
                               // self.selectedCityName = self.selectedCityObject.City ?? "Mumbai"
                                
                                let filterArray = self.cityModelArray.filter({$0.City?.lowercased() == self.addressLocation.lowercased()})
                                if filterArray.count > 0 {
                                     self.selectedCityObject = filterArray[0]
                                     self.selectedCityName = self.selectedCityObject.City ?? "Mumbai"
                                }
                                else {
                                    self.selectedCityName = self.addressLocation
                                }
                                
                                
                                let index = IndexPath(row: 0, section: 0)
                                self.tableView.reloadRows(at: [index], with: .automatic)
                            }
                           }
                       }
                       else {
                           //let msg = messageDictionary["Message"]?.stringValue
                        self.displayActivityAlert(title: m_errorMsg )
                       }
                       
                   }
                
                self.checkServisableCity()
                   
               }
               else {
                self.checkServisableCity()
            }
           }//msgDic
       }
}
