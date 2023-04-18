//
//  FitnessDashboardRootVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 05/09/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import AktivoCoreSDK
import CoreMotion
import MBProgressHUD
import SlideMenuControllerSwift

var menuButtonF = UIButton()
var isFromRefresh = 0
var networkScoreModelObj = NetworkScoreModel()
var aktivoTodaysScoreObj : AktivoDailyScore?
var aktivoTodaysStepObj : AktivoDailyStep?
var aktivoTodaysSleepObj : AktivoDailySleep?

class FitnessDashboardRootVC: UITableViewController,DashboardCollectionViewProtocol,DesDelegate, UIViewControllerTransitioningDelegate,OnboardingProtocol {
    
    
    
    //0
    @IBOutlet weak var collectionViewCellTab: CellForDashboardRootCell1!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var gifLoaderView: UIView!
    @IBOutlet weak var gifView: UIView!
    //1
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var viewLearnMore: UIView!
    @IBOutlet weak var lblLifestyle: UILabel!
    
    //2 BUTTON VIEWS
    @IBOutlet weak var btnSedentary: UIButton!
    @IBOutlet weak var btnExercise: UIButton!
    @IBOutlet weak var btnSleep: UIButton!
    @IBOutlet weak var btnLightActivity: UIButton!
    @IBOutlet weak var lblTimeToday: UILabel!
    @IBOutlet weak var lblTimeYesterday: UILabel!
    @IBOutlet weak var lblStatusToday: UILabel!
    @IBOutlet weak var imgChangeMiddle: UIImageView!
    
    @IBOutlet weak var lblNegative: UILabel!
    @IBOutlet weak var lblLeftSideChange: UILabel!
    @IBOutlet weak var btnMiddle: UIButton!
    
    //FOUR LABELS
    @IBOutlet weak var lblSedentary: UILabel!
    @IBOutlet weak var lblExcercise: UILabel!
    @IBOutlet weak var lblSleepMiddle: UILabel!
    @IBOutlet weak var lblLightActivity: UILabel!
    
    @IBOutlet weak var imgSleep: UIImageView!
    @IBOutlet weak var imgSedentary: UIImageView!
    @IBOutlet weak var imgExcercise: UIImageView!
    @IBOutlet weak var imgLightActivity: UIImageView!
    
    @IBOutlet weak var nameView1: UIView!
    @IBOutlet weak var nameView2: UIView!
    @IBOutlet weak var nameView3: UIView!
    @IBOutlet weak var nameView4: UIView!
    
    
    //FOUR IMAGES
    @IBOutlet weak var viewSedentary: UIView!
    @IBOutlet weak var viewExcercise: UIView!
    @IBOutlet weak var viewSleep: UIView!
    @IBOutlet weak var viewLightActivity: UIView!
    
    @IBOutlet weak var imgPositive: UIImageView!
    
    @IBOutlet weak var imgLbl1: UILabel!
    @IBOutlet weak var imgLbl2: UILabel!
    @IBOutlet weak var imgLbl3: UILabel!
    @IBOutlet weak var imgLbl4: UILabel!
    //3 Team Score
    @IBOutlet weak var scoreHeight1: NSLayoutConstraint!
    @IBOutlet weak var scoreHeight2: NSLayoutConstraint!
    @IBOutlet weak var scoreHeight3: NSLayoutConstraint!
    @IBOutlet weak var scoreHeight4: NSLayoutConstraint!
    
    @IBOutlet weak var competitiorsView: UIView!
    @IBOutlet weak var lblRank1: UILabel!
    @IBOutlet weak var lblRank2: UILabel!
    @IBOutlet weak var lblRank3: UILabel!
    @IBOutlet weak var lblRank4: UILabel!
    
    @IBOutlet weak var lblName1: UILabel!
    @IBOutlet weak var lblName2: UILabel!
    @IBOutlet weak var lblName3: UILabel!
    @IBOutlet weak var lblName4: UILabel!
    
    @IBOutlet weak var lblScore1: UILabel!
    @IBOutlet weak var lblScore2: UILabel!
    @IBOutlet weak var lblScore3: UILabel!
    @IBOutlet weak var lblScore4: UILabel!
    
    
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    
    //4th Last
    @IBOutlet weak var lblSteps: UILabel!
    @IBOutlet weak var lblSleep: UILabel!
    
    //for animation
    @IBOutlet weak var circleProgressfirst: KDCircularProgress!
    @IBOutlet weak var circleProgresssecond: KDCircularProgress!
    @IBOutlet weak var lblCount: UILabel!
    
    //Badge UI
    @IBOutlet weak var imgBadgeEmoji: UIImageView!
    @IBOutlet weak var lblBadgeHeading: UILabel!
    @IBOutlet weak var lblBadgeDetails: UILabel!
    
    @IBOutlet weak var lblFirstBadgeLabel: UILabel!
    
    var _dynamicValue : Int = 0
    var displayedScore = 0
    var scoreTimer = Timer()
    //end animation
    
    
    var isScore = false
    var isSleep = false
    var isStep = false
    
    var servicesArray = ["Insurance"]
    
    
    //For Pull to refresh
    lazy var refreshControl1: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        
        refreshControl.tintColor = UIColor.lightGray
        
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("Refresh.........")
        // refreshControl.endRefreshing()
        
        isFromRefresh = 1
        
        
        if let emailID = UserDefaults.standard.value(forKey: "emailid") as? String {
            self.getUserTokenValueAPI(email: emailID)
        }
    }
    
    
    var isFromInsurance = 0
    var selectedButton = 1
    
    //var isFromRefresh = 0
    
    var dailyStepData = Dictionary<Date, AktivoDailyStep>()
    var dailySleepData = Dictionary<Date, AktivoDailySleep>()
    var dailyScoreData = Dictionary<Date, AktivoDailyScore>()
    
    var sd = ""
    var lightActivity = ""
    var excer = ""
    var sleep = ""
    
    var sdIMP = ""
    var lightActivityIMP = ""
    var excerIMP = ""
    var sleepIMP = ""
    
    var nameModelArray = [LeaderboardModel]()
    var challengesModelObj = ChallengesScoreModel()
    
    //For hide challenges cell or not
    var isNamesFound = false
    var allHide = true
    override func viewDidLoad() {
        print("#VDL - Fitness")
        
        self.allHide = true
        DispatchQueue.main.async {
            self.tableView.isUserInteractionEnabled = false
            
        }
        menuButton.isHidden = true
        isRemoveFlag = 1
        setupMiddleButton()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.navBarDropShadow()
        
        //        tabBarController?.tabBar.tintColor = Color.redBottom.value
        //        tabBarController?.tabBar.unselectedItemTintColor = UIColor.lightGray
        //
        //        let selectedItem = [NSAttributedStringKey.foregroundColor: UIColor.red]
        //
        //        tabBarController?.tabBar.selectedItem?.setTitleTextAttributes(selectedItem, for: .selected)
        //        tabBarController?.tabBar.selectedItem?.setTitleTextAttributes(selectedItem, for: .normal)
        
        tabBarController?.tabBar.inActiveTintColor()
        
        super.viewDidLoad()
        isFromRefresh = 0
        selectedFeatureIndex = 0 //to set 0th position for stats view
        
        DispatchQueue.main.async {
            self.gifLoaderView.isHidden = false
            //blueCircle
            // let jeremyGif = UIImage.gifImageWithName("loading")
            let jeremyGif = UIImage.gifImageWithName("giphy")
            
            let imageView1 = UIImageView(image: jeremyGif)
            imageView1.frame = CGRect(x: 0, y: 0, width: self.gifLoaderView.frame.size.width, height: 40)
            self.gifLoaderView.addSubview(imageView1)
        }
        
        collectionViewCellTab.dashboarCollectionViewdDelegate = self
        
        let logo = UIImage(named: "mb360_white")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height:10))
        imageView.image=logo
        imageView.contentMode=UIViewContentMode.scaleAspectFit
        self.navigationItem.titleView = imageView
        
        //Name is removed
        //let name = UserDefaults.standard.value(forKey: "name") as? String
        //self.lblName.text = String(format: "Hello, %@", name ?? "")
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [Color.redBottom.value,Color.redTop.value])
        
        //self.tableView.backgroundView?.setGradientBackground1(colorTop: hexStringToUIColor(hex: "0171d5"), colorBottom:hexStringToUIColor(hex: "5eb1fd"))
        //self.view.setGradientBackground1(colorTop: hexStringToUIColor(hex: "0171d5"), colorBottom:hexStringToUIColor(hex: "5eb1fd"))
        
        //self.view.backgroundColor = UIColor.red
        //hexStringToUIColor(hex: "ffbb3d")
        //MARK:- set Gradient color
        //self.setTableViewBackgroundGradient(sender: self, Color.fitnessBottom.value, Color.fitnessTop.value)
        
        
        
        //Set Background Image
        //self.tableView.backgroundColor = UIColor.clear
        // self.tableView.backgroundView?.backgroundColor = UIColor.clear
        
        //0
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.learnMoreTapped(_:)))
        viewLearnMore.addGestureRecognizer(tap)
        
        //1
        viewLearnMore.layer.cornerRadius = 6.0
        self.shadowForCell(view: viewLearnMore)
        //viewLearnMore.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //viewLearnMore.layer.borderWidth = 1.0
        
        
        //Add Tap Gesture on step,sleep label
        let stepTap = UITapGestureRecognizer(target: self, action: #selector(self.stepLabelTapped(_:)))
        lblSteps.addGestureRecognizer(stepTap)
        let sleepTap = UITapGestureRecognizer(target: self, action: #selector(self.sleepLabelTapped(_:)))
        lblSleep.addGestureRecognizer(sleepTap)
        let tableTap = UITapGestureRecognizer(target: self, action: #selector(self.scoreViewTapped(_:)))
        competitiorsView.addGestureRecognizer(tableTap)
        
        self.tableView.refreshControl = self.refreshControl1
        
        //changeImageOnTapp(imgName: "BlackSleep")
        
        //2
        setButtonViews()
        //self.lblTimeToday.attributedText = attributedText(withString: "8 hours 57 minutes", boldString: "8", font: UIFont(name: "Poppins-Regular", size: 15.0)!)
        
        //set black img
        //        let origImage = UIImage(named: "newSleep")
        //        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        //        btnSleep.setImage(tintedImage, for: .normal)
        //        btnSleep.tintColor = UIColor.white
        
        //set black img
        //        let origImagelight = UIImage(named: "footprint25x25-1")
        //        let tintedImageLight = origImagelight?.withRenderingMode(.alwaysTemplate)
        //        btnLightActivity.setImage(tintedImageLight, for: .normal)
        //        btnLightActivity.tintColor = UIColor.white
        
        // let origImage = UIImage(named: "newSleep")
        //let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        // btnSedentary.setImage(tintedImage, for: .normal)
        //btnSedentary.tintColor = UIColor.black
        
        showDisclaimer()
        
        //4
        setTodaySection()
        
        //authenticUser()
        
        // let rightBarButton = UIBarButtonItem(title: "Menu", style: .plain, target:self, action:#selector(menuTapped))
        
        let rightBar = UIBarButtonItem(image: UIImage(named: "menu-1"), style: .done, target: self, action: #selector(menuTapped))
        self.navigationItem.rightBarButtonItem = rightBar
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("notificationDashboard"), object: nil)
        
        UserDefaults.standard.set(false, forKey: "isOnboardingFirstTime")
        
        getTopThreeButtonsAPI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("notificationDashboard"), object: nil)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        
        self.tabBarController?.selectedIndex = 2
    }
    
    
    @objc private func menuTapped() {
        self.slideMenuController()?.openRight()
        
    }
    
    //MARK:- Custom Delegate Methods
    func refreshData() {
        getTokenAPI()
    }
    
    func denyDisclaimer() {
        setupInsurance()
    }
    
    func onboardingCompleted(isComplete:Bool) {
        if isComplete
        {
            refreshData()
        }
        else {
            if isFromInsurance == 1 {
                print("Move to INSURANCE")
                setupInsurance()
            }
            else {
                print("Move to Wellness")
                
                setupWellnessTabbar()
            }
            
        }
    }
    
    
    
    func showDisclaimer() {
        
        if let isFirstTime = UserDefaults.standard.value(forKey: "isFitnessFirstTime") as? Bool {
            
            getTokenAPI()
            
        }
        else {
            let vc = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"DisclaimerViewController") as! DisclaimerViewController
            vc.modalPresentationStyle = .custom
            vc.delegate = self
            vc.modalTransitionStyle = .coverVertical
            
            self.navigationController?.present(vc, animated: true, completion: nil)
            
        }
    }
    
    
    
    
    
    private func authenticUser() {
        
        print("----AuthenticUser()")
        
        if let sdkStatus = UserDefaults.standard.value(forKey: "aktivo") as? Bool {
            if sdkStatus
            {
                if let authStatus = UserDefaults.standard.value(forKey: "aktivoAuth") as? Bool {
                    if authStatus == false
                    {
                        print("Auth failed first")
                        self.authenticProcess()
                        
                    }
                    else {
                        print("Already Authenticated")
                        //self.aktivoPermissionWithSyncData()
                        self.authenticProcess()
                    }
                    
                    
                    
                }
                else { //if value not found aktivoAuth in userdefaults
                    authenticProcess()
                    
                }
            }
            else {
                print("Failed to init SDK")
            }
        }
        
        
    }
    
    private func authenticProcess() {
        //Pranit
        
        guard let userToken = UserDefaults.standard.value(forKey: "userAktivoId") as? String else {
            return
        }
        
        Aktivo.authenticateUser(Aktivo.User(userID: userToken), completion: { (authError) in
            
            
            
            guard let error = authError else {
                print("#Authentication Success...")
                
                UserDefaults.standard.set(true, forKey: "aktivoAuth")
                self.aktivoPermissionWithSyncData()
                
                return
            }
            
            print("#Authentication Failed...")
            print(authError)
            
            //Check if error occured, else consider success
        })
    }
    
    
    //MARK:- SYNC DATA
    private func aktivoPermissionWithSyncData() {
        //AKTIVO INTEGRATION
        print("aktivoPermissionWithSyncData()")
        Aktivo.isPermissionGranted(completion: { (result, error) in
            
            if error != nil {
                print("..Failed Permission.. \(error)")
                //If we display motion permission screen here then it will display in full screen mode. added below method call on 4th Nov 2020
                //self.triggerActivityPermissionRequest()
                
                //If motion failed then asking for health permissions
                self.healthPermissions()
            }
            else {
                print("Permission")
                print(result)
                
                if result == false
                {
                    
                    
                    self.healthPermissions()
                    
                    //Motion Permission
                    Aktivo.requestFitnessTrackingPermission(completion: { (fitnessError) in
                        if error != nil {
                            
                            print("Successfully grant motion = \(error)")
                            
                        }
                        else {
                            
                            print("Failed to grant motion")
                            print(error)
                            
                            self.triggerActivityPermissionRequest()
                            
                            
                        }
                    })
                }
                else {
                    print("Already access to Permission")
                    if let healthStatus = UserDefaults.standard.value(forKey: "health") as? Bool {
                        if isFromRefresh == 0 {
                            //self.showPleaseWait(msg: "")
                            self.showFitnessLoader(msg: "", type: 1)
                            
                        }
                        
                        
                        Aktivo.syncFitnessData{ (error) in
                            if error != nil {
                                
                                self.hidePleaseWait()
                                print("Failed to Sync Data = \(error)")
                                self.checkAktivoMethods()
                                
                            }
                            else {
                                self.hidePleaseWait()
                                
                                print("Successfully Sync Data..")
                                self.checkAktivoMethods()
                                
                            }
                        }
                        
                        // self.checkAktivoMethods()
                        
                    }
                    else {
                        //User performed uninstall operation then ask again for health permissions
                        
                        self.healthPermissions()
                        
                    }
                }
            }
        })
        
        //end
    }
    
    //Checking healthKit permissions and sync data..
    func healthPermissions() {
        print("healthPermissions()")
        //check for Health permissions
        Aktivo.requestHealthDataAccess(completion: { (permissionError) in
            if permissionError == nil {
                print("Successfully granted permission for health data access..")
                
                UserDefaults.standard.set(true, forKey: "health")
                if isFromRefresh == 0 {
                    //self.showPleaseWait(msg: "")
                    self.showFitnessLoader(msg: "", type: 1)
                }
                //Sync Fitness Data
                
                Aktivo.syncFitnessData{ (error) in
                    if error != nil {
                        
                        self.hidePleaseWait()
                        
                        print("Failed to Sync Data = \(error)")
                        self.checkAktivoMethods()
                        
                    }
                    else {
                        self.hidePleaseWait()
                        
                        print("Successfully Sync Data..")
                        self.checkAktivoMethods()
                        
                    }
                }
                
                // self.checkAktivoMethods()
                
            }
            else {
                print("Error in permission User does not allow Health Access")
                self.checkAktivoMethods()
                
            }
        })
    }
    
    //MARK:- Check Aktivo Methods
    func checkAktivoMethods() {
        
        print("#.....Check MEHODS.....")
        
        let toDate = Date()
        let fromDate = Date().yesterdayDate // 10 Days back
        
        //        DispatchQueue.main.async {
        //            self.gifLoaderView.isHidden = false
        //        }
        
        
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day]
        
        // get the components
        let fromDateComponents = Calendar.current.dateComponents(requestedComponents, from: fromDate)
        let fromDateFinal = Calendar.current.date(from: DateComponents(calendar: Calendar.current, year:fromDateComponents.year, month:fromDateComponents.month, day:fromDateComponents.day))!
        print(fromDateFinal)
        
        let toDateComponents = Calendar.current.dateComponents(requestedComponents, from: toDate)
        let toDateFinal = Calendar.current.date(from: DateComponents(calendar: Calendar.current, year:toDateComponents.year, month:toDateComponents.month, day:toDateComponents.day))!
        
        self.getTodaysScore(fromDate: fromDateFinal, toDate: toDateFinal)
        self.getSleepData(fromDate: fromDateFinal, toDate: toDateFinal)
        
        //Get Number of weeks in current year and set that count to collectionview
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
        let weekDates = getRangeDates(weekNo: String(weekOfYear))
        //self.getStepData(fromDate: weekDates.start, toDate: weekDates.end)
        
        
        self.getStepData(fromDate: weekDates.start, toDate: weekDates.end)
        
        
        getTodaysBadge()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.backgroundView = UIImageView(image: UIImage(named: "aktivo_background"))
        
        tabBarController?.tabBar.tintColor = Color.redBottom.value
        tabBarController?.tabBar.unselectedItemTintColor = UIColor.lightGray
        
        //self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addRightGestures()
        self.startAnimation()
        
    }
    
    //Check Motion Permissions
    
    
    // If user turned off motion and uninstall application.
    //Install New app -> On Fitness tap -> Disclaimer page will present from VDL and that time viewWillAppear will try to present MotionPermissionVC, At a time 2vc will not present simultaneously.
    //To resolve this issue we are presenting Disclaimer from VDL.
    //When user tap on 'I understand'/Back button then we are checking for motion permissions and presenting Motion VC.
    //If app install or launch is not first time or dislaimer page already presented then only we are showing motion activity page.
    
    func triggerActivityPermissionRequest() {
        print("Motion Permissions....")
        
        if let isFirstTime = UserDefaults.standard.value(forKey: "isFitnessFirstTime") as? Bool {
            
            let manager = CMMotionActivityManager()
            let today = Date()
            
            manager.queryActivityStarting(from: today, to: today, to: OperationQueue.main, withHandler: { (activities: [CMMotionActivity]?, error: Error?) -> () in
                if error != nil {
                    let errorCode = (error! as NSError).code
                    if errorCode == Int(CMErrorMotionActivityNotAuthorized.rawValue) {
                        
                        print("MOTION NotAuthorized")
                        self.hidePleaseWait()
                        self.moveToMotionPermissionPage()
                        // self.showAlert(message: "Please Turn On Motion Permissions - NotAuthorized")
                        
                    }
                    else if errorCode == Int(CMErrorMotionActivityNotEntitled.rawValue) {
                        
                        print("MOTION Not Entitled")
                        self.moveToMotionPermissionPage()
                        self.hidePleaseWait()
                        
                        // self.showAlert(message: "Please Turn On Motion Permissions - Not Entitled")
                        
                    }
                    else if errorCode == Int(CMErrorMotionActivityNotEntitled.rawValue) {
                        
                        print("MOTION Not Available")
                        self.hidePleaseWait()
                        
                        self.moveToMotionPermissionPage()
                        
                        //self.showAlert(message: "Please Turn On Motion Permissions - Not Available")
                        
                    }
                    
                }
                    
                else {
                    
                    print("MOTION Authorized")
                    //                if let emailID = UserDefaults.standard.value(forKey: "emailid") as? String {
                    //                    self.getUserTokenValueAPI(email: emailID)
                    //                }
                }
                manager.stopActivityUpdates()
            })
        }
    }
    
    private func moveToMotionPermissionPage() {
        let motionVC  = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"MotionPermissionsVC") as! MotionPermissionsVC
        motionVC.modalPresentationStyle = .fullScreen
        self.navigationController?.present(motionVC, animated: true, completion: nil)
        
    }
    
    //MARK:- Move To Daily Badge
    @objc func learnMoreTapped(_ sender: UITapGestureRecognizer? = nil) {
        
        let dailyBadgeVC  = UIStoryboard.init(name: "Badge", bundle: nil).instantiateViewController(withIdentifier:"BadgeContainer") as! BadgeContainer
        dailyBadgeVC.dailyStepData = self.dailyStepData
        dailyBadgeVC.dailyScoreData = self.dailyScoreData
        dailyBadgeVC.dailySleepData = self.dailySleepData
        
        
        self.navigationController?.pushViewController(dailyBadgeVC, animated: true)
        
    }
    
    @objc func stepLabelTapped(_ sender: UITapGestureRecognizer? = nil) {
        selectedFeatureIndex = 1
        isDirect = 1
        self.tabBarController?.selectedIndex = 3
    }
    @objc func sleepLabelTapped(_ sender: UITapGestureRecognizer? = nil) {
        selectedFeatureIndex = 3
        isDirect = 1
        self.tabBarController?.selectedIndex = 3
    }
    @objc func scoreViewTapped(_ sender: UITapGestureRecognizer? = nil) {
        let competeView  = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier:"CompeteDetailsVC") as! CompeteDetailsVC
        competeView.challengesModelObj = self.challengesModelObj
        self.navigationController?.pushViewController(competeView, animated: true)
        
    }
    
    //MARK:- Animation
    private func animate(sender:UIButton) {
        //        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        //        colorAnimation.fromValue = UIColor.black.cgColor
        //        colorAnimation.duration = 0.5  // animation duration
        //        // colorAnimation.autoreverses = true // optional in my case
        //        // colorAnimation.repeatCount = FLT_MAX // optional in my case
        //        sender.layer.add(colorAnimation, forKey: "ColorPulse")
        
    }
    
    
    func setTableViewBackgroundGradient(sender: UITableViewController, _ topColor:UIColor, _ bottomColor:UIColor) {
        
        let gradientBackgroundColors = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations = [0.0,1.0]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        gradientLayer.frame = sender.tableView.bounds
        let backgroundView = UIView(frame: sender.tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        sender.tableView.backgroundView = backgroundView
    }
    
    
    
    private func hideViews(scoreHeight:NSLayoutConstraint,nameLbl:UILabel,scoreLbl:UILabel,rankLbl:UILabel) {
        scoreHeight.constant = 0
        nameLbl.isHidden = true
        scoreLbl.isHidden = true
        rankLbl.isHidden = true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if allHide
        {
            return 0
        }
        else {
            if indexPath.row == 3 {
                //for single + 25
                //return 120 + 95
                
                if isNamesFound {
                    if self.nameModelArray.count == 0 {
                        return 0
                    }
                    else if self.nameModelArray.count == 1 {
                        return 113 + 35 //top+bottom 15+ 8 + Cup 40 + (comp 50)
                    }
                    else if self.nameModelArray.count == 2 {
                        return 113 + 70
                    }
                    else if self.nameModelArray.count == 3 {
                        return 113 + 105
                    }
                    else {
                    return 243
                    }
                }
                return 0
                
            }
            else if indexPath.row == 0 {
                return 70
            }
            else if indexPath.row == 1 {
                return 312
            }
            else {
                return UITableViewAutomaticDimension
            }
        }
    }
    
    //4th combine different fonts
    private func setTodaySection() {
        let stringSteps = attributedText(withString: "Today you have covered % steps than yesterday. That's a total of steps this week!", boldString: "covered % ", font: UIFont(name: "Poppins-Regular", size: 15.0)!)
        
        self.lblSteps.attributedText = stringSteps
        
        let sleepStr = attributedText(withString: "You slept for hours minutes last night. Adequate sleep is essential for a healthy lifestyle. Tap here to check your weekly average.", boldString: "Tap here to check your weekly average.", font: UIFont(name: "Poppins-Regular", size: 15.0)!)
        self.lblSleep.attributedText = sleepStr
        
        
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom,colorTop]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    //Set four Button Views
    private func setButtonViews() {
        //        self.btnSedentary.layer.cornerRadius = self.btnSedentary.frame.height / 2
        //        self.btnExercise.layer.cornerRadius = self.btnExercise.frame.height / 2
        //        self.btnSleep.layer.cornerRadius = self.btnSleep.frame.height / 2
        //        self.btnLightActivity.layer.cornerRadius = self.btnLightActivity.frame.height / 2
        
        self.viewSedentary.layer.cornerRadius = self.viewSedentary.frame.height / 2
        self.viewExcercise.layer.cornerRadius = self.viewExcercise.frame.height / 2
        self.viewSleep.layer.cornerRadius = self.viewSleep.frame.height / 2
        self.viewLightActivity.layer.cornerRadius = self.viewLightActivity.frame.height / 2
        
        
        //        self.btnSedentary.dropShadow()
        //        self.btnExercise.dropShadow()
        //        self.btnSleep.dropShadow()
        //        self.btnLightActivity.dropShadow()
        
        self.viewSedentary.dropShadow()
        self.viewSleep.dropShadow()
        self.viewExcercise.dropShadow()
        self.viewLightActivity.dropShadow()
        
        changeButtonColors()
        
        
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        animate(sender: sender)
        self.selectedButton = sender.tag
        changeButtonColors()
    }
    
    private func changeButtonColors() {
        switch selectedButton {
        case 1:
            setWhiteButton(btn: viewSedentary, lbl: lblSedentary)
            
            setBlackButton(btn: viewExcercise, lbl: lblExcercise)
            setBlackButton(btn: viewSleep, lbl: lblSleepMiddle)
            setBlackButton(btn: viewLightActivity, lbl: lblLightActivity)
            
            self.lblStatusToday.text = "Sedentary Time Today"
            self.lblLeftSideChange.text = "Sedentary Time \nYesterday"
            
            //changeImageOnTapp(imgName: "sleep")
            setImages(id: 1)
            
            setsedentary()
            
        case 2:
            setWhiteButton(btn: viewExcercise, lbl: lblExcercise)
            
            setBlackButton(btn: viewSedentary, lbl: lblSedentary)
            setBlackButton(btn: viewSleep, lbl: lblSleepMiddle)
            setBlackButton(btn: viewLightActivity, lbl: lblLightActivity)
            self.lblStatusToday.text = "Exercise Time Today"
            self.lblLeftSideChange.text = "Exercise Time \nYesterday"
            
            
            self.imgChangeMiddle.image = UIImage(named: "blackRunNew")
            //set black img
            setImages(id: 2)
            
            setExcercise()
            
        case 3:
            setWhiteButton(btn: viewSleep, lbl: lblSleepMiddle)
            
            setBlackButton(btn: viewExcercise, lbl: lblExcercise)
            setBlackButton(btn: viewSedentary, lbl: lblSedentary)
            setBlackButton(btn: viewLightActivity, lbl: lblLightActivity)
            self.lblStatusToday.text = "Sleep Time Today"
            self.lblLeftSideChange.text = "Sleep Time \nYesterday"
            self.imgChangeMiddle.image = UIImage(named: "sleepAktivo")
            
            self.setSleepData()
            
            setImages(id: 3)
            
            
        case 4:
            setWhiteButton(btn: viewLightActivity, lbl: lblLightActivity)
            
            setBlackButton(btn: viewExcercise, lbl: lblExcercise)
            setBlackButton(btn: viewSleep, lbl: lblSleepMiddle)
            setBlackButton(btn: viewSedentary, lbl: lblSedentary)
            self.lblStatusToday.text = "Light Activity Time Today"
            self.lblLeftSideChange.text = "Light Activity Time \nYesterday"
            //self.lblNegative.text = "Positive"
            //self.imgPositive.image = UIImage(named: "positivearrrow20x20")
            //changeImageOnTapp(imgName: "sleep")
            
            self.imgChangeMiddle.image = UIImage(named: "FootPrint_black25x25")
            
            setImages(id: 4)
            setLightActivity()
            //self.lblTimeToday.text = "2 hours, 15 minutes"
            //self.lblTimeYesterday.text = "3 hours 30  minutes"
            
        default:
            break
        }
    }
    
    //MARK:- Set Image
    private func setImages(id:Int) {
        
        switch id {
        case 1:
            imgSedentary.image = UIImage(named:"people-sitting60x60")
            imgExcercise.image = UIImage(named:"smallRun")
            imgSleep.image = UIImage(named:"sleep_white25x25")
            imgLightActivity.image = UIImage(named:"FootPrint25x25-2")
            self.imgChangeMiddle.image = UIImage(named: "people-sitting60x60")
        case 2:
            imgSedentary.image = UIImage(named:"people-sitting_white60x60")
            imgExcercise.image = UIImage(named:"blackRunNew")
            imgSleep.image = UIImage(named:"sleep_white25x25")
            imgLightActivity.image = UIImage(named:"FootPrint25x25-2")
        case 3:
            imgSedentary.image = UIImage(named:"people-sitting_white60x60")
            imgExcercise.image = UIImage(named:"smallRun")
            imgSleep.image = UIImage(named:"newSleep")
            imgLightActivity.image = UIImage(named:"FootPrint25x25-2")
            
        case 4:
            imgSedentary.image = UIImage(named:"people-sitting_white60x60")
            imgExcercise.image = UIImage(named:"smallRun")
            imgSleep.image = UIImage(named:"sleep_white25x25")
            imgLightActivity.image = UIImage(named:"FootPrint_black25x25")
            
        default:
            break
        }
    }
    
    //MARK:- get min
    func getMin(seconds:Double) -> String {
        //int hours = (int) seconds / 3600;
        let hrs = Int(seconds)/3600
        var remainder = Int(seconds) - hrs * 3600
        var mins = remainder / 60
        
        remainder = remainder - mins * 60
        
        let secs = remainder
        if secs > 30 {
            mins += 1
        }
        
        
        var str = ""
        if hrs > 0 {
            str = String(format: "%@ hours %@ minutes", String(hrs.description),String(mins.description))
        }
        else {
            str = String(format: "%@ minutes",String(mins.description))
        }
        return str
    }
    
    public func setScore() {
        let resultsSorted = self.dailyScoreData.sorted(by: { ($0.key) < ($1.key)})
        // var countValue = 0
        
        for score in resultsSorted { //BAR
            var value = score.value
            
            
            if score.key.getSimpleDate() == Date().yesterdayDate.getSimpleDate() {
                print("Today")
                
                // self.lblTimeToday.text = Double(value.scoreStatsActualPas.sb).asString(style: .full)
                
                let scoreInt = Int(score.value.score.rounded())
                let scoreStr = String(format: "%@.", String(scoreInt))
                self.lblScore.text = scoreStr
                
                
                //self.showAlert(message: "\(scoreStr.description)\n Aktivo-\(score.key.getSimpleDate()) MB- \(Date().getSimpleDate())")
                
                //self.showAlert(message: resultsSorted.description)
                
                _dynamicValue = scoreInt
                
                if scoreInt >= 80 {
                    self.lblLifestyle.text = "Fantastic! You've achieved a healthy balance in your lifestyle."
                }
                else if scoreInt >= 75 && scoreInt <= 79 {
                    self.lblLifestyle.text = "Solid effort! A slight change to your physical activities is needed."
                }
                else if scoreInt >= 70 && scoreInt <= 74 {
                    self.lblLifestyle.text = "Your lifestyle is mildly imbalanced. Let's be more active!"
                }
                else if scoreInt >= 65 && scoreInt <= 69 {
                    self.lblLifestyle.text = "There's room for improvement. Your physical lifestyle is moderately imbalanced."
                }
                else if scoreInt >= 60 && scoreInt <= 64 {
                    self.lblLifestyle.text = "Reconsider your daily physical activities. Your lifestyle may pose a moderate health risk."
                }
                else {
                    self.lblLifestyle.text = "Make a change! Your physical lifestyle may pose a significant health risk."
                }
                
                
                
                lblCount.text = "0."
                
                DispatchQueue.main.async {
                    self.gifLoaderView.isHidden = true
                }
                aktivoTodaysScoreObj = value
                
                
                startAnimation()
            }
            else {
                print("Yesterday")
                
            }
            
        }
        
        if self.dailyScoreData.count == 0 {
            self.lblLifestyle.text = "MyBenefits360 unable to fetch your daily score. Please try again."
        }
        
        showTableView()
        
    }
    
    //MARK:- XYZ
    public func setsedentary() {
        let resultsSorted = self.dailyScoreData.sorted(by: { ($0.key) < ($1.key)})
        // var countValue = 0
        setWhiteButton(btn: viewSedentary, lbl: lblSedentary)
        
        setBlackButton(btn: viewExcercise, lbl: lblExcercise)
        setBlackButton(btn: viewSleep, lbl: lblSleepMiddle)
        setBlackButton(btn: viewLightActivity, lbl: lblLightActivity)
        selectedButton = 1
        setImages(id: 1)
        
        self.lblStatusToday.text = "Sedentary Time Today"
        self.lblLeftSideChange.text = "Sedentary Time \nYesterday"
        
        for score in resultsSorted { //BAR
            var value = score.value
            
            
            if score.key.getSimpleDate() == Date().getSimpleDate() {
                print("Today")
                
                // self.lblTimeToday.text = Double(value.scoreStatsActualPas.sb).asString(style: .full)
                
                self.lblTimeToday.text = getMin(seconds: Double(value.scoreStatsActualPas.sb))
                //                let scoreInt = Int(score.value.score.rounded())
                
            }
            else {
                print("Yesterday")
                //self.lblTimeYesterday.text = Double(value.scoreStatsActualPas.sb).asString(style: .full)
                self.lblTimeYesterday.text = getMin(seconds:Double(value.scoreStatsActualPas.sb))
                
                self.lblNegative.text = score.value.scoreStatsImpact.sbImpact.rawValue.capitalizingFirstLetter()
                
                if score.value.scoreStatsImpact.sbImpact.rawValue.lowercased() == "negative" {
                    self.imgPositive.image = UIImage(named: "negativearrrow40x40")
                }
                else {
                    self.imgPositive.image = UIImage(named: "positivearrrow20x20")
                }
            }
            
        }
        
        if self.dailyScoreData.count == 0 {
            self.lblTimeToday.text = getMin(seconds: Double(0))
            self.lblTimeYesterday.text = getMin(seconds: Double(0))
        }
        
    }
    /*
     public func setsedentaryOnTap() {
     let resultsSorted = self.dailyScoreData.sorted(by: { ($0.key) < ($1.key)})
     // var countValue = 0
     
     for score in resultsSorted { //BAR
     var value = score.value
     
     if score.key.getSimpleDate() == Date().yesterdayDate.getSimpleDate() {
     print("Today")
     
     self.lblTimeToday.text = Double(value.scoreStatsActualPas.sb).asString(style: .full)
     
     let scoreInt = Int(score.value.score.rounded())
     let scoreStr = String(format: "%@.", String(scoreInt))
     self.lblScore.text = scoreStr
     
     // _dynamicValue = scoreInt
     
     if scoreInt >= 80 {
     self.lblLifestyle.text = "Fantastic! You've achieved a healthy balance in your lifestyle."
     }
     else if scoreInt >= 75 && scoreInt <= 79 {
     self.lblLifestyle.text = "Solid effort! A slight change to your physical activities is needed."
     }
     else if scoreInt >= 70 && scoreInt <= 74 {
     self.lblLifestyle.text = "Your lifestyle is mildly imbalanced. Let's be more active!"
     }
     else if scoreInt >= 65 && scoreInt <= 69 {
     self.lblLifestyle.text = "There's room for improvement. Your physical lifestyle is moderately imbalanced."
     }
     else if scoreInt >= 60 && scoreInt <= 64 {
     self.lblLifestyle.text = "Reconsider your daily physical activities. Your lifestyle may pose a moderate health risk."
     }
     else {
     self.lblLifestyle.text = "Make a change! Your physical lifestyle may pose a significant health risk."
     }
     
     
     }
     else {
     print("Yesterday")
     self.lblTimeYesterday.text = Double(value.scoreStatsActualPas.sb).asString(style: .full)
     self.lblNegative.text = score.value.scoreStatsImpact.sbImpact.rawValue.capitalizingFirstLetter()
     
     if score.value.scoreStatsImpact.sbImpact.rawValue.lowercased() == "negative" {
     self.imgPositive.image = UIImage(named: "negativearrrow40x40")
     }
     else {
     self.imgPositive.image = UIImage(named: "positivearrrow20x20")
     }
     }
     
     }
     }
     */
    
    func showTableView() {
        // if isSleep == true && isScore == true && isStep == true {
        DispatchQueue.main.async {
            self.tableView.isUserInteractionEnabled = true
        }
        
        allHide = false
        
        isSleep = false
        isScore = false
        isStep = false
        self.tableView.reloadData()
        
        // }
    }
    
    //MARK:- Animation code start
    // Double Circle Progress
    func startAnimation() {
        // lblCount.text = "0."
        displayedScore = 0
        
        
        KKrange = Double((180 * _dynamicValue) / 100)
        scoreTimer.invalidate()
        runTimer()
        
        // DispatchQueue.main.async {
        //self.gifLoaderView.isHidden = true
        // }
        
        circleProgressfirst.animate(toAngle: 0.0, duration: 3.0, completion: nil)
        circleProgresssecond.animate(toAngle: 0.0, duration: 3.0, completion: nil)
    }
    
    func runTimer() {
        self.hidePleaseWait()
        scoreTimer = Timer.scheduledTimer(timeInterval: TimeInterval(5.5 / KKrange), target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if displayedScore >= _dynamicValue {
            scoreTimer.invalidate()
        } else {
            displayedScore += 1
            self.lblCount.text = "\(displayedScore)."
        }
    }
    
    
    //End Animation
    
    private func setExcercise() {
        let resultsSorted = self.dailyScoreData.sorted(by: { ($0.key) < ($1.key)})
        
        for score in resultsSorted { //BAR
            let value = score.value
            
            if score.key.getSimpleDate() == Date().getSimpleDate() {
                print("Today")
                
                //self.lblTimeToday.text = Double(value.scoreStatsActualPas.mpa).asString(style: .full)
                
                self.lblTimeToday.text = getMin(seconds: Double(value.scoreStatsActualPas.mpa))
            }
            else {
                print("Yesterday")
                //self.lblTimeYesterday.text = Double(value.scoreStatsActualPas.mpa).asString(style: .full)
                self.lblTimeYesterday.text = getMin(seconds: Double(value.scoreStatsActualPas.mpa))
                
                self.lblNegative.text =  score.value.scoreStatsImpact.mvpaImpact.rawValue.capitalizingFirstLetter()
                
                if score.value.scoreStatsImpact.mvpaImpact.rawValue.lowercased() == "negative" {
                    self.imgPositive.image = UIImage(named: "negativearrrow40x40")
                }
                else {
                    self.imgPositive.image = UIImage(named: "positivearrrow20x20")
                }
            }
            
        }
        
        if self.dailyScoreData.count == 0 {
            self.lblTimeToday.text = getMin(seconds: Double(0))
            self.lblTimeYesterday.text = getMin(seconds: Double(0))
        }
    }
    
    private func setLightActivity() {
        let resultsSorted = self.dailyScoreData.sorted(by: { ($0.key) < ($1.key)})
        
        for score in resultsSorted { //BAR
            let value = score.value
            
            if score.key.getSimpleDate() == Date().getSimpleDate() {
                print("Today")
                
                // self.lblTimeToday.text = Double(value.scoreStatsActualPas.lipa).asString(style: .full)
                
                self.lblTimeToday.text = getMin(seconds: Double(value.scoreStatsActualPas.lipa))
            }
            else {
                print("Yesterday")
                //self.lblTimeYesterday.text = Double(value.scoreStatsActualPas.lipa).asString(style: .full)
                
                self.lblTimeYesterday.text = getMin(seconds: Double(value.scoreStatsActualPas.lipa))
                
                self.lblNegative.text = score.value.scoreStatsImpact.lipaImpact.rawValue.capitalizingFirstLetter()
                
                if score.value.scoreStatsImpact.lipaImpact.rawValue.lowercased() == "negative" {
                    self.imgPositive.image = UIImage(named: "negativearrrow40x40")
                }
                else {
                    self.imgPositive.image = UIImage(named: "positivearrrow20x20")
                }
            }
            
        }
        
        if self.dailyScoreData.count == 0 {
            self.lblTimeToday.text = getMin(seconds: Double(0))
            self.lblTimeYesterday.text = getMin(seconds: Double(0))
        }
    }
    
    private func setSleepData() {
        
        let resultsSorted = self.dailySleepData.sorted(by: { ($0.key) < ($1.key)})
        
        
        for score in resultsSorted { //BAR
            //var key = score.key
            // var value = score.value
            
            if score.key.getSimpleDate() == Date().getSimpleDate() {
                print("Today")
                //self.lblTimeToday.text = Double(score.value.statTotal.timeInBed).asString(style: .full)
                self.lblTimeToday.text = getMin(seconds: Double(score.value.statTotal.timeInBed))
                print(Double(score.value.statTotal.timeInBed).asString(style: .full))
                let sleepOfYesterday = getMin(seconds: Double(score.value.statTotal.timeInBed))
                
                let tempStr = String(format: "You slept for %@ last night. Adequate sleep is essential for a healthy lifestyle. Tap here to check your weekly average.", sleepOfYesterday)
                
                let sleepStr = attributedText(withString: tempStr, boldString: "Tap here to check your weekly average.", font: UIFont(name: "Poppins-Regular", size: 15.0)!)
                self.lblSleep.attributedText = sleepStr
                
                //  aktivoTodaysSleepObj = score.value
                
                if resultsSorted.count == 1 {
                    self.lblTimeYesterday.text = "0 minutes"
                    self.imgPositive.image = UIImage(named: "negativearrrow40x40")
                    self.lblNegative.text = "Negative"
                }
                
            }
            else {
                print("Yesterday")
                //let sleepOfYesterday = Double(score.value.statTotal.timeInBed).asString(style: .full)
                
                let sleepOfYesterday = getMin(seconds: Double(score.value.statTotal.timeInBed))
                
                self.lblTimeYesterday.text = sleepOfYesterday
                self.lblNegative.text = score.value.impact.rawValue.capitalizingFirstLetter()
                
                
                
                if score.value.impact.rawValue.lowercased() == "negative" {
                    self.imgPositive.image = UIImage(named: "negativearrrow40x40")
                }
                else {
                    self.imgPositive.image = UIImage(named: "positivearrrow20x20")
                }
            }
            
        }
        
        if resultsSorted.count == 0 {
            self.lblTimeYesterday.text = getMin(seconds: Double(0))
            self.lblTimeToday.text = getMin(seconds: Double(0))
        }
    }
    
    public func setTodaySleepLabel() {
        
        let resultsSorted = self.dailySleepData.sorted(by: { ($0.key) < ($1.key)})
        
        
        for score in resultsSorted { //BAR
            
            if score.key.getSimpleDate() == Date().getSimpleDate() {
                print("Today")
                
                // let sleepOfYesterday = Double(score.value.statTotal.timeInBed).asString(style: .full)
                let sleepOfYesterday = getMin(seconds: Double(score.value.statTotal.timeInBed))
                
                let tempStr = String(format: "You slept for %@ last night. Adequate sleep is essential for a healthy lifestyle. Tap here to check your weekly average.", sleepOfYesterday)
                
                let sleepStr = attributedText(withString: tempStr, boldString: "Tap here to check your weekly average.", font: UIFont(name: "Poppins-Regular", size: 15.0)!)
                self.lblSleep.attributedText = sleepStr
                
                aktivoTodaysSleepObj = score.value
                
                
            }
            else {
                print("Yesterday")
                
            }
            
        } //for
        
        self.showTableView()
    }
    
    //MARK:- Empty Message
    func setNoSleepData() {
        self.lblSleep.text = "MyBenefits360 was unable to fetch your sleep data. Swipe down to refresh."
        
    }
    
    func setNoStepData() {
        self.lblSteps.text = "MyBenefits360 was unable to fetch your step data. Swipe down to refresh."
    }
    
    
    
    
    private func setBlackButton(btn:UIView,lbl:UILabel) {
        btn.backgroundColor = UIColor.black
        //btn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        lbl.textColor = UIColor.white
        //lbl.text = "SEDENTARY"
        
        
        
    }
    
    //MARK:- White
    private func setWhiteButton(btn:UIView,lbl:UILabel) {
        //        btn.backgroundColor = UIColor.red
        //        btn.layer.borderWidth = 1.0
        //        btn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //        btn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        //
        //        btnSedentary.tintColor = UIColor.white
        //        btnLightActivity.tintColor = UIColor.white
        //        btnExercise.tintColor = UIColor.white
        //        btnSleep.tintColor = UIColor.white
        //        btn.tintColor = UIColor.black
        
        btn.backgroundColor = UIColor.white
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        // btn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
        
        
        lblSedentary.textColor = UIColor.white
        lblSleepMiddle.textColor = UIColor.white
        lblLightActivity.textColor = UIColor.white
        lblExcercise.textColor = UIColor.white
        
        lbl.textColor = UIColor.black
        
        
    }
    
    
    
    
    private func changeImageOnTapp(imgName:String) {
        let origImage = UIImage(named: imgName)
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        imgChangeMiddle.image = tintedImage
        
        //btnMiddle.setImage(tintedImage, for: .normal)
        //btnMiddle.tintColor = UIColor.black
        imgChangeMiddle.tintColor = .black
        imgChangeMiddle.backgroundColor = UIColor.white
    }
    
    //*********************************************************
    //MARK:- Change Dashboard Methods
    func changeDashboardTapped(dashboard: Int) {
        switch dashboard {
        case 0:
            print("Move to Insurance")
            // isRemoveFlag = 1
            //           menuButtonF.removeFromSuperview()
            /*
             if isFromInsurance == 1 {
             self.dismiss(animated: true, completion: {
             })
             }
             else {
             //present Insurance
             setupInsurance()
             
             }
             */
            
            setupInsurance()
            
            break
            
        case 1:
            print("Move to Wellness")
            if isFromInsurance == 0 {
                self.dismiss(animated: true, completion: {
                })
            }
            else {
                //present Wellness
                setupWellnessTabbar()
            }
            
            break
        case 2:
            // print("Move to Fitness")
            
            
            break
            
        default:
            break
        }
    }
    
    //MARK:- Wellness Tabbar setup
    private func setupWellnessTabbar() {}
    //    {
    //
    //        let tabBarController = UITabBarController()
    //
    //        let tabViewController1 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"TempVC") as! TempVC
    //
    //        let tabViewController2 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"TempVC") as! TempVC
    //
    //
    //        // tabViewController1.isAddMember = 1
    //
    //        //let tabViewController2 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"ProfileViewForWellness") as! ProfileViewForWellness
    //
    //
    //
    //        let tabViewController3 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"DashboardRootViewController") as! DashboardRootViewController
    //        tabViewController3.fromInsurance = 0
    //
    //        //let tabViewController4 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"ProfileViewForWellness") as! ProfileViewForWellness
    //
    //
    //        let tabViewController4 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"TempVC") as! TempVC
    //
    //        let tabViewController5 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"TempVC") as! TempVC
    //
    //
    //        // let tabViewController5 = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"ProfileViewForWellness") as! ProfileViewForWellness
    //
    //
    //        let nav1:UINavigationController = UINavigationController.init(rootViewController: tabViewController1)
    //        let nav2:UINavigationController = UINavigationController.init(rootViewController: tabViewController2)
    //        let nav3:UINavigationController = UINavigationController.init(rootViewController: tabViewController3)
    //        let nav4:UINavigationController = UINavigationController.init(rootViewController: tabViewController4)
    //        let nav5:UINavigationController = UINavigationController.init(rootViewController: tabViewController5)
    //
    //
    //        let controllers : NSArray = [nav1,nav2,nav3,nav4,nav5]
    //
    //        tabBarController.viewControllers = controllers as? [UIViewController]
    //
    //        nav1.tabBarItem = UITabBarItem(
    //            title: "Add Member",
    //            image: UIImage(named: "adduser"),
    //            tag: 1)
    //
    //        nav2.tabBarItem = UITabBarItem(
    //            title: "History",
    //            image:UIImage(named: "history") ,
    //            tag:2)
    //        nav3.tabBarItem = UITabBarItem(
    //            title: "",
    //            image: UIImage(named: ""),
    //            tag: 1)
    //        nav4.tabBarItem = UITabBarItem(
    //            title: "Appointments",
    //            image:UIImage(named: "appointment") ,
    //            tag:2)
    //        nav5.tabBarItem = UITabBarItem(
    //            title: "Profile",
    //            image:UIImage(named: "profile-1") ,
    //            tag:2)
    //        tabBarController.selectedIndex=2
    //
    //        //Set Bar tint color white
    //        tabBarController.tabBar.barTintColor = Color.tabBarBottomColor.value
    //
    //        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
    //
    //        let colorSelected = Color.buttonBackgroundGreen.value
    //        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colorSelected ], for: .selected)
    //
    //        tabBarController.view.backgroundColor = UIColor.white
    //
    //        tabBarController.tabBar.tintColor = colorSelected
    //        tabBarController.tabBar.unselectedItemTintColor = UIColor.lightGray
    //
    //        //Set Tab bar border color
    //        //tabBarController.tabBar.layer.borderColor = UIColor.lightGray.cgColor
    //        tabBarController.tabBar.layer.borderWidth = 0.5
    //        tabBarController.tabBar.layer.borderColor =  #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
    //        tabBarController.tabBar.clipsToBounds = true
    //        tabBarController.tabBar.isHidden = false
    //        tabBarController.tabBar.isUserInteractionEnabled = false
    //
    //        //tabBarController.modalTransitionStyle = .crossDissolve
    //        tabBarController.modalPresentationStyle = .fullScreen
    //        self.present(tabBarController, animated: true)
    //    }
    
    
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
        
        //menuButton.isHidden = true
        isRemoveFlag = 0
        
        tabBarController.tabBar.barTintColor = Color.tabBarBottomColor.value
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        
        let colorSelected = hexStringToUIColor(hex: hightlightColor)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colorSelected ], for: .selected)
        
        tabBarController.view.backgroundColor = UIColor.white
        
        tabBarController.tabBar.tintColor = hexStringToUIColor(hex: hightlightColor)
        tabBarController.tabBar.unselectedItemTintColor = UIColor.lightGray
        
        tabBarController.modalPresentationStyle = .fullScreen
        
        
        navigationController?.present(tabBarController, animated: true, completion: nil)
        tabBarController.selectedIndex=2
        
        
    }
    
    
    
    
    //MARK:- Setup Middle Button
    private func setupMiddleButton()
    {
        
        menuButtonF = UIButton(frame: CGRect(x: 0, y: 0, width: 55, height: 55))
        
        var menuButtonFrame = menuButtonF.frame
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
        menuButtonF.frame = menuButtonFrame
        menuButtonF.ShadowForView()
        menuButtonF.layer.masksToBounds=true
        menuButtonF.layer.cornerRadius = menuButtonFrame.height/2
        menuButtonF.backgroundColor = hexStringToUIColor(hex: hightlightColor)
        menuButtonF.setImage(UIImage(named:"Home-2"), for: .normal)
        
        //menuButtonF.setBackgroundImage(UIImage(named: "blueEsclip"), for: .normal)
        menuButtonF.backgroundColor = Color.redTop.value
        
        menuButtonF.contentMode = .scaleAspectFill
        //        menuButtonF.setGradientBackground(colorTop: hexStringToUIColor(hex: "819ff6"), colorBottom: hexStringToUIColor(hex: "4b66ea"))
        menuButtonF.addTarget(self, action: #selector(homeButtonClicked(sender:)), for: .touchUpInside)
        
        
        menuButtonF.layer.borderWidth = 0.7
        menuButtonF.layer.borderColor =  #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
        
        tabBarController?.view.addSubview(menuButtonF)
        //        view.layoutIfNeeded()
        
        
        
    }
    
    @objc private func homeButtonClicked(sender: UIButton)
    {
        tabBarController!.selectedIndex = 2
        //menuButton1.backgroundColor = UIColor.red
        //Change menu button image
        let origImage = UIImage(named:"Home-2")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        menuButtonF.setImage(tintedImage, for: .normal)
        // menuButton1.tintColor = Color.buttonBackgroundGreen.value
        menuButtonF.tintColor = UIColor.white
    }
    
    
    //MARK:- Get Token API's
    //First Call this method
    private func getTokenAPI() {
        print("----Get Token API")
        
        let url = "https://api.aktivolabs.com/oauth/token"
        print(url)
        
        var parameter = [String:String]()
        var isAlreadyOnboarded = false
        
        if let memberId = UserDefaults.standard.value(forKey: "MEMBER_ID") as? String
        {
            isAlreadyOnboarded = true
            parameter = ["client_id":memberId, "client_secret":"47bed95c0f3df643492c5e80eabafa72ef3f3bb5259fbe4fe250b8bf03a26264","grant_type":"client_credentials"]
            
            getMemberIDFromAktivo(parameter: parameter as NSDictionary, url: url, isAlreadyOnboarded: isAlreadyOnboarded)
        }
        else {
            
            getMemberIdFromMBServer()
            
            //isAlreadyOnboarded = false
            //parameter = ["client_id":"semantic","client_secret":"47bed95c0f3df643492c5e80eabafa72ef3f3bb5259fbe4fe250b8bf03a26264","grant_type":"client_credentials","scope":"company:read_write:as_a_client,member:read_write:as_a_client"]
        }
        
        print(parameter)
        
        print(url)
        
    }
    
    func getMemberIDFromAktivo(parameter:NSDictionary,url:String,isAlreadyOnboarded:Bool) {
        ServerRequestManager.serverInstance.postDataToServerWithHeader(url: url, dictionary: parameter as NSDictionary, view: self,headerParam: ["add":"hello"], onComplition: { (response, error) in
            print("GET TOKEN ID \(url)")
            if error == nil {
                
                if let token = response?["access_token"].string {
                    UserDefaults.standard.setValue(token, forKey: "tokenAktivo")
                }
                if let tokenType = response?["token_type"].string {
                    UserDefaults.standard.setValue(tokenType, forKey: "tokenType")
                }
                
                if isAlreadyOnboarded {
                    //Pass member id and fetch data.
                    if let emailID = UserDefaults.standard.value(forKey: "emailid") as? String {
                        self.getUserTokenValueAPI(email: emailID)
                    }
                }
                else {
                    //Move to Onboarding screen
                    self.showOnboardingProfilePage()
                }
            }
            else {
                self.hidePleaseWait()
                self.refreshControl1.endRefreshing()
            }
            
            
        })
        
    }
    
    //MARK:- Show Profile Page
    func showOnboardingProfilePage() {
        let vc = UIStoryboard.init(name: "Fitness", bundle: nil).instantiateViewController(withIdentifier: "LoginFitnessProfile") as! LoginFitnessProfile
        vc.delegateOnboarding = self
        vc.isFromInsurance = isFromInsurance
        let nav1:UINavigationController = UINavigationController.init(rootViewController: vc)
        nav1.modalPresentationStyle = .fullScreen
        self.present(nav1, animated: true, completion: nil)
    }
    
    
    
    func getUserTokenValueAPI(email:String) {
        print("----Get User ID API")
        let dateStrStart = String(format: "01-01-\(String(Date().year))")
        let dateStrStartDate = dateStrStart.getDate()
        
        let dateStrEnd = String(format: "31-12-\(String(Date().year))")
        let dateStrEndDate = dateStrEnd.getDate()
        
        
        let startDate = dateStrStartDate.getSimpleDate()
        let endDate = dateStrEndDate.getSimpleDate()
        
        //leaderboards to *
        guard let memberId = UserDefaults.standard.value(forKey: "MEMBER_ID") as? String else {
            return
        }
        //let strURL = String(format: "https://api.aktivolabs.com/api/users?email=%@&include=*&startDate=%@&endDate=%@",email,startDate,endDate)
        
        
        let strURL = String(format: "https://api.aktivolabs.com/api/users/%@?include=*&startDate=%@&endDate=%@",memberId,startDate,endDate)
        
        
        let url = strURL
        print(url)
        
        let token = UserDefaults.standard.value(forKey: "tokenAktivo") as! String
        let tokenType = UserDefaults.standard.value(forKey: "tokenType") as! String
        
        let tokenStr = String(format: "%@ %@",tokenType,token)
        print(tokenStr)
        
        ServerRequestManager.serverInstance.getDataToServerWithHeaderSecond(url: url, view: self,token: tokenStr, onComplition: { (response, error, rawData) in
            
            print(response)
            
            if let dataDict = response?["data"].dictionary {
                
                if let id = dataDict["_id"]?.string {
                    UserDefaults.standard.setValue(id, forKey: "userAktivoId")
                    
                    self.authenticUser()
                }
            }
            else {
                
                self.hidePleaseWait()
                if let  status = response?["success"].boolValue {
                    if status == false {
                        let msg = response?["message"].stringValue
                        self.displayActivityAlert(title: msg ?? "")
                    }
                }
            }
            
            //  let welcome = try? JSONDecoder().decode(Welcome.self, from: rawData as! Data)
            
            
            
            let userID = UserDefaults.standard.value(forKey: "userAktivoId")
            
            if let embedded = response?["_embedded"].dictionaryValue {
                if let leaderboardsArray = embedded["leaderboards"]?.arrayValue {
                    
                    if leaderboardsArray.count > 0 {
                        
                        for outerObj in leaderboardsArray {
                            if outerObj["title"] == "Aktivo Score® Challenge" && outerObj["challenge_type"] == "Individual" {
                                
                                if let nameDictArray = outerObj["leaderboard"].array
                                {
                                    self.isNamesFound = true
                                    self.nameModelArray.removeAll()
                                    for nameObj in nameDictArray {
                                        //print(nameObj["name"].string)
                                        let obj = LeaderboardModel.init(name: nameObj["name"].string, _id: nameObj["_id"].string, score: nameObj["score"].int, rank: nameObj["rank"].intValue, impact: nameObj["impact"].int)
                                        
                                        print(nameObj["name"].string)
                                        
                                        
                                        self.nameModelArray.append(obj)
                                    
                                    }
                                    
                                    let challengeObj = ChallengesScoreModel.init(_id: outerObj["_id"].string ?? "", title: outerObj["title"].string  ?? "", days: outerObj["days"].string  ?? "", challenge_type: outerObj["challenge_type"].string  ?? "", description: outerObj["description"].string  ?? "", scored_by: outerObj["scored_by"].string  ?? "", category_name: outerObj["category_name"].string  ?? "", target: outerObj["target"].string  ?? "", imageUrl: outerObj["imageUrl"].string  ?? "",  start_date: outerObj["start_date"].string  ?? "", end_date: outerObj["end_date"].string  ?? "", userPosition: outerObj["userPosition"].string  ?? "",numberOfParticipants: outerObj["numberOfParticipants"].int  ?? 0, leaderboardModelArray: self.nameModelArray)
                                    
                                    self.challengesModelObj = challengeObj
                                    
                                    //set Data start
                                    
                                    if self.nameModelArray.count > 0 {
                                        self.nameModelArray.sorted(by: { ($0.rank) < ($1.rank) })
                                        
                                        var i = 1
                                        var isUser = 0
                                        
                                        var userId = UserDefaults.standard.value(forKey: "userAktivoId") as? String
                                        
                                        for obj in self.nameModelArray {
                                            
                                            switch i {
                                            case 1:
                                                self.lblName1.text = obj.name
                                                self.lblScore1.text = (obj.score ?? 0).description
                                                //self.lblRank1.text = String(obj.rank!.description)
                                                
                                                self.setRank(label: self.lblRank1, object: obj)
                                                if userId == obj._id {
                                                    isUser = 1
                                                    self.nameView1.backgroundColor = ConstantContent.sharedInstance.hexStringToUIColor(hex: "C9C9C9")
                                                }
                                                if let impact = obj.impact {
                                                    if impact > 0 {
                                                        self.imgLbl1.text = "▲"
                                                    }
                                                        
                                                    else if impact < 0 {
                                                        self.imgLbl1.text = "▼"
                                                    }
                                                    else {
                                                        self.imgLbl1.text = "-"
                                                    }
                                                }
                                                
                                                
                                                break
                                            case 2:
                                                self.lblName2.text = obj.name
                                                self.lblScore2.text = (obj.score ?? 0).description
                                                //self.lblRank2.text = String(obj.rank!.description)
                                                self.setRank(label: self.lblRank2, object: obj)
                                                
                                                if let impact = obj.impact {
                                                    if impact > 0 {
                                                        self.imgLbl2.text = "▲"
                                                    }
                                                        
                                                    else if impact < 0 {
                                                        self.imgLbl2.text = "▼"
                                                    }
                                                    else {
                                                        self.imgLbl2.text = "-"
                                                    }
                                                }
                                                
                                                if userId == obj._id {
                                                    isUser = 1
                                                    self.nameView2.backgroundColor = ConstantContent.sharedInstance.hexStringToUIColor(hex: "C9C9C9")
                                                }
                                                
                                                break
                                            case 3:
                                                self.lblName3.text = obj.name
                                                self.lblScore3.text = (obj.score ?? 0).description
                                                //self.lblRank3.text = String(obj.rank!.description)
                                                
                                                self.setRank(label: self.lblRank3, object: obj)
                                                
                                                if let impact = obj.impact {
                                                    if impact > 0 {
                                                        self.imgLbl3.text = "▲"
                                                    }
                                                        
                                                    else if impact < 0 {
                                                        self.imgLbl3.text = "▼"
                                                    }
                                                    else {
                                                        self.imgLbl3.text = "-"
                                                    }
                                                }
                                                
                                                if userId == obj._id {
                                                    isUser = 1
                                                    self.nameView3.backgroundColor = ConstantContent.sharedInstance.hexStringToUIColor(hex: "C9C9C9")
                                                    
                                                }
                                                break
                                            case 4 :
                                                
                                                if self.nameModelArray.count >= 4 && isUser == 0 {
                                                    //set User
                                                    let userObj = self.nameModelArray.filter{($0._id == userId)}
                                                    if userObj.count > 0 {
                                                        self.lblName4.text = userObj[0].name
                                                        self.lblScore4.text = (userObj[0].score ?? 0).description
                                                        
                                                        //self.lblRank4.text = String(userObj[0].rank!.description)
                                                        self.setRank(label: self.lblRank4, object: userObj[0])
                                                        
                                                        self.nameView4.backgroundColor = ConstantContent.sharedInstance.hexStringToUIColor(hex: "C9C9C9")
                                                        
                                                        
                                                    }
                                                    else {
                                                        self.lblName4.text = obj.name
                                                        self.lblScore4.text = (obj.score ?? 0).description
                                                        //self.lblRank4.text = String(obj.rank!.description)
                                                        self.setRank(label: self.lblRank4, object: obj)
                                                        
                                                    }
                                                    
                                                }
                                                else {
                                                    
                                                    if isUser == 1 { //if user in 1 to 3 then hide 4th element
                                                        
                                                        //Commented by Pranit 22 July
                                                        //self.nameView4.isHidden = true
                                                        self.lblName4.text = obj.name
                                                        self.lblScore4.text = (obj.score ?? 0).description
                                                        //self.lblRank4.text = String(obj.rank!.description)
                                                        self.setRank(label: self.lblRank4, object: obj)
                                                        
                                                        
                                                        
                                                    }
                                                    else {
                                                        self.lblName4.text = obj.name
                        self.lblScore4.text = (obj.score ?? 0).description
                                                        //self.lblRank4.text = String(obj.rank!.description)
                                                        self.setRank(label: self.lblRank4, object: obj)
                                                    }
                                                }
                                                if let impact = obj.impact {
                                                    if impact > 0 {
                                                        self.imgLbl4.text = "▲"
                                                    }
                                                        
                                                    else if impact < 0 {
                                                        self.imgLbl4.text = "▼"
                                                    }
                                                    else {
                                                        self.imgLbl4.text = "-"
                                                    }
                                                }
                                                
                                                break
                                            default:
                                                break
                                                
                                            }
                                            i += 1
                                            
                                        } //for modelArray
                                        
                                        //To set Height for tableview
                                        self.isNamesFound = true
                                        let indexPathNames = IndexPath(row: 3, section: 0)
                                        self.tableView.reloadRows(at: [indexPathNames], with: .none)
                                        
                                    }
                                    //set data end
                                }
                                
                            }
                        } //for
                    } //.count
                    else { //All leaderboard array is empty
                        self.isNamesFound = false
                        let indexPathNames = IndexPath(row: 3, section: 0)
                        self.tableView.reloadRows(at: [indexPathNames], with: .none)
                    }
                    
                }
                
                //MARK:- Network Array
                if let networkDictionary = embedded["network"]?.dictionaryObject {
                    
                    let avgDict = networkDictionary["average"] as? [String:Any]
                    let percentile10Dict = networkDictionary["percentile10"] as? [String:Int]
                    let percentile90Dict = networkDictionary["percentile90"] as? [String:Int]
                    let tempDict = networkDictionary["average"] as? [String:Int]
                    
                    let stepAVG = avgDict?["steps"] as? Double
                    
                    let avgObj = NetworkStatsScoreModel.init(exercise: avgDict?["exercise"] as? Int, sleep: avgDict?["sleep"] as? Int, score: avgDict?["score"] as? Int, steps: Int(stepAVG ?? 0))
                    
                    let per10Obj = NetworkStatsScoreModel.init(exercise: percentile10Dict?["exercise"], sleep: percentile10Dict?["sleep"] , score: percentile10Dict?["score"] , steps: percentile10Dict?["steps"])
                    
                    let per90Obj = NetworkStatsScoreModel.init(exercise: percentile90Dict?["exercise"], sleep: percentile90Dict?["sleep"] , score: percentile90Dict?["score"] , steps: percentile90Dict?["steps"])
                    
                    networkScoreModelObj = NetworkScoreModel.init(average: avgObj, percentile10: per10Obj, percentile90: per90Obj)
                    
                    
                }
            }
        })
    }
    
    
    private func setRank(label:UILabel,object:LeaderboardModel) {
        //Rank Start
        if let rankInt = object.rank {
            if rankInt <= 9 {
                label.text = String(format: "0%@", object.rank.description)
            }
            else {
                label.text = String(format: "%@", object.rank.description)
            }
        }
        else {
            label.text = String(format: "%@", object.rank.description)
        }
    }
    /*
     private func getRangeDates(weekNo:String) -> (start:Date,end:Date) {
     print(weekNo)
     
     let yearString = String(Date().year)
     let weekOfYearString = weekNo
     
     guard let year = Int(yearString), let weekOfYear = Int(weekOfYearString) else { return (Date(),Date()) }
     let components = DateComponents(weekOfYear: weekOfYear, yearForWeekOfYear: year)
     guard let date = Calendar.current.date(from: components) else {return (Date(),Date()) }
     
     //let df = DateFormatter()
     //df.dateFormat = "dd MMM"
     //let outputDate = df.string(from: date)  //2017-02-19
     
     var dateComponent = DateComponents()
     dateComponent.month = 0
     dateComponent.day = 6
     dateComponent.year = 0
     
     //let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
     //let endDate = df.string(from: futureDate ?? Date())  //2017-02-19
     guard var futureDate = Calendar.current.date(byAdding: dateComponent, to: date) else {return (Date(),Date())}
     
     print(date)
     print(futureDate)
     
     if futureDate > Date() {
     futureDate = Date()
     }
     
     return (date,futureDate)
     
     //        let requestedComponents: Set<Calendar.Component> = [
     //            .year,
     //            .month,
     //            .day
     //        ]
     //
     //        var toDateComponents = Calendar.current.dateComponents(requestedComponents, from: futureDate)
     //        let toDateFinal = Calendar.current.date(from: DateComponents(calendar: Calendar.current, year:toDateComponents.year, month:toDateComponents.month, day:toDateComponents.day))!
     //
     //
     //        return (date,toDateFinal)
     }
     */
    
    //Get Week Start date and End Date from Week No.
    private func getRangeDates(weekNo:String) -> (start:Date,end:Date) {
        print(weekNo)
        
        if weekNo == "1" && Date().month1 == 12 {
            let yearString = (Date().year + 1).description
            
            // let weekOfYearString = weekNo
            
            guard let year = Int(yearString), let weekOfYear = Int(weekNo) else { return (Date(),Date()) }
            let components = DateComponents(weekOfYear: weekOfYear, yearForWeekOfYear: year)
            guard let date = Calendar.current.date(from: components) else {return (Date(),Date()) }
            
            //let df = DateFormatter()
            //df.dateFormat = "dd MMM"
            //let outputDate = df.string(from: date)  //2017-02-19
            
            var dateComponent = DateComponents()
            dateComponent.month = 0
            dateComponent.day = 6
            dateComponent.year = 0
            
            dateComponent.hour = 18
            dateComponent.minute = 30
            dateComponent.second = 0
            
            //let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
            //let endDate = df.string(from: futureDate ?? Date())  //2017-02-19
            guard var futureDate = Calendar.current.date(byAdding: dateComponent, to: date) else {return (Date(),Date())}
            
            
            
            print(date)
            print(futureDate)
            
            if futureDate > Date() {
                futureDate = Date()
            }
            return (date,futureDate)
            
            //            let requestedComponents: Set<Calendar.Component> = [
            //                .year,
            //                .month,
            //                .day
            //            ]
            
            // var toDateComponents = Calendar.current.dateComponents(requestedComponents, from: futureDate)
            // let  toDateFinal = Calendar.current.date(from: DateComponents(calendar: Calendar.current, year:toDateComponents.year, month:toDateComponents.month, day:toDateComponents.day))!
            
        }
        else {
            let yearString = Date().year.description
            
            //let weekOfYearString = weekNo
            
            guard let year = Int(yearString), let weekOfYear = Int(weekNo) else { return (Date(),Date()) }
            let components = DateComponents(weekOfYear: weekOfYear, yearForWeekOfYear: year)
            guard let date = Calendar.current.date(from: components) else {return (Date(),Date()) }
            
            //let df = DateFormatter()
            //df.dateFormat = "dd MMM"
            //let outputDate = df.string(from: date)  //2017-02-19
            
            var dateComponent = DateComponents()
            dateComponent.month = 0
            dateComponent.day = 6
            dateComponent.year = 0
            
            dateComponent.hour = 18
            dateComponent.minute = 30
            dateComponent.second = 0
            
            //let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
            //let endDate = df.string(from: futureDate ?? Date())  //2017-02-19
            guard var futureDate = Calendar.current.date(byAdding: dateComponent, to: date) else {return (Date(),Date())}
            
            
            
            print(date)
            print(futureDate)
            
            if futureDate > Date() {
                futureDate = Date()
            }
            return (date,futureDate)
            
            //            let requestedComponents: Set<Calendar.Component> = [
            //                .year,
            //                .month,
            //                .day
            //            ]
            //
            //            var toDateComponents = Calendar.current.dateComponents(requestedComponents, from: futureDate)
            //            let  toDateFinal = Calendar.current.date(from: DateComponents(calendar: Calendar.current, year:toDateComponents.year, month:toDateComponents.month, day:toDateComponents.day))!
            //
            //            return (date,toDateFinal)
        }
    }
    
    public func setTodayStepLabel() {
        
        print("#-\(#function)")
        
        if dailyStepData.count > 0 {
            let resultsSorted = self.dailyStepData.sorted(by: { ($0.key) < ($1.key)})
            var totalSteps = 0
            for score in resultsSorted { //BAR
                
                totalSteps += Int(score.value.stepCount)
                
            }
            
            print("TOTAL STEPS = \(totalSteps)")
            
            var yesterdayStep = 0
            var todayStep = 0
            var percentage = 0
            
            for score in resultsSorted { //BAR
                
                if score.key.getSimpleDate() == Date().yesterdayDate.getSimpleDate() {
                    print("Yesterday...")
                    yesterdayStep = score.value.stepCount
                }
                else if score.key.getSimpleDate() == Date().getSimpleDate() {
                    print("Today...")
                    aktivoTodaysStepObj = score.value
                    todayStep = score.value.stepCount
                    
                }
                print("Today = \(todayStep)")
                print("Yesterday = \(yesterdayStep)")
                
                
                
                
            } //for
            
            if yesterdayStep > todayStep {
                let diff = yesterdayStep - todayStep
                let temp1:Double = Double(Double(diff * 100) / Double(yesterdayStep))
                
                percentage = Int(temp1.rounded())
                
                //percentage = percentage.rounded(toPlaces: 1)
                
                // percentage = yesterdayStep/todayStep * 100
                
                let stringSteps = attributedText(withString: "Today you have covered \(percentage.description)% less steps than yesterday. That's a total of \(totalSteps.description) steps this week!", boldString: "covered \(percentage.description)% less", font: UIFont(name: "Poppins-Regular", size: 15.0)!)
                self.lblSteps.attributedText = stringSteps
            }
            else {
                
                if yesterdayStep > 0 {
                    let diff = todayStep - yesterdayStep
                    let temp1:Double = Double(Double(diff * 100) / Double(yesterdayStep))
                    
                    percentage = Int(temp1.rounded())
                    
                    // percentage = percentage.rounded(toPlaces: 1)
                    
                    // percentage = todayStep/yesterdayStep * 100
                    
                    let stringSteps = attributedText(withString: "Today you have covered \(percentage.description)% more steps than yesterday. That's a total of \(totalSteps.description) steps this week!", boldString: "covered \(percentage.description)% more", font: UIFont(name: "Poppins-Regular", size: 15.0)!)
                    self.lblSteps.attributedText = stringSteps
                }
                else { //if yesterday steps is 0 then avoid crash on devide by zero show msg
                    let stringSteps = attributedText(withString: "Today you have covered 100% more steps than yesterday. That's a total of \(totalSteps.description) steps this week!", boldString: "covered 100% more", font: UIFont(name: "Poppins-Regular", size: 15.0)!)
                    self.lblSteps.attributedText = stringSteps
                    
                }
            }
            
            if dailyStepData.count == 0 {
                self.lblSteps.text = "Aktivo not able to fetch your data."
            }
            
        }//if
        print("ENDED....")
        self.hidePleaseWait()
        refreshControl1.endRefreshing()
        
        self.showTableView()
        
    }
    
    
}


extension UITabBar{
    func inActiveTintColor() {
        if let items = items{
            for item in items{
                item.image =  item.image?.withRenderingMode(.alwaysOriginal)
                item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.lightGray], for: .normal)
                item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : Color.redBottom.value], for: .selected)
            }
        }
    }
    
    func inActiveTintColorRed() {
        if let items = items{
            for item in items{
                item.image =  item.image?.withRenderingMode(.automatic)
                item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.lightGray], for: .normal)
                item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : Color.redBottom.value], for: .selected)
            }
        }
    }
    
    func inActiveTintColorGreen() {
        if let items = items{
            for item in items{
                item.image =  item.image?.withRenderingMode(.automatic)
                item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.lightGray], for: .normal)
                item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : Color.buttonBackgroundGreen.value], for: .selected)
            }
        }
    }
}

extension Date {
    
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
}
extension Date {
    
    func components(_ components: Set<Calendar.Component>) -> DateComponents {
        return Calendar.current.dateComponents(components, from: self)
    }
    
    func component(_ component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
    
    var era: Int { return component(.era) }
    var year: Int { return component(.year) }
    var monthC: Int { return component(.month) }
    var day: Int { return component(.day) }
    var hour: Int { return component(.hour) }
    var minute: Int { return component(.minute) }
    var second: Int { return component(.second) }
    var weekday: Int { return component(.weekday) }
    var weekdayOrdinal: Int { return component(.weekdayOrdinal) }
    var quarter: Int { return component(.quarter) }
    var weekOfMonth: Int { return component(.weekOfMonth) }
    var weekOfYear: Int { return component(.weekOfYear) }
    var yearForWeekOfYear: Int { return component(.yearForWeekOfYear) }
    var nanosecond: Int { return component(.nanosecond) }
    var calendar: Calendar? { return components([.calendar]).calendar }
    var timeZone: TimeZone? { return components([.timeZone]).timeZone }
    
}


extension Date {
    struct Formatter {
        static let utcFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            
            return dateFormatter
        }()
    }
    
    var dateToUTC: String {
        return Formatter.utcFormatter.string(from: self)
    }
}

extension String {
    struct Formatter {
        static let utcFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
            //dateFormatter.timeZone = TimeZone(identifier: "UTC+05:30")
            dateFormatter.timeZone = TimeZone(identifier: "IST")
            
            return dateFormatter
        }()
    }
    
    var dateFromUTC: Date? {
        return Formatter.utcFormatter.date(from: self)
    }
}


extension UIViewController {
    
    func showFitnessLoader(msg:String, type:Int) {
        
        
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            //hud.label.text = msg
            
            switch type {
            case 1:
                hud.bezelView.color = UIColor.white
                hud.bezelView.backgroundColor = UIColor.white //small box white
                hud.backgroundColor = UIColor.white //complete page make white
                hud.bezelView.layer.cornerRadius = 0
                break
            case 2:
                hud.backgroundColor = UIColor.clear
                hud.bezelView.backgroundColor = UIColor.clear
                hud.bezelView.color = UIColor.clear
                hud.bezelView.style = .solidColor
                // hud.backgroundView.color = UIColor.clear
                break
            default:
                break
            }
            
            hud.show(animated: true)
        }
    }
}
