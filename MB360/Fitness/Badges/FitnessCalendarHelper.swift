//
//  FitnessCalendarHelper.swift
//  FitnessUIApp
//
//  Created by SemanticMAC MINI on 18/07/20.
//  Copyright © 2020 SemanticMAC MINI. All rights reserved.
//

import Foundation
import JTAppleCalendar

import UIKit
class DateCell: JTAppleCell {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        backView.layer.cornerRadius = backView.bounds.height / 2
    }
    
}


extension BadgeCalendarSummaryViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        print("\(#function)")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2020 01 01")!
        let endDate = Date()
        return ConfigurationParameters(startDate: startDate,
                                       endDate: endDate,
                                       generateInDates: .forAllMonths,
                                       generateOutDates: .tillEndOfGrid)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        print("\(#function)SELECT")
        //print(date)
        handleCellConfiguration(cell: cell,date:date , cellState: cellState)
    }
    func handleCellConfiguration(cell: JTAppleCell?,date:Date, cellState: CellState) {
        //print("\(#function)")
        guard let myCustomCell = view as? DateCell else {return }
        
        myCustomCell.backView.backgroundColor = UIColor.orange
        
        
        handleCellSelection(view: cell, date:date, cellState: cellState)
        handleCellTextColor(view: cell, date:date,cellState: cellState)
        handleCellEvents(view: cell, date:date,cellState: cellState)
    }
    //MARK:- Custom handle Cell Events
    func handleCellEvents(view: JTAppleCell?,date:Date, cellState: CellState) {
        print("\(#function)$$")
        
        guard let myCustomCell = view as? DateCell else {return }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from:date as Date)
       // print(dateString)
        
               
    }
    
    // Function to handle the text color of the calendar
    func handleCellTextColor(view: JTAppleCell?,date:Date, cellState: CellState) {
        //print("\(#function)")
        
        guard let myCustomCell = view as? DateCell  else {
            return
        }
        
        if cellState.isSelected {
            myCustomCell.dateLabel?.textColor = UIColor.green
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dateLabel?.textColor = UIColor.black
                
                if Calendar.current.isDateInToday(date) {
                    myCustomCell.dateLabel?.textColor = UIColor.orange
                    myCustomCell.backView.backgroundColor = UIColor.black

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
        if cellState.isSelected {
            myCustomCell.backgroundColor = UIColor.green
        } else {
            myCustomCell.backgroundColor = UIColor.yellow
            if Calendar.current.isDateInToday(date) {
                myCustomCell.backgroundColor = UIColor.green
                
            }
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        print("\(#function)")
        
        let date =  visibleDates.monthDates.first?.date
        
        var dateString = ""
        
        dateFormatter.dateFormat = "MMMM"
        dateString = dateFormatter.string(from: date!).uppercased()
        
        monthLabel?.text = dateString.capitalizingFirstLetter()
        self.lblBadgesForMonth.text = """
        Badges For
        \(dateString.capitalizingFirstLetter())
        """
        self.getMonthlySummaryDataFromServer(startDate: visibleDates.monthDates.first?.date ?? Date().startOfMonth(), endDate: visibleDates.monthDates.last?.date ?? Date().endOfMonth())
    }
    
    
}

extension BadgeCalendarSummaryViewController: JTAppleCalendarViewDelegate {
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
                  if Calendar.current.isDateInToday(date) {
                      cell.dateLabel?.textColor = UIColor.white
                      cell.backView.backgroundColor = UIColor.black
                  }
                  else {
                      cell.dateLabel?.textColor = UIColor.black
                      cell.backView.backgroundColor = UIColor.white
                  }
        
        let formatter = DateFormatter()
              formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from:date as Date)
              //print(dateString)
        
        if self.badgeArray.count > 0 {
            let filteredArray = self.badgeArray.filter({$0.refDateString == dateString })
            if filteredArray.count > 0 {
//                if dateString == "2020-09-27" {
//                    print("Found = \(filteredArray[0])")
//                }
                switch filteredArray[0].badge.type {
                case .contender:
                    cell.backView.backgroundColor = #colorLiteral(red: 1, green: 0.568627451, blue: 0.2588235294, alpha: 1)
                case .challenger:
                    cell.backView.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.262745098, alpha: 1)
                case .achiever:
                    cell.backView.backgroundColor = #colorLiteral(red: 0.07450980392, green: 0.8274509804, blue: 0.7921568627, alpha: 1)

                default:
                    break
                }
                
                cell.dateLabel.textColor = UIColor.white

                
                if Calendar.current.isDateInToday(date) {
                    cell.backView.backgroundColor = UIColor.black
                    cell.dateLabel.textColor = UIColor.white
                }
            }
            else {
                if Calendar.current.isDateInToday(date) {
                    cell.backView.backgroundColor = UIColor.black
                    cell.dateLabel.textColor = UIColor.white
                }
                else {
                    cell.backView.backgroundColor = UIColor.white
                    cell.dateLabel.textColor = UIColor.darkGray
                    
                }
                
                if date > Date() {
                    cell.dateLabel.textColor = UIColor.black
                }
                else {
                    if Calendar.current.isDateInToday(date) {
                        cell.backView.backgroundColor = UIColor.black
                        cell.dateLabel.textColor = UIColor.white
                    }
                    else{
                    cell.dateLabel.textColor = UIColor.lightGray
                    }
                }
            }
            
          
        }
        //print(cell.dateLabel.text)
        return cell
    }
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! DateCell
        //print(cell.dateLabel.text)
        cell.dateLabel.textColor = UIColor.black
        cell.dateLabel.text = cellState.text
        
    }
    
}
