//
//  AppDelegate.swift
//  MyBenefits
//
//  Created by Semantic on 11/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
import CoreData
//import FlexibleSteppedProgressBar
import GoogleMaps
import GooglePlaces
import FirebaseCrashlytics
import Firebase
import Fabric
import UserNotifications
import FirebaseMessaging
import AktivoCoreSDK
import BackgroundTasks
import FirebaseCore
import EncryptedCoreData
import IOSSecuritySuite

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,UITabBarDelegate,UITabBarControllerDelegate,MessagingDelegate,UNUserNotificationCenterDelegate{

    var window: UIWindow?
    var navigationController:UINavigationController?=nil;
    internal var shouldRotate = false
   
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        FirebaseApp.configure()

        Fabric.sharedSDK().debug = true
        //Fabric.with([Crashlytics.self])
        print("Crashlytics version: \(FirebaseCrashlyticsVersionNumber)")

        if #available(iOS 13.0, *) {
            registerBackgroundTaks()
        } else {
            // Fallback on earlier versions
        }

        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
                self?.getUserToken()
            }
        
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.checkjailbrokenDevice()
            }
        
    //Aktivo Configure
            DispatchQueue.main.async {
                
        
            
            
            print("#AKTIVO##")
                    Aktivo.configure(evn: "debug") { (error) in
                    // Check for error
                    guard let error1 = error else {
                    // No error found
                    // Success block
                       UserDefaults.standard.set(true, forKey: "aktivo")

                    print("Successfully integarted Aktivo SDK")
              
                    
                    return
                    }
                    
    //                    if let errorNew = error as? AktivoCoreError {
    //                        print("New Error..")
    //                        print(errorNew)
    //                    }
                        
                       UserDefaults.standard.set(false, forKey: "aktivo")
                    switch error {

                    case .configFileNotFound(let desc):
                    print("configFileNotFound")
                    print(desc)
                    break
                    case .configFilePathEmpty(let desc):
                    print(desc)
                    print("configFilePathEmpty")
                    
                    break
                    // Handle other cases as per your logic
                    default:
                    print("Faced unknown error while configuration")
                    //print(error)
                    break
                    }
                    }
            }
                   //end

        
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
        
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        
        GMSServices.provideAPIKey("AIzaSyAUzPSBZaV7zH9kkW-alDkSnA6-TlS4t4s")
        GMSPlacesClient.provideAPIKey("AIzaSyAUzPSBZaV7zH9kkW-alDkSnA6-TlS4t4s")
        
        
       
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
        
        
        nav1.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        nav2.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        nav3.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        nav4.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        nav5.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)

        
        //tabBarController
        
        
        let status=UserDefaults.standard.object(forKey: "isAlreadylogin") as? Bool
        if(status==true) //If user logged In
        {
            //let rootView: HomePageViewController = HomePageViewController()
           // navigationController=UINavigationController (rootViewController: rootView)
            
           
            if let window = self.window
            {
                if #available(iOS 13.0, *) {
                    window.overrideUserInterfaceStyle = .light
                }

                window.rootViewController = tabBarController
               tabBarController.selectedIndex=2
                
//                m_progressBar = FlexibleSteppedProgressBar()
            }
            
            
        }
        else
        { //if user not Logged in or logout
//            let leftSideMenuNav = UINavigationController(rootViewController: leftSideView)
//
//            drawerContainer = MMDrawerController(center: tabBarController, leftDrawerViewController: leftSideMenuNav)
//            drawerContainer?.openDrawerGestureModeMask=MMOpenDrawerGestureMode.panningCenterView
//            drawerContainer?.closeDrawerGestureModeMask=MMCloseDrawerGestureMode.panningCenterView
            
            if UserDefaults.standard.value(forKey: "firstTimeInstall") != nil {
                //let rootView: LoginViewController = LoginViewController()
                let rootView: LoginViewController_New = LoginViewController_New()
                
                navigationController=UINavigationController (rootViewController: rootView)
                if let window = self.window
                {
                    if #available(iOS 13.0, *) {
                        window.overrideUserInterfaceStyle = .light
                    }
                    window.rootViewController = navigationController
                }
            }
            else{
                let enrollView: PageMenuViewController = PageMenuViewController()
                navigationController=UINavigationController (rootViewController: enrollView)
                if let window = self.window
                {
                    if #available(iOS 13.0, *) {
                        window.overrideUserInterfaceStyle = .light
                    }
                    window.rootViewController = navigationController
                }
            }
            
        }
        
        print("Device Token:")
        //Push Notification
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self as MessagingDelegate
        }
        else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
       
                let container = NSPersistentContainer(name: "MyBenefits")
                do {
                    let options: [AnyHashable: Any] = [
                        NSPersistentStoreFileProtectionKey: FileProtectionType.complete,
                        EncryptedStorePassphraseKey: "123456"
                    ]
                    let store = try container.persistentStoreCoordinator.addPersistentStore(ofType: EncryptedStoreType, configurationName: nil, at: container.persistentStoreDescriptions[0].url, options: options)
                } catch {
                    print("Core data not encrypted \(error.localizedDescription)")
                }
        
       
        
        
        

        
        return true
    }
    
    @available(iOS 13.0, *)
   //MARK: Regiater BackGround Tasks
   private func registerBackgroundTaks() {
       
       BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.SO.imagefetcher", using: nil) { task in
           //This task is cast with processing request (BGProcessingTask)
           //self.scheduleLocalNotification()
           self.handleImageFetcherTask(task: task as! BGProcessingTask)
       }
       
       BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.SO.apprefresh", using: nil) { task in
           //This task is cast with processing request (BGAppRefreshTask)
         //  self.scheduleLocalNotification()
           self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
       }
   }
    
    @available(iOS 13.0, *)
    func cancelAllPandingBGTask() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }
    
    @available(iOS 13.0, *)
    func scheduleAppRefresh() {
        print("$$$$$$$$$$$$$$$$scheduleAppRefresh")
        let request = BGAppRefreshTaskRequest(identifier: "com.SO.apprefresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 2 * 60) // App Refresh after 2 minute.
        //Note :: EarliestBeginDate should not be set to too far into the future.
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    @available(iOS 13.0, *)
    func scheduleImageFetcher() {
           let request = BGProcessingTaskRequest(identifier: "com.SO.imagefetcher")
           request.requiresNetworkConnectivity = true // Need to true if your task need to network process. Defaults to false.
           request.requiresExternalPower = false
           
           request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60) // Featch Image Count after 1 minute.
           //Note :: EarliestBeginDate should not be set to too far into the future.
           do {
               try BGTaskScheduler.shared.submit(request)
           } catch {
               print("Could not schedule image featch: \(error)")
           }
       }
    
    
    @available(iOS 13.0, *)
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        //Todo Work
        /*
         //AppRefresh Process
         */
        print("&&&&&&&&&&&&&&&&=handleAppRefreshTask")
       // scheduleLocalNotification()
        
        
        task.expirationHandler = {
            //This Block call by System
            //Canle your all tak's & queues
        }
       // scheduleLocalNotification()
        //
        task.setTaskCompleted(success: true)
    }
    
    @available(iOS 13.0, *)
    func handleImageFetcherTask(task: BGProcessingTask) {
        scheduleImageFetcher() // Recall
        
        //Todo Work
        task.expirationHandler = {
            //This Block call by System
            //Canle your all tak's & queues
        }
        
        
        if let logInStatus = UserDefaults.standard.value(forKey: "isAlreadylogin") as? Bool {
            if logInStatus == true {
                EnrollmentServerRequestManager.serverInstance.getBGGHITopUpOptionsFromServer()
            }
        }
     
        task.setTaskCompleted(success: true)
        
    }
    
    func scheduleLocalNotification() {
        // Swift
      
    }
    
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
      return  UIInterfaceOrientationMask.portrait
        return shouldRotate ? .allButUpsideDown : .portrait
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        if(tabBarController.selectedIndex==1)
        {
            print("E-Card")
            tabBarController.selectedIndex=2
        }
        else if(tabBarController.selectedIndex==4)
        {
            tabBarController.selectedIndex=4
//            let transition:CATransition = CATransition()
//            transition.duration = 0.5
//            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//            transition.type = kCATransitionPush
//            transition.subtype = kCATransitionFromBottom
//            self.navigationController!.view.layer.add(transition, forKey: kCATransition)
//            self.navigationController?.pushViewController(dstVC, animated: false)
        }
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool
    {
        if(tabBarController.selectedIndex==1)
        {
            print("E-Card")
        }
        return true
    }
    
    //PN Start
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String!) {
        print("FCM")
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        UserDefaults.standard.set(fcmToken, forKey: "token")
        
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 1. Print out error if PNs registration not successful
        print("Failed to register for remote notifications with error: \(error)")
    }
    
    //MARK: - Delegates for Notifications
    //This method is called when user respond to notification either tap on notification, or tap on action buttons.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Background and closed app  push notifications handler
        
        let action = response.actionIdentifier
        let request = response.notification.request
        let content = request.content
        
        
        print("Action=\(action)")
        print("Request=\(request)")
        print("Content=\(content)")
        
        
        completionHandler()
    }
    
    //MARK:- Set Local Notification...
    func setLocalNotifications(onDate:Date) {
        // Swift
        print("Date Array-")
        print(onDate)
        
        //Initialize notification
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: ["HCAppointmentLocalNotification"])
        center.removePendingNotificationRequests(withIdentifiers: ["HCAppointmentLocalNotification"])

         
        let date = onDate.getDateStrdd_mmm_yy()

        let content = UNMutableNotificationContent()
        content.title = "Health Checkup"
        content.body = "Your Health Checkup scheduled on \(date)."
        content.sound = UNNotificationSound.default()

        
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
        
       // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
                let gregorian = Calendar(identifier: .gregorian)

                var dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: onDate)
                dateComponents.hour = 19
                dateComponents.minute = 20
                dateComponents.second = 0
                
                let identifier = "HCAppointmentLocalNotification"
                print(dateComponents)
                
                
                let datepp = gregorian.date(from: dateComponents)!

                let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: datepp)

                let trigger =  UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: false)
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

                

       // let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
                // Something went wrong
            }
        })
    
    }
    
    
    //Added on 23rd June
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("got silent notification....")
        // Perform background operation
        
        if let valueDate = userInfo["date"] as? String {
           print(valueDate) // output: "some-value"
            if valueDate != "" {
                print("Final Date...")
                print(valueDate.getDatefromddMMyyyy())
                let finalDate = valueDate.getDatefromddMMyyyy()
                setLocalNotifications(onDate: finalDate)
            }
            
        }
        
        // Inform the system after the background operation is completed.
        completionHandler(.newData)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void)
    {
        //Handle the notification
        completionHandler(
            [UNNotificationPresentationOptions.alert,
             UNNotificationPresentationOptions.sound,
             UNNotificationPresentationOptions.badge])
    }
    
    // This method will be called when app received push notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        print("Notification Received...!!")
        print(notification.request.content.userInfo)
        
        completionHandler([.alert, .badge, .sound])
    }
    //PN END
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
       // cancelAllPandingBGTask()
        //timer?.invalidate()
        if #available(iOS 13.0, *) {
            cancelAllPandingBGTask()
            scheduleAppRefresh()
            scheduleImageFetcher()
            
        } else {
            // Fallback on earlier versions
        }
       // scheduleImageFetcher()

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //timer?.fire()
        isFromforeground = false
        checkjailbrokenDevice()
    }
    
    func checkjailbrokenDevice(){
        if IOSSecuritySuite.amIJailbroken() {
            print("This device is jailbroken")
            isJailbrokenDevice = true
            UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                   to: UIApplication.shared, for: nil)
            fatalError()
            //self.showalertforJailbreakDevice("This device is jailbroken.")
            //self.showAlert(message: "This device is jailbroken")
           
            //return true
        }
        else{
            let fileManager = FileManager.default

                        if (fileManager.fileExists(atPath: "/var/mobile/Library/Preferences/ABPattern") ||
                            fileManager.fileExists(atPath: "/usr/lib/ABDYLD.dylib") ||
                            fileManager.fileExists(atPath: "/usr/lib/ABSubLoader.dylib") ||
                            fileManager.fileExists(atPath: "/usr/sbin/frida-server") ||
                            fileManager.fileExists(atPath: "/etc/apt/sources.list.d/electra.list") ||
                            fileManager.fileExists(atPath: "/etc/apt/sources.list.d/sileo.sources") ||
                            fileManager.fileExists(atPath: "/.bootstrapped_electra") ||
                            fileManager.fileExists(atPath: "/usr/lib/libjailbreak.dylib") ||
                            fileManager.fileExists(atPath: "/jb/lzma") ||
                            fileManager.fileExists(atPath: "/.cydia_no_stash") ||
                            fileManager.fileExists(atPath: "/.installed_unc0ver") ||
                            fileManager.fileExists(atPath: "/jb/offsets.plist") ||
                            fileManager.fileExists(atPath: "/usr/share/jailbreak/injectme.plist") ||
                            fileManager.fileExists(atPath: "/etc/apt/undecimus/undecimus.list") ||
                            fileManager.fileExists(atPath: "/var/lib/dpkg/info/mobilesubstrate.md5sums") ||
                            fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
                            fileManager.fileExists(atPath: "/jb/jailbreakd.plist") ||
                            fileManager.fileExists(atPath: "/jb/amfid_payload.dylib") ||
                            fileManager.fileExists(atPath: "/jb/libjailbreak.dylib") ||
                            fileManager.fileExists(atPath: "/usr/libexec/cydia/firmware.sh") ||
                            fileManager.fileExists(atPath: "/var/lib/cydia") ||
                            fileManager.fileExists(atPath: "/etc/apt") ||
                            fileManager.fileExists(atPath: "/private/var/lib/apt") ||
                            fileManager.fileExists(atPath: "/private/var/Users/") ||
                            fileManager.fileExists(atPath: "/var/log/apt") ||
                            fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
                            fileManager.fileExists(atPath: "/private/var/stash") ||
                            fileManager.fileExists(atPath: "/private/var/lib/apt/") ||
                            fileManager.fileExists(atPath: "/private/var/lib/cydia") ||
                            fileManager.fileExists(atPath: "/private/var/cache/apt/") ||
                            fileManager.fileExists(atPath: "/private/var/log/syslog") ||
                            fileManager.fileExists(atPath: "/private/var/tmp/cydia.log") ||
                            fileManager.fileExists(atPath: "/Applications/Icy.app") ||
                            fileManager.fileExists(atPath: "/Applications/MxTube.app") ||
                            fileManager.fileExists(atPath: "/Applications/RockApp.app") ||
                            fileManager.fileExists(atPath: "/Applications/blackra1n.app") ||
                            fileManager.fileExists(atPath: "/Applications/SBSettings.app") ||
                            fileManager.fileExists(atPath: "/Applications/FakeCarrier.app") ||
                            fileManager.fileExists(atPath: "/Applications/WinterBoard.app") ||
                            fileManager.fileExists(atPath: "/Applications/IntelliScreen.app") ||
                            fileManager.fileExists(atPath: "/private/var/mobile/Library/SBSettings/Themes") ||
                            fileManager.fileExists(atPath: "/Library/MobileSubstrate/CydiaSubstrate.dylib") ||
                            fileManager.fileExists(atPath: "/System/Library/LaunchDaemons/com.ikey.bbot.plist") ||
                            fileManager.fileExists(atPath: "/Library/MobileSubstrate/DynamicLibraries/Veency.plist") ||
                            fileManager.fileExists(atPath: "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist") ||
                            fileManager.fileExists(atPath: "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist") ||
                            fileManager.fileExists(atPath: "/Applications/Sileo.app") ||
                            fileManager.fileExists(atPath: "/var/binpack") ||
                            fileManager.fileExists(atPath: "/Library/PreferenceBundles/LibertyPref.bundle") ||
                            fileManager.fileExists(atPath: "/Library/PreferenceBundles/ShadowPreferences.bundle") ||
                            fileManager.fileExists(atPath: "/Library/PreferenceBundles/ABypassPrefs.bundle") ||
                            fileManager.fileExists(atPath: "/Library/PreferenceBundles/FlyJBPrefs.bundle") ||
                            fileManager.fileExists(atPath: "/usr/lib/libhooker.dylib") ||
                            fileManager.fileExists(atPath: "/usr/lib/libsubstitute.dylib") ||
                            fileManager.fileExists(atPath: "/usr/lib/substrate") ||
                            fileManager.fileExists(atPath: "/usr/lib/TweakInject") ||
                            fileManager.fileExists(atPath: "/var/binpack/Applications/loader.app") ||
                            fileManager.fileExists(atPath: "/Applications/FlyJB.app") ||
                            fileManager.fileExists(atPath: "/Applications/Zebra.app")){
                            print("This device is jailbroken ")
                            isJailbrokenDevice = true
                            fatalError()
                            //self.showalertforJailbreakDevice("This device is jailbroken..")

                        }else{
                            print("This device is not jailbroken")
                            isJailbrokenDevice = false

                        }
            //return false
        }
    }
    
    func showalertforJailbreakDevice(_ msg : String){
        let alertController = UIAlertController(title: msg, message: "", preferredStyle: UIAlertControllerStyle.alert)
        
//            let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel)
//            {
//                (result : UIAlertAction) -> Void in
//                print("Cancel")
//
//            }
        let yesAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        {(result : UIAlertAction) -> Void in
            
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "isAlreadylogin")

            menuButton.isHidden=true
            menuButton.removeFromSuperview()


            let loginVC :LoginViewController_New = LoginViewController_New()

            UserDefaults.standard.set("", forKey: "ExtGroupSrNo")
            UserDefaults.standard.set("", forKey: "ExtFamilySrNo")
            UserDefaults.standard.set("", forKey: "OrderMasterNo")
            UserDefaults.standard.set("", forKey: "GroupChildSrNo")
            UserDefaults.standard.set("", forKey: "emailid")

            UserDefaults.standard.set(nil, forKey: "MEMBER_ID")

            //for Added for Terms and codition on 1st time login
//                if (UserDefaults.standard.bool(forKey: "HasLaunchedOnce")) {
//                    self.perviousTermsCondtion = "true"
//                }
//                else{
//                    self.perviousTermsCondtion = "false"
//                }
            //To display disclaimer every time
            UserDefaults.standard.setValue(nil, forKey: "isFitnessFirstTime")
            UserDefaults.standard.setValue(nil, forKey: "cigaretteCount")
            UserDefaults.standard.setValue(nil, forKey: "drinkCount")
            UserDefaults.standard.setValue(nil, forKey: "getOfflineTabs")

            UserDefaults.standard.set(false, forKey: "isInsurance")
            UserDefaults.standard.set(false, forKey: "isWellness")
            UserDefaults.standard.set(false, forKey: "isFitness")


            let center = UNUserNotificationCenter.current()
            center.removeDeliveredNotifications(withIdentifiers: ["EnrollmentLocalNotification"])
            center.removePendingNotificationRequests(withIdentifiers: ["EnrollmentLocalNotification"])

            center.removeAllPendingNotificationRequests()
//                if self.perviousTermsCondtion == "true"{
//                    UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
//                }

            self.navigationController?.pushViewController(loginVC, animated: true)
            //        navigationController?.popToViewController(loginVC, animated: true)
            UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                   to: UIApplication.shared, for: nil)
            
        }
        //alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        window?.rootViewController?.present(alertController, animated: true)
        //self.present(alertController, animated: true, completion: nil)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MyBenefits")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }else{
                let container = NSPersistentContainer(name: "MyBenefits")
                do {
                    let options: [AnyHashable: Any] = [
                        NSPersistentStoreFileProtectionKey: FileProtectionType.complete,
                        EncryptedStorePassphraseKey: "123456"
                    ]
                    let store = try container.persistentStoreCoordinator.addPersistentStore(ofType: EncryptedStoreType, configurationName: nil, at: container.persistentStoreDescriptions[0].url, options: options)
                } catch {
                    print("Core data not encrypted \(error.localizedDescription)")
                }
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    
    
    
    //CoreData
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.razeware.HitList" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "MyBenefits", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("MyBenefits.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
//    func application(_ app: UIApplication, open url: URL,
//                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        if let scheme = url.scheme,
//            scheme.localizedCaseInsensitiveCompare("https://mb360.page.link") == .orderedSame,
//            let view = url.host {
//
//            var parameters: [String: String] = [:]
//            URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
//                parameters[$0.name] = $0.value
//            }
//
//            moveToVc()
//            }
//
//        print(url.scheme)
//
//
//        return true
//    }
    
    func moveToVc() {
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
        
        
        nav1.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        nav2.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        nav3.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        nav4.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        nav5.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        
        
        //tabBarController
        
        
        let status=UserDefaults.standard.object(forKey: "isAlreadylogin") as? Bool
        if(status==true) //If user logged In
        {
                  if let window = self.window
            {
                if #available(iOS 13.0, *) {
                    window.overrideUserInterfaceStyle = .light
                }
                window.rootViewController = tabBarController
                tabBarController.selectedIndex=2
            }
            
            
        }
        else
        { //if user not Logged in or logout
   
            if UserDefaults.standard.value(forKey: "firstTimeInstall") != nil {
                //let rootView: LoginViewController = LoginViewController()
                let rootView: LoginViewController_New = LoginViewController_New()
                navigationController=UINavigationController (rootViewController: rootView)
                if let window = self.window
                {
                    if #available(iOS 13.0, *) {
                        window.overrideUserInterfaceStyle = .light
                    }
                    window.rootViewController = navigationController
                }
            }
            else{
                let enrollView: PageMenuViewController = PageMenuViewController()
                navigationController=UINavigationController (rootViewController: enrollView)
                if let window = self.window
                {
                    if #available(iOS 13.0, *) {
                        window.overrideUserInterfaceStyle = .light
                    }
                    window.rootViewController = navigationController
                }
            }
            
        }

    }
    
    
    func getUserToken(){
        
        var employeeSrno = String()
        var personSrnNo = String()
        var employeIdNo = String()
        
        var empSrno = UserDefaults.standard.value(forKey: "userEmployeeSrnoValue") as? String
        var empIDno = UserDefaults.standard.value(forKey: "userEmployeIdNoValue") as? String
        var perSrno = UserDefaults.standard.value(forKey: "userPersonSrnNoValue") as? String
        
        if empSrno != nil{
            employeeSrno = empSrno ?? ""
            print("employeeSrno: ",employeeSrno)
            employeeSrno = try! AesEncryption.encrypt(employeeSrno)
        }
        if empIDno != nil{
            employeIdNo = empIDno ?? ""
            print("employeIdNo: ",employeIdNo)
            employeIdNo = try! AesEncryption.encrypt(employeIdNo)
        }
        
        if perSrno != nil{
            personSrnNo = perSrno ?? ""
            print("personSrnNo: ",personSrnNo)
            personSrnNo = try! AesEncryption.encrypt(personSrnNo)
        }
        
        
        let allowedCharacterSet = CharacterSet.alphanumerics // Set of allowed characters
        let urlEncodedemployeeSrno = employeeSrno.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
        print("urlEncodedemployeeSrno: ",urlEncodedemployeeSrno)
        
        let urlEncodedpersonSrnNo = personSrnNo.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
        print("urlEncodedpersonSrnNo: ",urlEncodedpersonSrnNo)
        
        let urlEncodedemployeIdNo = employeIdNo.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
        print("urlEncodedemployeIdNo: ",urlEncodedemployeIdNo)
        
        
        
        let urlreq = NSURL(string: WebServiceManager.sharedInstance.getRefreshUserToken(employeeSrno: urlEncodedemployeeSrno!, personSrnNo: urlEncodedpersonSrnNo!, employeIdNo: urlEncodedemployeIdNo!))
        
        print("1000 getUserToken : \(urlreq)")
        
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = urlreq as URL?
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue( "Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { [self] (data, response, error) in
            if let error = error {
                print("error:", error)
                return
            }
            else{
                if let httpResponse = response as? HTTPURLResponse
                {
                    if httpResponse.statusCode == 200
                    {
                        do {
                            guard let data = data else { return }
                            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else { return }
                            print("jsonResponse: ", json)
                            
                            if let token = json["Authtoken"]
                            {
                                print("Token:  ",token)
                                if token.isEmpty{
                                    print("Something went wrong!!!")
                                }
                                else{
                                    authToken = token
                                }
                            }
                        } catch {
                            print("error:", error)
                            //self.hidePleaseWait()
                            //Crashlytics.crashlytics().record(error: m_errorMsg as! Error)
                        }
                    }
                    else if httpResponse.statusCode == 401{
                        
                        //self.hidePleaseWait()
                        //self.displayActivityAlert(title: m_errorMsg)
                        print("else 401 executed with \(httpResponse.statusCode)")
                        //showAlert(message: "Some error occured.Please try again later")
                    }
                    else{
                        print("else executed with \(httpResponse.statusCode)")
                    }
                }
                else {
                    print("Can't cast response to NSHTTPURLResponse")
                    //                        self.displayActivityAlert(title: m_errorMsg)
                    //                        self.hidePleaseWait()
                }
            }
        }
        if empSrno == nil && empIDno == nil && perSrno == nil{
            print("Empty value: empSrno: ",empSrno,"empIDno: ",empIDno,"perSrno: ",perSrno)
        }
        else{
            print("empSrno: ",empSrno,"empIDno: ",empIDno,"perSrno: ",perSrno)
            task.resume()
        }
    }
    
//    func showAlert(message: String) {
//        guard let viewController = viewController else {
//            return
//        }
//
//
//        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
//        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(action)
//
//        viewController.present(alert, animated: true, completion: nil)
//    }

}


