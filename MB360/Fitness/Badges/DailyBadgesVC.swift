//
//  DailyBadgesVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 16/07/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit
import AktivoCoreSDK

class DailyBadgesVC: UIViewController {
    
    //Top Badge Awarded View
    
    @IBOutlet weak var topAwardedStckView: UIStackView!
    @IBOutlet weak var topAwardedBadgeBackView: UIView!
    @IBOutlet weak var imgAwardedBadge: UIImageView!
    @IBOutlet weak var lblFirstMsg: UILabel!
    @IBOutlet weak var lblAwardedBadge: UILabel!
    @IBOutlet weak var lblBottomAwardedMsg: UILabel!
    
    //Daily Goals
    @IBOutlet weak var lblDailyGoals: UILabel!
    @IBOutlet weak var lblDailyGoalMsg: UILabel!
    
    
    //Sleep
    @IBOutlet weak var headerStack1: UIStackView!
    @IBOutlet weak var detailStack11: UIStackView!
    @IBOutlet weak var viewHeader1: UIView!
    @IBOutlet weak var viewDetail11: UIView!
    
    @IBOutlet weak var lblSleepTime1: UILabel!
    @IBOutlet weak var lblSleepTime11: UILabel!
    
    
    @IBOutlet weak var lblDailySleep1: UILabel!
    @IBOutlet weak var lblDailySleep11: UILabel!
    
    //Exercise
    @IBOutlet weak var viewHeader2: UIView!
    @IBOutlet weak var viewDetail22: UIView!
    @IBOutlet weak var headerStack2: UIStackView!
    @IBOutlet weak var detailStack22: UIStackView!

    @IBOutlet weak var lblExerciseTime1: UILabel!
    @IBOutlet weak var lblExerciseTime11: UILabel!

    @IBOutlet weak var lblDailyExercise1: UILabel!
    @IBOutlet weak var lblDailyExercise11: UILabel!
    
    //Sedentary
    @IBOutlet weak var viewHeader3: UIView!
    @IBOutlet weak var viewDetail33: UIView!

    @IBOutlet weak var headerStack3: UIStackView!
    @IBOutlet weak var detailStack33: UIStackView!
    
    @IBOutlet weak var lblSedentaryTime1: UILabel!
    @IBOutlet weak var lblSedentaryTime11: UILabel!

    @IBOutlet weak var lblDailySedentary1: UILabel!
    @IBOutlet weak var lblDailySedentary11: UILabel!
    
    //Light Activity
    @IBOutlet weak var viewHeader4: UIView!
    @IBOutlet weak var viewDetail44: UIView!

    @IBOutlet weak var headerStack4: UIStackView!
    @IBOutlet weak var detailStack44: UIStackView!
    @IBOutlet weak var lblLightActTime1: UILabel!
    @IBOutlet weak var lblLightActTime11: UILabel!

    
    @IBOutlet weak var temp1View: UIView!
    @IBOutlet weak var lblDailyLPA1: UILabel!
    
    @IBOutlet weak var lblDailyLPA11: UILabel!
    //Achiver table view
    @IBOutlet weak var achiverBackView: UIView!
    
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img11: UIImageView!

    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img22: UIImageView!

    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img33: UIImageView!

    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img44: UIImageView!


    @IBOutlet weak var lblMiddle: UILabel!
    
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn11: UIButton!
    
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn22: UIButton!

    
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn33: UIButton!

    
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn44: UIButton!

    
//    var sleepTime = String()
//    var exerciseTime = String()
//    var sedentaryTime = String()
//    var lpaTime = String()
    
    
    var dailyStepData = Dictionary<Date, AktivoDailyStep>()
    var dailySleepData = Dictionary<Date, AktivoDailySleep>()
    var dailyScoreData = Dictionary<Date, AktivoDailyScore>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setFitnessBackground()
       // self.view.backgroundColor = UIColor(patternImage: UIImage(named:"aktivo_background")!)
        

          //let img = UIImage(named: "aktivo_background")
          //self.view.backgroundColor = UIColor(patternImage: img!)

        
        lblMiddle.text = "Sleeping between 7 and 9 hours is important for your health and can have beneficial effects on your heart, metabolism and cognitive funtion."
        
        detailStack11.isHidden = true
        detailStack22.isHidden = true
        detailStack33.isHidden = true
        detailStack44.isHidden = true
        topAwardedStckView.isHidden = true

        addTapGestures()
        
//        img1.makeRounded()
//        img11.makeRounded()
//        img2.makeRounded()
//        img22.makeRounded()
//
//        img3.makeRounded()
//        img33.makeRounded()
//
//        img4.makeRounded()
//        img44.makeRounded()
        
        btn1.makeRounded()
        btn11.makeRounded()

        btn2.makeRounded()
        btn22.makeRounded()

        btn3.makeRounded()
        btn33.makeRounded()

        btn4.makeRounded()
        btn44.makeRounded()

        
       // viewDetail11.clipsToBounds = true
        setShadow()
        
        setData()

        getSummaryDataFromServer()
    }
    
    private func setData() {
        
        setsedentary()
        setSleepData()
        setExcercise()
        setLightActivity()
        
    }
    
    
    private func addTapGestures() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped))
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped))

        let tap11 = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped))
        let tap22 = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped))
        let tap33 = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped))
        let tap44 = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped))

        headerStack1.addGestureRecognizer(tap1)
        detailStack11.addGestureRecognizer(tap11)
        
        headerStack2.addGestureRecognizer(tap2)
        detailStack22.addGestureRecognizer(tap22)
        
        headerStack3.addGestureRecognizer(tap3)
        detailStack33.addGestureRecognizer(tap33)

        headerStack4.addGestureRecognizer(tap4)
        detailStack44.addGestureRecognizer(tap44)

    }
    
    @objc func stackViewTapped(_ sender :UITapGestureRecognizer) {
        print("Tapped....\(String(describing: sender.view?.tag))")
        switch sender.view?.tag {
        case 1:
            self.headerStack1.isHidden = true
            self.detailStack11.isHidden = false
            
        case 11:
            self.headerStack1.isHidden = false
            self.detailStack11.isHidden = true
            
        case 2:
            self.headerStack2.isHidden = true
            self.detailStack22.isHidden = false
            
        case 22:
            self.headerStack2.isHidden = false
            self.detailStack22.isHidden = true
            
        case 3:
            self.headerStack3.isHidden = true
            self.detailStack33.isHidden = false
            
        case 33:
            self.headerStack3.isHidden = false
            self.detailStack33.isHidden = true
            
        case 4:
            self.headerStack4.isHidden = true
            self.detailStack44.isHidden = false
            
        case 44:
            self.headerStack4.isHidden = false
            self.detailStack44.isHidden = true
            
        default:
            break
            
        }
    }
    
    func setShadow() {
        
        shadowForCell(view: topAwardedBadgeBackView)
        
        shadowForCell(view: viewHeader1)
        shadowForCell(view: viewDetail11)

        shadowForCell(view: viewHeader2)
        shadowForCell(view: viewDetail22)
        
        shadowForCell(view: viewHeader3)
        shadowForCell(view: viewDetail33)
        
        shadowForCell(view: viewHeader4)
        shadowForCell(view: viewDetail44)
        
        shadowForCell(view: achiverBackView)

    }

}



//Network call
extension DailyBadgesVC {
    func getSummaryDataFromServer() {
        if isConnectedToNet() {
            
            let fromDate = Date().yesterdayDate // 10 Days back
                   
                  let requestedComponents: Set<Calendar.Component> = [
                      .year,
                      .month,
                      .day]
                  
                  // get the components
                  let fromDateComponents = Calendar.current.dateComponents(requestedComponents, from: fromDate)
                  let fromDateFinal = Calendar.current.date(from: DateComponents(calendar: Calendar.current, year:fromDateComponents.year, month:fromDateComponents.month, day:fromDateComponents.day))!
                  print(fromDateFinal)
            
            

            self.showFitnessLoader(msg: "", type: 2)

            print("Today's Data Badge.... \(fromDate)")

            let dateQuery = AktivoBadgeDateQuery(date: fromDate)
            Aktivo.queryDateBadge(query: dateQuery) { (result, error) in
               
                print(result)
                print(error)
            
                self.hidePleaseWait()
                
                if let dailyBadge = result {
                    DispatchQueue.main.async {
                        
                        self.lblAwardedBadge.text = dailyBadge.badge.title
                        
                        if let text = dailyBadge.badge.congratsMessage {
                            self.topAwardedStckView.isHidden = false
                            if text.lowercased().contains("sleep")
                            {
                                self.lblBottomAwardedMsg.text = "For successfully achieving the recommended level of sleep yesterday!"
                            }
                            else if text.lowercased().contains("exercise")
                            {
                                self.lblBottomAwardedMsg.text = "For successfully achieving the recommended level of exercise yesterday!"

                            }
                            else if text.lowercased().contains("step")
                            {
                                self.lblBottomAwardedMsg.text = "For successfully achieving the recommended level of steps yesterday!"

                            }
                            else {
                                self.lblBottomAwardedMsg.text = "For successfully achieving the recommended level of light activity yesterday!"
                            }
                            
                        }
                        
                    if let badgeGoalsArray = dailyBadge.badgeGoals {
                        for badge in badgeGoalsArray {
                            switch badge.goalType {
                            case .sleep:
                                self.lblSleepTime1.text = self.getMin(seconds: Double(badge.durationInSec))
                                self.lblSleepTime11.text = self.getMin(seconds: Double(badge.durationInSec))

                                let min = self.getHours(seconds: Double(badge.minValueInSec))
                                let max = self.getHours(seconds: Double(badge.maxValueInSec))
                                
                                self.lblDailySleep1.text = String(format: "Daily goal: %@ to %@ hours", min.description,max.description)
                                self.lblDailySleep11.text = String(format: "Daily goal: %@ to %@ hours", min.description,max.description)

                            case .exercise:
                                self.lblExerciseTime1.text = self.getMin(seconds: Double(badge.durationInSec))
                                self.lblExerciseTime11.text = self.getMin(seconds: Double(badge.durationInSec))

                                let min = self.getHours(seconds: Double(badge.minValueInSec))
                               // let max = self.getHours(seconds: Double(badge.maxValueInSec))
                                
                                self.lblDailyExercise1.text = String(format: "Daily goal: %@ mins +",min.description)
                                self.lblDailyExercise11.text = String(format: "Daily goal: %@ mins +",min.description)

//                                if badge.minValueInSec == 0 {
//                                    self.lblDailyExercise1.text = String(format: "Daily goal: %@ mins +",min.description)
//                                    self.lblDailyExercise11.text = String(format: "Daily goal: %@ mins +",min.description)
//                                }
//                                else {
//                                    self.lblDailyExercise1.text = String(format: "Daily goal: %@ mins +", min.description)
//                                    self.lblDailyExercise11.text = String(format: "Daily goal: %@ mins +", min.description)
//                                }

                            case .sedentary:
                                self.lblSedentaryTime1.text = self.getMin(seconds: Double(badge.durationInSec))
                                self.lblSedentaryTime11.text = self.getMin(seconds: Double(badge.durationInSec))

                                //let min = self.getHours(seconds: Double(badge.minValueInSec))
                                let max = self.getHours(seconds: Double(badge.maxValueInSec))

                                self.lblDailySedentary1.text = String(format: "Daily goal: Less than %@ hours",max.description)
                                self.lblDailySedentary11.text = String(format: "Daily goal: Less than %@ hours",max.description)

                                
                            case .lpa:
                                self.lblLightActTime1.text = self.getMin(seconds: Double(badge.durationInSec))
                                self.lblLightActTime11.text = self.getMin(seconds: Double(badge.durationInSec))

                                //let min = self.getHours(seconds: Double(badge.minValueInSec))
                                //let max = self.getHours(seconds: Double(badge.maxValueInSec))
                                

                            default:
                                break
                            }
                        }
                        
                    }//badge goals
                        
                        
                        switch dailyBadge.badge.type {
                        case .contender:
                            self.imgAwardedBadge.image = UIImage(named: "contender_badge")
                        case .challenger:
                            self.imgAwardedBadge.image = UIImage(named: "challenger_badge")
                        case .achiever:
                            self.imgAwardedBadge.image = UIImage(named: "achiever_badge")
                            
                        default:
                            break
                        }
                        
                    } //Main thread
                    
                }
                else if let error = error {
                    print(error)

                }
                else {
                    print("No error no value..")
                // No error, no value invalid state
                }
                }
        }
        else {
            displayActivityAlert(title: "No Internet Connection")
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
        
        var hrsStr = ""
        var minStr = ""
        
        hrs > 1 ? (hrsStr = "Hours") : (hrsStr = "Hour")
        
        mins > 1 ? (minStr = "Mins") : (minStr = "Min")

        
        var str = ""
        if hrs > 0 {
            if mins > 0 {
            str = String(format: "%@ \(hrsStr) %@ \(minStr)", String(hrs.description),String(mins.description))
            }
            else {
            str = String(format: "%@ \(hrsStr)", String(hrs.description))
            }
        }
        else if hrs == 0 && mins == 0 {
            str = String(format: "%@ \(minStr)",String(mins.description))
        }
        else {
            str = String(format: "%@ \(minStr)",String(mins.description))
        }
        return str
    }
    
    private func getHours(seconds:Double) -> String {
        let hrs = Int(seconds)/3600
        var remainder = Int(seconds) - hrs * 3600
        var mins = remainder / 60
        
        remainder = remainder - mins * 60
        
        let secs = remainder
        if secs > 30 {
            mins += 1
        }
        
        if hrs > 0 {
        return hrs.description
        }
        else {
        return mins.description
        }
    }
    
//    private func getText(hours:Int,minutes:Int) -> String {
//        if hours > 1 {
//            return String(format: "%@ Hours %@ Mins", String(hours.description),String(minutes.description))
//        }
//        else if hours > 0{
//            return String(format: "%@ Hour %@ Mins", String(hours.description),String(minutes.description))
//
//        }
//        else if hours == 0 && minutes == 0 {
//
//        }
//        else {
//
//        }
//
//    }
    
}


//For Dashboard data static
extension DailyBadgesVC {
    public func setsedentary() {
        let resultsSorted = self.dailyScoreData.sorted(by: { ($0.key) < ($1.key)})

        for score in resultsSorted { //BAR
            let value = score.value
            
            
            if score.key.getSimpleDate() == Date().getSimpleDate() {
       
                
            }
            else {
                print("Yesterday")
                //self.lblTimeYesterday.text = Double(value.scoreStatsActualPas.sb).asString(style: .full)
                self.lblSedentaryTime1.text = getMin(seconds:Double(value.scoreStatsActualPas.sb))
                self.lblSedentaryTime11.text = getMin(seconds:Double(value.scoreStatsActualPas.sb))

                if score.value.scoreStatsImpact.sbImpact.rawValue.lowercased() == "negative" {
                    self.btn3.makeRounded()
                    self.btn33.makeRounded()
                }
                else {
                    self.btn3.makeRoundedGreen()
                    self.btn33.makeRoundedGreen()
                }

            }
            
        }
        
        if self.dailyScoreData.count == 0 {
            self.lblSedentaryTime1.text = getMin(seconds: Double(0))
            self.lblSedentaryTime11.text = getMin(seconds: Double(0))
        }
        
    }
    
    private func setSleepData() {
        
        let resultsSorted = self.dailySleepData.sorted(by: { ($0.key) < ($1.key)})
        
        
        for score in resultsSorted { //BAR
            //var key = score.key
            // var value = score.value
            
            if score.key.getSimpleDate() == Date().getSimpleDate() {
                print("Today")
             
                
            }
            else {
                print("Yesterday")
                //let sleepOfYesterday = Double(score.value.statTotal.timeInBed).asString(style: .full)
                
                let sleepOfYesterday = getMin(seconds: Double(score.value.statTotal.timeInBed))
                lblSleepTime1.text = sleepOfYesterday
                lblSleepTime11.text = sleepOfYesterday

                if score.value.impact.rawValue.lowercased() == "negative" {
                    self.btn1.makeRounded()
                    self.btn11.makeRounded()
                }
                else {
                    self.btn1.makeRoundedGreen()
                    self.btn11.makeRoundedGreen()
                }
            }
            
        }
        
        if resultsSorted.count == 0 {
            lblSleepTime1.text = getMin(seconds: Double(0))
            lblSleepTime11.text = getMin(seconds: Double(0))
        }
    }
    
    private func setExcercise() {
        let resultsSorted = self.dailyScoreData.sorted(by: { ($0.key) < ($1.key)})
        
        for score in resultsSorted { //BAR
            let value = score.value
            
            if score.key.getSimpleDate() == Date().getSimpleDate() {
            }
            else {
                print("Yesterday")
                //self.lblTimeYesterday.text = Double(value.scoreStatsActualPas.mpa).asString(style: .full)
                self.lblExerciseTime1.text = getMin(seconds: Double(value.scoreStatsActualPas.mpa))
                self.lblExerciseTime11.text = getMin(seconds: Double(value.scoreStatsActualPas.mpa))
              
                if score.value.scoreStatsImpact.mvpaImpact.rawValue.lowercased() == "negative" {
                    self.btn2.makeRounded()
                    self.btn22.makeRounded()
                }
                else {
                    self.btn2.makeRoundedGreen()
                    self.btn22.makeRoundedGreen()
                }
                
            }
            
        }
        
        if self.dailyScoreData.count == 0 {
            self.lblExerciseTime1.text = getMin(seconds: Double(0))
            self.lblExerciseTime11.text = getMin(seconds: Double(0))
        }
    }
    
    
    private func setLightActivity() {
        let resultsSorted = self.dailyScoreData.sorted(by: { ($0.key) < ($1.key)})
        
        for score in resultsSorted { //BAR
            let value = score.value
            
            if score.key.getSimpleDate() == Date().getSimpleDate() {
            }
            else {
                print("Yesterday Light Activity")
                //self.lblTimeYesterday.text = Double(value.scoreStatsActualPas.lipa).asString(style: .full)
                
                self.lblLightActTime1.text = getMin(seconds: Double(value.scoreStatsActualPas.lipa))
                self.lblLightActTime11.text = getMin(seconds: Double(value.scoreStatsActualPas.lipa))

                
                self.btn4.makeRoundedLightGray()
                self.btn44.makeRoundedLightGray()
                
//                if score.value.scoreStatsImpact.lipaImpact.rawValue.lowercased() == "negative" {
//                    self.img4.makeRounded()
//                    self.img44.makeRounded()
//                }
//                else {
//                    self.img4.makeRoundedGreen()
//                    self.img44.makeRoundedGreen()
//                }
            }
            
        }
        
        if self.dailyScoreData.count == 0 {
            self.lblLightActTime1.text = getMin(seconds: Double(0))
            self.lblLightActTime11.text = getMin(seconds: Double(0))
        }
    }
    
    
}


extension UIImageView {

    func makeRounded() {
        
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.007843137255, blue: 0.007843137255, alpha: 1)
        self.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0.007843137255, blue: 0.007843137255, alpha: 1)

        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
     func makeRoundedGreen() {
           
           self.layer.borderWidth = 1
           self.layer.masksToBounds = false
           self.layer.borderColor = #colorLiteral(red: 0.003921568627, green: 0.6784313725, blue: 0.3529411765, alpha: 1)
           self.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.6784313725, blue: 0.3529411765, alpha: 1)

           self.layer.cornerRadius = self.frame.height / 2
           self.clipsToBounds = true
       }
    
    func makeRoundedLightGray() {
             
             self.layer.borderWidth = 1
             self.layer.masksToBounds = false
             self.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
             self.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)

             self.layer.cornerRadius = self.frame.height / 2
             self.clipsToBounds = true
         }
    
}


extension UIButton {

    func makeRounded() {
        
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.007843137255, blue: 0.007843137255, alpha: 1)
        self.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0.007843137255, blue: 0.007843137255, alpha: 1)

        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
     func makeRoundedGreen() {
           
           self.layer.borderWidth = 1
           self.layer.masksToBounds = false
           self.layer.borderColor = #colorLiteral(red: 0.003921568627, green: 0.6784313725, blue: 0.3529411765, alpha: 1)
           self.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.6784313725, blue: 0.3529411765, alpha: 1)

           self.layer.cornerRadius = self.frame.height / 2
           self.clipsToBounds = true
       }
    
    func makeRoundedLightGray() {
             
             self.layer.borderWidth = 1
             self.layer.masksToBounds = false
             self.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.662745098, blue: 0.7725490196, alpha: 1)
             self.backgroundColor = #colorLiteral(red: 0.5921568627, green: 0.662745098, blue: 0.7725490196, alpha: 1)
//             self.backgroundColor = #colorLiteral(red: 0.462745098, green: 0.5529411765, blue: 0.7019607843, alpha: 1)

             self.layer.cornerRadius = self.frame.height / 2
             self.clipsToBounds = true
         }
    
   

    
    
}
