//
//  StatsFitnessVC.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 10/09/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import Charts
import AktivoCoreSDK
import SwiftyJSON

var selectedFeatureIndex = 0
var isDirect = 0

struct ScoreModel {
    var date :Date?
    var scoreModel : AktivoDailyScore?
}

class StatsFitnessVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,ChartViewDelegate {
    
    @IBOutlet weak var topFitnessCollectionView: UICollectionView!
    @IBOutlet weak var weekCollectionView: UICollectionView!
    @IBOutlet weak var monthCollectionView: UICollectionView!
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var lblMidMsg: UILabel!
    var featureArray = ["AKTIVO SCORE®","STEPS TAKEN","HEART RATE","SLEEP"]
    var selectedWeekIndex = 0
    var selectedMonthIndex = 0
    var topCollectioViewSelectedIndex = 0
    
    var months = [String]()
    //var enabledMonths = [String]()

    var unitsSold : [Double]!
    var dateArray : [Double]!
    var weeksArray1: [String]!
    var weeksArray = [String]()
    
    weak var axisFormatDelegate: AxisValueFormatter?
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var lblWeekDate: UILabel!
    
    
    //Network Graph Variables
    var you = "20"
    var youWeekAgo = "40"
    var usersBottom = "60"
    var yourNetwork = "80"
    var usersTop = "90"
    var youMonthAgo = "10"
    var youFinalValue = 0
    
    var numberOfWeeks = 0
    var currentWeek = 0
    var currentMonth = 0
    
    //For line chart
    var lineDateArray = [Double]()
    var lineScoreArray = [Double]()
    var lineStepArray = [Double]()
    var lineSleepArray = [Double]()
    var lineHeartRateArray = [Double]()
    
    
    //for Bar Chart
    var barDateArray = [Double]()
    var barScoreArray = [Double]()
    var barStepArray = [Double]()
    var barSleepArray = [Double]()
    var barHeartRateArray = [Double]()
    
    var selectedBar = -1
    var selectedBarValue: Double = 1.0
    
    var weekStructArray = [WeekDateStruct]()
    var monthStructArray = [MonthDataStruct]()

    var weekScrollIndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setFitnessBackground()
        self.navigationItem.title = "My Stats"
        self.navigationController?.navigationBar.changeFont()
        self.navigationController?.navigationBar.applyFitnessGradient()
        self.navigationController?.navigationBar.navBarDropShadow()
        
        //topProgressBar.transform = topProgressBar.transform.scaledBy(x: 1, y: 30)
        
        //MARK:- Background Gradient
        //self.view.setGradientBackgroundCA(colorOne: Color.fitnessBottom.value, colorTwo: Color.fitnessTop.value)
        self.view.backgroundColor = UIColor.white
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        //self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        //self.view.addGestureRecognizer(swipeLeft)
        
        weeksArray1 = ["Sun","Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        
        //Bar chart
        unitsSold = [25, 15, 22, 12, 30, 10, 8]
        // dateArray = [25, 15, 22, 12, 30, 10, 8]
        dateArray = [25, 15, 22, 12, 30, 10, 15,2, 15, 22,8]
        
        
        
        let formatter = DateFormatter()
        let monthComponents = formatter.shortMonthSymbols
        
        //It returns 12 months
        months = Calendar.current.shortMonthSymbols
        
       // getAllMonths()
        
        axisFormatDelegate = self
        
        
        //Get Number of weeks in current year and set that count to collectionview
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
        print(weekOfYear)
        self.currentWeek = weekOfYear
        self.selectedWeekIndex = weekOfYear
        self.lblWeekDate.text = self.getRange(weekNo: String(currentWeek))
        
        //Get Current Month
        currentMonth = Int(Date().month) ?? 1
        selectedMonthIndex = currentMonth ?? 3 - 1
        
        let weekRange = NSCalendar.current.range(of: .weekOfYear, in: .yearForWeekOfYear, for: Date())
        print(weekRange?.count ?? 0)
        //self.numberOfWeeks = weekRange?.count ?? 0
        
        self.getWeeksData()
        
        
        //SET GRAPH VIEWS....
        //Network Graph
        
        //updateNetworkGraph(youN: "10", youWeek: "15", userBottomN: networkScoreModelObj.percentile10?.score?.description ?? "0", yourNetworkN: networkScoreModelObj.average?.score?.description ?? "0", usersTopN: networkScoreModelObj.percentile90?.score?.description ?? "0", monthAgoN: "15", min: 8, max: 62)
        
        //Bar Graph
        //setChart(dataEntryX: weeksArray1, dataEntryY: unitsSold)
        
        //Line Graph
        //updateLineChart()
        
        
        //AKTIVO
        if isDirect == 0
        {
            //commented on 5th june 2020
            //getYearlyCompleteScore(month: currentMonth, year: Date().year)
        getScore(month: currentMonth, year: Date().year)
            
            
            let weekDates = getRangeDates(weekNo: String(selectedWeekIndex))
            getScoreData(fromDate: weekDates.start, toDate: weekDates.end, chartType: 1)
            getWeekAgoData(searchCase: "score")
        }
        
        let rightBar = UIBarButtonItem(image: UIImage(named: "menu-1"), style: .done, target: self, action: #selector(menuTapped))
        self.navigationItem.rightBarButtonItem = rightBar
        
    }
    
    @objc private func menuTapped() {
        self.slideMenuController()?.openRight()
    }
    
    //MARK:- View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        //scrollWeekTo(index: selectedWeekIndex)
        //direct from dashboard or user selects stats option
        if isDirect == 1 {
            isDirect = 0
            topCollectioViewSelectedIndex = selectedFeatureIndex
            menuChanged()
            self.topFitnessCollectionView.reloadData()
            startTimer()
        }
        else {
            self.topFitnessCollectionView.reloadData()
            startTimer()
        }
    }
    
    private func getAllMonths() {
    
//        let thirdPMonth = Calendar.current.date(byAdding: .month, value: -3, to: Date())?.monthStr ?? "Jan"
//        let secPMonth = Calendar.current.date(byAdding: .month, value: -2, to: Date())?.monthStr ?? "Jan"
//        let firstPMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())?.monthStr ?? "Jan"
//        enabledMonths.append(thirdPMonth)
//        enabledMonths.append(secPMonth)
//        enabledMonths.append(firstPMonth)
//        enabledMonths.append(Date().monthStr)
//
//
//        let thirdNMonth = Calendar.current.date(byAdding: .month, value: 3, to: Date())?.monthStr ?? "Jan"
//        let secNMonth = Calendar.current.date(byAdding: .month, value: 2, to: Date())?.monthStr ?? "Jan"
//        let firstNMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date())?.monthStr ?? "Jan"
//        //enabledMonths.append(firstNMonth)
//        //enabledMonths.append(secNMonth)
//        //enabledMonths.append(thirdNMonth)
        
    }
    
    //MARK:- Get Weeks and Months
    //first if month is less than 10 means jan to sept then fetch previous year nov to current date data.
    //else fetch data from Jan to Current date.
    private func getWeeksData() {
        var oldDate = Date()
        let currentDate = Date().addMonthFC(month: 1)
        
        if Date().month1 < 10 {
            //Get Dates
        let dateStr = String(format: "%@-%@-%@", "27","10",String(Date().year - 1))
        oldDate = dateStr.getDate()
            self.weekStructArray = weekRange(from: oldDate, to: currentDate)
            
            
            //Get Weeks
            let futureMonthDate = Date().addMonthFC(month: 4)
            self.monthStructArray = monthRange(from: oldDate, to: futureMonthDate)
            print(monthStructArray)
        }
        else {
            let dateStr = String(format: "%@-%@-%@", "01","01",String(Date().year))
            oldDate = dateStr.getDate()
                self.weekStructArray = weekRange(from: oldDate, to: Date())
                
                
                //Get Weeks
                let futureMonthDate = Date().addMonthFC(month: 2)
                self.monthStructArray = monthRange(from: oldDate, to: futureMonthDate)
                print(monthStructArray)

        }
        
    }
    
    
    
    //Set Automatic move collectionview
    var timer = Timer()
    func startTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(scrollWeekTo), userInfo: nil, repeats: false)
    }
    
    //MARK:- Scroll
    @objc func scrollWeekTo() {
        print("Scroll Weeks = \(weekScrollIndexPath.row)")
//        if numberOfWeeks > selectedWeekIndex {
//            let indexPath = IndexPath(row: selectedWeekIndex, section: 0)
//            self.weekCollectionView.reloadData()
//            weekCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
//        }
//        else {
//
//            let indexPath = IndexPath(row: numberOfWeeks - 1, section: 0)
//            self.weekCollectionView.reloadData()
//            weekCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
//        }
        
        
        let currentWeekObj = self.weekStructArray.filter({$0.weekNumber == currentWeek})
        let crIndex = currentWeekObj[0].index!
        
        if self.weekStructArray.count >= crIndex {
        weekCollectionView.scrollToItem(at: IndexPath(row: crIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
        
        scrollMonths()
        
        if selectedFeatureIndex > 2 {
            let indexPath = IndexPath(row: selectedFeatureIndex, section: 0)
            self.topFitnessCollectionView.reloadData()
            topFitnessCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        
    }
    @objc func scrollMonths() {
        print("Scroll Month = \(selectedMonthIndex)")
//        if months.count > selectedMonthIndex {
//            let indexPath = IndexPath(row: selectedMonthIndex, section: 0)
//            self.monthCollectionView.reloadData()
//            monthCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
//        }
//        else {
//            if selectedMonthIndex == 12 {
//            let indexPath = IndexPath(row: 11, section: 0)
//            self.monthCollectionView.reloadData()
//            monthCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
//            }
//        }
        
        if monthStructArray.count > selectedMonthIndex {
            let indexPath = IndexPath(row: selectedMonthIndex, section: 0)
            self.monthCollectionView.reloadData()
            monthCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        else {
            if selectedMonthIndex == 12 {
            //let indexPath = IndexPath(row: 11, section: 0)
            //self.monthCollectionView.reloadData()
           // monthCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    
    //MARK:- Swipe Gesture
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                
                if selectedFeatureIndex >= 1 {
                    selectedFeatureIndex -= 1
                    self.topFitnessCollectionView.reloadData()
                    let indexPath = IndexPath(row: selectedFeatureIndex, section: 0)
                    topFitnessCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
               
                    self.menuChanged()
                }
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                
                if selectedFeatureIndex < featureArray.count - 1 {
                    selectedFeatureIndex += 1
                    self.topFitnessCollectionView.reloadData()
                    let indexPath = IndexPath(row: selectedFeatureIndex, section: 0)
                    topFitnessCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
               
                    self.menuChanged()
                    
                }
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    
    
    //MARK:- CollectionView Delegate & DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topFitnessCollectionView {
            return featureArray.count
        }
        else if collectionView == weekCollectionView {
           // return numberOfWeeks
            return weekStructArray.count
        }
        else {
            //return months.count
            return monthStructArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellForTopFeatureStatsCollectionView", for: indexPath) as! CellForTopFeatureStatsCollectionView
        
        if collectionView == topFitnessCollectionView {
            cell.lblName.text = featureArray[indexPath.row]
            
            if selectedFeatureIndex == indexPath.row {
                cell.backView.backgroundColor = UIColor.black
                cell.lblName.textColor = UIColor.white
            }
            else {
                cell.backView.backgroundColor = UIColor.clear
                cell.lblName.textColor = UIColor.black
            }
        }
            //WEEK
        else if collectionView == weekCollectionView {
            
            
            cell.lblName.text = String(self.weekStructArray[indexPath.row].weekNumber ?? 1)
            let currentWeekObj = self.weekStructArray.filter({$0.weekNumber == currentWeek})
            let cr = currentWeekObj[0]
            
            print(self.weekStructArray[indexPath.row].weekNumber!,selectedWeekIndex)
            if self.weekStructArray[indexPath.row].weekNumber == selectedWeekIndex {
                
                cell.backView.backgroundColor = UIColor.black
                cell.lblName.textColor = UIColor.white
                cell.isUserInteractionEnabled = true
                self.weekScrollIndexPath = indexPath
            }
            else if self.weekStructArray[indexPath.row].index! <= cr.index!  {
                cell.isUserInteractionEnabled = true
                cell.lblName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.backView.backgroundColor = UIColor.clear
            }
            else {
                cell.isUserInteractionEnabled = false
                cell.lblName.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                cell.backView.backgroundColor = UIColor.clear

            }
            
            //cell.lblName.text = String(indexPath.row + 1)
//            if currentWeek < indexPath.row + 1 {
//                cell.isUserInteractionEnabled = false
//                cell.lblName.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//                cell.backView.backgroundColor = UIColor.clear
//            }
//            else {
//
//                if selectedWeekIndex == indexPath.row + 1 {
//                    cell.backView.backgroundColor = UIColor.black
//                    cell.lblName.textColor = UIColor.white
//                }
//                else {
//                    cell.isUserInteractionEnabled = true
//                    cell.lblName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//                    cell.backView.backgroundColor = UIColor.clear
//                }
//            }
            
        }
            //MONTHS
        else { //Months CollectionView
            cell.lblName.text = monthStructArray[indexPath.row].monthStr
            
            if selectedMonthIndex == monthStructArray[indexPath.row].monthNumber! { //show selected black
                cell.backView.backgroundColor = UIColor.black
                cell.lblName.textColor = UIColor.white
                cell.isUserInteractionEnabled = true
            }
            else {
                if monthStructArray[indexPath.row].isEnabled {
                    print("Failed") //enabled
                   cell.backView.backgroundColor = UIColor.clear
                    cell.lblName.textColor = UIColor.black
                    cell.isUserInteractionEnabled = true
                }
                else {
                    cell.backView.backgroundColor = UIColor.clear
                    cell.lblName.textColor = UIColor.lightGray
                    cell.isUserInteractionEnabled = false
                }
            }
            
            
            //Logic 2 correct for current year
            /*
            cell.lblName.text = months[indexPath.row]
            let currentMonthStr = Date().monthStr
            
            if selectedMonthIndex == indexPath.row + 1 { //show selected black
                cell.backView.backgroundColor = UIColor.black
                cell.lblName.textColor = UIColor.white
                cell.isUserInteractionEnabled = true
            }
            else {
                if enabledMonths.contains(months[indexPath.row]) || indexPath.row < currentMonth  {
                    print("Failed") //enabled
                   cell.backView.backgroundColor = UIColor.clear
                    cell.lblName.textColor = UIColor.black
                    cell.isUserInteractionEnabled = true
                }
                else {
                    cell.backView.backgroundColor = UIColor.clear
                    cell.lblName.textColor = UIColor.lightGray
                    cell.isUserInteractionEnabled = false
                }
            }
            */
            //Logic 1
            //Set disabled cell which are greater than current months
//            if currentMonth < indexPath.row + 1 {
//                cell.backView.backgroundColor = UIColor.clear
//                cell.lblName.textColor = UIColor.lightGray
//                cell.isUserInteractionEnabled = false
//            }
//            else {
//                if selectedMonthIndex == indexPath.row + 1 {
//                    print("Failed")
//                    cell.backView.backgroundColor = UIColor.black
//                    cell.lblName.textColor = UIColor.white
//                    cell.isUserInteractionEnabled = true
//                }
//                else {
//                    cell.isUserInteractionEnabled = true
//                    cell.backView.backgroundColor = UIColor.clear
//                    cell.lblName.textColor = UIColor.black
//                }
//            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == topFitnessCollectionView {
            topCollectioViewSelectedIndex = indexPath.row
            selectedFeatureIndex = indexPath.row
            self.topFitnessCollectionView.reloadData()
            topFitnessCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            menuChanged()

        }
        else if collectionView == weekCollectionView
        {
//            self.selectedWeekIndex = indexPath.row + 1
//            self.weekCollectionView.reloadData()
//            weekCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//
//            self.lblWeekDate.text = getRange(weekNo: String(indexPath.row + 1))
//            weekChanged()
            
            self.selectedWeekIndex = self.weekStructArray[indexPath.row].weekNumber!
            self.weekCollectionView.reloadData()
            weekCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            self.lblWeekDate.text = getRange(weekNo: String(self.weekStructArray[indexPath.row].weekNumber!))
            weekChanged()
            
        }
        else if collectionView == monthCollectionView
        {
//            self.selectedMonthIndex = indexPath.row+1
//            self.monthCollectionView.reloadData()
//            monthCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//
//
//            monthChanged()
            
            self.selectedMonthIndex = self.monthStructArray[indexPath.row].monthNumber!
                       self.monthCollectionView.reloadData()
                       monthCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                       
                       
                       monthChanged()
            
        }
    }
    
    
    //MARK:- Get Range of Weeks
    private func getRange(weekNo:String) -> String {
        print(weekNo)
        if weekNo == "1" && Date().month1 == 12 {

        let yearString = (Date().year + 1).description
        let weekOfYearString = weekNo
        
        guard let year = Int(yearString), let weekOfYear = Int(weekOfYearString) else {return ""}
        var components = DateComponents(weekOfYear: weekOfYear, yearForWeekOfYear: year)
        components.timeZone = TimeZone.init(abbreviation: "GMT")
        guard let date = Calendar.current.date(from: components) else {return ""}
        
        let df = DateFormatter()
        df.dateFormat = "dd MMM"
        let outputDate = df.string(from: date)  //2017-02-19
        
        var dateComponent = DateComponents()
        dateComponent.month = 0
        dateComponent.day = 6
        dateComponent.year = 0
        
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
        let endDate = df.string(from: futureDate ?? Date())  //2017-02-19
        
        
        print(outputDate)
        print(endDate)
        
        let finalString = String(format: "%@ - %@", outputDate,endDate)
        return finalString
        }
        else {
            //for current week
            var yearString = Date().year.description
            
            //for previous year weeks
            if selectedWeekIndex > currentWeek {
                yearString = (Date().year - 1).description
            }
            
            //            let weekOfYearString = weekNo
            
            guard let year = Int(yearString), let weekOfYear = Int(weekNo) else {return ""}
            var components = DateComponents(weekOfYear: weekOfYear, yearForWeekOfYear: year)
            components.timeZone = TimeZone.init(abbreviation: "GMT")
            guard let date = Calendar.current.date(from: components) else {return ""}
            
            let df = DateFormatter()
            df.dateFormat = "dd MMM"
            let outputDate = df.string(from: date)  //2017-02-19
            
            var dateComponent = DateComponents()
            dateComponent.month = 0
            dateComponent.day = 6
            dateComponent.year = 0
            
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
            let endDate = df.string(from: futureDate ?? Date())  //2017-02-19
            
            
            print(outputDate)
            print(endDate)
            
            let finalString = String(format: "%@ - %@", outputDate,endDate)
            return finalString
        }
    }
    
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
            
            let requestedComponents: Set<Calendar.Component> = [
                .year,
                .month,
                .day
            ]
            
            let toDateComponents = Calendar.current.dateComponents(requestedComponents, from: futureDate)
            let  toDateFinal = Calendar.current.date(from: DateComponents(calendar: Calendar.current, year:toDateComponents.year, month:toDateComponents.month, day:toDateComponents.day))!
        
            return (date,toDateFinal)
        }
        else {
            
            //for current week
            var yearString = Date().year.description
            
            //for previous year weeks
            if selectedWeekIndex > currentWeek {
                yearString = (Date().year - 1).description
            }
            
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
            
            let requestedComponents: Set<Calendar.Component> = [
                .year,
                .month,
                .day
            ]
            
            let toDateComponents = Calendar.current.dateComponents(requestedComponents, from: futureDate)
            let  toDateFinal = Calendar.current.date(from: DateComponents(calendar: Calendar.current, year:toDateComponents.year, month:toDateComponents.month, day:toDateComponents.day))!
       
            return (date,toDateFinal)
        }
    }
    
    
   /*
    private func getRangeDates(weekNo:String) -> (start:Date,end:Date) {
        print(weekNo)
        
        let yearString = Date().year.description
        let weekOfYearString = weekNo
        
        guard let year = Int(yearString), let weekOfYear = Int(weekOfYearString) else { return (Date(),Date()) }
        let components = DateComponents(weekOfYear: weekOfYear, yearForWeekOfYear: 2020)
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
        
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day
        ]
        
        var toDateComponents = Calendar.current.dateComponents(requestedComponents, from: futureDate)
        var  toDateFinal = Calendar.current.date(from: DateComponents(calendar: Calendar.current, year:toDateComponents.year, month:toDateComponents.month, day:toDateComponents.day))!
        
//        if date.month1 > toDateFinal.month1 {
//            toDateFinal = Calendar.current.date(from: DateComponents(calendar: Calendar.current, year:(toDateComponents.year!) + 1, month:toDateComponents.month, day:toDateComponents.day))!
//        }
        
        return (date,toDateFinal)
    }
 */
    
    /*
     private func getRangeDates(weekNo:String) -> (start:Date,end:Date) {
     print(weekNo)
     
     let yearString = Date().year.description
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
     
     let requestedComponents: Set<Calendar.Component> = [
     .year,
     .month,
     .day
     ]
     
     var toDateComponents = Calendar.current.dateComponents(requestedComponents, from: futureDate)
     var  toDateFinal = Calendar.current.date(from: DateComponents(calendar: Calendar.current, year:toDateComponents.year, month:toDateComponents.month, day:toDateComponents.day))!
     
     
     var fromDate = date
     if date.month1 > toDateFinal.month1 {
     toDateFinal = Calendar.current.date(from: DateComponents(calendar: Calendar.current, year:(toDateComponents.year!) + 1, month:toDateComponents.month, day:toDateComponents.day))!
     
     var fromDateComponents = Calendar.current.dateComponents(requestedComponents, from: fromDate)
     fromDate = Calendar.current.date(from: DateComponents(calendar: Calendar.current, year:Date().year, month:fromDateComponents.month, day:fromDateComponents.day))!
     
     }
     
     if toDateFinal > Date() {
     toDateFinal = Date()
     }
        var toFinalDateComponents = Calendar.current.dateComponents(requestedComponents, from: toDateFinal)

        toDateFinal = Calendar.current.date(from: DateComponents(calendar: Calendar.current, year:toFinalDateComponents.year, month:toFinalDateComponents.month, day:toFinalDateComponents.day))!
     
     return (fromDate,toDateFinal)
     }
    */
    
    private func updateNetworkGraph(youN:String,youWeek:String,userBottomN:String,yourNetworkN:String,usersTopN:String,monthAgoN:String,min:Int,max:Int,youFinal:Int) {
        
        print("Update net graph..")
        you = youN + "%"
        youWeekAgo = youWeek + "%"
        usersBottom = userBottomN + "%"
        yourNetwork = yourNetworkN + "%"
        usersTop = usersTopN + "%"
        youMonthAgo = monthAgoN + "%"
        
        youFinalValue = youFinal
        setHtml(min:min,max:max)
        
    }
    
    //MARK:- BAR CHART
    /*
    func setChart(dataEntryX forX:[String],dataEntryY forY: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        var dataEntries:[BarChartDataEntry] = []
        
        for i in 0..<forX.count{
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(forY[i]) , data: weeksArray1 as AnyObject?)
            print(dataEntry)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        let xAxisValue = barChartView.xAxis
        xAxisValue.valueFormatter = axisFormatDelegate
        
        //CUSTOMISE
        chartDataSet.colors = [UIColor.black]
        
        //Change POsition
        barChartView.xAxis.labelPosition = .bottom
        
        barChartView.backgroundColor = UIColor.white
        //UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        
        //Draw limit line
        let ll = ChartLimitLine(limit: 10.0, label: "10.0")
        ll.lineColor = UIColor.black
        ll.lineWidth =  1.0
        barChartView.rightAxis.addLimitLine(ll)
        
        
        barChartView.xAxis.gridColor = NSUIColor.clear
        barChartView.xAxis.drawGridLinesEnabled = false
        
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.gridColor = NSUIColor.clear
        
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.gridColor = NSUIColor.clear
        
        
        // barChartView.barData?.barWidth = Double(8.0)
        
        
        barChartView.backgroundColor = .clear
        //        barChartView.translatesAutoresizingMaskIntoConstraints = false
        
        //Hide Right Numbers YAxis
        barChartView.rightAxis.drawLabelsEnabled = false
        
        //Hide left Y Axis
        barChartView.leftAxis.drawZeroLineEnabled = false
        barChartView.leftAxis.drawLabelsEnabled = false
        barChartView.leftAxis.axisLineColor = UIColor.clear
        
        
        //Hide Right Line YAxis
        barChartView.rightAxis.drawAxisLineEnabled = false
        
        //Hide Legend
        barChartView.legend.drawInside = false
        
        //Hide Legend
        barChartView.legend.enabled = false
        
        //Set Bar Width
        chartData.barWidth = 0.3
        
        
        barChartView.data = chartData
        
    }
    */
    
    func updateBarChart(forX:[Double], forY: [Double],avgLine:Double) {
        barChartView.clear()
        barChartView.clearValues()
        barChartView.rightAxis.removeAllLimitLines()
        
        if forY.count == 0
        {
            barChartView.noDataText = "No data for the chart."
            barChartView.clear()
            barChartView.notifyDataSetChanged()
        }
        else {
            
            
            var dataEntries:[BarChartDataEntry] = []
            
            for i in 0..<forY.count {
                let dataEntry = BarChartDataEntry(x: Double(i), y: forY[i] , data: weeksArray1 as AnyObject?)
                
                //let dataEntry = BarChartDataEntry(x: Double(i), y: forY[i])
                print(dataEntry)
            
                dataEntries.append(dataEntry)
            }
            let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Week")
            let chartData = BarChartData(dataSet: chartDataSet)

            
            let xAxisValue = barChartView.xAxis
            xAxisValue.valueFormatter = axisFormatDelegate
            
            //CUSTOMISE
            chartDataSet.colors = [UIColor.black]
            
            //Change POsition
            barChartView.xAxis.labelPosition = .bottom
            
            barChartView.backgroundColor = UIColor.white
            //UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
            
            if selectedFeatureIndex == 0 {
                barChartView.leftAxis.axisMaximum = forY.max()! + 10
                barChartView.leftAxis.axisMinimum = 0.0
                
                barChartView.rightAxis.axisMaximum = forY.max()! + 10
                barChartView.rightAxis.axisMinimum = 0.0
            }
            else if selectedFeatureIndex == 3 { //sleep
                // barChartView.leftAxis.axisMaximum = 24.0
                barChartView.leftAxis.axisMinimum = 0.0
                //  barChartView.leftAxis.axisMinimum = 0.0
                barChartView.leftAxis.axisMaximum = forY.max()! + 2
                barChartView.rightAxis.axisMaximum = forY.max()! + 2
                barChartView.rightAxis.axisMinimum = 0.0
                
            }
            else {
                barChartView.leftAxis.axisMinimum = 0.0
                barChartView.leftAxis.axisMaximum = forY.max()! + 150

                barChartView.rightAxis.axisMinimum = 0.0
                barChartView.rightAxis.axisMaximum = forY.max()! + 150

            }
            
            //Draw limit line
            barChartView.rightAxis.removeAllLimitLines()
//            let ll = ChartLimitLine(limit: avgLine.rounded(toPlaces: 0), label: avgLine.description)
//            ll.lineColor = UIColor.black
//            ll.lineWidth =  1.0
//            if avgLine > 0 {
//                barChartView.rightAxis.addLimitLine(ll)
//            }
            
            if selectedFeatureIndex != 3 {
                
                let ll = ChartLimitLine(limit: avgLine.rounded(toPlaces: 0), label: Int(avgLine.rounded(toPlaces: 0)).description)
                ll.lineColor = UIColor.black
                ll.lineWidth =  1.0
                if avgLine > 0 {
                    barChartView.rightAxis.addLimitLine(ll)
                }
            }
            else {
                let ll = ChartLimitLine(limit: avgLine.rounded(toPlaces: 0), label: avgLine.description)
                ll.lineColor = UIColor.black
                ll.lineWidth =  1.0
                if avgLine > 0 {
                    barChartView.rightAxis.addLimitLine(ll)
                }
            }
            
            barChartView.xAxis.gridColor = NSUIColor.clear
            barChartView.xAxis.drawGridLinesEnabled = false
            
            barChartView.leftAxis.drawGridLinesEnabled = false
            barChartView.leftAxis.gridColor = NSUIColor.clear
            
            barChartView.rightAxis.drawGridLinesEnabled = false
            barChartView.rightAxis.gridColor = NSUIColor.clear
            
            
            // barChartView.barData?.barWidth = Double(8.0)
            
            
            barChartView.backgroundColor = .clear
            //        barChartView.translatesAutoresizingMaskIntoConstraints = false
            
            //Hide Right Numbers YAxis
            barChartView.rightAxis.drawLabelsEnabled = false
            
            //Hide left Y Axis
            barChartView.leftAxis.drawZeroLineEnabled = false
            barChartView.leftAxis.drawLabelsEnabled = false
            barChartView.leftAxis.axisLineColor = UIColor.clear
            
            
            
            //Hide Right Line YAxis
            barChartView.rightAxis.drawAxisLineEnabled = false
            
            //Hide Legend
            barChartView.legend.drawInside = false
            
            //Hide Legend
            barChartView.legend.enabled = false
            
            //Set Bar Width
            chartData.barWidth = 0.5
            barChartView.xAxis.labelFont = UIFont(name: "Poppins-Medium", size: 11.0)!
            barChartView.leftAxis.labelFont = UIFont(name: "Poppins-Medium", size: 11.0)!
            
            //barChartView.xAxis.axisMaximum = Double(self.barDateArray.count)
           // barChartView.xAxis.labelCount = self.barDateArray.count
            barChartView.xAxis.labelCount = 7
            barChartView.xAxis.axisMaximum = 7
            
            
            barChartView.minOffset = 15.0
            //barChartView.delegate  = self as! ChartViewDelegate
            //barChartView.xAxis.axisMaxLabels = self.barDateArray.count
            
            //Hide unhide bar label
            
            // let marker:XYMarkerView = XYMarkerView(color: UIColor.black, font: UIFont(name: "Poppins-SemiBold", size: 12)!, textColor: UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 7.0, right: 7.0), xAxisValueFormatter: barChartView.xAxis.valueFormatter!)
            
            let marker:BalloonMarker = BalloonMarker(color: UIColor.clear, font: UIFont(name: "Poppins-SemiBold", size: 12)!, textColor: UIColor.black, insets: UIEdgeInsets(top: 0.0, left: 7.0, bottom: 0.0, right: 7.0))
            marker.chartView?.layer.cornerRadius = 6.0
            //marker.setLabel(self.selectedBarValue.description)
            marker.minimumSize = CGSize(width: 0, height: 0)
            barChartView.marker = marker
            
       
            //hide values above Bar
            barChartView.drawValueAboveBarEnabled = false
            chartData.setValueTextColor(UIColor.clear)
            
            
            //Disable Zoom
            barChartView.pinchZoomEnabled = false
            barChartView.doubleTapToZoomEnabled = false
            barChartView.scaleXEnabled = false
            barChartView.scaleYEnabled = false
            
            //barChartView.highlightValue(x: 2, dataSetIndex: 0, stackIndex: 0)

            //        barChartView.animate(xAxisDuration: 1.0)
            barChartView.animate(yAxisDuration: 0.6)
            barChartView.data = chartData

            
            if let (maxIndex, maxValue) = forY.enumerated().max(by: { $0.element < $1.element }) {
                //print("The max element is \(maxValue) at index \(maxIndex)")
                barChartView.highlightValue(x: Double(maxIndex), dataSetIndex: 0)

            }
            else {
                //print("The array is empty, and has no max element or index.")
            }

        }
    }
    
    //MARK:- Line Chart date score
    func updateLineChart(forXAxis:[Double],forYAxis:[Double],avgLine:Double) {
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        lineChartView.leftAxis.removeAllLimitLines()
        
        lineChartView.minOffset = 15.0

        if forYAxis.count == 0
        {
            lineChartView.noDataText = "No data for the chart."
            lineChartView.clear()
            lineChartView.notifyDataSetChanged()
        }
        else {
        
            print(lineDateArray)
            //here is the for loop
            for i in 0..<lineDateArray.count {
                
                // let value = ChartDataEntry(x: Double(i+1), y: (dateArray?[i])!)
                
                let value = ChartDataEntry(x: Double(i + 1), y:forYAxis[i])
                
                
                //let value = ChartDataEntry(x: Double(i+1), y: Double(i+1) )
                
                //let value = ChartDataEntry(x: Double(i), y: Double(i), data: (dateArray?[i])!)
                // here we set the X and Y status in a data chart entry
                
               

                
                lineChartEntry.append(value) // here we add it to the data set
            }
            
            
            let line1 = LineChartDataSet(entries: lineChartEntry, label: "") //Here we convert lineChartEntry to a LineChartDataSet
            line1.colors = [NSUIColor.black] //Sets the colour to blue
            line1.lineWidth = 2.0 //lineWidth
            
            //Line Circle
            line1.circleHoleColor = UIColor.black //Inner color
            line1.drawCircleHoleEnabled = true
            line1.circleRadius = 2.5
            line1.circleHoleRadius = 2.5
            line1.circleColors = [UIColor.black] //Outer color
            
            line1.highlightColor = UIColor.black
            line1.drawHorizontalHighlightIndicatorEnabled = false
            line1.drawVerticalHighlightIndicatorEnabled = true
            
            //limit Line
            
            if selectedFeatureIndex != 3 {
                let sum = forYAxis.reduce(0, +)
                let avg = (sum / Double(forYAxis.count)).rounded()
                
                
                //Draw limit line
                let ll = ChartLimitLine(limit: avg.rounded(toPlaces: 0), label: (Int(avg)).description)
                ll.lineColor = UIColor.black
                ll.lineWidth =  0.8
                ll.labelPosition = .rightTop
                lineChartView.leftAxis.addLimitLine(ll)
                
                
                
            }
            else {
                
                lineChartView.leftAxis.axisMinimum = 0.0
                lineChartView.leftAxis.axisMaximum = forYAxis.max() ?? 10 + 1
                
                lineChartView.rightAxis.axisMinimum = 0.0
                lineChartView.rightAxis.axisMaximum = forYAxis.max() ?? 10 + 1
               
                //Draw limit line for sleep
                let ll = ChartLimitLine(limit: avgLine.rounded(toPlaces: 2), label: avgLine.rounded(toPlaces: 2).description)
                ll.lineColor = UIColor.black
                ll.lineWidth =  0.8
                ll.labelPosition = .rightTop
                lineChartView.leftAxis.addLimitLine(ll)
            }
            
            
            if selectedFeatureIndex == 0 {
                lineChartView.leftAxis.axisMaximum = 100.0
                lineChartView.leftAxis.axisMinimum = 0.0
                
                lineChartView.rightAxis.axisMaximum = 100.0
                lineChartView.rightAxis.axisMinimum = 0.0
            }
            else {
                lineChartView.leftAxis.axisMinimum = 0.0
                lineChartView.leftAxis.axisMaximum = (forYAxis.max() ?? 10) + 10
                
                lineChartView.rightAxis.axisMinimum = 0.0
                lineChartView.rightAxis.axisMaximum = (forYAxis.max() ?? 10) + 10

            }
            
            //Hide Right Numbers YAxis
            lineChartView.rightAxis.drawLabelsEnabled = false
            
            //Hide Right Line YAxis
            lineChartView.rightAxis.drawAxisLineEnabled = false
            
            //Hide Right Numbers YAxis
            lineChartView.leftAxis.drawLabelsEnabled = false
            
            //Hide Right Line YAxis
            lineChartView.leftAxis.drawAxisLineEnabled = false
            
            lineChartView.backgroundColor = UIColor.clear
            
            //Hide Legend
            lineChartView.legend.enabled = false
            
            
            let data = LineChartData() //This is the object that will be added to the chart
            data.append(line1) //Adds the line to the dataSet
            
        
            
            lineChartView.leftAxis.drawGridLinesEnabled = false
            lineChartView.leftAxis.gridColor = NSUIColor.clear
            
            lineChartView.rightAxis.drawGridLinesEnabled = false
            lineChartView.rightAxis.gridColor = NSUIColor.clear
            
            lineChartView.rightAxis.drawGridLinesEnabled = false
            lineChartView.rightAxis.gridColor = NSUIColor.clear
            
            lineChartView.xAxis.drawGridLinesEnabled = false
            lineChartView.xAxis.gridColor = NSUIColor.clear
            
            
            lineChartView.xAxis.labelPosition = .bottom
            // lineChartView.xAxis.avoidFirstLastClippingEnabled = true
            
            //Set maximum values on x axis
            //lineChartView.xAxis.axisMaxLabels = 30
            //lineChartView.setVisibleXRangeMaximum(2.0)
            
           // lineChartView.xAxis.axisMaximum = Double(lineDateArray.count)
            
            //Uncomment later
            lineChartView.leftAxis.axisMinimum = 0.0
            
            //lineChartView.setVisibleXRangeMaximum(30)
            if forYAxis.count > 30 {
                lineChartView.xAxis.labelCount = forYAxis.count
                lineChartView.xAxis.axisMaximum = Double(forYAxis.count)
            }
            else {
                lineChartView.xAxis.labelCount = 30
                lineChartView.xAxis.axisMaximum = 30
            }
            
            //lineChartView.maxVisibleCount = 30
            

            //lineChartView.xAxis.setLabelCount(30, force: true)
            //lineChartView.leftAxis.axisMaximum = 100.0
            
//            if lineDateArray.count > 20 {
//                lineChartView.xAxis.granularity = 3.0
//            }
//            else {
//                lineChartView.xAxis.granularity = 1.0
//
//            }
            
            lineChartView.xAxis.granularity = 3.0

            
            //lineChartView.xAxis.spaceMax = 10
            
            lineChartView.xAxis.labelFont = UIFont(name: "Poppins-Regular", size: 11.0)!
            lineChartView.leftAxis.labelFont = UIFont(name: "Poppins-Regular", size: 11.0)!
            
            lineChartView.highlightPerTapEnabled = true
            //lineChartView.highlightPerDragEnabled = true
            //Disable Zoom
            lineChartView.pinchZoomEnabled = false
            lineChartView.doubleTapToZoomEnabled = false
            lineChartView.scaleXEnabled = false
            lineChartView.scaleYEnabled = false
            
            
            let emptyVals = [Highlight]()
            lineChartView.highlightValues(emptyVals)
            
            
            // let marker = PillMarker(color: .white, font: UIFont(name: "Poppins-Regular", size: 11.0)!, textColor: .black)
            // lineChartView.marker = marker
            
            let marker:BalloonMarker = BalloonMarker(color: UIColor.clear, font: UIFont(name: "Poppins-SemiBold", size: 12)!, textColor: UIColor.black, insets: UIEdgeInsets(top: 0.0, left: 7.0, bottom: 0.0, right: 7.0))
            marker.chartView?.layer.cornerRadius = 6.0
            //marker.setLabel(self.selectedBarValue.description)
            marker.minimumSize = CGSize(width: 0, height: 0)
            lineChartView.marker = marker
            
            lineChartView.animate(yAxisDuration: 0.6)
            
           
            //set1.setHighLightColor(Color.BLACK);
            

            //Hide values on chart
            data.setDrawValues(false)
            lineChartView.data = data
            
        
            
            if let (maxIndex, maxValue) = forYAxis.enumerated().max(by: { $0.element < $1.element }) {
                //print("The max element is \(maxValue) at index \(maxIndex)")
                lineChartView.highlightValue(x: Double(maxIndex + 1), dataSetIndex: 0)
            }
            else {
                //print("The array is empty, and has no max element or index.")
            }
            
        }
    }

    
    //MARK:- # AKTIVO METHODS
    //Score
    var lineScoreData = Dictionary<Date, AktivoDailyScore>()
    var barScoreData = Dictionary<Date, AktivoDailyScore>()
    
    //Step
    var lineStepData = Dictionary<Date, AktivoDailyStep>()
    var barStepData = Dictionary<Date, AktivoDailyStep>()
    
    //Sleep
    var lineSleepData = Dictionary<Date, AktivoDailySleep>()
    var barSleepData = Dictionary<Date, AktivoDailySleep>()
    
    //HeartRate
    var lineHeartRateData = Dictionary<Date, AktivoDailyHeartRate>()
    var barHeartRateData = Dictionary<Date, AktivoDailyHeartRate>()
    
    
    
    
    
    //MARK:- Get Monthly Score
    func getScore(month:Int,year:Int) {
        self.showFitnessLoader(msg: "", type: 2)

        let dateStr = String(format: "%@-%@-%@", "01",String(month),String(year))
        let selectedMonthStartDate = dateStr.getDate()
        //let yesterdayDate = selectedMonthStartDate.yesterdayDate
        
        var toDate = selectedMonthStartDate.endOfMonth()
        if month == currentMonth {
            toDate = Date()
        }
        // toDate = Date()
        let fromDate = selectedMonthStartDate  // 01-11-2019
        
        //From first date of month
        print("#.....Get Monthly score.....\nFrom=\(fromDate) \nTo = \(toDate)")
        
        
        let scoreQuery = AktivoScoreQuery(fromDate: fromDate.yesterdayDate, toDate:
            toDate.yesterdayDate)
        Aktivo.query(scoreQuery){ (result, error) in
            self.hidePleaseWait()
            
            let modelArray = [ScoreModel]()
            self.lineScoreArray.removeAll()
            self.lineDateArray.removeAll()
            
            if error == nil  {
                
                self.lineScoreData = result ?? Dictionary<Date, AktivoDailyScore>()
                // let array = self.scoreData as? NSArray
                let resultsSorted = self.lineScoreData.sorted(by: { ($0.key) < ($1.key)})
                
                //start new
                var startFromDate = fromDate.yesterdayDate
                let toEndDate = toDate.yesterdayDate
                while startFromDate <= toEndDate {
                    print("DATE == \(startFromDate.getSimpleDate())")
                    
                    
                    
                    let components = NSCalendar.current.dateComponents([.day,.month,.year,.weekday],from:startFromDate)
                    if let day = components.day {
                        print("Date = \(day),")
                        self.lineDateArray.append(Double(day))
                    }
                    
                    let foundObj = self.lineScoreData.filter{($0.key.getSimpleDate() == startFromDate.getSimpleDate())}
                    if foundObj.count != 0 {
                        
                        for scoreObj in resultsSorted {
                            if scoreObj.key.getSimpleDate() == startFromDate.getSimpleDate() {
                                self.lineScoreArray.append(scoreObj.value.score.rounded())
                                break
                            }
                            
                        }
                        
                        print("FOUND = \(foundObj)")
                    }
                    else {
                        print("NOT FOUND")
                        self.lineScoreArray.append(0.0)
                        
                    }
                    
                    startFromDate = startFromDate.dayAfter
                    
                }
                //end new
                
                //                for score in resultsSorted {
                //                    var key = score.key
                //                    var value = score.value
                //
                //                    //Create Model
                //                    print(score.key)
                //                    print(score.value)
                //                    let obj = ScoreModel.init(date: key, scoreModel: value)
                //                    modelArray.append(obj)
                //
                //                    //Access Line Date array
                //                 //let tpDate = key.getSimpleDateGMTStr()
                //                    //let finalDate = tpDate.getSimpleDateGMT()
                //
                //                        let components = NSCalendar.current.dateComponents([.day,.month,.year],from:key)
                //                        if let day = components.day {
                //                            //let dayString = "\(day)"
                //                            //let monthString = "\(month)"
                //                            //let yearString = "\(year)"
                //                            print("Day = \(day)")
                //                            self.lineDateArray.append(Double(day))
                //                            self.lineScoreArray.append(value.score.rounded())
                //
                //                        }
                //
                //
                //                } //for
                
                print("count = \(modelArray.count)")
                print(self.lineScoreArray)
                print(self.lineDateArray)
                
                
                self.updateLineChart(forXAxis:self.lineDateArray,forYAxis:self.lineScoreArray, avgLine: 0.0)
                
                //                if let resultDict = result {
                //                    print(resultDict)
                //                }
                //                else {
                //                    print("Parsing Failed")
                //                }
                
                //print(StatsFitnessVC())
                
                //For Network Graph
//                var scoreNetArray = [Int]()
//                scoreNetArray.append(networkScoreModelObj.percentile10?.score ?? 0)
//                scoreNetArray.append(networkScoreModelObj.average?.score ?? 0)
//                scoreNetArray.append(networkScoreModelObj.percentile90?.score ?? 0)
//
//                let sum = self.lineScoreArray.reduce(0, +)
//                let monthAvg = (sum / Double(self.lineScoreArray.count)).rounded()
//                scoreNetArray.append(Int(monthAvg))
//
//                var weekAvg = 0.0
//                if self.barScoreArray.count > 0 {
//                    let weekSum = self.barScoreArray.reduce(0, +)
//                    weekAvg = (weekSum / Double(self.barScoreArray.count)).rounded()
//
//                    scoreNetArray.append(Int(weekAvg))
//                }
//
//                var youScore = 0
//                if aktivoTodaysScoreObj != nil {
//                    youScore = Int(aktivoTodaysScoreObj!.score)
//                    scoreNetArray.append(Int(youScore))
//                }
//
//
//
//                let min = scoreNetArray.min()
//                let max = scoreNetArray.max()
                
              //  print(scoreNetArray)
//                self.updateNetworkGraph(youN: self.getPercentStr(value: Double(youScore), max: Double(max!)), youWeek: self.getPercentStr(value: Double(weekAvg), max: Double(max!))
//                    , userBottomN:self.getPercentStr(value: Double(networkScoreModelObj.percentile10?.score ?? Int(0.0)), max: Double(max!)), yourNetworkN: self.getPercentStr(value:Double(networkScoreModelObj.average?.score ?? Int(0.0)), max: Double(max!)), usersTopN: self.getPercentStr(value:Double(networkScoreModelObj.percentile90?.score ?? Int(0.0)), max: Double(max!)),
//                      monthAgoN: self.getPercentStr(value: monthAvg, max: Double(max!)),min: min ?? 0,max: max ?? 100)
                
            }
            else {
                self.hidePleaseWait()
                
                print("Failed to get Score Monthly")
                
                self.lineDateArray.removeAll()
                self.lineScoreArray.removeAll()
                self.updateLineChart(forXAxis:self.lineDateArray,forYAxis:self.lineScoreArray, avgLine: 0.0)
                
                
            }
            
        }
        
    }
    
    //June 2020 - Lockdown
    func getYearlyCompleteScore(month:Int,year:Int) {
            self.showFitnessLoader(msg: "", type: 2)

            let dateStr = String(format: "%@-%@-%@", "01",String(04),String(2020))
            let selectedMonthStartDate = dateStr.getDate()
            
           
               let toDate = Date()
            
            // toDate = Date()
            let fromDate = selectedMonthStartDate  // 01-11-2019
            
            //From first date of month
            print("#.....Get Yearly score.....\nFrom=\(fromDate) \nTo = \(toDate)")
            
            
            let scoreQuery = AktivoScoreQuery(fromDate: fromDate.yesterdayDate, toDate:
                toDate.yesterdayDate)
            Aktivo.query(scoreQuery){ (result, error) in
                self.hidePleaseWait()
                
                //var modelArray = [ScoreModel]()
                self.lineScoreArray.removeAll()
                self.lineDateArray.removeAll()
                self.lineScoreData.removeAll()
                
                if error == nil  {
                    
                    self.lineScoreData = result ?? Dictionary<Date, AktivoDailyScore>()
                  

                    self.getScore(month:month,year:year)
                  
                }
                else {
                    self.hidePleaseWait()
                    
                    print("Failed to get Score Monthly")
                    print(error)
                    
                    self.lineDateArray.removeAll()
                    self.lineScoreArray.removeAll()
                    self.updateLineChart(forXAxis:self.lineDateArray,forYAxis:self.lineScoreArray, avgLine: 0.0)
                    
                    
                }
                
            }
            
        }
    
    
    func getScoreOLD(month:Int,year:Int) {

            let dateStr = String(format: "%@-%@-%@", "01",String(month),String(year))
            let selectedMonthStartDate = dateStr.getDate()
            
            var toDate = selectedMonthStartDate.endOfMonth()
            if month == currentMonth {
                toDate = Date()
            }
        
            // toDate = Date()
            let fromDate = selectedMonthStartDate  // 01-11-2019
            
            //From first date of month
            print("#.....Get Monthly score.....\nFrom=\(fromDate) \nTo = \(toDate)")
            
               
                self.lineDateArray.removeAll()
                self.lineScoreArray.removeAll()
        
                    let resultsSorted = self.lineScoreData.sorted(by: { ($0.key) < ($1.key)})
                    
                    //start new
                    var startFromDate = fromDate.yesterdayDate
                    let toEndDate = toDate.yesterdayDate
                    while startFromDate <= toEndDate {
                        print("DATE == \(startFromDate.getSimpleDate())")
                        
                        
                        
                        let components = NSCalendar.current.dateComponents([.day,.month,.year,.weekday],from:startFromDate)
                        if let day = components.day {
                            print("Date = \(day),")
                            self.lineDateArray.append(Double(day))
                        }
                        
                     
            
                        
                        let foundObj = resultsSorted.filter{($0.key.getSimpleDate() == startFromDate.getSimpleDate())}
                        
                       
                        
                        if foundObj.count != 0 {
                        
                            lineScoreArray.append(foundObj[0].value.score.rounded())
//                            for scoreObj in resultsSorted {
//                                if scoreObj.key.getSimpleDate() == startFromDate.getSimpleDate() {
//                                    self.lineScoreArray.append(scoreObj.value.score.rounded())
//                                    break
//                                }
//
//                            }

                            print("FOUND = \(foundObj)")
                        }
                        else {
                            print("NOT FOUND")
                            self.lineScoreArray.append(0.0)

                        }
                        
                        startFromDate = startFromDate.dayAfter
                        
                    }//While
                
                    
                    print(self.lineScoreArray)
                    print(self.lineDateArray)
                    
                    
                    self.updateLineChart(forXAxis:self.lineDateArray,forYAxis:self.lineScoreArray, avgLine: 0.0)

        }
    /*
        func getYearScore(month:Int,year:Int) {
            self.showFitnessLoader(msg: "", type: 2)

            let dateStr = String(format: "%@-%@-%@", "01","01","2019")
            let selectedMonthStartDate = dateStr.getDate()
            //let yesterdayDate = selectedMonthStartDate.yesterdayDate
            
            var toDate = selectedMonthStartDate.endOfMonth()
            //if month == currentMonth {
                toDate = Date()
           // }
            // toDate = Date()
            let fromDate = selectedMonthStartDate  // 01-11-2019
            
            //From first date of month
            print("#.....Get Yearly score.....\nFrom=\(fromDate) \nTo = \(toDate)")
            
            
            let scoreQuery = AktivoScoreQuery(fromDate: fromDate.yesterdayDate, toDate:
                toDate.yesterdayDate)
            Aktivo.query(scoreQuery){ (result, error) in
                self.hidePleaseWait()
                
                var modelArray = [ScoreModel]()
                self.lineScoreArray.removeAll()
                self.lineDateArray.removeAll()
                
                if error == nil  {
                    
                    self.lineScoreData = result ?? Dictionary<Date, AktivoDailyScore>()
                    // let array = self.scoreData as? NSArray
                    
                    //start new
                    let dateStr1 = String(format: "%@-%@-%@", "01",String(month),String(year))

                    var startFromDate = dateStr1.getDate()
                    var toEndDate = startFromDate.endOfMonth()
                    if month == self.currentMonth {
                       toEndDate = Date()
                    }
                    
                    self.getMonthlyScoreNew(startFromDate: startFromDate, toEndDate: toEndDate)
                    
                }
                else {
                    self.hidePleaseWait()
                    
                    print("Failed to get Score Monthly")
                    print(error)
                    
                    self.lineDateArray.removeAll()
                    self.lineScoreArray.removeAll()
                    self.updateLineChart(forXAxis:self.lineDateArray,forYAxis:self.lineScoreArray, avgLine: 0.0)
                }
            }
            
        }
    
    func getMonthlyScoreNew(startFromDate:Date,toEndDate:Date) {
        while startFromDate <= toEndDate {
            print("DATE == \(startFromDate.getSimpleDate())")
            
            let foundObj = self.lineScoreData.filter{($0.key.getSimpleDate() == startFromDate.getSimpleDate())}
            
            
            let components = NSCalendar.current.dateComponents([.day,.month,.year,.weekday],from:startFromDate)
            if let day = components.day {
                print("Date = \(day),")
                self.lineDateArray.append(Double(day))
            }
            
            if foundObj.count != 0 {
                let resultsSorted = self.lineScoreData.sorted(by: { ($0.key) < ($1.key)})

                self.lineScoreArray.removeAll()
                self.lineDateArray.removeAll()
                
                for scoreObj in resultsSorted {
                    if scoreObj.key.getSimpleDate() == startFromDate.getSimpleDate() {
                        self.lineScoreArray.append(scoreObj.value.score.rounded())
                        break
                    }
                    
                }
                
                print("FOUND = \(foundObj)")
            }
            else {
                print("NOT FOUND")
                self.lineScoreArray.append(0.0)
                
            }
            
            
        }
        //end new
                            
        //print("count = \(modelArray.count)")
        print(self.lineScoreArray)
        print(self.lineDateArray)
        self.updateLineChart(forXAxis:self.lineDateArray,forYAxis:self.lineScoreArray, avgLine: 0.0)

    }
    */
    private func getPercentStr(value:Double,max:Double,min:Double) -> String {
        if value == min {
            return 0.description
        }
        else {
        let ans = (value * 100) / max
        return ans.description
        }
    }
    
    //MARK:- Get weekly score
    private func getScoreData(fromDate:Date,toDate:Date,chartType:Int) { //chartType = 1/2
        //From first date of month
        print("#.....Get Weekly score.....\nFrom=\(fromDate) \nTo = \(toDate)")
        
        self.showFitnessLoader(msg: "", type: 2)

        let scoreQuery = AktivoScoreQuery(fromDate: fromDate.yesterdayDate, toDate:
            toDate.yesterdayDate)
        Aktivo.query(scoreQuery){ (result, error) in
            self.hidePleaseWait()
            
            var modelArray = [ScoreModel]()
            
            if error == nil  {
                //var tempScoreData = Dictionary<Date, AktivoDailyScore>()
                
                if chartType == 1 {
                    self.barDateArray.removeAll()
                    self.barScoreArray.removeAll()
                    self.barScoreData.removeAll()
                    self.barScoreData = result ?? Dictionary<Date, AktivoDailyScore>()
                    self.weeksArray.removeAll()
                    modelArray.removeAll()
                    
                    let resultsSorted = self.barScoreData.sorted(by: { ($0.key) < ($1.key)})
                    
                    //Start new
                    var startFromDate = fromDate.yesterdayDate
                    let toEndDate = toDate.yesterdayDate
                    while startFromDate <= toEndDate {
                        print("DATE == \(startFromDate.getSimpleDate())")
                        
                        let foundObj = self.barScoreData.filter{($0.key.getSimpleDate() == startFromDate.getSimpleDate())}
                        
                        
                        let components = NSCalendar.current.dateComponents([.day,.month,.year,.weekday],from:startFromDate)
                        if let day = components.day {
                            print("Date = \(day),")
                            self.barDateArray.append(Double(day))
                            
                        }
                        
                        if foundObj.count != 0 {
                            
                            for scoreObj in resultsSorted {
                                if scoreObj.key.getSimpleDate() == startFromDate.getSimpleDate() {
                                    self.barScoreArray.append(scoreObj.value.score.rounded())
                                    self.weeksArray.append(scoreObj.key.getSimpleDate().getDateYMD().getDayUTC())
                                    break
                                }
                                
                            }
                            
                            print("FOUND = \(foundObj)")
                        }
                        else {
                            print("NOT FOUND")
                            self.barScoreArray.append(0.0)
                            
                        }
                        
                        startFromDate = startFromDate.dayAfter
                        
                    }
                    //End
                    
                    //                    for score in resultsSorted { //BAR
                    //                        let key = score.key
                    //                        let value = score.value
                    //
                    //                        //Create Model
                    //                        print(score.key)
                    //                        print(score.value)
                    //                        let obj = ScoreModel.init(date: key, scoreModel: value)
                    //                        modelArray.append(obj)
                    //
                    //                        //Access Line Date array
                    //
                    //
                    //                        let components = NSCalendar.current.dateComponents([.day,.month,.year,.weekday],from:key)
                    //                        if let day = components.day {
                    //                            print("Date = \(day),")
                    //                            self.barDateArray.append(Double(day))
                    //
                    //                            self.weeksArray.append(key.getSimpleDate().getDateYMD().getDayUTC())
                    //                            print("Day = \(key.getDay())")
                    //                            print(components.weekday)
                    //
                    //                        }
                    //                       // self.barScoreArray.append(value.score.rounded())
                    //
                    //                    } //for
                    
                    print("count = \(modelArray.count)")
                    print(self.barDateArray)
                    print(self.barScoreArray)
                    print(self.weeksArray)
                    
                    let sum = self.barScoreArray.reduce(0, +)
                    let avg = (sum / Double(self.barScoreArray.count)).rounded(toPlaces: 2)
                    
                    self.weeksArray = self.weeksArray1
                    self.updateBarChart(forX: self.barDateArray, forY: self.barScoreArray, avgLine: avg)
                    
                }
                else {
                    self.lineScoreArray.removeAll()
                    self.lineDateArray.removeAll()
                    self.lineScoreData = result ?? Dictionary<Date, AktivoDailyScore>()
                    
                    let resultsSorted = self.lineScoreData.sorted(by: { ($0.key) < ($1.key)})
                    
                    
                    for score in resultsSorted { //LINE
                        let key = score.key
                        let value = score.value
                        
                        //Create Model
                        print(score.key)
                        print(score.value)
                        let obj = ScoreModel.init(date: key, scoreModel: value)
                        modelArray.append(obj)
                        
                        //Access Line Date array
                        
                        let components = NSCalendar.current.dateComponents([.day,.month,.year],from:key)
                        if let day = components.day {
                            
                            print("Day = \(day)")
                            self.lineDateArray.append(Double(day))
                        }
                        
                        self.lineScoreArray.append(value.score)
                        
                    } //for
                    
                    print("count = \(modelArray.count)")
                    self.updateLineChart(forXAxis:self.lineDateArray,forYAxis:self.lineScoreArray, avgLine: 0.0)
                }
                
                
            }
            else {
                self.hidePleaseWait()
                
                print("Failed to get Score weekly")
                self.barDateArray.removeAll()
                self.barScoreArray.removeAll()
                self.updateBarChart(forX: self.barDateArray, forY: self.barScoreArray, avgLine: 0)
                
                // self.updateLineChart(forXAxis:self.lineDateArray,forYAxis:self.lineScoreArray)
            }
            
        }
    }
    
    //MARK:- Get Weekly STEPS
    private func getStepsData(fromDate:Date,toDate:Date,chartType:Int) { //chartType = 1/2
        //From first date of month
        print("#.....Get Weekly Steps.....\nFrom=\(fromDate) \nTo = \(toDate)")
        
        self.showFitnessLoader(msg: "", type: 2)

        let stepQuery = AktivoStepQuery(fromDate: fromDate, toDate:
            toDate)
        Aktivo.query(stepQuery){ (result, error) in
            self.hidePleaseWait()
            
            var modelArray = [ScoreModel]()
            
            if error == nil  {
               // var tempScoreData = Dictionary<Date, AktivoDailyScore>()
                
                if chartType == 1 {
                    self.barDateArray.removeAll()
                    self.barStepArray.removeAll()
                    self.barStepData.removeAll()
                    self.barStepData = result ?? Dictionary<Date, AktivoDailyStep>()
                    self.weeksArray.removeAll()
                    modelArray.removeAll()
                    
                    let resultsSorted = self.barStepData.sorted(by: { ($0.key) < ($1.key)})
                    
                    
                    //Start new
                    var startFromDate = fromDate
                    let toEndDate = toDate.dayAfter
                    while startFromDate < toEndDate {
                        print("DATE == \(startFromDate.getSimpleDate())")
                        
                        let foundObj = self.barStepData.filter{($0.key.getSimpleDate() == startFromDate.getSimpleDate())}
                        
                        
                        let components = NSCalendar.current.dateComponents([.day,.month,.year,.weekday],from:startFromDate)
                        if let day = components.day {
                            print("Date = \(day),")
                            self.barDateArray.append(Double(day))
                            
                        }
                        
                        if foundObj.count != 0 {
                            
                            for scoreObj in resultsSorted {
                                if scoreObj.key.getSimpleDate() == startFromDate.getSimpleDate() {
                                    self.barStepArray.append(Double(scoreObj.value.stepCount))
                                    self.weeksArray.append(scoreObj.key.getSimpleDate().getDateYMD().getDayUTC())
                                    break
                                }
                                
                            }
                            
                            print("FOUND = \(foundObj)")
                        }
                        else {
                            print("NOT FOUND")
                            self.barStepArray.append(0.0)
                            
                        }
                        
                        startFromDate = startFromDate.dayAfter
                        
                    }
                    //End
                    
                    
                    
                    //                    for score in resultsSorted { //BAR
                    //                        var key = score.key
                    //                        var value = score.value
                    //
                    //                        //Create Model
                    //                        print(score.key)
                    //                        print(score.value)
                    //                        //let obj = ScoreModel.init(date: key, scoreModel: value)
                    //                        //modelArray.append(obj)
                    //
                    //                        //Access Line Date array
                    //
                    //                        let components = NSCalendar.current.dateComponents([.day,.month,.year],from:key)
                    //                        if let day = components.day {
                    //                            print("Date = \(day)")
                    //                            self.barDateArray.append(Double(day))
                    //                            //self.weeksArray.append(key.getDay())
                    //                            self.weeksArray.append(key.getSimpleDate().getDateYMD().getDay())
                    //
                    //                            print("Day = \(key.getDay())")
                    //
                    //                        }
                    //
                    //                        self.barStepArray.append(Double(value.stepCount).rounded(toPlaces: 0))
                    //
                    //                    } //for
                    
                    print("count = \(modelArray.count)")
                    print(self.barDateArray)
                    print(self.barStepArray)
                    print(self.weeksArray)
                    
                    let sum = self.barStepArray.reduce(0, +)
                    let avg = (sum / Double(self.barStepArray.count)).rounded(toPlaces: 0)
                    self.weeksArray = self.weeksArray1
                    self.updateBarChart(forX: self.barDateArray, forY: self.barStepArray, avgLine: avg.rounded(toPlaces: 0))
                    
                }
                else {
                    
                }
                
                
            }
            else {
                self.hidePleaseWait()
                
                print("Failed to get Weekly Steps")
                self.barDateArray.removeAll()
                self.barStepArray.removeAll()
                self.updateBarChart(forX: self.barDateArray, forY: self.barStepArray, avgLine: 0)
                self.barChartView.noDataText = "No Data Found"
                
            }
            
        }
    }
    
    //MARK:- Get Monthly Steps
    private func getSteps(month:Int,year:Int) {
        print("#getSteps..")
        
        if (isConnectedToNet()) {
            self.showFitnessLoader(msg: "", type: 2)

            let dateStr = String(format: "%@-%@-%@", "01",String(month),String(year))
            let selectedMonthStartDate = dateStr.getDate()
            
            var toDate = selectedMonthStartDate.endOfMonth().dayAfter
            if month == currentMonth {
                
                let requestedComponents: Set<Calendar.Component> = [
                    .year,
                    .month,
                    .day
                ]
                
                let toDateComponents = Calendar.current.dateComponents(requestedComponents, from: Date())
                let toDateFinal = Calendar.current.date(from: DateComponents(calendar: Calendar.current, year:toDateComponents.year, month:toDateComponents.month, day:toDateComponents.day))!
                toDate = toDateFinal

            }
            // toDate = Date()
            let fromDate = selectedMonthStartDate  // 01-11-2019
            
            //From first date of month
            print("#.....Get Monthly Steps.....\nFrom=\(fromDate) \nTo = \(toDate)")
            
            
            let stepQuery = AktivoStepQuery(fromDate: fromDate.yesterdayDate, toDate:
                toDate)
            Aktivo.query(stepQuery){ (result, error) in
                self.hidePleaseWait()
                
                self.lineStepArray.removeAll()
                self.lineDateArray.removeAll()
                
                
                if error == nil  {
                    
                    self.lineStepData = result ?? Dictionary<Date, AktivoDailyStep>()
                    let resultsSorted = self.lineStepData.sorted(by: { ($0.key) < ($1.key)})
                
                    print(resultsSorted)
                    
                    //start new
                    var startFromDate = fromDate
                    
                    var toEndDate = toDate
                    if month == self.currentMonth {
                        toEndDate = toEndDate.dayAfter
                    }
                    
                    
                    while startFromDate < toEndDate {
                        print("DATE == \(startFromDate.getSimpleDate())")
                        
                        let foundObj = self.lineStepData.filter{($0.key.getSimpleDate() == startFromDate.getSimpleDate())}
                        
                        
                        let components = NSCalendar.current.dateComponents([.day,.month,.year,.weekday],from:startFromDate)
                        if let day = components.day {
                            print("Date = \(day),")
                            self.lineDateArray.append(Double(day))
                        }
                        
                        if foundObj.count != 0 {
                            
                            for scoreObj in resultsSorted {
                                if scoreObj.key.getSimpleDate() == startFromDate.getSimpleDate() {
                                    self.lineStepArray.append(Double(scoreObj.value.stepCount).rounded(toPlaces: 2))
                                    break
                                }
                                
                            }
                            
                            print("FOUND = \(foundObj)")
                        }
                        else {
                            print("NOT FOUND")
                            self.lineStepArray.append(0.0)
                            
                        }
                        
                        startFromDate = startFromDate.dayAfter
                        
                    }
                    //end new
                    
                    //                for score in resultsSorted {
                    //                    var key = score.key
                    //                    var value = score.value
                    //
                    //                    //Create Model
                    //                    print(score.key)
                    //                    print(score.value)
                    //
                    //
                    //                    //Access Line Date array
                    //
                    //                    let components = NSCalendar.current.dateComponents([.day,.month,.year],from:key)
                    //                    if let day = components.day {
                    //                        //let dayString = "\(day)"
                    //                        //let monthString = "\(month)"
                    //                        //let yearString = "\(year)"
                    //                        print("Day = \(day)")
                    //                        self.lineDateArray.append(Double(day))
                    //                    }
                    //
                    //                    self.lineStepArray.append(Double(value.stepCount))
                    //
                    //                } //for
                    
                    self.updateLineChart(forXAxis:self.lineDateArray,forYAxis:self.lineStepArray, avgLine: 0.0)
                    
                    
                    //For Network Graph
//                    var stepNetArray = [Int]()
//                    stepNetArray.append(networkScoreModelObj.percentile10?.steps ?? 0)
//                    stepNetArray.append(networkScoreModelObj.average?.steps ?? 0)
//                    stepNetArray.append(networkScoreModelObj.percentile90?.steps ?? 0)
//
//                    let sum = self.lineStepArray.reduce(0, +)
//                    let monthAvg = (sum / Double(self.lineStepArray.count)).rounded()
//                    stepNetArray.append(Int(monthAvg))
//
//                    var weekAvg = 0.0
//                    if self.barStepArray.count > 0 {
//                        let weekSum = self.barStepArray.reduce(0, +)
//                        weekAvg = (weekSum / Double(self.barStepArray.count)).rounded()
//
//                        stepNetArray.append(Int(weekAvg))
//                    }
//
//
//
//                    print(stepNetArray)
//
//                    var youSteps = 0
//                    if aktivoTodaysStepObj != nil {
//                        youSteps = aktivoTodaysStepObj!.stepCount
//                        stepNetArray.append(Int(youSteps))
//                    }
//                    let min = stepNetArray.min()
//                    let max = stepNetArray.max()
                    
                    // self.updateNetworkGraph(youN: "584", youWeek: weekAvg.description , userBottomN: networkScoreModelObj.percentile10?.steps?.description ?? "0", yourNetworkN: networkScoreModelObj.average?.steps?.description ?? "0", usersTopN: networkScoreModelObj.percentile90?.steps?.description ?? "0", monthAgoN: monthAvg.description , min: min ?? 0, max: max ?? 100)
                    
//                    self.updateNetworkGraph(youN: self.getPercentStr(value: Double(youSteps), max: Double(max!)), youWeek: self.getPercentStr(value: Double(weekAvg), max: Double(max!))
//                        , userBottomN:self.getPercentStr(value: Double(networkScoreModelObj.percentile10?.steps ?? Int(0.0)), max: Double(max!)), yourNetworkN: self.getPercentStr(value:Double(networkScoreModelObj.average?.steps ?? Int(0.0)), max: Double(max!)), usersTopN: self.getPercentStr(value:Double(networkScoreModelObj.percentile90?.steps ?? Int(0.0)), max: Double(max!)),
//                          monthAgoN: self.getPercentStr(value: monthAvg, max: Double(max!)),min: min ?? 0,max: max ?? 100)
//
                    
                }
                else {
                    self.hidePleaseWait()
                    
                    print("Failed to get Steps Weekly")
                    self.lineDateArray.removeAll()
                    self.lineStepArray.removeAll()
                    self.updateLineChart(forXAxis:self.lineDateArray,forYAxis:self.lineStepArray, avgLine: 0.0)
                }
                
            }
            
        }
    }
    
    //MARK:- Get Weekly Sleep
    private func getSleepData(fromDate:Date,toDate:Date,chartType:Int) { //chartType = 1/2
        //From first date of month
        print("#.....Get Weekly Sleep.....\nFrom=\(fromDate) \nTo = \(toDate)")
        
        self.showFitnessLoader(msg: "", type: 2)

        let sleepQuery = AktivoSleepQuery(fromDate: fromDate, toDate:
            toDate)
        Aktivo.query(sleepQuery){ (result, error) in
            self.hidePleaseWait()
            
            var secondsArray = [Int]()
            if error == nil  {
                
                if chartType == 1 {
                    self.barDateArray.removeAll()
                    self.barSleepArray.removeAll()
                    self.barSleepData = result ?? Dictionary<Date, AktivoDailySleep>()
                    self.weeksArray.removeAll()
                    
                    let resultsSorted = self.barSleepData.sorted(by: { ($0.key) < ($1.key)})
                    
                    //Start new
                    var startFromDate = fromDate
                    let toEndDate = toDate.dayAfter
                    while startFromDate < toEndDate {
                        print("DATE == \(startFromDate.getSimpleDate())")
                        
                        let foundObj = self.barSleepData.filter{($0.key.getSimpleDate() == startFromDate.getSimpleDate())}
                        
                        
                        let components = NSCalendar.current.dateComponents([.day,.month,.year,.weekday],from:startFromDate)
                        if let day = components.day {
                            print("Date = \(day),")
                            self.barDateArray.append(Double(day))
                            
                        }
                        
                        if foundObj.count != 0 {
                            
                            for scoreObj in resultsSorted {
                                if scoreObj.key.getSimpleDate() == startFromDate.getSimpleDate() {
                                    
                                    //var timeStr = Double(scoreObj.value.statTotal.timeInBed).asString(style: .positional)
                                    
                                    var timeStr = self.getMin(seconds: Double(scoreObj.value.statTotal.timeInBed))
                                    
                                    secondsArray.append(scoreObj.value.statTotal.timeInBed)
                                    if timeStr.contains(":") {
                                        timeStr = timeStr.replace(string: ":", replacement: ".")
                                        
                                    }
                                    else {
                                        timeStr = String(format: "0.%@", timeStr)
                                    }
                                    //print(timeStr)
                                    //print(Double(timeStr))
                                    self.barSleepArray.append(Double(timeStr) ?? 0)
                                    
                                    self.weeksArray.append(scoreObj.key.getSimpleDate().getDateYMD().getDayUTC())
                                    break
                                }
                                
                            }
                            
                            print("FOUND = \(foundObj)")
                        }
                        else {
                            print("NOT FOUND")
                            self.barSleepArray.append(0.0)
                            
                        }
                        
                        startFromDate = startFromDate.dayAfter
                        
                    }
                    //End
                    
                    
                    //                    for score in resultsSorted { //BAR
                    //                        var key = score.key
                    //                        var value = score.value
                    //
                    //                        //Create Model
                    //                        print(score.key)
                    //                        print(score.value)
                    //                        //let obj = ScoreModel.init(date: key, scoreModel: value)
                    //                        //modelArray.append(obj)
                    //
                    //                        //Access Line Date array
                    //
                    //                        let components = NSCalendar.current.dateComponents([.day,.month,.year],from:key)
                    //                        if let day = components.day {
                    //                            print("Date = \(day)")
                    //                            self.barDateArray.append(Double(day))
                    //                           // self.weeksArray.append(key.getDay())
                    //                            self.weeksArray.append(key.getSimpleDate().getDateYMD().getDayUTC())
                    //
                    //                            print("Day = \(key.getDay())")
                    //
                    //                        }
                    //
                    //                        var timeStr = Double(score.value.statTotal.timeInBed).asString(style: .positional)
                    //                        if timeStr.contains(":") {
                    //                            timeStr = timeStr.replace(string: ":", replacement: ".")
                    //                        }
                    //                        else {
                    //                            timeStr = String(format: "0.%@", timeStr)
                    //                        }
                    //                        print(timeStr)
                    //                        self.barSleepArray.append(Double(timeStr)?.rounded(toPlaces: 2) ?? 0)
                    //
                    //
                    //
                    //                    } //for
                    
                    
                    
                    print(self.barDateArray)
                    print(self.barSleepArray)
                    print(self.weeksArray)
                    
                    let sum = secondsArray.reduce(0, +)
                    let avg = (Double(sum) / Double(secondsArray.count)).rounded(toPlaces: 2)
                    
                    var timeStr = self.getMin(seconds: Double(avg))
                    
                    if timeStr.contains(":") {
                        timeStr = timeStr.replace(string: ":", replacement: ".")
                    }
                    else {
                        timeStr = String(format: "0.%@", timeStr)
                    }
                    
                    self.weeksArray = self.weeksArray1
                    self.updateBarChart(forX: self.barDateArray, forY: self.barSleepArray, avgLine: Double(timeStr) ?? 0)
                    
                    
                    
                }
                else {
                    
                }
                
                
            }
            else {
                self.hidePleaseWait()
                
                print("Failed to get Sleep Data Weekly")
                //print(error)
                self.updateBarChart(forX: self.barDateArray, forY: self.barSleepArray, avgLine: 0)
            }
            
        }
    }
    
    //MARK:- get min
    func getMin(seconds:Double) -> String {
        //int hours = (int) seconds / 3600;
        
        if !(seconds.isNaN) {
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
            str = String(format: "%@:%@", String(hrs.description),String(mins.description))
        }
        else {
            str = String(format: "0:%@",String(mins.description))
        }
        print(str)
        return str
        }
        else {
            return "0"
        }
    }
    
    func getMinInInt(seconds:Double) -> Int {
        //int hours = (int) seconds / 3600;
        if !(seconds.isNaN) {

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
            str = String(format: "%@.%@", String(hrs.description),String(mins.description))
        }
        else {
            str = String(format: "0.%@",String(mins.description))
        }
        
        let doubleSleep = (Double(str))!
      //  return doubleSleep.rounded(toPlaces: 2)
        return Int(doubleSleep)
        }
        else {
            return 0
        }
        
    }
    
    //MARK:- Get Sleep Monthly
    private func getSleeps(month:Int,year:Int) { //line chart sleep
        print("#getSleepMonthly..")
        
        if (isConnectedToNet()) {
            self.showFitnessLoader(msg: "", type: 2)

            let dateStr = String(format: "%@-%@-%@", "01",String(month),String(year))
            let selectedMonthStartDate = dateStr.getDate()
            
            var toDate = selectedMonthStartDate.endOfMonth().dayAfter
            if month == currentMonth {
                let requestedComponents: Set<Calendar.Component> = [
                    .year,
                    .month,
                    .day
                ]
                
                let toDateComponents = Calendar.current.dateComponents(requestedComponents, from: Date())
                let toDateFinal = Calendar.current.date(from: DateComponents(calendar: Calendar.current, year:toDateComponents.year, month:toDateComponents.month, day:toDateComponents.day))!
                toDate = toDateFinal
                
            }
            // toDate = Date()
            let fromDate = selectedMonthStartDate  // 01-11-2019
            
            //From first date of month
            print("#.....Get Monthly Sleeps.....\nFrom=\(fromDate) \nTo = \(toDate)")
            
            
            let sleepQuery = AktivoSleepQuery(fromDate: fromDate, toDate:
                toDate)
            Aktivo.query(sleepQuery){ (result, error) in
                self.hidePleaseWait()
                
                self.lineSleepArray.removeAll()
                self.lineDateArray.removeAll()
                var secondsArray = [Int]()
                if error == nil  {
                    
                    self.lineSleepData = result ?? Dictionary<Date, AktivoDailySleep>()
                    let resultsSorted = self.lineSleepData.sorted(by: { ($0.key) < ($1.key)})
                    
                    //start new
                    var startFromDate = fromDate
                    
                    
                    var toEndDate = toDate
                    if month == self.currentMonth {
                        toEndDate = toEndDate.dayAfter
                    }
                    
                    while startFromDate < toEndDate {
                        print("DATE == \(startFromDate.getSimpleDate())")
                        
                        let foundObj = self.lineSleepData.filter{($0.key.getSimpleDate() == startFromDate.getSimpleDate())}
                        
                        
                        let components = NSCalendar.current.dateComponents([.day,.month,.year,.weekday],from:startFromDate)
                        if let day = components.day {
                            print("Date = \(day),")
                            self.lineDateArray.append(Double(day))
                        }
                        
                        if foundObj.count != 0 {
                            
                            for scoreObj in resultsSorted {
                                if scoreObj.key.getSimpleDate() == startFromDate.getSimpleDate() {
                                    
                                    //var timeStr = Double(scoreObj.value.statTotal.timeInBed).asString(style: .positional)
                                    
                                    var timeStr = self.getMin(seconds: Double(scoreObj.value.statTotal.timeInBed))
                                    
                                    
                                    print(timeStr)
                                    if timeStr.contains(":") {
                                        timeStr = timeStr.replace(string: ":", replacement: ".")
                                    }
                                    else {
                                        timeStr = String(format: "0.%@", timeStr)
                                    }
                                    print(timeStr)
                                    self.lineSleepArray.append(Double(timeStr) ?? 0)
                                    secondsArray.append(scoreObj.value.statTotal.timeInBed)
                                    break
                                }
                                
                            }
                            
                            print("FOUND = \(foundObj)")
                        }
                        else {
                            print("NOT FOUND")
                            self.lineSleepArray.append(0.0)
                            
                        }
                        
                        startFromDate = startFromDate.dayAfter
                        
                    }
                    //end new
                    
                    
                    //                    for score in resultsSorted {
                    //                        var key = score.key
                    //                        var value = score.value
                    //
                    //                        //Create Model
                    //                        print(score.key)
                    //                        print(score.value)
                    //
                    //
                    //                        //Access Line Date array
                    //
                    //                        let components = NSCalendar.current.dateComponents([.day,.month,.year],from:key)
                    //                        if let day = components.day {
                    //                            //let dayString = "\(day)"
                    //                            //let monthString = "\(month)"
                    //                            //let yearString = "\(year)"
                    //                            print("Day = \(day)")
                    //                            self.lineDateArray.append(Double(day))
                    //                        }
                    //                        var timeStr = Double(score.value.statTotal.timeInBed).asString(style: .positional)
                    //                        print(timeStr)
                    //                        if timeStr.contains(":") {
                    //                        timeStr = timeStr.replace(string: ":", replacement: ".")
                    //                        }
                    //                        else {
                    //                            timeStr = String(format: "0.%@", timeStr)
                    //                        }
                    //                        print(timeStr)
                    //                        self.lineSleepArray.append(Double(timeStr)?.rounded(toPlaces: 2) ?? 0)
                    //
                    //                    } //for
                    
                    //Calculate avg
                    let sumSec = secondsArray.reduce(0, +)
                    let avgSec = (Double(sumSec) / Double(secondsArray.count)).rounded(toPlaces: 2)
                    
                    var timeStr = self.getMin(seconds: Double(avgSec))
                    
                    if timeStr.contains(":") {
                        timeStr = timeStr.replace(string: ":", replacement: ".")
                    }
                    else {
                        timeStr = String(format: "0.%@", timeStr)
                    }

                    
                    self.updateLineChart(forXAxis:self.lineDateArray,forYAxis:self.lineSleepArray, avgLine: Double(timeStr) ?? 0)
                    
                    
                    //For Network Graph
                    //var sleepNetArray = [Int]()
                    
                    //                    sleepNetArray.append(networkScoreModelObj.percentile10?.sleep ?? 0)
                    //                    sleepNetArray.append(networkScoreModelObj.average?.sleep ?? 0)
                    //                    sleepNetArray.append(networkScoreModelObj.percentile90?.sleep ?? 0)
                    //
//                    sleepNetArray.append(self.getMinInInt(seconds: Double(networkScoreModelObj.percentile10?.sleep ?? 0)))
//                    sleepNetArray.append(self.getMinInInt(seconds: Double(networkScoreModelObj.average?.sleep ?? 0)))
//                    sleepNetArray.append(self.getMinInInt(seconds: Double(networkScoreModelObj.percentile90?.sleep ?? 0)))
//
//                    let sum = self.lineSleepArray.reduce(0, +)
//                    let monthAvg = (sum / Double(self.lineSleepArray.count)).rounded()
//                    sleepNetArray.append(Int(monthAvg))
//
//                    var weekAvg = 0.0
//                    if self.barSleepArray.count > 0 {
//                        let weekSum = self.barSleepArray.reduce(0, +)
//                        weekAvg = (weekSum / Double(self.barSleepArray.count)).rounded()
//
//
//                        sleepNetArray.append(Int(weekAvg))
//                    }
//
//
//
//
//                    print(sleepNetArray)
                    // self.updateNetworkGraph(youN: "584", youWeek: weekAvg.description , userBottomN: networkScoreModelObj.percentile10?.sleep?.description ?? "0", yourNetworkN: networkScoreModelObj.average?.sleep?.description ?? "0", usersTopN: networkScoreModelObj.percentile90?.sleep?.description ?? "0", monthAgoN: monthAvg.description , min: min ?? 0, max: max ?? 100)
                    
                    
//                    var youSleep = 0
//                    if aktivoTodaysSleepObj != nil {
//
//                        //youSleep = getMin(seconds: Double((aktivoTodaysSleepObj?.statTotal.timeInBed)!).rounded()
//
//                        youSleep = self.getMinInInt(seconds: Double(aktivoTodaysSleepObj?.statTotal.timeInBed ?? Int(0.0)))
//
//                        sleepNetArray.append(Int(youSleep))
//                    }
//
//
//                    let min = sleepNetArray.min()
//                    let max = sleepNetArray.max()
//
//                    print(sleepNetArray)
//                    self.updateNetworkGraph(youN: self.getPercentStr(value: Double(youSleep), max: Double(max!)), youWeek: self.getPercentStr(value: Double(weekAvg), max: Double(max!))
//                        , userBottomN:self.getPercentStr(value: Double(self.getMinInInt(seconds: Double(networkScoreModelObj.percentile10?.sleep ?? 0))), max: Double(max!)),
//                          yourNetworkN: self.getPercentStr(value: Double(self.getMinInInt(seconds: Double(networkScoreModelObj.average?.sleep ?? 0))), max: Double(max!)),
//                          usersTopN: self.getPercentStr(value: Double(self.getMinInInt(seconds: Double(networkScoreModelObj.percentile90?.sleep ?? 0))), max: Double(max!)),
//                          monthAgoN: self.getPercentStr(value: monthAvg, max: Double(max!)),
//                          min: min ?? 0,
//                          max: max ?? 100)
                    
                    
                    
                    
                }
                else {
                    self.hidePleaseWait()
                    
                    print("Failed to get Sleep Monthly")
                    print(error)
                    self.lineDateArray.removeAll()
                    self.lineSleepArray.removeAll()
                    self.updateLineChart(forXAxis:self.lineDateArray,forYAxis:self.lineSleepArray, avgLine: 0.0)
                }
                
            }
            
        }
    }
    
    
    //MARK:-Get HeartRate Weekly
    private func getHeartRateData(fromDate:Date,toDate:Date,chartType:Int) { //chartType = 1/2
        //From first date of month
        print("#.....Get Weekly Heart Rate.....\nFrom=\(fromDate) \nTo = \(toDate)")
        
        self.showFitnessLoader(msg: "", type: 2)

        let heartRateQuery = AktivoHeartRateQuery(fromDate: fromDate, toDate:
            toDate)
        Aktivo.query(heartRateQuery){ (result, error) in
            self.hidePleaseWait()
            
            
            if error == nil  {
                
                if chartType == 1 {
                    self.barDateArray.removeAll()
                    self.barHeartRateArray.removeAll()
                    self.barHeartRateData = result ?? Dictionary<Date, AktivoDailyHeartRate>()
                    self.weeksArray.removeAll()
                    
                    let resultsSorted = self.barHeartRateData.sorted(by: { ($0.key) < ($1.key)})
                    
                    print(resultsSorted)
                    
                    //Start new
                    var startFromDate = fromDate
                    let toEndDate = toDate.dayAfter
                    while startFromDate < toEndDate {
                        print("DATE == \(startFromDate.getSimpleDate())")
                        
                        let foundObj = self.barHeartRateData.filter{($0.key.getSimpleDate() == startFromDate.getSimpleDate())}
                        
                        
                        let components = NSCalendar.current.dateComponents([.day,.month,.year,.weekday],from:startFromDate)
                        if let day = components.day {
                            print("Date = \(day),")
                            self.barDateArray.append(Double(day))
                            
                        }
                        
                        if foundObj.count != 0 {
                            
                            for scoreObj in resultsSorted {
                                if scoreObj.key.getSimpleDate() == startFromDate.getSimpleDate() {
                                    
                                    //self.barHeartRateArray.append(Double(scoreObj.value) ?? 0)
                                    let stringheartRate = scoreObj.value.description
                                    self.barHeartRateArray.append(Double(stringheartRate) as! Double)
                                    
                                    self.weeksArray.append(scoreObj.key.getSimpleDate().getDateYMD().getDayUTC())
                                    break
                                }
                                
                            }
                            
                            print("FOUND = \(foundObj)")
                        }
                        else {
                            print("NOT FOUND")
                            self.barHeartRateArray.append(0.0)
                            
                        }
                        
                        startFromDate = startFromDate.dayAfter
                        
                    }
                    //End
                    
                    print(self.barDateArray)
                    print(self.barHeartRateArray)
                    print(self.weeksArray)
                    
                    let sum = self.barHeartRateArray.reduce(0, +)
                    let avg = (sum / Double(self.barHeartRateArray.count)).rounded(toPlaces: 2)
                    
                    self.updateBarChart(forX: self.barDateArray, forY: self.barHeartRateArray, avgLine: avg.rounded(toPlaces: 2))
                    
                }
                else {
                    //for Line chart
                    self.lineDateArray.removeAll()
                    self.lineHeartRateArray.removeAll()
                    
                    self.updateLineChart(forXAxis: self.lineDateArray, forYAxis: self.lineHeartRateArray, avgLine: 0.0)
                }
                
                
            }
            else {
                self.hidePleaseWait()
                
                print("Failed to get HeartRate weekly")
                self.barDateArray.removeAll()
                self.barHeartRateArray.removeAll()
                self.updateBarChart(forX: self.barDateArray, forY: self.barHeartRateArray, avgLine: 0)
                
            }
            
        }
    }
    
    //MARK:-Get HeartRate Monthly
    private func getHeartRates(month:Int,year:Int) {
        print("#getHeartRate Monthly..")
        
        if (isConnectedToNet()) {
            self.showFitnessLoader(msg: "", type: 2)

            let dateStr = String(format: "%@-%@-%@", "01",String(month),String(year))
            let selectedMonthStartDate = dateStr.getDate()
            
            var toDate = selectedMonthStartDate.endOfMonth().dayAfter
            if month == currentMonth {
                toDate = Date()
            }
            // toDate = Date()
            let fromDate = selectedMonthStartDate  // 01-11-2019
            
            //From first date of month
            print("#.....Get Monthly HeartRate.....\nFrom=\(fromDate) \nTo = \(toDate)")
            
            
            let HRQuery = AktivoHeartRateQuery(fromDate: fromDate.yesterdayDate, toDate:
                toDate)
            Aktivo.query(HRQuery){ (result, error) in
                self.hidePleaseWait()
                
                self.lineHeartRateArray.removeAll()
                self.lineDateArray.removeAll()
                
                if error == nil  {
                    
                    self.lineHeartRateData = result ?? Dictionary<Date, AktivoDailyHeartRate>()
                    let resultsSorted = self.lineHeartRateData.sorted(by: { ($0.key) < ($1.key)})
                    
                    //start new
                    var startFromDate = fromDate
                    let toEndDate = toDate
                    while startFromDate < toEndDate {
                        print("DATE == \(startFromDate.getSimpleDate())")
                        
                        let foundObj = self.lineHeartRateData.filter{($0.key.getSimpleDate() == startFromDate.getSimpleDate())}
                        
                        
                        let components = NSCalendar.current.dateComponents([.day,.month,.year,.weekday],from:startFromDate)
                        if let day = components.day {
                            print("Date = \(day),")
                            self.lineDateArray.append(Double(day))
                        }
                        
                        if foundObj.count != 0 {
                            
                            for scoreObj in resultsSorted {
                                if scoreObj.key.getSimpleDate() == startFromDate.getSimpleDate() {
                                    
                                   // self.lineHeartRateArray.append(75.0) //self.lineStepArray.append(Double(scoreObj.value.stepCount).rounded(toPlaces: 2))
                                    
                                    let stringheartRate = scoreObj.value.description
                                    self.lineHeartRateArray.append(Double(stringheartRate) as! Double)

                                    break
                                }
                                
                            }
                            
                            print("FOUND = \(foundObj)")
                        }
                        else {
                            print("NOT FOUND")
                            self.lineHeartRateArray.append(0.0)
                            
                        }
                        
                        startFromDate = startFromDate.dayAfter
                        
                    }
                    //end new
                    
                    
                    print(self.lineHeartRateArray)
                    self.updateLineChart(forXAxis:self.lineDateArray,forYAxis:self.lineHeartRateArray, avgLine: 0.0)
                    
                    
                    //For Network Graph
                    //                    var stepNetArray = [Int]()
                    //                    stepNetArray.append(networkScoreModelObj.percentile10?.steps ?? 0)
                    //                    stepNetArray.append(networkScoreModelObj.average?.steps ?? 0)
                    //                    stepNetArray.append(networkScoreModelObj.percentile90?.steps ?? 0)
                    //
                    //                    let sum = self.lineStepArray.reduce(0, +)
                    //                    let monthAvg = (sum / Double(self.lineStepArray.count)).rounded()
                    //                    stepNetArray.append(Int(monthAvg))
                    //
                    //                    var weekAvg = 0.0
                    //                    if self.barStepArray.count > 0 {
                    //                        let weekSum = self.barStepArray.reduce(0, +)
                    //                        weekAvg = (weekSum / Double(self.barStepArray.count)).rounded()
                    //
                    //                        stepNetArray.append(Int(weekAvg))
                    //                    }
                    //
                    //
                    //
                    //                    print(stepNetArray)
                    //
                    //                    var youSteps = 0
                    //                    if aktivoTodaysScoreObj != nil {
                    //                        youSteps = aktivoTodaysStepObj!.stepCount
                    //                        stepNetArray.append(Int(youSteps))
                    //                    }
                    //                    let min = stepNetArray.min()
                    //                    let max = stepNetArray.max()
                    
                    // self.updateNetworkGraph(youN: self.getPercentStr(value: Double(youSteps), max: Double(max!)), youWeek: self.getPercentStr(value: Double(weekAvg), max: Double(max!)), userBottomN:self.getPercentStr(value: Double(networkScoreModelObj.percentile10?.steps ?? Int(0.0)), max: Double(max!)), yourNetworkN: self.getPercentStr(value:Double(networkScoreModelObj.average?.steps ?? Int(0.0)), max: Double(max!)), usersTopN: self.getPercentStr(value:Double(networkScoreModelObj.percentile90?.steps ?? Int(0.0)), max: Double(max!)),monthAgoN: self.getPercentStr(value: monthAvg, max: Double(max!)),min: min ?? 0,max: max ?? 100)
                    
                    
                }
                else {
                    self.hidePleaseWait()
                    
                    print("Failed to get HeartRate Monthly")
                    self.lineDateArray.removeAll()
                    self.lineHeartRateArray.removeAll()
                    self.updateLineChart(forXAxis:self.lineDateArray,forYAxis:self.lineHeartRateArray, avgLine: 0.0)
                }
                
            }
            
        }
    }
    
    
    func getDayOfWeek(_ todayDate:Date) -> Int? {
        // let formatter  = DateFormatter()
        //formatter.dateFormat = "yyyy-MM-dd"
        // guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    //    subscript(index: Date) -> AktivoDailyScore {
    //        get {
    //            return scoreData[index]!
    //        }
    //        set(newValue) {
    //            self.scoreData[index] = newValue
    //        }
    //    }
    
    //MARK:- Menu Changed
    private func menuChanged() {
        weekChanged()
        monthChanged()
        
        switch topCollectioViewSelectedIndex {
        case 0: //SCORE
            getWeekAgoData(searchCase: "score")

            break
            
            
        case 1: //STEPS
        
            setStepNetwork()
            break
            
        case 2: //HEART RATE
            updateNetworkGraph(youN: "0", youWeek: "0", userBottomN: "0", yourNetworkN: "0", usersTopN: "0", monthAgoN: "0", min: 0,max: 100, youFinal: 0)
            break
        case 3: //SLEEP
           setSleepNetworkGraph()
            break
            
            
        default:
            break
        }
    }
    
    //MARK:- Week Changed - change middle msg
    private func weekChanged() {
        switch topCollectioViewSelectedIndex {
        case 0: //SCORE
            self.lblMidMsg.text = "Stay healthy with the Aktivo Score® as your daily guide. To score 80+ for good health, exercise for at least 30 minutes a day, sit for less than 8 hours a day, and sleep between 7 and 9 hours a day."
            
            let weekDates = getRangeDates(weekNo: String(selectedWeekIndex))
            getScoreData(fromDate: weekDates.start, toDate: weekDates.end, chartType: 1)
            
            
            break
            
        case 1: //STEPS
            self.lblMidMsg.text = "Taking more steps with walking increases your physical activity, reduces your sedentary behavior and improves your health and Aktivo Score"
            
            let weekDates = getRangeDates(weekNo: String(selectedWeekIndex))
            getStepsData(fromDate: weekDates.start, toDate: weekDates.end, chartType: 1)
            
            
            
            break
        case 2: //HEART RATE
            self.lblMidMsg.text = "The normal resting heart rate for adults is between 60 and 100 beats per minute. A lower heart rate at rest usually indicates a more efficient heart function and better cardiorespiratory fitness."
            
            
            let weekDates = getRangeDates(weekNo: String(selectedWeekIndex))
            getHeartRateData(fromDate: weekDates.start, toDate: weekDates.end, chartType: 1)
            
     
            
            break
        case 3: //SLEEP
            self.lblMidMsg.text = "Sleeping between 7 and 9 hours is important for your health and can have beneficial effects on your heart, metabolism and cognitive function."
            
            let weekDates = getRangeDates(weekNo: String(selectedWeekIndex))
            getSleepData(fromDate: weekDates.start, toDate: weekDates.end, chartType: 1)
            
            
            break
        default:
            break
        }
    }
    
    //MARK:- Month Changed
    private func monthChanged() {
        
        switch topCollectioViewSelectedIndex {
        case 0: //SCORE
            if currentMonth < selectedMonthIndex { //for previous months
                
                getScore(month: selectedMonthIndex, year: Date().year - 1)
//                if lineScoreData.count < 40 {
//                getYearScore(month:selectedMonthIndex,year: Date().year - 1)
//                }
//                else {
//                    let dateStr1 = String(format: "%@-%@-%@", "01",String(selectedMonthIndex),String(Date().year - 1))
//
//                    var startFromDate = dateStr1.getDate().yesterdayDate
//                    var toEndDate = startFromDate.endOfMonth()
//                                       if selectedMonthIndex == self.currentMonth {
//                                          toEndDate = Date()
//                                       }
//
//                    getMonthlyScoreNew(startFromDate: startFromDate, toEndDate: toEndDate)
//                }
            }
            else { //current year months
                
                getScore(month: selectedMonthIndex, year: Date().year)
            }
            break
            
        case 1: //STEPS
            if currentMonth < selectedMonthIndex { //for previous months
                getSteps(month: selectedMonthIndex, year: Date().year - 1)
            }
            else { //current year months
                getSteps(month: selectedMonthIndex, year: Date().year)
            }
            
            break

        case 2: //HEART RATE
            if currentMonth < selectedMonthIndex { //for previous months
                getHeartRates(month: selectedMonthIndex, year: Date().year - 1)
            }
            else { //current year months
                getHeartRates(month: selectedMonthIndex, year: Date().year)
            }

            break

        case 3: //SLEEP
            
            if currentMonth < selectedMonthIndex { //for previous months
                getSleeps(month: selectedMonthIndex, year: Date().year - 1)
            }
            else { //current year months
                getSleeps(month: selectedMonthIndex, year: Date().year)
            }
            
            break
            
        default:
            break
        }
    }
    
    //MARK:- Set Web View
    func setHtml(min:Int,max:Int) {
        print("set Html")
        let aktivoScore =  StatsHelper.sharedInstance.getHTMLText(you: you, youWeekAgo: youWeekAgo, usersBottom: usersBottom, yourNetwork: yourNetwork, usersTop: usersTop, youMonthAgo: youMonthAgo, min: min, max:max, youFinal: youFinalValue)
        
        self.webView.loadHTMLString(aktivoScore, baseURL: nil)
        
    }
    
    
    
}

extension StatsFitnessVC {
//Get WeekAgo Data And Month Ago Data
func getWeekAgoData(searchCase:String) {

    var weekAgo = 0.0
    var monthAgo = 0.0

    switch searchCase {
    case "score":
        
        self.showFitnessLoader(msg: "", type: 2)
        let weekAgoDate = Date().weekAgoDate.yesterdayDate
        let monthAgoDate = getMonthAgoDate().yesterdayDate
        
        print(monthAgoDate)
    
    let scoreQuery = AktivoScoreQuery(fromDate: weekAgoDate, toDate:
        weekAgoDate)
    Aktivo.query(scoreQuery){ (result, error) in
        //self.hidePleaseWait()
        
        if error == nil  {
            let scoreWeekAgo = result ?? Dictionary<Date, AktivoDailyScore>()
            let resultsSorted = scoreWeekAgo.sorted(by: { ($0.key) < ($1.key)})
            
            print("WEEK AGO =  \(resultsSorted)")
           // let foundObj = resultsSorted.filter{($0.key.getSimpleDate() == weekAgoDate.getSimpleDate())}

            
            if resultsSorted.count > 0 {
                 weekAgo = resultsSorted[0].value.score.rounded()
            }
        }
        
        
        //MonthAgo
        let scoreQueryMonth = AktivoScoreQuery(fromDate: monthAgoDate as Date, toDate:
            monthAgoDate as Date)
        Aktivo.query(scoreQueryMonth){ (result, error) in
            self.hidePleaseWait()

            if error == nil  {
                let scoreMonthAgo = result ?? Dictionary<Date, AktivoDailyScore>()
                let resultsSorted = scoreMonthAgo.sorted(by: { ($0.key) < ($1.key)})

                print("MONTH AGO Score=")
                print(resultsSorted)
               // let foundObj = resultsSorted.filter{($0.key.getSimpleDate() == weekAgoDate.getSimpleDate())}


                if resultsSorted.count > 0 {

                    monthAgo = resultsSorted[0].value.score.rounded()

                }
                else {
                    monthAgo = 0
                }
                
                //For Network Graph
                var scoreNetArray = [Int]()
                scoreNetArray.append(networkScoreModelObj.percentile10?.score ?? 0)
                scoreNetArray.append(networkScoreModelObj.average?.score ?? 0)
                scoreNetArray.append(networkScoreModelObj.percentile90?.score ?? 0)
                scoreNetArray.append(Int(weekAgo.rounded()))
                scoreNetArray.append(Int(monthAgo.rounded()))
                
                var youScore = 0
                if aktivoTodaysScoreObj != nil {
                    youScore = Int(aktivoTodaysScoreObj!.score.rounded())
                    scoreNetArray.append(Int(youScore))
                }
                
                
                let min = scoreNetArray.min()
                let max = scoreNetArray.max()
                
                print(scoreNetArray)
                self.updateNetworkGraph(youN: self.getPercentStr(value: Double(youScore), max: Double(max!),min: Double(min ?? 0)), youWeek: self.getPercentStr(value: weekAgo.rounded(), max: Double(max!),min: Double(min ?? 0)), userBottomN:self.getPercentStr(value: Double(networkScoreModelObj.percentile10?.score ?? Int(0.0)), max: Double(max!),min: Double(min ?? 0)), yourNetworkN: self.getPercentStr(value:Double(networkScoreModelObj.average?.score ?? Int(0.0)), max: Double(max!),min: Double(min ?? 0)), usersTopN: self.getPercentStr(value:Double(networkScoreModelObj.percentile90?.score ?? Int(0.0)), max: Double(max!),min: Double(min ?? 0)), monthAgoN: self.getPercentStr(value: monthAgo, max: Double(max!),min: Double(min ?? 0)),min: min ?? 0,max: max ?? 100, youFinal: youScore)
            }
        }
        
       
  
    }
    case "step":
      
        break
        
        
    default:
        break
    }
    }
    
   
    //MARK:- Get One Month Ago Date
    func getMonthAgoDate() -> Date {
        var todaysDate = Date()
        if currentMonth == 1 {
    
                let requestedComponents: Set<Calendar.Component> = [
                    .year,
                    .month,
                    .day]
            
            let toDateComponents = Calendar.current.dateComponents(requestedComponents, from: Date())
            todaysDate = Calendar.current.date(from: DateComponents(calendar: Calendar.current, year:(toDateComponents.year ?? Date().year) - 1, month:12, day:toDateComponents.day))!
            
            }
        
        else {
            let requestedComponents: Set<Calendar.Component> = [
                .year,
                .month,
                .day
            ]
            
            let toDateComponents = Calendar.current.dateComponents(requestedComponents, from: Date())
            todaysDate = Calendar.current.date(from: DateComponents(calendar: Calendar.current, year:toDateComponents.year, month:toDateComponents.month! - 1 ?? currentMonth - 1, day:toDateComponents.day))!
        }
        return todaysDate
    }
    
    //MARK:- GET STEP NETWORK
    func setStepNetwork() {
        let weekAgoDate = Date().weekAgoDate
        let monthAgoDate = getMonthAgoDate()
        
        
        var weekAgo = 0.0
        var monthAgo = 0.0
        
        self.showFitnessLoader(msg: "", type: 2)
        let stepQuery = AktivoStepQuery(fromDate: weekAgoDate, toDate:
            weekAgoDate)
        Aktivo.query(stepQuery){ (result, error) in
 //           self.hidePleaseWait()
            
            if error == nil  {
                let scoreWeekAgo = result ?? Dictionary<Date, AktivoDailyStep>()
                let resultsSorted = scoreWeekAgo.sorted(by: { ($0.key) < ($1.key)})
                
                print("WEEK AGO =  \(resultsSorted)")
                // let foundObj = resultsSorted.filter{($0.key.getSimpleDate() == weekAgoDate.getSimpleDate())}
                
                
                if resultsSorted.count > 0 {
                    weekAgo = Double(resultsSorted[0].value.stepCount)
                }
            }
            
            
            //MonthAgo
            let stepQueryMonth = AktivoStepQuery(fromDate: monthAgoDate as Date, toDate:
                monthAgoDate as Date)
            Aktivo.query(stepQueryMonth){ (result, error) in
                self.hidePleaseWait()
                
                if error == nil  {
                    let stepMonthAgo = result ?? Dictionary<Date, AktivoDailyStep>()
                    let resultsSortedStep = stepMonthAgo.sorted(by: { ($0.key) < ($1.key)})
                    
                   // let foundObj = resultsSorted.filter{($0.key.getSimpleDate() == weekAgoDate.getSimpleDate())}
                    
                    print("MONTH AGO Steps - ")
                    print(resultsSortedStep)
                    
                    if resultsSortedStep.count > 0 {
                        monthAgo = Double(resultsSortedStep[0].value.stepCount)
                    }
                        var stepNetArray = [Int]()
                        stepNetArray.append(networkScoreModelObj.percentile10?.steps ?? 0)
                        stepNetArray.append(networkScoreModelObj.average?.steps ?? 0)
                        stepNetArray.append(networkScoreModelObj.percentile90?.steps ?? 0)
                        stepNetArray.append(Int(weekAgo))
                        stepNetArray.append(Int(monthAgo))
                        
                        var youSteps = 0
                        if aktivoTodaysStepObj != nil {
                            youSteps = (Int?(aktivoTodaysStepObj?.stepCount ?? 0))!
                            stepNetArray.append(Int(youSteps))
                        }
                        else {
                    stepNetArray.append(Int(youSteps))
                    }
                            let min = stepNetArray.min()
                            let max = stepNetArray.max()
                            
                            print(stepNetArray)
                            self.updateNetworkGraph(youN: self.getPercentStr(value: Double(youSteps), max: Double(max!), min: Double(min ?? 0)), youWeek: self.getPercentStr(value: weekAgo.rounded(), max: Double(max!), min: Double(min ?? 0)), userBottomN:self.getPercentStr(value: Double(networkScoreModelObj.percentile10?.steps ?? Int(0.0)), max: Double(max!), min: Double(min ?? 0)), yourNetworkN: self.getPercentStr(value:Double(networkScoreModelObj.average?.steps ?? Int(0.0)), max: Double(max!), min: Double(min ?? 0)), usersTopN: self.getPercentStr(value:Double(networkScoreModelObj.percentile90?.steps ?? Int(0.0)), max: Double(max!), min: Double(min ?? 0)),monthAgoN: self.getPercentStr(value: monthAgo, max: Double(max!), min: Double(min ?? 0)),min: min ?? 0,max: max ?? 100, youFinal: youSteps)
                        }
                    
                
            }
            
            //For Network Graph

            
            
          
            
        }
    }
    
    //MARK:- Sleep Network
    private func setSleepNetworkGraph() {
        
        let weekAgoDate = Date().weekAgoDate
        let monthAgoDate = getMonthAgoDate()
        
        
        var weekAgo = 0.0
        var monthAgo = 0.0
        self.showFitnessLoader(msg: "", type: 2)
        let sleepQuery = AktivoSleepQuery(fromDate: weekAgoDate, toDate:
            weekAgoDate)
        Aktivo.query(sleepQuery){ (result, error) in
            //self.hidePleaseWait()
            
            if error == nil  {
                let sleepWeekAgo = result ?? Dictionary<Date, AktivoDailySleep>()
                let resultsSorted = sleepWeekAgo.sorted(by: { ($0.key) < ($1.key)})
                
                print("WEEK AGO Sleep =  \(resultsSorted)")
                
                if resultsSorted.count > 0 {
                    weekAgo = Double(self.getMinInInt(seconds: Double(resultsSorted[0].value.statTotal.timeInBed )))
                    
                    print("WeekAgoSleep-=\(weekAgo)")
                    
                }
            }
            
            
            //MonthAgo
            let sleepQueryMonth = AktivoSleepQuery(fromDate: monthAgoDate as Date, toDate:
                monthAgoDate as Date)
            Aktivo.query(sleepQueryMonth){ (result, error) in
                self.hidePleaseWait()
                
                if error == nil  {
                    let sleepMonthAgo = result ?? Dictionary<Date, AktivoDailySleep>()
                    let resultsSortedSleep = sleepMonthAgo.sorted(by: { ($0.key) < ($1.key)})
                    
                    print(resultsSortedSleep)
                    var sleepNetArray = [Int]()

                    if resultsSortedSleep.count > 0 {
                        monthAgo = Double(self.getMinInInt(seconds: Double(resultsSortedSleep[0].value.statTotal.timeInBed )))
                        
                        sleepNetArray.append(Int(monthAgo))
                        sleepNetArray.append(Int(weekAgo))

                        sleepNetArray.append(self.getMinInInt(seconds: Double(networkScoreModelObj.percentile10?.sleep ?? 0)))
                        sleepNetArray.append(self.getMinInInt(seconds: Double(networkScoreModelObj.average?.sleep ?? 0)))
                        sleepNetArray.append(self.getMinInInt(seconds: Double(networkScoreModelObj.percentile90?.sleep ?? 0)))
                    }
                        
                        var youSleep = 0.0
                        if aktivoTodaysSleepObj != nil {
                            youSleep = Double(self.getMinInInt(seconds: Double(aktivoTodaysSleepObj?.statTotal.timeInBed ?? 0)))
                        }
                            sleepNetArray.append(Int(youSleep))
                    
                    if sleepNetArray.count == 1 {
                        sleepNetArray.insert(0, at: 0)
                    }
                            let min = sleepNetArray.min()
                            let max = sleepNetArray.max()
                            
                            print(sleepNetArray)
                            
                            self.updateNetworkGraph(youN: self.getPercentStr(value: Double(youSleep), max: Double(max!),min: Double(min ?? 0)), youWeek: self.getPercentStr(value: Double(weekAgo), max: Double(max!),min: Double(min ?? 0))
                                , userBottomN:self.getPercentStr(value: Double(self.getMinInInt(seconds: Double(networkScoreModelObj.percentile10?.sleep ?? 0))), max: Double(max!),min: Double(min ?? 0)),
                                  yourNetworkN: self.getPercentStr(value: Double(self.getMinInInt(seconds: Double(networkScoreModelObj.average?.sleep ?? 0))), max: Double(max!),min: Double(min ?? 0)),usersTopN: self.getPercentStr(value: Double(self.getMinInInt(seconds: Double(networkScoreModelObj.percentile90?.sleep ?? 0))), max: Double(max!),min: Double(min ?? 0)),
                                  monthAgoN: self.getPercentStr(value: monthAgo, max: Double(max!),min: Double(min ?? 0)),min: Int(min ?? 0),max: Int(max ?? 15), youFinal: Int(youSleep))
                        }
                    
                
            }
        }
    } //setSleepNetworkGraph
    
    }

extension StatsFitnessVC: AxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if weeksArray1.count > Int(value) {
            //print("Week - \(weeksArray1[Int(value)])")
            return weeksArray1[Int(value)]
            //return String(value.description)
        }
        else {
            return ""
            
        }
    }
}

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self)
    }
    var monthStr: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    
}


extension String {
    func getDate() -> Date {
        if self != "" {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-M-yyyy"
            //formatter.timeZone = TimeZone(abbreviation: "GMT")
            
            let olddate = formatter.date(from: self)
            return olddate ?? Date()
        }
        return Date()
    }
    
    func getDateYMD() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-M-dd"
        //formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.timeZone = TimeZone(abbreviation: "UTC")!
        
        let olddate = formatter.date(from: self)
        return olddate ?? Date()
    }
    
    func getGMTDateFromSTR() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")!
        
        let olddate = dateFormatter.date(from: self)
        return olddate ?? Date()
        
    }
    
    func getSimpleDateGMT() -> Date {
        if self != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")!
            
            let olddate = dateFormatter.date(from: self)
            return olddate ?? Date()
        }
        else {
            return Date()
        }
        //        return dateFormatter.string(from: self)
    }
    
    func getSimpleDateUTC() -> Date {
        if self != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
            
            let olddate = dateFormatter.date(from: self)
            return olddate ?? Date()
        }
        else {
            return Date()
        }
        //        return dateFormatter.string(from: self)
    }
}


extension Date {
    func convertToLocalTime(fromTimeZone timeZoneAbbreviation: String) -> Date? {
        if let timeZone = TimeZone(abbreviation: timeZoneAbbreviation) {
            let targetOffset = TimeInterval(timeZone.secondsFromGMT(for: self))
            let localOffeset = TimeInterval(TimeZone.autoupdatingCurrent.secondsFromGMT(for: self))
            
            return self.addingTimeInterval(targetOffset - localOffeset)
        }
        
        return nil
    }
}
