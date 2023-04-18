//
//  DahboardRootViewController.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 27/05/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import CoreLocation

struct DashboardModelStruct {
    var id : String?
    var imgName : String?
    var heading : String?
    var btnTitle : String?
    var cityLbl : String?
    var serverName : String?
}


var isRemoveFlag = 0

class DashboardRootViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,DashboardCollectionViewProtocol,MoveToMedicineDelegate, UITabBarControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var locationManager = CLLocationManager()

    var modelArray = [DashboardModelStruct]()
    var personName = ""
    var addressName = ""
    var cityName = ""
    var changeIndex = 4
    var menuButton1 = UIButton()

    var fromInsurance = 0
    var servicesArray = ["Insurance"]
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    //EXTRA FOR  getFamilyDetailsFromServer
    var personDetailsArray = [FamilyDetailsModelHHC]()
    
    override func viewDidLoad() {
        
            
        spinner.color = UIColor.darkGray
        spinner.hidesWhenStopped = true
        self.view.addSubview(spinner)
        spinner.startAnimating()
        
        menuButton.isHidden = true
        isRemoveFlag = 1
        print("#VDL - Wellness dashboardController")

       self.tabBarController?.tabBar.isHidden=true
        
        setupMiddleButton()
        self.tabBarController?.tabBar.inActiveTintColorGreen()

        
        super.viewDidLoad()
      // setupWellnessTabbar()
        
//        UserDefaults.standard.set("17", forKey: "ExtGroupSrNo")
//        UserDefaults.standard.set("17878", forKey: "ExtFamilySrNo")
//        UserDefaults.standard.set("1795", forKey: "OrderMasterNo")
        self.tableView.register(CellForAdvertiseCell.self, forCellReuseIdentifier: "CellForAdvertiseCell")
        
        //To set Nav bar color
        //navigationController?.view.applyGradient(colours: [Color.greenTop.value, Color.greenBottom.value], locations: nil)
        navigationController?.view.setGradientBackground1(colorTop: Color.greenTop.value, colorBottom:Color.greenBottom.value)

        self.navigationController?.navigationBar.navBarDropShadow()
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])

        
        self.navigationController?.navigationBar.applyGradient()
        self.navigationController?.navigationBar.changeFont()
        
        let logo = UIImage(named: "mb360_white")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height:10))
        imageView.image=logo
        imageView.contentMode=UIViewContentMode.scaleAspectFit
        self.navigationItem.titleView = imageView
        
        let btn =  UIBarButtonItem(image:UIImage(named: "") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn

        
        //Get user's current location.
//        getLocationPermission()

        // Ask for Authorisation from the User.
        //self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            //self.showPleaseWait(msg: "")
            locationManager.startUpdatingLocation()
        }

        
        //Set Emp Name On Top
        getInfo()
        canAddMemberAPI()
        
        //Offline Data
       // getHealthcareServices() //offline
        
        getTopThreeButtonsAPI()
        print("In \(navigationItem.title ?? "") DashboardModelStruct")

    }
    
  
   
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.view.setGradientBackground1(colorTop: Color.greenTop.value, colorBottom:Color.greenBottom.value)
        menuButton1.isHidden = false
        //setupMiddleButton()
        self.tabBarController?.tabBar.isHidden=false
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        tabBarController?.tabBar.isUserInteractionEnabled = false
    }
    
    func setupMiddleButton()
    {
        
        menuButton1 = UIButton(frame: CGRect(x: 0, y: 0, width: 55, height: 55))
        
        var menuButtonFrame = menuButton1.frame
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
        menuButton1.frame = menuButtonFrame
        menuButton1.ShadowForView()
        menuButton1.layer.masksToBounds=true
        menuButton1.layer.cornerRadius = menuButtonFrame.height/2
        menuButton1.backgroundColor = hexStringToUIColor(hex: hightlightColor)
        menuButton1.setImage(UIImage(named:"Home-2"), for: .normal)
        
        //menuButton1.setBackgroundImage(UIImage(named: "blueEsclip"), for: .normal)
        menuButton1.backgroundColor = Color.buttonBackgroundGreen.value
        
        menuButton1.contentMode = .scaleAspectFill
        //        menuButton1.setGradientBackground(colorTop: hexStringToUIColor(hex: "819ff6"), colorBottom: hexStringToUIColor(hex: "4b66ea"))
        menuButton1.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
        
        
        menuButton1.layer.borderWidth = 0.7
        menuButton1.layer.borderColor =  #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
        
        tabBarController?.view.addSubview(menuButton1)
        //        view.layoutIfNeeded()
        
    }
    
    //MARK:- Medicine Delegate
    func moveToMedicineSection()
    {
        let wellnessDashboard = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier:"InstructionsMedicineVC") as! InstructionsMedicineVC
        self.navigationController?.pushViewController(wellnessDashboard, animated: true)
        menuButton1.isHidden = true

    }
    
    @objc private func homeButtonClicked(sender: UIButton)
    {
        tabBarController!.selectedIndex = 2
        //menuButton1.backgroundColor = UIColor.red
        //Change menu button image
        let origImage = UIImage(named:"Home-2")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        menuButton1.setImage(tintedImage, for: .normal)
        // menuButton1.tintColor = Color.buttonBackgroundGreen.value
        menuButton1.tintColor = UIColor.white
    }
    
//    func setupTabBar() {
//        menuButton1.isHidden = false
//        let tabBarController = UITabBarController()
//
//        let tabViewController1 = ContactDetailsViewController(
//            nibName: "ContactDetailsViewController",
//            bundle: nil)
//        let tabViewController2 = NewDashboardViewController(
//            nibName:"NewDashboardViewController",
//            bundle: nil)
//        let tabViewController3 = NewDashboardViewController(
//            nibName: "NewDashboardViewController",
//            bundle: nil)
//        let tabViewController4 = UtilitiesViewController(
//            nibName:"UtilitiesViewController",
//            bundle: nil)
//        let tabViewController5 = LeftSideViewController(
//            nibName:"LeftSideViewController",
//            bundle: nil)
//
//        let nav1:UINavigationController = UINavigationController.init(rootViewController: tabViewController1)
//        let nav2:UINavigationController = UINavigationController.init(rootViewController: tabViewController2)
//        let nav3:UINavigationController = UINavigationController.init(rootViewController: tabViewController3)
//        let nav4:UINavigationController = UINavigationController.init(rootViewController: tabViewController4)
//        let nav5:UINavigationController = UINavigationController.init(rootViewController: tabViewController5)
//
//
//        let controllers : NSArray = [nav1,nav2,nav3,nav4,nav5]
//        tabBarController.viewControllers = controllers as? [UIViewController]
//
//        nav1.tabBarItem = UITabBarItem(
//            title: "Support",
//            image: UIImage(named: "call-1"),
//            tag: 1)
//        nav2.tabBarItem = UITabBarItem(
//            title: "E-Card",
//            image:UIImage(named: "ecard1") ,
//            tag:2)
//        nav3.tabBarItem = UITabBarItem(
//            title: "",
//            image: UIImage(named: ""),
//            tag: 1)
//        nav4.tabBarItem = UITabBarItem(
//            title: "Utilities",
//            image:UIImage(named: "utilities") ,
//            tag:2)
//
//        nav5.tabBarItem = UITabBarItem(
//            title: "More",
//            image:UIImage(named: "menu-1") ,
//            tag:2)
//
//
//        nav1.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
//        nav2.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
//        nav3.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
//        nav4.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
//        nav5.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
//
//        menuButton1.backgroundColor = hexStringToUIColor(hex: hightlightColor)
//        menuButton1.setImage(UIImage(named:"Home-2"), for: .normal)
//
//        menuButton1.setBackgroundImage(UIImage(named: "blueEsclip"), for: .normal)
//        menuButton1.contentMode = .scaleAspectFill
//
//
//        let colorSelected = hexStringToUIColor(hex: hightlightColor)
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colorSelected ], for: .selected)
//
//        tabBarController.view.backgroundColor = UIColor.white
//
//
//        tabBarController.tabBar.tintColor = hexStringToUIColor(hex: hightlightColor)
//        tabBarController.tabBar.unselectedItemTintColor = UIColor.lightGray
//
//
//    }
    @objc func backTapped() {
       // self.navigationController?.popViewController(animated: true)
    }
    
   
    
    override func viewWillDisappear(_ animated: Bool) {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        let colorSelected = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colorSelected ], for: .selected)
    }
    
    private func wellnessServerCalls() {
        isEmployeeIDExist()
        
    }
    
    //MARK:- Change Dashboard
    func changeDashboardTapped(dashboard: Int) {
        switch dashboard {
        case 0:
            
            //OLD
            /*
            print("Move to Insurance")
            isRemoveFlag = 1
            menuButton1.removeFromSuperview()
            
            self.dismiss(animated: true, completion: {
                // menuButton1.isHidden = false
                //menuButton1.removeFromSuperview()
                //isRemoveFlag = 1
            })
            
            */
            if fromInsurance == 1 {
                self.dismiss(animated: true)
            }
            else {
            setupInsurance()
            }

            break
            
        case 1:
            print("Move to Wellness")

            break
        case 2:
            print("Move to Fitness")
//            menuButton1.removeFromSuperview()
            //menuButton1.isHidden = true //Uncomment for fitness

            
            
                print("Fitness Tapped")
                /*
                if let isFirstTime = UserDefaults.standard.value(forKey: "isOnboardingFirstTime") as? Bool {
                    if isFirstTime {
                       // showProfilePage()
                        setupFitnessTabbar()

                    }
                    else {
                        //Show Profile Page
                        setupFitnessTabbar()
                    }
                }
                else {
                    //Show Profile Page
                    //showProfilePage()
                    setupFitnessTabbar()

                }
                 */
            
            

           // setupFitnessTabbar()

            break
        
        default:
            break
        }
    }
    
    //MARK:- Show Profile Page
    func showProfilePage() {
        let vc = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier: "LoginFitnessProfile") as! LoginFitnessProfile
       // vc.delegateOnboarding = self
        let nav1:UINavigationController = UINavigationController.init(rootViewController: vc)
        nav1.modalPresentationStyle = .fullScreen
        
        self.present(nav1, animated: true, completion: nil)

    }

    
    //MARK:- Move To Insurance
    private func setupInsurance()
    {
    
    let tabBarController = UITabBarController()
    let tabViewController1 = ContactDetailsViewController(
    nibName: "ContactDetailsViewController",
    bundle: nil)
    let tabViewController2 = NewDashboardViewController(
    nibName:"NewDashboardViewController",
    bundle: nil)
    let tabViewController3 = NewDashboardViewController(
    nibName: "NewDashboardViewController",
    bundle: nil)
    let tabViewController4 = UtilitiesViewController(
    nibName:"UtilitiesViewController",
    bundle: nil)
    let tabViewController5 = LeftSideViewController(
    nibName:"LeftSideViewController",
    bundle: nil)
    
    let nav1:UINavigationController = UINavigationController.init(rootViewController: tabViewController1)
    let nav2:UINavigationController = UINavigationController.init(rootViewController: tabViewController2)
    let nav3:UINavigationController = UINavigationController.init(rootViewController: tabViewController3)
    let nav4:UINavigationController = UINavigationController.init(rootViewController: tabViewController4)
    let nav5:UINavigationController = UINavigationController.init(rootViewController: tabViewController5)
    
    
    let controllers : NSArray = [nav1,nav2,nav3,nav4,nav5]
    tabBarController.viewControllers = controllers as? [UIViewController]
    
    nav1.tabBarItem = UITabBarItem(
    title: "Support",
    image: UIImage(named: "call-1"),
    tag: 1)
    nav2.tabBarItem = UITabBarItem(
    title: "E-Card",
    image:UIImage(named: "ecard1") ,
    tag:2)
    nav3.tabBarItem = UITabBarItem(
    title: "",
    image: UIImage(named: ""),
    tag: 1)
    nav4.tabBarItem = UITabBarItem(
    title: "Utilities",
    image:UIImage(named: "utilities") ,
    tag:2)
    
    nav5.tabBarItem = UITabBarItem(
    title: "More",
    image:UIImage(named: "menu-1") ,
    tag:2)
    
        isRemoveFlag = 0
        tabBarController.modalPresentationStyle = .fullScreen

    navigationController?.present(tabBarController, animated: true, completion: nil)
    tabBarController.selectedIndex=2
    
    
    }
    let tabBarControllerF = UITabBarController()

    //MARK:- Tabbar setup
    func setupFitnessTabbar()
    {

        let tabViewController1 = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"CompeteChallengesVC") as! CompeteChallengesVC
        // tabViewController1.isAddMember = 1

        let tabViewController2 = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"FitnessDashboardVC") as! FitnessDashboardVC

        let tabViewController3 = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"FitnessDashboardRootVC") as! FitnessDashboardRootVC
        tabViewController3.isFromInsurance = 0

        let tabViewController4 = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"StatsFitnessVC") as! StatsFitnessVC

        let tabViewController5 = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"ProfileFitnessTVC") as! ProfileFitnessTVC



        let nav1:UINavigationController = UINavigationController.init(rootViewController: tabViewController1)
        let nav2:UINavigationController = UINavigationController.init(rootViewController: tabViewController2)
        let nav3:UINavigationController = UINavigationController.init(rootViewController: tabViewController3)
        let nav4:UINavigationController = UINavigationController.init(rootViewController: tabViewController4)
        let nav5:UINavigationController = UINavigationController.init(rootViewController: tabViewController5)


        let controllers : NSArray = [nav1,nav2,nav3,nav4,nav5]

        tabBarControllerF.viewControllers = controllers as? [UIViewController]

        nav1.tabBarItem = UITabBarItem(
            title: "Compete",
            image: UIImage(named: "star20x20"),
            tag: 1)

        nav2.tabBarItem = UITabBarItem(
            title: "Rewards",
            image:UIImage(named: "reward20x20") ,
            tag:2)
        nav3.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: ""),
            tag: 1)
        nav4.tabBarItem = UITabBarItem(
            title: "Stats",
            image:UIImage(named: "stat40x40") ,
            tag:2)
        nav5.tabBarItem = UITabBarItem(
            title: "Profile",
            image:UIImage(named: "profile-1") ,
            tag:2)
        tabBarControllerF.selectedIndex=2

        //Set Bar tint color white
        tabBarControllerF.tabBar.barTintColor = Color.tabBarBottomColor.value

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)

        let colorSelectedOrange = Color.buttonBackgroundGreen.value
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colorSelectedOrange ], for: .selected)

        tabBarControllerF.view.backgroundColor = UIColor.red

        tabBarControllerF.tabBar.tintColor = Color.redBottom.value
        tabBarControllerF.tabBar.unselectedItemTintColor = UIColor.lightGray


        //Set Tab bar border color
        //tabBarController.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        tabBarControllerF.tabBar.layer.borderWidth = 0.5
        tabBarControllerF.tabBar.layer.borderColor =  #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
        tabBarControllerF.tabBar.clipsToBounds = true
        tabBarControllerF.tabBar.isHidden = false
        tabBarControllerF.tabBar.isUserInteractionEnabled = true




        //tabBarController.modalTransitionStyle = .crossDissolve
        //self.tabBarController?.tabBar.isHidden = true
        //tabBarControllerF.tabBar.isHidden = true
        tabBarControllerF.modalPresentationStyle = .fullScreen

        self.present(tabBarControllerF, animated: true)
    }
    
    
    private func isEmployeeIDExist() {
        
        if let groupNo = UserDefaults.standard.value(forKey: "ExtGroupSrNo") as? String
        {
            if groupNo == "" {
                checkIsEmployeePresentAPI()
            }
            else {
                //Commented By Pranit For Offline menu
                getDataFromServer()
            }
        }
        else {
            checkIsEmployeePresentAPI()
        }
    }
    
    private func getInfo() {
        
        //Person Name
        let array : [PERSON_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeePersonDetails(productCode:"EMPLOYEE")
        if(array.count>0)
        {
            let personInfo = array[0]
            if let name = personInfo.personName
            {
                self.personName = name
                UserDefaults.standard.set(name, forKey: "name")
            }
            if let email = personInfo.emailID
            {
                UserDefaults.standard.set(email, forKey: "emailID")
            }
            if let mobileNo = personInfo.cellPhoneNUmber
            {
                UserDefaults.standard.set(mobileNo, forKey: "mobileNo")
            }
        }
        
        
        //Group Info
        var m_employeedict : EMPLOYEE_INFORMATION?
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        m_employeedict=userArray[0]
        
        var groupChildSrNo = String()
        var empID = String()
        var empName = String()

        var groupName = String()
        
        if let groupChlNo = m_employeedict?.groupChildSrNo
        {
            groupChildSrNo=String(groupChlNo)
            UserDefaults.standard.set(groupChildSrNo, forKey: "GroupChildSrNo")
        }
        
        if let empIDStr = m_employeedict?.empIDNo
        {
            empID=String(empIDStr)
            UserDefaults.standard.set(empID, forKey: "EmpID")
        }
        

        
        wellnessServerCalls()
    }
    
    
    
    
    //MARK:- TableView Delegate and Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if modelArray.count > 0 {
            if modelArray.count % 2 == 0{
             return (modelArray.count/2) + 2
            }
            return (modelArray.count/2) + 3
        }
        return modelArray.count + 2
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //set welcome msg and top 3 buttons (Insurance,Wellness,Fitness)
        if indexPath.row == 0 {
            let rootCell = tableView.dequeueReusableCell(withIdentifier: "CellForDashboardRootCell1", for: indexPath) as! CellForDashboardRootCell1
            
            //Hide Specific service using hideView (Wellness,Insurance,Fitness)
            //rootCell.hideView(view: rootCell.view_Wellness)
            
//            let gesture1 = UITapGestureRecognizer(target: self, action:  #selector (self.insuranceTapped (_:)))
//            rootCell.view_Insurance.addGestureRecognizer(gesture1)
//
//            let gesture2 = UITapGestureRecognizer(target: self, action:  #selector (self.wellnessTapped (_:)))
//            rootCell.view_Wellness.addGestureRecognizer(gesture2)
//
//            let gesture3 = UITapGestureRecognizer(target: self, action:  #selector (self.fitnessTapped (_:)))
//            rootCell.viewFitness.addGestureRecognizer(gesture3)
            
            rootCell.dashboarCollectionViewdDelegate = self
            rootCell.servicesArray = self.servicesArray
            //Remove Name From Dashboard
            //rootCell.lblName.text = "Hello, " + personName
            return rootCell
        }
        else if indexPath.row == 1 {
            let advertiseCell = tableView.dequeueReusableCell(withIdentifier: "CellForAdvertiseCell", for: indexPath) as! CellForAdvertiseCell
            return advertiseCell
        }
        else {
            
            let name = modelArray[indexPath.row - 2].serverName
            print(name ?? "")
            
            let combinedCell = tableView.dequeueReusableCell(withIdentifier: "CellForCombinedTwoView", for: indexPath) as! CellForCombinedTwoView
            // combinedCell.backgroundBorderView2.isHidden = true
            
            if indexPath.row == 2 { //0,1
//                combinedCell.lblHeading1.text = modelArray[0].heading
//                combinedCell.imgView1.image = UIImage(named: modelArray[0].imgName!)
//                combinedCell.lblCities1.text = modelArray[0].cityLbl
                
                combinedCell.backgroundBorderView1.tag = 0
                setData(dataModel: modelArray[0], combinedCell: combinedCell, index: 0,isFirst: true)
                
                if modelArray.count > 0 {
                   // combinedCell.lblHeading2.text = modelArray[1].heading
                   // combinedCell.imgView2.image = UIImage(named: modelArray[1].imgName!)
                   // combinedCell.lblCities2.text = modelArray[1].cityLbl
                    combinedCell.backgroundBorderView2.tag = 1
                    setData(dataModel: modelArray[1], combinedCell: combinedCell, index: 1,isFirst: false)
                }
            }
            else if indexPath.row == 3 { // 2,3
                
                combinedCell.backgroundBorderView1.tag = 2
                if modelArray.count>2{
                    setData(dataModel: modelArray[2], combinedCell: combinedCell, index: 2,isFirst: true)
                }
                if modelArray.count > 3 {
                    combinedCell.backgroundBorderView2.tag = 3
                    setData(dataModel: modelArray[3], combinedCell: combinedCell, index: 3,isFirst: false)
                }
            }
//            else  {
//                if modelArray.count > changeIndex {
//                setData(dataModel: modelArray[changeIndex], combinedCell: combinedCell, index: changeIndex,isFirst: true)
//                }
//                if modelArray.count > changeIndex+1 {
//                    setData(dataModel: modelArray[changeIndex+1], combinedCell: combinedCell, index: changeIndex+1,isFirst: false)
//                }
//                changeIndex = changeIndex + 1
//            }
            
            
            else if indexPath.row == 4 {
                if modelArray.count > 4 {
                setData(dataModel: modelArray[4], combinedCell: combinedCell, index: 4,isFirst: true)
                }
                if modelArray.count > 5 {
                    setData(dataModel: modelArray[5], combinedCell: combinedCell, index: 5,isFirst: false)
                }
            }
            else if indexPath.row == 5 {
                if modelArray.count > 6 {
                setData(dataModel: modelArray[6], combinedCell: combinedCell, index: 6,isFirst: true)
                }
                if modelArray.count > 7 {
                    setData(dataModel: modelArray[7], combinedCell: combinedCell, index: 7,isFirst: false)
                }
            }
            else if indexPath.row == 6 {
                if modelArray.count > 8 {
                setData(dataModel: modelArray[8], combinedCell: combinedCell, index: 8,isFirst: true)
                }
                if modelArray.count > 9 {
                    setData(dataModel: modelArray[9], combinedCell: combinedCell, index: 9,isFirst: false)
                }
            }
            else if indexPath.row == 7 {
                if modelArray.count > 10 {
                    setData(dataModel: modelArray[10], combinedCell: combinedCell, index: 10,isFirst: true)
                }
                if modelArray.count > 11 {
                    setData(dataModel: modelArray[11], combinedCell: combinedCell, index: 11,isFirst: false)
                }
            }
            else if indexPath.row == 8 {
                if modelArray.count > 12 {
                    setData(dataModel: modelArray[12], combinedCell: combinedCell, index: 12,isFirst: true)
                }
                if modelArray.count > 13 {
                    setData(dataModel: modelArray[13], combinedCell: combinedCell, index: 13,isFirst: false)
                }
            }
            else if indexPath.row == 9 {
                if modelArray.count > 14 {
                    setData(dataModel: modelArray[14], combinedCell: combinedCell, index: 14,isFirst: true)
                }
                if modelArray.count > 15 {
                    setData(dataModel: modelArray[15], combinedCell: combinedCell, index: 15,isFirst: false)
                }
            }
            
            
            //Add gestures on view
            let gesture1 = UITapGestureRecognizer(target: self, action:  #selector (self.cellDidTapped (_:)))
            combinedCell.backgroundBorderView1.addGestureRecognizer(gesture1)
            
            let gesture2 = UITapGestureRecognizer(target: self, action:  #selector (self.cellDidTapped (_:)))
            combinedCell.backgroundBorderView2.addGestureRecognizer(gesture2)
            
            return combinedCell
            
        }
        
    }
    
    private func setData(dataModel:DashboardModelStruct,combinedCell:CellForCombinedTwoView,index:Int,isFirst:Bool) {
        
        if isFirst { //set Data on Half part
            combinedCell.lblHeading1.text = dataModel.heading
            combinedCell.imgView1.image = UIImage(named: dataModel.imgName!)
//            if dataModel.heading == "Schedule Health Check"  {
//                combinedCell.lblCities1.text = "Available in 126 Cities"
//            } else if dataModel.heading == "Medicine Delivery" || dataModel.heading == "Dental" {
//                combinedCell.lblCities1.text = "Available in 15 Cities"
//            }else{
//                combinedCell.lblCities1.text = ""
//            }
            combinedCell.lblCities1.text = dataModel.cityLbl
            combinedCell.backgroundBorderView1.tag = index
            combinedCell.backgroundBorderView2.isHidden = true
        }
        else {
            combinedCell.lblHeading2.text = dataModel.heading
            combinedCell.imgView2.image = UIImage(named: dataModel.imgName!)
//            if dataModel.heading == "Schedule Health Check"  {
//                combinedCell.lblCities2.text = "Available in 126 Cities"
//            } else if dataModel.heading == "Medicine Delivery" || dataModel.heading == "Dental" {
//                combinedCell.lblCities2.text = "Available in 15 Cities"
//            }else{
//                combinedCell.lblCities2.text = ""
//            }
            combinedCell.lblCities2.text = dataModel.cityLbl
            combinedCell.backgroundBorderView2.tag = index
            combinedCell.backgroundBorderView2.isHidden = false

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
           // return 184 //before green
            return 80
            //return UITableViewAutomaticDimension
        }
        else if indexPath.row == 1  {
           // return 135
            return 0 //if add is present
        }
        else {
            return 110
            //return UITableViewAutomaticDimension

//            if UITableViewAutomaticDimension > 90 {
//                return UITableViewAutomaticDimension
//            }
//            else {
//          return 90
//           }
        }
    }
    
    @objc private func insuranceTapped(_ sender:UITapGestureRecognizer) {
   // self.navigationController?.popViewController(animated: true)
        //isRemoveFlag = 1
        menuButton1.removeFromSuperview()

        self.dismiss(animated: true, completion: {
           // menuButton1.isHidden = false
            //menuButton1.removeFromSuperview()
            //isRemoveFlag = 1
        })
    }
    
    //MARK:- Wellness
//    @objc func wellnessTapped(_ sender:UITapGestureRecognizer)
//    {
//    //    let wellnessDashboard = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"DashboardRootViewController") as! DashboardRootViewController
//       // self.navigationController?.pushViewController(wellnessDashboard, animated: true)
//    }
//
//    @objc private func fitnessTapped(_ sender:UITapGestureRecognizer) {
//
//    }
    
    //MARK:- TableView Helper
    func hideElement(cell:CellForCombinedTwoView) {
        cell.imgView2.isHidden = true
        cell.lblHeading2.isHidden = true
        cell.lblCities2.isHidden = true
    }
    
    
    @objc func cellDidTapped(_ sender:UITapGestureRecognizer)
    {
        print(sender.view?.tag ?? 0)
        //        let array = ["Covid-19 Tests","Schedule Health Check","Medicine Delivery","Doctor Consultation","Dental","Trained Attendant","Short Term Nursing","Long Term Nursing","Doctor Home Visit","Physiotherapy","Diabetes management","Elder care","Post Natal Care"]

        guard let index = sender.view?.tag else { return  }
        let headingName = self.modelArray[index].heading
        print("Selected headingName: ",headingName)
        switch headingName {
        //case "Schedule Health Check":
        case "Health Checkup":
            if let isTermsStatus = UserDefaults.standard.value(forKey: "isT&CDisplayed") as? Bool {
                print("isTermsStatus: ",isTermsStatus)
                if !isTermsStatus {
                    // let wellnessDashboard = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"TermsAndConditionsViewController") as! TermsAndConditionsViewController
                    // menuButton1.isHidden = true
                    UserDefaults.standard.set(true, forKey:"isT&CDisplayed")
                    // navigationController?.pushViewController(wellnessDashboard, animated: true)
                    setupWellnessTabbar()
                    
                }
                else {
                    setupWellnessTabbar()
                }
            }
            else {
                
                //                let wellnessDashboard = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"TermsAndConditionsViewController") as! TermsAndConditionsViewController
                //                menuButton1.isHidden = true
                //                    UserDefaults.standard.set(true, forKey:"isT&CDisplayed")
                //                navigationController?.pushViewController(wellnessDashboard, animated: true)
                
                
                setupWellnessTabbar()
                
            }
        case "Medicine Delivery":
            //Comment by Geeta
            //1. Need to remove pincode box & Add/call moveToMedicineSection code here ..X
            //2. need to open list first, on overview clk move to instructionVC
            
          //1.//  let medicine = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier:"SearchPincodeForMD_VC") as! SearchPincodeForMD_VC
//            medicine.modalPresentationStyle = .overFullScreen
//            medicine.modalTransitionStyle = .crossDissolve
//            medicine.medicineDelegateObj = self
//            navigationController?.present(medicine, animated: true, completion: nil)
            
//            let wellnessDashboard = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier:"InstructionsMedicineVC") as! InstructionsMedicineVC
//            self.navigationController?.pushViewController(wellnessDashboard, animated: true)
//            menuButton1.isHidden = true
            
            /*commented by shubham*/
            /*
            let wellnessDashboard = UIStoryboard.init(name: "MedicineDelivery", bundle: nil).instantiateViewController(withIdentifier:"FamilyMemberListMD_VC") as! FamilyMemberListMD_VC
            //self.navigationController?.present(wellnessDashboard, animated: true, completion: nil)
            self.navigationController?.pushViewController(wellnessDashboard, animated: true)
            menuButton1.isHidden = true
            */
            print("Medicine Delivery")
            break
            
        case "TELECONSULTATION":
            
            setupNursingTabbar(nursingType: .trainedAttendants)
            break
            
        case "Dental":
            setupDentalTabbar(nursingType: .dental)
            break
        case "Covid-19 Tests" :
            setupCovidScreen(nursingType:.longTerm)
            break
            
        case "Long Term Nursing" :
            setupNursingTabbar(nursingType: .longTerm)
            break
        case "Short Term Nursing" :
            setupNursingTabbar(nursingType: .shortTerm)
            break
        case "Trained Attendant" :
            setupNursingTabbar(nursingType: .trainedAttendants)
            break
            
        case "Doctor Services" :
            setupNursingTabbar(nursingType: .doctorServices)
            break
        case "Physiotherapy" :
            setupNursingTabbar(nursingType: .physiotherapy)
            break
        case "Diabetes management" :
            setupDiabetesTabbar(nursingType: .diabetesManagement)
            break
            
        case "Elder Care" :
            setupNursingTabbar(nursingType: .elderCare)
            break
            
        case "Post Natal Care" :
            setupNursingTabbar(nursingType: .postNatelCare)
            
            break
        case "ONLINE COUNSELLOR":
            break
            
        case "HOME HEALTHCARE":
            //let wellnessDashboard = UIStoryboard.init(name: "CustomPopups", bundle: nil).instantiateViewController(withIdentifier:"TempScreen")
            // self.navigationController?.pushViewController(wellnessDashboard, animated: true)
            
            break
            
        case "Doctor Consultation":
            print("Doctor Consultation:  ")
            let doctorConsultationVC = UIStoryboard.init(name: "Wellness_New", bundle: nil).instantiateViewController(withIdentifier:"DoctorConsultationVC") as! DoctorConsultationVC
            //To hide Home button
            menuButton1.isHidden = true
             self.navigationController?.pushViewController(doctorConsultationVC, animated: true)
            
            break
            
            
        default: break
            
        }
        
        
    }
    
    
    //Added on 13rd May 2020
    func setupWellnessTabbar()
    {
        
        let tabBarController = UITabBarController()

          let tabViewController1 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"HealthCheckupOptVC") as! HealthCheckupOptVC
        tabViewController1.isAddMember = 1
        
//        let tabViewController2 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"AppointmentHistory") as! AppointmentHistory // Old Appt UI
        
        let tabViewController2 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"NewAppointmentHistory") as! NewAppointmentHistory // New appt UI according to Prathmesh Sir :: api pending
//        let tabViewController2 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"TempVC") as! TempVC
        
        
        //let tabViewController3 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"FamilyDetailsViewController") as! FamilyDetailsViewController
        
       // let tabViewController3 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"NewHealthCheckupVC") as! NewHealthCheckupVC
        
        let tabViewController3 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"HealthCheckupOptVC") as! HealthCheckupOptVC
        tabViewController3.isAddMember = 0


        let tabViewController4 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"AppointmentsViewController") as! AppointmentsViewController
    
       // let tabViewController5 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"ProfileViewForWellness") as! ProfileViewForWellness
        
//        let tabViewController5 = ProfileViewForWellness(
//            nibName:"ProfileViewForWellness",
//            bundle: nil)
        
        let tabViewController5 = ProfileViewController(
            nibName:"ProfileViewController",
            bundle: nil)
        tabViewController5.highlightclr = "HC"
        
        let nav1:UINavigationController = UINavigationController.init(rootViewController: tabViewController1)
        let nav2:UINavigationController = UINavigationController.init(rootViewController: tabViewController2)
        let nav3:UINavigationController = UINavigationController.init(rootViewController: tabViewController3)
        let nav4:UINavigationController = UINavigationController.init(rootViewController: tabViewController4)
        let nav5:UINavigationController = UINavigationController.init(rootViewController: tabViewController5)
        
        
        let controllers : NSArray = [nav1,nav2,nav3,nav4,nav5]
        
        tabBarController.viewControllers = controllers as? [UIViewController]
        
        nav1.tabBarItem = UITabBarItem(
            title: "Add Member",
            image: UIImage(named: "adduser"),
            tag: 1)
    
        nav2.tabBarItem = UITabBarItem(
            title: "History",
            image:UIImage(named: "history") ,
            tag:2)
        nav3.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: ""),
            tag: 1)
        nav4.tabBarItem = UITabBarItem(
            title: "Appointments",
            image:UIImage(named: "appointment") ,
            tag:2)
        nav5.tabBarItem = UITabBarItem(
            title: "Profile",
            image:UIImage(named: "profile-1") ,
            tag:2)
        tabBarController.selectedIndex=2
        //nav2.tabBarItem.isEnabled = false
        
        //Set Bar tint color white
        tabBarController.tabBar.barTintColor = Color.tabBarBottomColor.value

        //    tabBarController.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    //tabBarController.tabBar.selectedItem?.badgeColor = #colorLiteral(red: 0.2431372549, green: 0.8509803922, blue: 0.6941176471, alpha: 1)

     //Set Bar tint color white
     tabBarController.tabBar.barTintColor = Color.tabBarBottomColor.value

     UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)

     let colorSelectedOrange = Color.buttonBackgroundGreen.value
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.yellow ], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red ], for: .normal)

     tabBarController.view.backgroundColor = Color.buttonBackgroundGreen.value

     tabBarController.tabBar.tintColor = Color.buttonBackgroundGreen.value
     tabBarController.tabBar.unselectedItemTintColor = UIColor.lightGray


     //Set Tab bar border color
     //tabBarController.tabBar.layer.borderColor = UIColor.lightGray.cgColor
     tabBarController.tabBar.layer.borderWidth = 0.5
     tabBarController.tabBar.layer.borderColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
     tabBarController.tabBar.clipsToBounds = true
     tabBarController.tabBar.isHidden = false
     tabBarController.tabBar.isUserInteractionEnabled = true

     tabBarController.modalPresentationStyle = .fullScreen

     self.present(tabBarController, animated: true)

        /*
        //Set Bar tint color white
        tabBarController.tabBar.barTintColor = Color.tabBarBottomColor.value
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        
        let colorSelected = Color.buttonBackgroundGreen.value
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colorSelected], for: .selected)
        
        tabBarController.view.backgroundColor = UIColor.white
        
        tabBarController.tabBar.tintColor = colorSelected
        tabBarController.tabBar.unselectedItemTintColor = UIColor.lightGray

        //Set Tab bar border color
        //tabBarController.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        tabBarController.tabBar.layer.borderWidth = 0.5
        tabBarController.tabBar.layer.borderColor =  #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
        tabBarController.tabBar.clipsToBounds = true

        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true)
        */
    }
    
    
    //MARK:- API Link
    //Get wellness sequence from server
    private func getDataFromServer() {
        
        guard let groupChildSrNo = UserDefaults.standard.value(forKey: "GroupChildSrNo") as? String else {
            return
        }
        guard let groupSrNo = UserDefaults.standard.value(forKey: "ExtGroupSrNo") as? String else {
            return
        }
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
            return
        }
        guard let orderMasterNo = UserDefaults.standard.value(forKey: "OrderMasterNo") else {
            return
        }
        
        //To Do - change 909 to groupChildSrNo var
        //let url = APIEngine.shared.getDashboardLinkURL(groupChildSrNo: "909")
        //let url = APIEngine.shared.getDashboardLinkURL(groupChildSrNo: "17")
        let url = APIEngine.shared.getDashboardLinkURL(groupChildSrNo: groupSrNo)
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            
            if let messageDictionary = response?["message"].dictionary
            {
                if let status = messageDictionary["Status"]?.bool {
                    if status == true {
                        if let serviceArray = response?["Services"].arrayValue {
                            self.modelArray.removeAll()
                            for service in serviceArray {
                                var name = service["Name"].stringValue
                                var obj = DashboardModelStruct()
                                switch (name) {
//                                case "HEALTH CHECKUP":
//                                    obj = DashboardModelStruct.init(id: service["Position"].stringValue, imgName: "healthcheckg", heading: "Schedule Health Check", btnTitle: "", cityLbl: "Available in 70 Cities", serverName: service["Name"].stringValue)
//                                case "MEDICINE DELIVERY":
//                                    obj = DashboardModelStruct.init(id: service["Position"].stringValue, imgName: "medicinedeliveryg", heading: "Medicine Delivery", btnTitle: "", cityLbl: "Available in 10 Cities", serverName: service["Name"].stringValue)
//                                case "TELECONSULTATION":
//                                     obj = DashboardModelStruct.init(id: service["Position"].stringValue, imgName: "Teleconsultationg", heading: "Teleconsultation", btnTitle: "", cityLbl: "Available 24/7", serverName: service["Name"].stringValue)
//                                    break
//                                case "DENTAL":
//                                     obj = DashboardModelStruct.init(id: service["Position"].stringValue, imgName: "dentalg", heading: "Dental", btnTitle: "", cityLbl: "Available in 15 Cities", serverName: "DENTAL")
//                                    let obj1 = DashboardModelStruct.init(id: service["Position"].stringValue, imgName: "Homehealthcareg", heading: "Short Term Nursing", btnTitle: "", cityLbl: "Available in 20 Cities", serverName: "SHORT TERM NURSING")
//                                    self.modelArray.append(obj1)
//                                case "ONLINE COUNSELLOR":
//                                    obj = DashboardModelStruct.init(id: service["Position"].stringValue, imgName: "onlinecounsellorg", heading: "Online Counsellor", btnTitle: "", cityLbl: "Available 24/7", serverName: service["Name"].stringValue)
//                                case "HOME HEALTHCARE":
//                                    obj = DashboardModelStruct.init(id: service["Position"].stringValue, imgName: "Homehealthcareg", heading: "Home HealthCare", btnTitle: "", cityLbl: "Available in 20 Cities", serverName: service["Name"].stringValue)
                                case "HEALTH CHECKUP":
                                    obj = DashboardModelStruct.init(id: service["Position"].stringValue, imgName: "health_check", heading: "Health Checkup", btnTitle: "", cityLbl: "Available in 15 Cities", serverName: service["Name"].stringValue)
                                //case "MEDICINE DELIVERY":
                                    //obj = DashboardModelStruct.init(id: service["Position"].stringValue, imgName: "medicine_delivery", heading: "Medicine Delivery", btnTitle: "", cityLbl: "Available in 15 Cities", serverName: service["Name"].stringValue)
                                case "COVID 19 TEST":
                                    obj = DashboardModelStruct.init(id: service["Position"].stringValue, imgName: "coronavirus", heading: "Covid-19 Tests", btnTitle: "", cityLbl: "Available in 15 Cities", serverName: service["Name"].stringValue)
                                case "DOCTOR CONSULTATION":
                                    obj = DashboardModelStruct.init(id: service["Position"].stringValue, imgName: "doctos_consuktation", heading: "Doctor Consultation", btnTitle: "", cityLbl: "Available in 15 Cities", serverName: service["Name"].stringValue)
                                //case "DENTAL":
                                    //obj = DashboardModelStruct.init(id: service["Position"].stringValue, imgName: "dental", heading: "Dental", btnTitle: "", cityLbl: "Available in 15 Cities", serverName: service["Name"].stringValue)
                                case "TRAINED ATTENDANT":
                                    obj = DashboardModelStruct.init(id: service["Position"].stringValue, imgName: "trained_attendant", heading: "Trained Attendant", btnTitle: "", cityLbl: "Available in 15 Cities", serverName: service["Name"].stringValue)
                                case "SHORT TERM NURSING":
                                    obj = DashboardModelStruct.init(id: service["Position"].stringValue, imgName: "short_term_nursing", heading: "Short Term Nursing", btnTitle: "", cityLbl: "Available in 15 Cities", serverName: service["Name"].stringValue)
                                case "LONG TERM NURSING":
                                    obj = DashboardModelStruct.init(id: service["Position"].stringValue, imgName: "long_term_nursingN", heading: "Long Term Nursing", btnTitle: "", cityLbl: "Available in 15 Cities", serverName: service["Name"].stringValue)
                                case "DOCTOR SERVICES":
                                    obj = DashboardModelStruct.init(id: service["Position"].stringValue, imgName: "doctor_visit", heading: "Doctor Services", btnTitle: "", cityLbl: "Available in 15 Cities", serverName: service["Name"].stringValue)
                                case "PHYSIOTHERAPY":
                                    obj = DashboardModelStruct.init(id: service["Position"].stringValue, imgName: "physiotheraphyNew", heading: "Physiotherapy", btnTitle: "", cityLbl: "Available in 15 Cities", serverName: service["Name"].stringValue)
                                case "DIABETESE MANAGEMENT","DIABETES MANAGEMENT":
                                    obj = DashboardModelStruct.init(id: service["Position"].stringValue, imgName: "diabetes_care", heading: "Diabetes management", btnTitle: "", cityLbl: "Available in 15 Cities", serverName: service["Name"].stringValue)
                                case "ELDER CARE":
                                    obj = DashboardModelStruct.init(id: service["Position"].stringValue, imgName: "elder_careN", heading: "Elder Care", btnTitle: "", cityLbl: "Available in 15 Cities", serverName: service["Name"].stringValue)
                                case "POST NATAL CARE":
                                    obj = DashboardModelStruct.init(id: service["Position"].stringValue, imgName: "post_natal", heading: "Post Natal Care", btnTitle: "", cityLbl: "Available in 15 Cities", serverName: service["Name"].stringValue)
                                
                                default: break
                                }
                                
                                if service["Name"].stringValue != "WEBINARS" && service["Name"].stringValue != "HEALTH VIDEOS"  {
                                    if obj.heading != nil {
                                        self.modelArray.append(obj)
                                    }
                                }
                            }
                            
                            if self.modelArray.count > 0 {
                                
                                for i in 0..<self.modelArray.count {
                                for j in (i + 1)..<self.modelArray.count {
                                    let dict = self.modelArray[i]
                                    let dict1 = self.modelArray[j]
                                    if let id1 = dict.id, let id2 = dict1.id {
                                        if Int(id1)! > Int(id2)! {
                                                   let a = self.modelArray[i]
                                                    self.modelArray[i] = self.modelArray[j]
                                                    self.modelArray[j] = a
                                                   
                                        }
                                      }
                                    }
                                   }
//                                let array = self.modelArray
//                                let results = array.sorted(by: { ($0 ).Int(id)! < ($1 ).Int(id)!})
//                                self.modelArray = results
                                self.getFamilyDetailsFromServer()
                                self.spinner.stopAnimating()
                                self.tableView.reloadData()
                            }
                        }
                    }else{
                        //false status
                    }
                }
            }
        }
    }
    
    //MARK:- HOME HEALTH CARE **
    private func getHealthcareServices() {
        let array = ["Covid-19 Tests","Schedule Health Check","Medicine Delivery","Doctor Consultation","Dental","Trained Attendant","Short Term Nursing","Long Term Nursing","Doctor Home Visit","Physiotherapy","Diabetes management","Elder Care","Post Natal Care"]
                
        let imgArray = ["coronavirus","health_check","medicine_delivery","doctos_consuktation","dental","trained_attendant","short_term_nursing","long_term_nursingN","doctor_visit","physiotheraphyNew","diabetes_care","elder_careN","post_natal"]

        
        var iCnt = 0;
        for service in array {
            let obj = DashboardModelStruct.init(id: iCnt.description, imgName: imgArray[iCnt], heading: service, btnTitle: "", cityLbl: "Available in 15 Cities", serverName: service)
            self.modelArray.append(obj)
            iCnt += 1
        }
        self.tableView.reloadData()
        
    }
    
  
    
    
    //MARK:- EMP Is Exist API
    private func checkIsEmployeePresentAPI() {
        //http://www.mybenefits360.in/mbapi/api/v1/Wellness/IsEmployeeDetailsPresent
        print("IS Emp Exists")
        var m_employeedict : EMPLOYEE_INFORMATION?
        
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        m_employeedict=userArray[0]
        
        var empId = String()
        
        if let groupChlNo = m_employeedict?.empIDNo
        {
            empId=String(groupChlNo)
        }
        
        print(empId)
        
        //let url = APIEngine.shared.isEmployeePresentURL(empIdNo: empId, groupCode: "stt")
        let url = APIEngine.shared.isEmployeePresentURL(empIdNo: empId, groupCode:self.getGroupCode())
      
        
        print("****First Call checkIsEmployeePresentAPI")
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            
            
            
            if let status = response?["Status"].bool
            {
                if status == true {
                    let extGroupSrNo = response?["ExtGroupSrNo"].stringValue
                    let extFamilySrNo = response?["ExtFamilySrNo"].stringValue
                    let orderMasterNo = response?["OrderMasterNo"].stringValue
                    
                    UserDefaults.standard.set(extGroupSrNo, forKey: "ExtGroupSrNo")
                    UserDefaults.standard.set(extFamilySrNo, forKey: "ExtFamilySrNo")
                    UserDefaults.standard.set(orderMasterNo, forKey: "OrderMasterNo")
                    
                    //Commented By Pranit For Offline menu
                    self.getDataFromServer()
                    
                }
                else {
                    //Send Emp Info To Server
                    self.createRequestForEmpInfo()
                }
            }
        }
    }
    
    private func canAddMemberAPI() {
//http://mybenefits360.in/mbapi/api/v1/Wellness/CanAddMember?EmpIdNo=6001846
        var m_employeedict : EMPLOYEE_INFORMATION?
        
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        m_employeedict=userArray[0]
        
        var empId = String()
        
        if let empIdNo = m_employeedict?.empIDNo
        {
            empId=String(empIdNo)
        }
        
        print(empId)
        
        //let url = APIEngine.shared.canAddMember(empId: empId)
        let url = APIEngine.shared.canAddMember1(groupCode: self.getGroupCode())
        //let url = APIEngine.shared.canAddMember1(groupCode: "NAYASA1")

        print("****First Call canAddMemberAPI")
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            print(response ?? "")
            var canAddMember = false
            if let canAdd = response?["AddMember"].intValue {
                if canAdd == 1 {
                    canAddMember = true
                    print("Enable Add Member 1")
                    UserDefaults.standard.set(true, forKey: "canAddMember")
                }
                else {
                    canAddMember = true
                    print("Enable Add Member true")
                    UserDefaults.standard.set(true, forKey: "canAddMember")
//                    canAddMember = false
//                    print("Disable Add Member")
//                    UserDefaults.standard.set(false, forKey: "canAddMember")
                }
            }
            else {
                canAddMember = true
                print("Enable Add Member true else")
                UserDefaults.standard.set(true, forKey: "canAddMember")
//            canAddMember = false
//                print("Disable Add Member")

            }
            
            /*
            if let status = response?["Status"].bool
            {
                if status == true {
                    let extGroupSrNo = response?["ExtGroupSrNo"].stringValue
                    let extFamilySrNo = response?["ExtFamilySrNo"].stringValue
                    let orderMasterNo = response?["OrderMasterNo"].stringValue
                    
                    UserDefaults.standard.set(extGroupSrNo, forKey: "ExtGroupSrNo")
                    UserDefaults.standard.set(extFamilySrNo, forKey: "ExtFamilySrNo")
                    UserDefaults.standard.set(orderMasterNo, forKey: "OrderMasterNo")
                    
                    self.getDataFromServer()
                    
                }
                else {
                    //Send Emp Info To Server
                    self.createRequestForEmpInfo()
                }
            }
            */
        }
    }
    
    
    private func createRequestForEmpInfo() {
        var finalDictionary = NSDictionary()
        //Get EMP Info
        var m_employeedict : EMPLOYEE_INFORMATION?
        
        let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
        m_employeedict=userArray[0]
        
        var EmpIdNo = ""
        var DateOfJoining = ""
        var OfficialEmailID = ""
        var Department = ""
        var Grade = ""
        var Designation = ""
        let EmployeeAddress = "NOT AVAILABLE"
        let EmployeeCity = "NOT AVAILABLE"
        let EmployeeLocation = "NOT AVAILABLE"
        
        
        if let empid = m_employeedict?.empIDNo
        {
            EmpIdNo=String(empid)
        }
        
        if let doj = m_employeedict?.dtaeOfJoining
        {
            
            DateOfJoining = convertDateNew(doj)
        }
        
        if let emailID = m_employeedict?.officialEmailID
        {
            OfficialEmailID = emailID
        }
        if let department = m_employeedict?.department {
            Department = department
        }
        if let grade = m_employeedict?.grade {
            Grade = grade
        }
        if let designation = m_employeedict?.designation {
            Designation = designation
        }
        
        
        
        
        
        //Get Person Info
        var personDictArray = NSMutableArray()
        
        let array = DatabaseManager.sharedInstance.retrievePersonDetails(productCode: "")
        for dict in array
        {
            if(dict.personName==nil || dict.personName=="")
            {
                
            }
            else
            {
                let emailId = dict.emailID
                
                var emailStr = ""
                emailStr = emailId == "" ? "NOT AVAILABLE" : emailId ?? "NOT AVAILABLE"
                
                let dob = convertDateNew(dict.dateofBirth ?? "")
                
                let singlePerson =  ["PersonName": dict.personName ?? "","Age": String(dict.age), "DateOfBirth": dob, "EmailID": emailStr,
                                     "cellphoneNumber": dict.cellPhoneNUmber ?? "", "Gender": dict.gender ?? "", "RelationID": String(dict.relationID)] as [String : Any]
                personDictArray.add(singlePerson as NSDictionary)
            }
            
        }
        
        
        print(personDictArray)
        
        //Get Group Info
        let groupMasterArray  =  DatabaseManager.sharedInstance.retrieveGroupChildMasterDetails(productCode:"")
        let groupMasterDict = groupMasterArray[0]
        
        let groupDict = ["GroupChildSrNo": String(groupMasterDict.groupChildSrNo),  "Name": groupMasterDict.groupName ?? "","GroupCode": self.getGroupCode()] as [String : Any]
        
        
        finalDictionary = ["EmpIdNo": EmpIdNo,
                           "DateOfJoining": DateOfJoining,
                           "OfficialEmailID": OfficialEmailID,
                           "Department":Department,
                           "Grade":Grade,
                           "Designation":Designation,
                           "EmployeeAddress":EmployeeAddress,
                           "EmployeeCity":EmployeeCity,
                           "EmployeeLocation":EmployeeLocation,"Persons":personDictArray,"group":groupDict]
        
        
        self.insertEmployeeInfoToWellnessServer(parameter: finalDictionary)
        
    }
    
    //MARK:- Convert Date
    func convertDateNew(_ date: String) -> String
    {
        if date == "" {
            return "NOT AVAILABLE"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        if let date1 = dateFormatter.date(from: date)
        {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return  dateFormatter.string(from: date1)
        }
        else
        {
            return date
        }
    }
    
    
    //MARK:- Insert EMP Info
    private func insertEmployeeInfoToWellnessServer(parameter:NSDictionary) {
        print("Insert EMP Info")
        
        let url = APIEngine.shared.sendEmpInfoToServerURL()
        print(url)
        ServerRequestManager.serverInstance.postDataToServer(url: url, dictionary: parameter, view: self, onComplition: { (response, error) in
            
            if let status = response?["Status"].bool
            {
                if status == true {
                    /*{
                     "ExtGroupSrNo": "1",
                     "ExtFamilySrNo": "5454",
                     "OrderMasterNo": "-1",
                     "Message": "Employee Data Present",
                     "Status": true
                     }*/
                    
                    let extGroupSrNo = response?["ExtGroupSrNo"].stringValue
                    let extFamilySrNo = response?["ExtFamilySrNo"].stringValue
                    let orderMasterNo = response?["OrderMasterNo"].stringValue
                    
                    UserDefaults.standard.set(extGroupSrNo, forKey: "ExtGroupSrNo")
                    UserDefaults.standard.set(extFamilySrNo, forKey: "ExtFamilySrNo")
                    UserDefaults.standard.set(orderMasterNo, forKey: "OrderMasterNo")
                    
                    //Commented By Pranit For Offline menu
                    self.getDataFromServer()
                }
                else {
                    //Failed to send emp info
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
    }
    
    //Users Current Location
    private func getLocationPermission() {
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    /*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    */
    
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        self.hidePleaseWait()

        DispatchQueue.global(qos: .background).async{
            if let location:CLLocation = locations.last
            {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                
                var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
                let ceo: CLGeocoder = CLGeocoder()
                center.latitude = latitude
                center.longitude = longitude
                
                let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
                ceo.reverseGeocodeLocation(loc, completionHandler:
                    {(placemarks, error) in
                        if (error != nil)
                        {
                            print("reverse geocode fail: \(error!.localizedDescription)")
                        }
                        else
                        {
                            if let pm = placemarks
                            {
                                if pm.count > 0
                                {
                                    if let pm = placemarks?[0]
                                    {
                                        if let subLocality = pm.postalCode
                                        {
                                            self.cityName=subLocality
                                            var addressString : String = ""
                                            if pm.locality != nil
                                            {
                                                addressString = addressString + pm.locality!
                                            }
                                            print("L O C A T I O N")
                                            print("Location=")
                                            print(subLocality)
                                            print(addressString)
                                            self.addressName = addressString
                                            
                                            UserDefaults.standard.set(self.addressName, forKey: "city")
                                        }
                                        else
                                        {
                                        }
                                    }
                                }
                            }
                            else
                            {
                            }
                        }
                })
            }
        }
    }
    
    
}

extension NSDictionary {
    
    var json: Data {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            //return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
            return jsonData
            
        } catch {
            print("Exp")
            
        }
        return Data()
    }
    
    
}




/*
 {
 "EmpIdNo": null,
 "DateOfJoining": null,
 "OfficialEmailID": null,
 ,"Department":"NOT AVAILABLE",
 "Grade":"F",
 "Designation":"SR. MANAGER - BUSINESS IT",
 "EmployeeAddress":null,
 "EmployeeCity":null,
 "EmployeeLocation":null,
 
 "Persons": [
 {
 "PersonName": null,"Age": null, "DateOfBirth": null, "EmailID": null,
 "cellphoneNumber": null, "Gender": null, "RelationID": null
 },
 {
 "PersonName": null,"Age": null, "DateOfBirth": null,
 "EmailID": null, "cellphoneNumber": null, "Gender": null,
 "RelationID": null
 }
 ],
 
 "group": {
 "GroupChildSrNo": null,  "Name": null,"GroupCode": null
 }
 
 }
 */


/*
 
 let array = datasourceModelArray as? NSArray
 let results = array?.sorted(by: { ($0 as! FixtureModel).startDate! < ($1 as! FixtureModel).startDate!})
 self.datasourceModelArray = results as! [FixtureModel]
 self.myTableView.reloadData()
 
 */

//MARK:- MOVE to Nursing Attendant
extension DashboardRootViewController {
    
    
    
    //MARK:- Tabbar setup
    func setupNursingTabbar(nursingType:NursingType)
    {
        
        let tabBarController = UITabBarController()
        tabBarController.delegate = self

        let tabViewController1 = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"NursingMemberListVC") as! NursingMemberListVC
        tabViewController1.selectedNursingType = nursingType
        tabViewController1.isAddMember = 1
        tabViewController1.addressLocation = addressName
        tabViewController1.isRemoveLocation = false

        //let tabViewController2 = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"TempHistoryScreenVC") as! TempHistoryScreenVC
        
        let tabViewController2 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"NewAppointmentHistory") as! NewAppointmentHistory
        
        let tabViewController3 = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"NursingMemberListVC") as! NursingMemberListVC
        tabViewController3.selectedNursingType = nursingType
        tabViewController3.addressLocation = addressName

        //let tabViewController3 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"FamilyDetailsViewController") as! FamilyDetailsViewController

        
        let tabViewController4 = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"SchduledHHCAppointmentsVC") as! SchduledHHCAppointmentsVC
        tabViewController4.selectedNursingType = nursingType
        
//        let tabViewController5 = ProfileViewForWellness(
//            nibName:"ProfileViewForWellness",
//            bundle: nil)
        
        let tabViewController5 = ProfileViewController(
            nibName:"ProfileViewController",
            bundle: nil)
        tabViewController5.highlightclr = "HC"
        
        let nav1:UINavigationController = UINavigationController.init(rootViewController: tabViewController1)
        let nav2:UINavigationController = UINavigationController.init(rootViewController: tabViewController2)
        let nav3:UINavigationController = UINavigationController.init(rootViewController: tabViewController3)
        let nav4:UINavigationController = UINavigationController.init(rootViewController: tabViewController4)
        let nav5:UINavigationController = UINavigationController.init(rootViewController: tabViewController5)
        
        let controllers : NSArray = [nav1,nav2,nav3,nav4,nav5]
        
        tabBarController.viewControllers = controllers as? [UIViewController]
        
        nav1.tabBarItem = UITabBarItem(
            title: "Add Member",
            image: UIImage(named: "adduser"),
            tag: 1)
        
        nav2.tabBarItem = UITabBarItem(
            title: "History",
            image:UIImage(named: "history") ,
            tag:2)
        nav3.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: ""),
            tag: 1)
        nav4.tabBarItem = UITabBarItem(
            title: "Ongoing",
            image:UIImage(named: "appointment") ,
            tag:2)
        nav5.tabBarItem = UITabBarItem(
            title: "Profile",
            image:UIImage(named: "profile-1") ,
            tag:2)
        tabBarController.selectedIndex=2
        //nav2.tabBarItem.isEnabled = false
        //Set Bar tint color white
        tabBarController.tabBar.barTintColor = Color.tabBarBottomColor.value
        
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        
        let colorSelected = Color.buttonBackgroundGreen.value
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colorSelected ], for: .selected)
        
        tabBarController.view.backgroundColor = UIColor.white
        tabBarController.tabBar.tintColor = colorSelected
        tabBarController.tabBar.unselectedItemTintColor = UIColor.lightGray
        
        //Set Tab bar border color
        //tabBarController.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        tabBarController.tabBar.layer.borderWidth = 0.5
        tabBarController.tabBar.layer.borderColor =  #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
        tabBarController.tabBar.clipsToBounds = true
        
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true)
    }
    
    
    func setupDiabetesTabbar(nursingType:NursingType)
    {
        
        let tabBarController = UITabBarController()
        
        let tabViewController1 = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"NursingMemberListVC") as! NursingMemberListVC
        tabViewController1.selectedNursingType = nursingType
        tabViewController1.isAddMember = 0
        tabViewController1.addressLocation = addressName
        tabViewController1.isRemoveLocation = true
        
//        let tabViewController2 = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"TempHistoryScreenVC") as! TempHistoryScreenVC
        
        //Shubham commented
        //let tabViewController2 = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"NursingMemberListVC") as! NursingMemberListVC
        //tabViewController2.selectedNursingType = nursingType
       // tabViewController2.addressLocation = addressName
       
        
        let tabViewController2 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"NewAppointmentHistory") as! NewAppointmentHistory
        
              
               
               let tabViewController3 = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"NursingMemberListVC") as! NursingMemberListVC
               tabViewController3.selectedNursingType = nursingType
               tabViewController3.addressLocation = addressName
               tabViewController3.isRemoveLocation = true

        //let tabViewController3 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"FamilyDetailsViewController") as! FamilyDetailsViewController

        
        let tabViewController4 = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"SchduledHHCAppointmentsVC") as! SchduledHHCAppointmentsVC
        tabViewController4.selectedNursingType = nursingType
        
//        let tabViewController5 = ProfileViewForWellness(
//            nibName:"ProfileViewForWellness",
//            bundle: nil)
        
        let tabViewController5 = ProfileViewController(
            nibName:"ProfileViewController",
            bundle: nil)
        tabViewController5.highlightclr = "HC"
        
        
        let nav1:UINavigationController = UINavigationController.init(rootViewController: tabViewController1)
        let nav2:UINavigationController = UINavigationController.init(rootViewController: tabViewController2)
        let nav3:UINavigationController = UINavigationController.init(rootViewController: tabViewController3)
        let nav4:UINavigationController = UINavigationController.init(rootViewController: tabViewController4)
        let nav5:UINavigationController = UINavigationController.init(rootViewController: tabViewController5)
        
        
       
        
        
        let controllers : NSArray = [nav1,nav2,nav3,nav4,nav5]
        
        tabBarController.viewControllers = controllers as? [UIViewController]
        
        nav1.tabBarItem = UITabBarItem(
            title: "Add Member",
            image: UIImage(named: "adduser"),
            tag: 1)
        
        nav2.tabBarItem = UITabBarItem(
            title: "History",
            image:UIImage(named: "history") ,
            tag:2)
        nav3.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: ""),
            tag: 1)
        nav4.tabBarItem = UITabBarItem(
            title: "Ongoing",
            image:UIImage(named: "appointment") ,
            tag:2)
        nav5.tabBarItem = UITabBarItem(
            title: "Profile",
            image:UIImage(named: "profile-1") ,
            tag:2)
        tabBarController.selectedIndex=2
        //nav2.tabBarItem.isEnabled = false
        //Set Bar tint color white
        tabBarController.tabBar.barTintColor = Color.tabBarBottomColor.value

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        
        let colorSelected = Color.buttonBackgroundGreen.value
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colorSelected ], for: .selected)
        
        tabBarController.view.backgroundColor = UIColor.white
        tabBarController.tabBar.tintColor = colorSelected
        tabBarController.tabBar.unselectedItemTintColor = UIColor.lightGray
        
        //Set Tab bar border color
        //tabBarController.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        tabBarController.tabBar.layer.borderWidth = 0.5
        tabBarController.tabBar.layer.borderColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tabBarController.tabBar.clipsToBounds = true
        
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true)
    }
    
    //added parameter to func by geeta
    func setupDentalTabbar(nursingType:NursingType)
    {
        
        let tabBarController = UITabBarController()
        
        let tabViewController1 = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"NursingMemberListVC") as! NursingMemberListVC
        tabViewController1.selectedNursingType = nursingType
        tabViewController1.isAddMember = 1
        tabViewController1.addressLocation = addressName
        tabViewController1.isRemoveLocation = false
        //commented by tejaswi
//        let tabViewController2 = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"TempHistoryScreenVC") as! TempHistoryScreenVC
//
//        let tabViewController3 = UIStoryboard.init(name: "Dental", bundle: nil).instantiateViewController(withIdentifier:"DentalPackagesWVC") as! DentalPackagesWVC
        
        let tabViewController2 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"NewAppointmentHistory") as! NewAppointmentHistory

        let tabViewController3 = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"NursingMemberListVC") as! NursingMemberListVC
        tabViewController3.selectedNursingType = nursingType
        tabViewController3.addressLocation = addressName
        
        
        
       // tabViewController3.selectedNursingType = nursingType
       // tabViewController3.addressLocation = addressName
         
        let tabViewController4 = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"SchduledHHCAppointmentsVC") as! SchduledHHCAppointmentsVC
        //Uncomment by geeta
        tabViewController4.selectedNursingType = nursingType
        
//        let tabViewController5 = ProfileViewForWellness(
//            nibName:"ProfileViewForWellness",
//            bundle: nil)
        
        let tabViewController5 = ProfileViewController(
            nibName:"ProfileViewController",
            bundle: nil)
        tabViewController5.highlightclr = "HC"
        
        
        let nav1:UINavigationController = UINavigationController.init(rootViewController: tabViewController1)
        let nav2:UINavigationController = UINavigationController.init(rootViewController: tabViewController2)
        let nav3:UINavigationController = UINavigationController.init(rootViewController: tabViewController3)
        let nav4:UINavigationController = UINavigationController.init(rootViewController: tabViewController4)
        let nav5:UINavigationController = UINavigationController.init(rootViewController: tabViewController5)
        
        
        let controllers : NSArray = [nav1,nav2,nav3,nav4,nav5]
        
        tabBarController.viewControllers = controllers as? [UIViewController]
        
        nav1.tabBarItem = UITabBarItem(
            title: "Add Member",
            image: UIImage(named: "adduser"),
            tag: 1)
        
        nav2.tabBarItem = UITabBarItem(
            title: "History",
            image:UIImage(named: "history") ,
            tag:2)
        nav3.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: ""),
            tag: 1)
        nav4.tabBarItem = UITabBarItem(
            title: "Ongoing",
            image:UIImage(named: "appointment") ,
            tag:2)
        nav5.tabBarItem = UITabBarItem(
            title: "Profile",
            image:UIImage(named: "profile-1") ,
            tag:2)
        tabBarController.selectedIndex=2
        //nav2.tabBarItem.isEnabled = false
        //Set Bar tint color white
        tabBarController.tabBar.barTintColor = Color.tabBarBottomColor.value
        
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        
        let colorSelected = Color.buttonBackgroundGreen.value
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colorSelected ], for: .selected)
        
        tabBarController.view.backgroundColor = UIColor.white
        tabBarController.tabBar.tintColor = colorSelected
        tabBarController.tabBar.unselectedItemTintColor = UIColor.lightGray
        
        //Set Tab bar border color
        //tabBarController.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        tabBarController.tabBar.layer.borderWidth = 0.5
        tabBarController.tabBar.layer.borderColor =  #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
        tabBarController.tabBar.clipsToBounds = true
        
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true)
    }
    
    //MARK:- Tabbar setup for Covid
    func setupCovidScreen(nursingType:NursingType)
    {
        if self.getGroupCode() == "SEM1" {
            //CovidInstructionsVC
           //let vc  = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"CovidInstructionsVC") as! CovidInstructionsVC
            let vc  = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"CovidTestBookingTVC") as! CovidTestBookingTVC
            //vc.isSOP1 = false
            //vc.hideTopSegmentView = true
            vc.modalPresentationStyle = .fullScreen
            
            let nav1:UINavigationController = UINavigationController.init(rootViewController: vc)
            nav1.modalPresentationStyle = .fullScreen
            self.navigationController?.present(nav1, animated: true, completion: nil)
        }
        else {
            let vc  = UIStoryboard.init(name: "AttendantHC", bundle: nil).instantiateViewController(withIdentifier:"CovidTestBookingTVC") as! CovidTestBookingTVC
            vc.modalPresentationStyle = .fullScreen
            
            let nav1:UINavigationController = UINavigationController.init(rootViewController: vc)
            nav1.modalPresentationStyle = .fullScreen
            self.navigationController?.present(nav1, animated: true, completion: nil)
        }
        
       
    }
    
}


extension DashboardRootViewController {
    //Get Top Bar Button API...
    func getTopThreeButtonsAPI() {
        if let isInsurance = UserDefaults.standard.value(forKey:"isInsurance") as? Bool {
            if !servicesArray.contains("Insurance") {
                self.servicesArray.append("Insurance")
            }
        }
        
        if let isInsurance = UserDefaults.standard.value(forKey:"isWellness") as? Bool {
            if !servicesArray.contains("Wellness") {
                self.servicesArray.append("Wellness")
            }
        }
        
        if let isInsurance = UserDefaults.standard.value(forKey:"isFitness") as? Bool {
            if !servicesArray.contains("Fitness") {
                //self.servicesArray.append("Fitness")
            }
        }

        let indexPath = IndexPath.init(row: 0, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .none)

    }
    
    
    //MARK:- Get Data From Server
    private func getFamilyDetailsFromServer() {
     
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
        let serviceId = "10"
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
                            
                            for person in personArray {
                                
                                let modelObj = FamilyDetailsModelHHC.init(PersonName: person["PERSON_NAME"].stringValue.capitalized, DateOfBirth: person["DOB"].stringValue, Gender: person["GENDER"].stringValue, RelationID: person["RELATIONID"].stringValue, RelationName: person["RELATION_NAME"].stringValue.capitalized, EXT_EMPLOYEE_SR_NO: person["EXT_EMPLOYEE_SR_NO"].stringValue, ExtPersonSRNo: person["EXT_PERSON_SR_NO"].stringValue, CellPhoneNumber: person["CELLPHONE_NUMBER"].stringValue, EmailID: person["EMAIL_ID"].stringValue, IS_ADDRESS_SAVED: person["IS_ADDRESS_SAVED"].stringValue,AGE:person["AGE"].stringValue)
                                    
                                let age = person["AGE"].stringValue
                                let relationID = person["RELATIONID"].stringValue
                                let gender = person["GENDER"].stringValue
                                let ext_employee_sr_no = person["EXT_EMPLOYEE_SR_NO"].stringValue
                                let ext_person_sr_no = person["EXT_PERSON_SR_NO"].stringValue
                                
                                print("age:::",age)
                                print("relationID:::",relationID)
                                let ageInt = Int(age)
                                
                                if let relationIDInt = Int(relationID)
                                    {
                                    //self
                                    if relationID == "17" && ext_employee_sr_no != ""{
                                        self.personDetailsArray.append(modelObj)
                                        print("ext_employee_sr_no ",ext_employee_sr_no)
                                        print("ext_person_sr_no ",ext_person_sr_no)
                                        
                                        UserDefaults.standard.set(ext_employee_sr_no, forKey: "Wellness_Ext_Employee_Sr_No")
                                        
                                        UserDefaults.standard.set(ext_person_sr_no, forKey: "Wellness_Ext_Person_Sr_No")
                                   }
                                }

                            }
                        }
                        
                    }
                    else {
                        self.displayActivityAlert(title: m_errorMsg )
                    }
                }
            }//msgDic
        }
    }
    
    
//    {
//            guard let orderMasterNo = UserDefaults.standard.value(forKey: "OrderMasterNo") else {
//                return
//            }
//
//            var m_employeedict : EMPLOYEE_INFORMATION?
//            let userArray : [EMPLOYEE_INFORMATION] = DatabaseManager.sharedInstance.retrieveEmployeeDetails(productCode: "GMC")
//
//        if userArray.count > 0 {
//            m_employeedict=userArray[0]
//            var groupChildSrNo = String()
//
//            if let groupChildSR = m_employeedict?.groupChildSrNo
//            {
//                groupChildSrNo=String(groupChildSR)
//            }
//
//            print(groupChildSrNo)
//            let url = APIEngine.shared.getServicableTabs(strGroupChildSrno: groupChildSrNo)
//            print(url)
//
//            ServerRequestManager.serverInstance.getRequestDataFromServerWithoutLoader(url: url, view: self) { (response, error) in
//
//                if let messageDictionary = response?["message"].dictionary
//                {
//
//                    if let status = messageDictionary["Status"]?.bool
//                    {
//                        if status == true {
//
//                            UserDefaults.standard.set(false, forKey: "isInsurance")
//                            UserDefaults.standard.set(false, forKey: "isWellness")
//                            UserDefaults.standard.set(false, forKey: "isFitness")
//
//
//                            if let buttonsArray = response?["showButtons"].array {
//                                for arrDict in buttonsArray {
//                                    guard let serviceName = arrDict["SERVICE_NAME"].string else {
//                                        return
//                                    }
//
//                                    switch serviceName.uppercased() {
//                                    case "INSURANCE":
//                                        UserDefaults.standard.set(true, forKey: "isInsurance")
//                                        if !self.servicesArray.contains("Insurance") {
//                                        self.servicesArray.append("Insurance")
//                                        }
//                                    case "WELLNESS":
//                                        UserDefaults.standard.set(true, forKey: "isWellness")
//                                        if !self.servicesArray.contains("Wellness") {
//                                        self.servicesArray.append("Wellness")
//                                        }
//                                    case "FITNESS":
//                                        UserDefaults.standard.set(true, forKey: "isFitness")
//                                        if !self.servicesArray.contains("Fitness") {
//                                        self.servicesArray.append("Fitness")
//                                        }
//                                    default:
//                                        break
//                                    }
//
//                                }
//                            }
//                            let indexPath = IndexPath.init(row: 0, section: 0)
//                            self.tableView.reloadRows(at: [indexPath], with: .none)
//
//                           // self.topCollectionView.reloadData()
//                        }
//                        else {
//                            //employee record not found
//                            //let msg = messageDictionary["Message"]?.string
//                            //self.displayActivityAlert(title: m_errorMsg )
//                        }
//                    }
//                }//msgDic
//            }
//        }
//    }
}

