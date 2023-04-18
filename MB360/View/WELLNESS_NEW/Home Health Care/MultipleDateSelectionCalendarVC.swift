//
//  MultipleDateSelectionCalendarVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 24/10/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit
import JTAppleCalendar


protocol MultipleDateSelectionProtocol {
    func datesSelected(selectedDatesArray :[Date], stringSelectionArray:[String])
}


class MultipleDateSelectionCalendarVC: UIViewController {
    @IBOutlet weak var monthLabel:UILabel?
    @IBOutlet weak var calenderView:JTAppleCalendarView?

    var selectedDateArray = [Date]()
    
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnCancel: UIButton!

    @IBOutlet weak var mainView: UIView!
    
    var multipleDateDelegateObj : MultipleDateSelectionProtocol? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        print("In \(navigationItem.title ?? "") MultipleDateSelectionCalendarVC")
        setUpCalenderView()
        calenderView?.scrollingMode = .stopAtEachCalendarFrame

        btnDone.makeCicular()
        btnCancel.makeCicular()
        
        btnDone.layer.borderColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        btnDone.setTitleColor(#colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1), for: .normal)
        btnDone.layer.borderWidth = 1.0

        btnCancel.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        btnCancel.setTitleColor(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), for: .normal)
        btnCancel.layer.borderWidth = 1.0

        mainView.layer.cornerRadius = 10.0
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDoneTapped(_ sender: UIButton) {
        if selectedDateArray.count > 0 {
            var stringDateArray = [String]()
            for dateObj in selectedDateArray {
                
                //"02/11/2020"
                let dateStr = dateObj.getSimpleDateGMTStrIndia()
                stringDateArray.append(dateStr)
                
                //Append 2020-11-02
//                let strDateArray = dateObj.description.split(separator: " ")
//                if strDateArray.count > 0 {
//
//                    stringDateArray.append(String(strDateArray[0]))
//                }
            }
            
        if multipleDateDelegateObj != nil {
            multipleDateDelegateObj?.datesSelected(selectedDatesArray: self.selectedDateArray, stringSelectionArray: stringDateArray)
        }
        self.dismiss(animated: true, completion: nil)
        }
        else {
            self.displayActivityAlert(title: "Please select date")
        }
    }
    
    @IBAction func nextClick(_ sender: UIButton) {
        calenderView?.scrollToSegment(SegmentDestination.next)

    }
    
    @IBAction func prevClick(_ sender: UIButton) {
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
            
            dateFormatter.dateFormat = "YYYY"
           dateString = dateString.appendingFormat("  %@", dateFormatter.string(from: date!))
            
            self.monthLabel?.text = dateString.uppercased()
        })
        
        calenderView?.scrollToDate(Date(), triggerScrollToDateDelegate: true, animateScroll: true, preferredScrollPosition: UICollectionView.ScrollPosition.right, extraAddedOffset: 0.0, completionHandler: nil)
        
        
        calenderView?.minimumLineSpacing = 0.0
        calenderView?.minimumInteritemSpacing = 0.0
    }
}


//class DateCell: JTAppleCell {
//
//    @IBOutlet var dateLabel: UILabel!
//    @IBOutlet weak var backView: UIView!
//
//    override func awakeFromNib() {
//        backView.layer.cornerRadius = backView.bounds.height / 2
//    }
//
//}


extension MultipleDateSelectionCalendarVC: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        print("\(#function)")
        
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy MM dd"
        formatter.dateFormat = "dd/MM/yyyy"

        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale

        //let endDate = formatter.date(from: "2021 10 10")!
        let endDate = Date().addYears(noOfYears: 3)

        let startDate = Date()
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: NSTimeZone.local.secondsFromGMT())!

        return ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 6, calendar: calendar, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: .sunday)

       // return ConfigurationParameters(startDate: startDate,endDate: endDate,generateInDates:.forAllMonths,generateOutDates: .tillEndOfGrid)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        print("didSelectDate....")
        
        if selectedDateArray.contains(date) {
            //remove
            print("Removed")
            if let index = selectedDateArray.firstIndex(of: date) {
                selectedDateArray.remove(at: index)
            }

        }
        else {
            print("Added")
            if date >= Date() {
                if let removedTimeStamp = date.removeTimeStamp {
                selectedDateArray.append(removedTimeStamp)
                }
            }
        }
       // configureCell(view: cell, cellState: cellState)
        handleCellConfiguration(cell: cell,date:date , cellState: cellState)

        print(selectedDateArray)
        calenderView?.reloadData()
    }

    
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        print("\(#function)SELECT")
        //print(date)
        handleCellConfiguration(cell: cell,date:date , cellState: cellState)
    }
    func handleCellConfiguration(cell: JTAppleCell?,date:Date, cellState: CellState) {
        //print("\(#function)")
        guard let myCustomCell = view as? DateCell else {return }
        
       // myCustomCell.backView.backgroundColor = UIColor.orange
        
        
        handleCellSelection(view: cell, date:date, cellState: cellState)
        handleCellTextColor(view: cell, date:date,cellState: cellState)
        handleCellEvents(view: cell, date:date,cellState: cellState)
    }
    //MARK:- Custom handle Cell Events
    func handleCellEvents(view: JTAppleCell?,date:Date, cellState: CellState) {
        print("\(#function)$$")
        
        guard let myCustomCell = view as? DateCell else {return }
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy-MM-dd"
        formatter.dateFormat = "dd/MM/yyyy"

        let dateString = formatter.string(from:date as Date)
       // print(dateString)
        
    }
    
    // Function to handle the text color of the calendar
    func handleCellTextColor(view: JTAppleCell?,date:Date, cellState: CellState) {
        print("\(#function)")
        
        guard let myCustomCell = view as? DateCell  else {
            return
        }
        
        if cellState.isSelected {
            myCustomCell.dateLabel?.textColor = UIColor.white
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dateLabel?.textColor = UIColor.red
                
                if Calendar.current.isDateInToday(date) {
                    myCustomCell.dateLabel?.textColor = UIColor.black
                    myCustomCell.backView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)

                }
                
            } else {
                myCustomCell.dateLabel?.textColor = UIColor.clear
            }
        }
        
    }
    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleCell?,date:Date, cellState: CellState) {
        print("\(#function)")
        
        guard let myCustomCell = view as? DateCell else {return }
        
        //Convert into date
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let dateString = formatter.string(from:date as Date)

    
//        if cellState.isSelected {
//            print("Appended")
//            self.selectedDateArray.append(date)
//            myCustomCell.backgroundColor = UIColor.green
//        } else {
//
//            if let index = selectedDateArray.firstIndex(of: date) {
//                selectedDateArray.remove(at: index)
//                print("removed")
//            }
//
//            //myCustomCell.backgroundColor = UIColor.yellow
//            if Calendar.current.isDateInToday(date) {
//                myCustomCell.backgroundColor = UIColor.green
//
//            }
//
//
//        }
        print(self.selectedDateArray)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        print("\(#function)")
        
        calenderView?.visibleDates({ visibleDates in
            let date =  visibleDates.monthDates.first?.date
            
            var dateString = ""
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "MMMM"
            dateString = ((dateFormatter.string(from: date!) as AnyObject) as! String)
            
            dateFormatter.dateFormat = "YYYY"
           dateString = dateString.appendingFormat("  %@", dateFormatter.string(from: date!))
            
            self.monthLabel?.text = dateString.uppercased()
        })

      
    }
    
    
}

extension MultipleDateSelectionCalendarVC: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if cellState.day == .sunday {
        return false
        }
        else {
        return true
        }
        
    }

    
    //MARK:- Set Color
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        cell.dateLabel.text = cellState.text
        
        if cellState.dateBelongsTo == .thisMonth {
            cell.isHidden = false
        } else {
            cell.isHidden = true
        }
        
            //Set Color For Current Date
//                  if Calendar.current.isDateInToday(date) {
//                      cell.dateLabel?.textColor = UIColor.black
//                      cell.backView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
//                  }
//                  else {
//                      cell.dateLabel?.textColor = UIColor.white
//                    cell.backView.backgroundColor = Color.buttonBackgroundGreen.value
//                  }
        
      //  let formatter = DateFormatter()
        //      formatter.dateFormat = "yyyy-MM-dd"
        
        if selectedDateArray.contains(date) {
            cell.backView.backgroundColor = Color.buttonBackgroundGreen.value
            cell.dateLabel?.textColor = UIColor.white
            
        }
        else
        {
            if Calendar.current.isDateInToday(date) {
                cell.dateLabel?.textColor = UIColor.black
                cell.backView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            }
            else {
                cell.dateLabel?.textColor = UIColor.black
                cell.backView.backgroundColor = UIColor.white
            }
        }
        
        return cell
    }
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! DateCell
        //print(cell.dateLabel.text)
        //cell.dateLabel.textColor = UIColor.red
        //cell.dateLabel.text = cellState.text
        
    }
    
}
