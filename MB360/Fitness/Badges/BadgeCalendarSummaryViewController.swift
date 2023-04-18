//
//  BadgeCalendarSummaryViewController.swift
//  FitnessUIApp
//
//  Created by SemanticMAC MINI on 17/07/20.
//  Copyright © 2020 SemanticMAC MINI. All rights reserved.
//

import UIKit
import JTAppleCalendar
import AktivoCoreSDK

class BadgeCalendarSummaryViewController: UIViewController {
 
    @IBOutlet weak var monthLabel:UILabel?
    @IBOutlet weak var calenderView:JTAppleCalendarView?

    
    //UIviews
    @IBOutlet weak var topBadgeView: UIView!
    @IBOutlet weak var totalBadgeView: UIView!
    @IBOutlet weak var monthlyBadgeView: UIView!
    @IBOutlet weak var calendarBackView: UIView!
    @IBOutlet weak var earnBadgeBackView: UIView!
    
    
    //Labels
    @IBOutlet weak var lblBadgesForMonth: UILabel!
    @IBOutlet weak var lblTopDate: UILabel!
    @IBOutlet weak var lblBadgeName: UILabel!
    @IBOutlet weak var lblTotalBadge: UILabel!
    @IBOutlet weak var lblMonthlyBadges: UILabel!
    @IBOutlet weak var lblLastBadgeDays: UILabel!
    
    @IBOutlet weak var lblLastEarnedBadge: UILabel!
    @IBOutlet weak var imgBadge: UIImageView!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrev: UIButton!
    
    
    //Bottom UI
    
    @IBOutlet weak var contendarView: UIView!
    @IBOutlet weak var challengerView: UIView!
    @IBOutlet weak var achiverView: UIView!
    
    @IBOutlet weak var lblContendarLastEarned: UILabel!
    @IBOutlet weak var lblChallengerLastEarned: UILabel!
    @IBOutlet weak var lblAchiverLastEarned: UILabel!
    
    
    @IBOutlet weak var lblContendarCount: UILabel!
    @IBOutlet weak var lblChallengerCount: UILabel!
    @IBOutlet weak var lblAchiverCount: UILabel!

    @IBOutlet weak var circularConView: UIView!
    @IBOutlet weak var circularChallView: UIView!
    @IBOutlet weak var circularAchivView: UIView!
    
    
    @IBOutlet weak var contenderHeight: NSLayoutConstraint!
    @IBOutlet weak var challengerHeight: NSLayoutConstraint!
    @IBOutlet weak var achiverHeight: NSLayoutConstraint!
    
    
    var badgeArray = [AktivoDailyBadge]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setFitnessBackground()
        self.setUpCalenderView()
        calenderView?.scrollingMode = .stopAtEachCalendarFrame
        

        setShadow()
        getSummaryDataFromServer()
        getHistoryDataFromServer()

        
    }
    
    func setShadow() {
         
        shadowForCell(view: topBadgeView)
        shadowForCell(view: totalBadgeView)
        shadowForCell(view: monthlyBadgeView)
        shadowForCell(view: calendarBackView)
        shadowForCell(view: earnBadgeBackView)
        
        makeCircular(view: circularConView)
        makeCircular(view: circularChallView)
        makeCircular(view: circularAchivView)

    }
    
    func makeCircular(view:UIView) {
        view.layer.cornerRadius = view.frame.size.width/2
        view.clipsToBounds = true

        view.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.borderWidth = 0.5
    }
    
    let dateFormatter = DateFormatter()

    @IBAction func nextClick(_ sender: UIButton) {
        calenderView?.scrollToSegment(SegmentDestination.next)

    }
    
    @IBAction func prevClick(_ sender: Any) {
        calenderView?.scrollToSegment(SegmentDestination.previous)

    }
    
    
    func setUpCalenderView() -> Void {
        print("\(#function)")
        
        calenderView?.visibleDates({ visibleDates in
            let date =  visibleDates.monthDates.first?.date
            
            var dateString = ""
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "MMMM"
            dateString = ((dateFormatter.string(from: date!) as AnyObject) as! String)
            
            //dateFormatter.dateFormat = "YYYY"
            //dateString = dateString.appendingFormat("  %@", dateFormatter.string(from: date!))
            
            self.monthLabel?.text = dateString.capitalizingFirstLetter()
            self.lblBadgesForMonth.text = """
            Badges For
            \(dateString.capitalizingFirstLetter())
            """
        })
        
        calenderView?.scrollToDate(Date(), triggerScrollToDateDelegate: true, animateScroll: true, preferredScrollPosition: UICollectionView.ScrollPosition.right, extraAddedOffset: 0.0, completionHandler: nil)
        
        
        calenderView?.minimumLineSpacing = 0.0
        calenderView?.minimumInteritemSpacing = 0.0
    }
    
    
    
}
  


//Network call
extension BadgeCalendarSummaryViewController {
    
    private func setLabels(lblCount:UILabel,lblLastEarned:UILabel,obj:AktivoBadgeSummaryBadgeType) {
        lblCount.text = obj.allTimeTotal.description
        if let lastEanedDate =  obj.lastEarned {
            //let convertDate = lastEanedDate.getSimpleDateGMT().dayAfter
            let convertDate = lastEanedDate.getSimpleDateUTC()

            //calculate date difference
            let noOfDays = Date().days(from: convertDate)
            
            switch noOfDays {
            case 0:
                lblLastEarned.text = "Last earned today"

            case 1:
                lblLastEarned.text = "Last earned yesterday"

            default:
                lblLastEarned.text = String(format: "Last earned %@ days ago (%@)", noOfDays.description, convertDate.getSimpleDateDD_MMM())
            }
        }

    }
    
    /*
     - This function is used for display data for current month in Your Badges.
     - Display total badges count & current month badges count.
     - Display last earned badges at the bottom side.
     - Display TopLabel for last Earned badge with date
     - This function is called first time from VDL..
     */
    
    func getSummaryDataFromServer() {
        if isConnectedToNet() {
            
            /*
             var components = DateComponents()
             components.day = 25
             components.month = 07
             components.year = 2020
             guard let oldDate = Calendar.current.date(from: components) else {return  }
             */
            
            //new start
            let dateStr = String(format: "%@-%@-%@", "01",String(Date().month),String(Date().year))
            let selectedMonthStartDate = dateStr.getDate()
            //let yesterdayDate = selectedMonthStartDate.yesterdayDate
            
            var toDate = selectedMonthStartDate.endOfMonth()
            if Date() < toDate {
                toDate = Date().yesterdayDate
            }
            // toDate = Date()
            let fromDate = selectedMonthStartDate  // 01-11-2019
            
            //print("#.....Get Monthly score.....\nFrom=\(fromDate) \nTo = \(toDate)")

            
            
            //new end
            self.showFitnessLoader(msg: "", type: 2)

            //let today = Date().yesterdayDate
            print("Today's Badge..Calendar summary..\(fromDate) to \(toDate)")
           // print("Today's Badge..Calendar summary..\(Date().monthAgoDate) to \(Date().yesterdayDate)")

            let summaryQuery = AktivoBadgeSummaryQuery(fromDate: fromDate, toDate: toDate)
           // let summaryQuery = AktivoBadgeSummaryQuery(fromDate: Date().monthAgoDate, toDate: (Date().yesterdayDate))

            Aktivo.queryBadgeSummary(query: summaryQuery) { (result, error) in
            print("RESULT OF = getSummaryDataFromServer()")
                print(result)
                print(error)
               
                
                self.hidePleaseWait()
                if let response = result {
                    
                    DispatchQueue.main.async {
                        self.lblTotalBadge.text = response.allTimeTotal.description
                        self.lblMonthlyBadges.text = response.periodTotal.description
                    
                    
                    if let lastBadge = response.lastBadge {
                        
                        print("LAST BADGE")
                        print(lastBadge)
                        
                         let badgeInfo = lastBadge.badge
                        //if badgeInfoArray.count > 0 {
                        self.lblBadgeName.text = badgeInfo.title
                        
                        //we are setting one days plus
                        self.lblTopDate.text = String(format: "Date:%@", lastBadge.refDateString.getStrDateFitnessBadge())
                        //}
                    
                        switch badgeInfo.type {
                        case .contender:
                            self.imgBadge.image = UIImage(named: "contender_badge")
                        case .challenger:
                            self.imgBadge.image = UIImage(named: "challenger_badge")
                        case .achiever:
                            self.imgBadge.image = UIImage(named: "achiever_badge")

                        default:
                            break
                        }
                        
                        self.earnBadgeBackView.isHidden = false

                        for obj in response.badgeTypes {
                            
                            switch obj.type {
                            case .contender:
                                if obj.lastEarned == nil {
                                    self.contendarView.isHidden = true
                                    self.contenderHeight.constant = 0

                                }
                                else {
                                    self.setLabels(lblCount: self.lblContendarCount, lblLastEarned: self.lblContendarLastEarned, obj: obj)
                                    
//                                    self.lblContendarCount.text = obj.allTimeTotal.description
//                                    if let lastEanedDate =  obj.lastEarned {
//                                        let convertDate = lastEanedDate.getSimpleDateGMT()
//                                        //calculate date difference
//                                        let noOfDays = Date().days(from: convertDate)
//                                        self.lblContendarLastEarned.text = String(format: "Last Earn %@ days ago", noOfDays.description)
//                                    }
                                }
                                
                            case .challenger:
                                if obj.lastEarned == nil {
                                    self.challengerView.isHidden = true
                                    self.challengerHeight.constant = 0

                                }
                                else {
                                    self.setLabels(lblCount: self.lblChallengerCount, lblLastEarned: self.lblChallengerLastEarned, obj: obj)
                                }
                                
                            case .achiever:
                                if obj.lastEarned == nil {
                                    self.achiverView.isHidden = true
                                    self.achiverHeight.constant = 0
                                }
                                else {
                                    self.setLabels(lblCount: self.lblAchiverCount, lblLastEarned: self.lblAchiverLastEarned, obj: obj)
                                }
                                
                                
                            default:
                                break
                            }
                        }
                    
                }//if let
                    else {
                        print("NO BADGE FOUND")
                        self.contendarView.isHidden = true
                        self.contenderHeight.constant = 0
                        
                        self.challengerView.isHidden = true
                        self.challengerHeight.constant = 0
                        
                        self.achiverView.isHidden = true
                        self.achiverHeight.constant = 0
                        self.lblTopDate.text = "No Badges Earned"
                        self.earnBadgeBackView.isHidden = true
                        }
                        
                    }//main thread
                }
                    
                else if let error = error {
                    print(error)

                }
                else {
                    print("No error no value..")
                }
                
            }
        }
        else {
            displayActivityAlert(title: "No Internet Connection")
        }
    
    }
    
    //MARK:- Change by month
    /*
     When user change month on calendar or by swipe on calendar then fetch summary data and set monthly badges count for single variable.
     - This function is used to set data for only one variable.
     - Every Time call when user change month.
     */
    func getMonthlySummaryDataFromServer(startDate:Date,endDate:Date) {
            if isConnectedToNet() {
                
               // self.showFitnessLoader(msg: "", type: 2)

                var endDateN = endDate

                if endDateN > Date() {
                    endDateN = Date().yesterdayDate
                }
                print("Get Monthly summary Data....\(startDate) to \(endDateN)")

                let summaryQuery = AktivoBadgeSummaryQuery(fromDate: startDate, toDate: endDateN)
                Aktivo.queryBadgeSummary(query: summaryQuery) { (result, error) in
                
                    print("Monthly Result..")
                    print(result)
                  //  print(error)
                   
                    
                    //self.hidePleaseWait()
                    if let response = result {
                        
                        DispatchQueue.main.async {
                           self.lblMonthlyBadges.text = response.periodTotal.description
                        
                        }//main thread
                    }
                        
                    else if let error = error {
                        print(error)

                    }
                    else {
                        print("No error no value..")
                    }
                    
                }
            }
            else {
                displayActivityAlert(title: "No Internet Connection")
            }
        
        }
}


//MARK:- History API
extension BadgeCalendarSummaryViewController {
    
    /*
     - Calendar Data from 1st january to current data
     - This function is used to fetch Data to display on calendar.
     - single time call from VDL()
     */
        func getHistoryDataFromServer() {
            if isConnectedToNet() {
                
                var components = DateComponents()
                components.day = 01
                components.month = 01
                components.year = Date().year
                guard let oldDate = Calendar.current.date(from: components) else {return  }

                self.showFitnessLoader(msg: "", type: 2)

                //let today = Date().yesterdayDate
                print("History's Data From....\(oldDate) to \(Date().yesterdayDate)")

             
                let summaryQuery = AktivoBadgeHistoryQuery(fromDate: oldDate, toDate: Date().yesterdayDate)
                Aktivo.queryBadgeHistory(query: summaryQuery) { (result, error) in
                print("History Response")
                    print(result)
                    print(error)
                     self.hidePleaseWait()
                    if let response = result {
                        print("YEAR SUMMARY")
                        print(response)
                        self.badgeArray = response
                        DispatchQueue.main.async {

                        self.calenderView?.reloadData()
                        }
                    }
                    else if let error = error {
                        print(error)

                    }
                    else {
                        print("No error no value..")
                    }
                    }
            }
            else {
                displayActivityAlert(title: "No Internet Connection")
            }
        }
}
