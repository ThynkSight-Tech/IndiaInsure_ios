//
//  HelperForFitnessDashboard.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 08/11/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import Foundation
import AktivoCoreSDK
import UIKit





extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -10, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var yesterdayDate: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month1: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    var weekAgoDate: Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: noon)!
    }
    var monthAgoDate: Date {
        return Calendar.current.date(byAdding: .day, value: -30, to: noon)!
    }
    
}



extension FitnessDashboardRootVC {
    
   

    /*
    func getStepsData(fromDate:Date,toDate:Date) {
        //From first date of month
        print("#.....Get Weekly score.....\nFrom=\(fromDate) \nTo = \(toDate)")
        self.showPleaseWait(msg: "")
        
        let stepQuery = AktivoStepQuery(fromDate: fromDate, toDate:
            toDate)
        Aktivo.query(stepQuery){ (result, error) in
            self.hidePleaseWait()
            print(error)
            print(result)
            
            if error == nil  {
                self.dailyStepData = result ?? Dictionary<Date, AktivoDailyStep>()
            }
            else {
                self.hidePleaseWait()
                print("Failed to get Score")
                print(error)
            }
            
        }
    }
    */
    /*
     Optional(
     [2019-11-04 18:30:00 +0000: AktivoDailySleep: [refDate: 2019-11-04 18:30:00 +0000, statTotal: AktivoSleepStatsTotal: [timeInBed: 23817 sec], imapact: NEGATIVE],
     2019-11-05 18:30:00 +0000: AktivoDailySleep: [refDate: 2019-11-05 18:30:00 +0000, statTotal: AktivoSleepStatsTotal: [timeInBed: 6107 sec], imapact: NEGATIVE]]
     )
     */
    func getSleepData(fromDate:Date,toDate:Date) {
        //From first date of month
        print("#.....Get Daily Sleep.....\nFrom=\(fromDate) \nTo = \(toDate)")
        if(isConnectedToNetWithAlert())
        {
            if isFromRefresh == 0 {

//            self.showPleaseWait(msg: "")
                self.showFitnessLoader(msg: "", type: 1)
            }
            let sleepQuery = AktivoSleepQuery(fromDate: fromDate, toDate:
                toDate)
            Aktivo.query(sleepQuery){ (result, error) in
                self.hidePleaseWait()
                print(error)
                print(result)
                self.isSleep = true
                
                if error == nil  {
                    
                    self.dailySleepData = result ?? Dictionary<Date, AktivoDailySleep>()
                    
                    self.setTodaySleepLabel()
                }
                else {
                    self.hidePleaseWait()
                    
                    print("Failed to get Sleep")
                    print(error)
                    
                    self.setNoSleepData()
                }
                
            }
        }
    }
    
    
    func getStepData(fromDate:Date,toDate:Date) {
        //From first date of month
        print("#.....Get Weekly Step.....\nFrom=\(fromDate) \nTo = \(toDate)")
        if(isConnectedToNetWithAlert())
        {
            if isFromRefresh == 0 {
           // self.showPleaseWait(msg: "")
                self.showFitnessLoader(msg: "", type: 1)

            }
            let stepQuery = AktivoStepQuery(fromDate: fromDate, toDate:
                toDate)
            Aktivo.query(stepQuery){ (result, error) in
                self.hidePleaseWait()
                print(error)
                print(result)
                self.isStep = true //for Loader
                if error == nil  {
                    self.hidePleaseWait()

                    self.dailyStepData = result ?? Dictionary<Date, AktivoDailyStep>()
                    self.setTodayStepLabel()
                    
                }
                else {
                    self.hidePleaseWait()
                    self.refreshControl1.endRefreshing()

                    print("Failed to get STEP")
                    print(error)
                    self.setNoStepData()
                }
                
            }
        }
    }
    
    
    
    func getTodaysScore(fromDate:Date,toDate:Date) {
        //From first date of month
        print("#.....Get Score Data.....\nFrom=\(fromDate) \nTo = \(toDate)")
        if(isConnectedToNetWithAlert())
        {
            if isFromRefresh == 0 {

            //self.showPleaseWait(msg: "")
                self.showFitnessLoader(msg: "", type: 1)

            }
            let scoreQuery = AktivoScoreQuery(fromDate: fromDate, toDate:
                toDate)
            Aktivo.query(scoreQuery){ (result, error) in
                self.hidePleaseWait()
                print(error)
                print(result)
                
                if error == nil  {
                    
                    self.dailyScoreData = result ?? Dictionary<Date, AktivoDailyScore>()
                   // let resultsSorted = self.dailyScoreData.sorted(by: { ($0.key) < ($1.key)})
                    self.setScore()
                    self.setsedentary()
                    
                }
                else {
                    self.hidePleaseWait()
                    self.setScore()

                    print("Failed to get Todays Score")
                    print(error)
                }
                
            }
        }
    }
    
    /*
     [refDate: 2019-11-05 18:30:00 +0000, score: 26.57446206462825, scoreStatsActualPas: AktivoScoreStatsActualPas: [mpa: 0 sec, vpa: 0 sec, lipa:6409 sec, sb:52202 sec],
     scoreStatsImpact: AktivoScoreStatsImpact: [mvpaImpact: NEGATIVE, lipaImpact: POSITIVE, sbImpact:NEGATIVE]]])
     */
}


extension Double {
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = style
        guard let formattedString = formatter.string(from: self) else { return "" }
        return formattedString
    }
}

extension FitnessDashboardRootVC {
    
    func getTodaysBadge() {
        
      /*  var components = DateComponents()
        components.day = 9
        components.month = 07
        components.year = 2020
        guard let today = Calendar.current.date(from: components) else {return  }
*/
        
        let today = Date().yesterdayDate
        print("Today's Badge....\(today)")

        let scoreQuery = AktivoBadgeDateQuery(date: today)
        Aktivo.queryDateBadge(query: scoreQuery) { (result, error) in
            print(result)
            print(error)
            // In other cases (network error, invalid data from server etc, we are
            // following same for PA queries).
            if let dailyBadge = result {
            // Success we found a badge for the date specified in query
                DispatchQueue.main.async {
                self.lblBadgeHeading.text = dailyBadge.badge.title
                //self.lblBadgeDetails.text = dailyBadge.badge.congratsMessage
                    
                    if let txt = dailyBadge.badge.congratsMessageShort {
                
                //self.lblBadgeDetails.attributedText =  txt.htmlAttributed(family: "Poppins", size: 10.0, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))

                        self.lblBadgeDetails.text = txt
                        
                        
                    }
                    
                    switch dailyBadge.badge.type {
                    case .contender:
                        self.imgBadgeEmoji.image = UIImage(named: "contender_badge")
                    case .challenger:
                        self.imgBadgeEmoji.image = UIImage(named: "challenger_badge")
                    case .achiever:
                        self.imgBadgeEmoji.image = UIImage(named: "achiever_badge")
                        
                    default:
                        self.imgBadgeEmoji.image = UIImage(named: "")
                        break
                    }
                    
                }
                
            }
            else if let error = error {
            switch error {
            case .noBadge:
                print("No badge found")
                
                DispatchQueue.main.async {
              

                    
                   // let str = "<strong>No badges earned today</strong><br> Sit less, exercise more or sleep well to earn a badge!"
                    self.lblBadgeHeading.text = "No badges earned today"
                  //  self.lblBadgeHeading.text = ""
                    self.lblBadgeDetails.text = "Sit less, exercise more or sleep well to earn a badge!"
                    //Working
                    self.lblFirstBadgeLabel.text = ""
                    
                  //  self.lblBadgeDetails.attributedText = str.htmlAttributed(family: "Poppins", size: 11.0, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))

                    
                    //self.imgBadgeEmoji.image = UIImage(named: <#T##String#>)
                }
                break
            // User did not achieve any badge on the specified date
            default:
                print("Server error")

                break
            // Some other error, check `AkctivoCoreError`
            }
            }
            else {
            // No error, no value invalid state
            }
            }
    }
    


    
    
}
extension String {
    var htmlToAttributedString11: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            let str = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            let attrs = [NSAttributedStringKey.font : UIFont.init(name: "Poppins-Regular", size: 13.0)]
            let boldString = NSMutableAttributedString(string: self, attributes:attrs as [NSAttributedStringKey : Any])

           // str.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red, NSAttributedString.Key.font: UIFont.init(name: "PTSans-Regular", size: 15.0) as Any], range: str.length)
            

            //str.NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 17)!
            
            return boldString
            
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString11: String {
        return htmlToAttributedString11?.string ?? ""
    }
}
//NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 17)!


extension FitnessDashboardRootVC {
    //Get Top Bar Button API...
    func getTopThreeButtonsAPI()
    {
        if let isInsurance = UserDefaults.standard.value(forKey:"isInsurance") as? Bool {
            if isInsurance {
            if !servicesArray.contains("Insurance") {
                self.servicesArray.append("Insurance")
            }
            }
        }
        
        if let isInsurance = UserDefaults.standard.value(forKey:"isWellness") as? Bool {
            if !servicesArray.contains("Wellness") {
                //self.servicesArray.append("Wellness")
            }
        }
        
        if let isInsurance1 = UserDefaults.standard.value(forKey:"isFitness") as? Bool {
            if isInsurance1 {

            if !servicesArray.contains("Fitness") {
                self.servicesArray.append("Fitness")
            }
            }
        }
        
        collectionViewCellTab.servicesArray = servicesArray
        collectionViewCellTab.reloadInputViews()
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
//
//                            //let indexPath = IndexPath.init(row: 0, section: 0)
//                            //self.tableView.reloadRows(at: [indexPath], with: .none)
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



    func getMemberIdFromMBServer() {
        print("Get Member Id From Aktivo")
        let empID = DatabaseManager.sharedInstance.getSelectedEmpSrNo1()
        if empID != "" {
            let url = APIEngine.shared.getFitnessUserInfo(strEmpSrno:empID)
            
            print(url)
            
            ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
                
                if let messageDictionary = response?["message"].dictionary
                {
                    
                    if let status = messageDictionary["Status"]?.bool
                    {
                        if status == true {
                            
                            
                            if let memberInfoArray = response?["UserMemberIdInfo"].array {
                                
                                if memberInfoArray.count == 0 {
                                   let isAlreadyOnboarded = false
                                   let parameter = ["client_id":"semantic","client_secret":"47bed95c0f3df643492c5e80eabafa72ef3f3bb5259fbe4fe250b8bf03a26264","grant_type":"client_credentials","scope":"company:read_write:as_a_client,member:read_write:as_a_client"]
                                    
                                    let aktivoUrl = "https://api.aktivolabs.com/oauth/token"
                                    
                                    print("MemberId Not Found-----")
                                    self.getMemberIDFromAktivo(parameter: parameter as NSDictionary, url: aktivoUrl, isAlreadyOnboarded: isAlreadyOnboarded)

                                }
                                else {
                                var memberID = ""
                                for arrDict in memberInfoArray {
                                    let memberid = arrDict["MEMBER_ID"].stringValue
                                    memberID = memberid
                                    UserDefaults.standard.set(memberid, forKey: "MEMBER_ID")
                                }
                                    
                                print("MemberId Found ++++")
                                    let isAlreadyOnboarded = true
                                    let parameter = ["client_id":memberID, "client_secret":"47bed95c0f3df643492c5e80eabafa72ef3f3bb5259fbe4fe250b8bf03a26264","grant_type":"client_credentials"]
                                    let aktivoUrl = "https://api.aktivolabs.com/oauth/token"

                                    if memberID != "" {
                                    self.getMemberIDFromAktivo(parameter: parameter as NSDictionary, url: aktivoUrl, isAlreadyOnboarded: isAlreadyOnboarded)
                                    }
                                //self.getUserTokenValueAPI(email: "")
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
        else {
            print("Failed to get EMP ID")
        }
    }
}
