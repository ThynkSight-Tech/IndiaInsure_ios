//
//  DentalPackagesVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 01/01/21.
//  Copyright © 2021 Semantic. All rights reserved.
//

import UIKit

struct DentalPackageModel {
    var packageName : String?
    var packagePrice : String?
    var packageImage : String?
}


class DentalPackagesWVC: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITabBarDelegate,UITabBarControllerDelegate,NewMemberAddedProtocol,UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.estimatedRowHeight = 130.0
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    var isAddMember = 0
    var relationModelArray = [RelationDataModel]()
    var serverDate = ""
    var relationStringArray = [String]()
    
    var personDetailsModel = FamilyDetailsModel()
    var summaryModelObject = SummaryModel()
    
    var scrollOffset:CGFloat = 0
    var isLoaded = 0
    var selectedCityName = ""
    var packageDetailsArray = [DentalPackageModel]()

    //var personDetailsArray = Array<PERSON_INFORMATION>()
    var sortedPersonDetailsArray = Array<PERSON_INFORMATION>()
    var m_policyDetailsArray = Array<OE_GROUP_BASIC_INFORMATION>()
    var selectedMemberIndex = -1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        isReloadFamilyDetails = 1
        self.tabBarController?.tabBar.inActiveTintColorGreen()
        

        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn

        
        self.navigationController?.navigationBar.applyGradient()
        self.navigationController?.navigationBar.navBarDropShadow()
        
        self.navigationController?.navigationBar.changeFont()
        
        
        setupMiddleButton()
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate
        
        self.navigationItem.title = "Dental Packages"
        print("In \(navigationItem.title ?? "") DentalPackagesWVC")
        getData()
    }
    
    private func getData() {
        let obj1 = DentalPackageModel.init(packageName: "WISDOM TOOTH EXTRACTION", packagePrice: "4,499", packageImage: "")
        let obj2 = DentalPackageModel.init(packageName: "DENTAL IMPLANT WITH CERAMIC CROWN(KOREAN)", packagePrice: "17,999", packageImage: "")
        let obj3 = DentalPackageModel.init(packageName: "DENTAL IMPLANT WITH CERAMIC CROWN(GERMAN)", packagePrice: "27,999", packageImage: "")
        let obj4 = DentalPackageModel.init(packageName: "SMILE DESIGNING", packagePrice: "", packageImage: "76,999")
        let obj5 = DentalPackageModel.init(packageName: "SINGLE ARCH REHAB", packagePrice: "1,09,999", packageImage: "")
        let obj6 = DentalPackageModel.init(packageName: "DOUBLE ARCH REHAB", packagePrice: "2,09,999", packageImage: "")
        let obj7 = DentalPackageModel.init(packageName: "CLEANING AND POLISHING WITH DENTAL CHECKUP", packagePrice: "499", packageImage: "")
        let obj8 = DentalPackageModel.init(packageName: "CLEANING AND FILLING WITH DENTAL CHECKUP", packagePrice: "1,999", packageImage: "")
        let obj9 = DentalPackageModel.init(packageName: "CLEANING AND WHITENING WITH DENTAL CHECKUP", packagePrice: "3,999", packageImage: "")
        let obj10 = DentalPackageModel.init(packageName: "ROOT CANAL AND CROWN WITH DENTAL CHECKUP", packagePrice: "4,999", packageImage: "")
      
        self.packageDetailsArray.append(obj1)
        self.packageDetailsArray.append(obj2)
        self.packageDetailsArray.append(obj3)
        self.packageDetailsArray.append(obj4)
        self.packageDetailsArray.append(obj5)
        self.packageDetailsArray.append(obj6)
        self.packageDetailsArray.append(obj7)
        self.packageDetailsArray.append(obj8)
        self.packageDetailsArray.append(obj9)
        self.packageDetailsArray.append(obj10)

        self.tableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        isLoaded = 1
        self.tabBarController?.tabBar.isHidden = false
        menuButton.isHidden = false
        super.viewWillAppear(true)
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


    }

    
    func showOverview(isPrice : Bool)
    {
        let vc = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier: "WellnessOverviewVC") as! WellnessOverviewVC
       // vc.selectedNursingType = self.selectedNursingType
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
    

    
    //MARK- add Shimmer
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("VDA..")
     
        
        //Get Data from Server
        if isReloadFamilyDetails == 1 {
          
            
        }
        
        //Get Data for Bottom bar view
        //getSummaryDataFromServer()
        
        if isAddMember == 1 {
            getRelationDataFromServer()
        }
        
    }
    
    
    //MARK:- Protocol Methods
    func newMemberAdded() {
    }
    
    
    @objc func notificationTapped() {
        
    }
    
    
    
    
    @objc func cartTapped() {
       
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

    }
    
    
    func tabBarController(_: UITabBarController, shouldSelect: UIViewController) -> Bool
    {
        print("Should Select")
        return true
    }
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected item")
        /*
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
        */
        
        
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
        
        tabBarController?.view.addSubview(menuButton)
        
    }
    
    @objc private func homeButtonClicked(sender: UIButton)
    {
        tabBarController!.selectedIndex = 2
        //Change menu button image
        let origImage = UIImage(named:"Home-2")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        menuButton.setImage(tintedImage, for: .normal)
        menuButton.tintColor = UIColor.white
    }
    
    //MARK:- TableView Delegate and Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 //for overview cell
        }
        
        return packageDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cityCell = tableView.dequeueReusableCell(withIdentifier: "CellForOverviewHHC", for: indexPath) as! CellForOverviewHHC
            cityCell.btnOverview.addTarget(self, action: #selector(overViewTapped(_:)), for: .touchUpInside)
            cityCell.btnRates.isHidden = true
            //cityCell.btnRates.addTarget(self, action: #selector(packagePriceTapped(_:)), for: .touchUpInside)

            return cityCell
        }
        else {
     
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellForDentalPackageW", for: indexPath) as! CellForDentalPackageW
            
            cell.lblPackage.text = self.packageDetailsArray[indexPath.row].packageName!
            let priceText = "Starting from ₹ \(self.packageDetailsArray[indexPath.row].packagePrice!)"
                
            cell.lblStartingPrice.attributedText = handleRuppeeText(customFontString:priceText, SystemFontString: "₹")

            cell.btnViewDetails.tag = indexPath.row
            cell.btnViewDetails.addTarget(self, action: #selector(selectDidTapped(_:)), for: .touchUpInside)
            
            if indexPath.row == selectedMemberIndex {
                cell.imgTickView.isHidden = false
                cell.lblSelectPackage.text = "Select Member"
            }
            else
            {
                cell.imgTickView.isHidden = true
                cell.lblSelectPackage.text = "Get Package"
            }
            
            return cell
        }
        }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if indexPath.section == 0 {
            return 80

        }
        else {
        return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedMemberIndex == indexPath.row {
            let vc = UIStoryboard.init(name: "Dental", bundle: nil).instantiateViewController(withIdentifier: "DentalMemberListVC") as! DentalMemberListVC
            vc.selectedPackage = packageDetailsArray[indexPath.row]
            //vc.selectedCity = selectedCityName
            //vc.cityNursingDelegate = self
            //vc.isFromNursing = true
            //vc.nursingType = selectedNursingType
            self.navigationController?.pushViewController(vc, animated: true)

        }
        else {
            selectedMemberIndex = indexPath.row
            self.tableView.reloadData()
        }
        

        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
 
    func handleRuppeeText(customFontString: String, SystemFontString: String) -> NSAttributedString {
        let poppinsFont = UIFont(name: "Poppins-Regular",
        size: 14)

        let attributedString = NSMutableAttributedString(string: customFontString,
                                                         attributes: [NSAttributedString.Key.font: poppinsFont!])
        
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: poppinsFont!.pointSize)]
        let range = (customFontString as NSString).range(of: SystemFontString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }

    
    @objc func overViewTapped(_ sender : UIButton) {
        showOverview(isPrice: false)
    }
    
    @objc func packagePriceTapped(_ sender : UIButton) {
        showOverview(isPrice: true)
    }
    
    
    //MARK:- Package Content Tapped
    @objc func viewPackageDidTapped(_ sender : UIButton) {

    }
    
    
   
    
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
    

}
