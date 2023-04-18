//
//  StatsHelper.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 05/11/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit

class StatsHelper: NSObject {
    public var CSS = "style=\"position: absolute; right: 5px; text-align:right;\"";
    
    //public var CSS1 = "style=\"position: absolute; left: 0px;\"";
    
    private func convertHtmlCss(htmlText:String) -> String {
        
        print(htmlText)
        let cssText = "<style> .main-container { text-align: justify; font-size:13px; font-family: 'Poppins-Regular'; src: url(Poppins-Regular.ttf);color:#696969;}ul.pretests { padding-left: 0px; }ul.pretests li{ color:#696969; line-height: 1;font-size : 13px;font-size:13px; font-family: 'Poppins-Regular'; src: url(Poppins-Regular.ttf); text-align: justify; margin: 0 10px 10px; }.main-container .text-center {text-align: center;}.main-container ul { padding-left:20px; }span.clearfix { color:#696969; font-size:13px; font-size:13px; font-family: 'Poppins-Regular'; src: url(Poppins-Regular.ttf);}.h1 {font-size: 24px;}.main-container h2.sbold {font-size: larger;}.sbold { font-weight: 400!important; }.main-container h2,.text-primary,.text-info { color: #0096d6; }.h1, .h2, .h3, h1, h2, h3 {margin-top: 20px;margin-bottom: 10px; }</style>"
        
        
        let finalString = String(format: "%@%@", htmlText,cssText)
        
        print("Converted Text =\(finalString) ")
        
        return finalString
    }
    
    
    static var sharedInstance = StatsHelper()
    
    
    
    func getInt(percentage:String) -> Int {
        var per = percentage
        
        if per != nil {
            per = per.replace(string: "%", replacement: "")
            let perc = Double(per)
            return Int(perc?.rounded() ?? 0)
        }
        return 0
    }
    
    //body {font-family: 'Poppins-Regular'; src: url(Poppins-Regular.ttf);color:#000000;.ml-2 {
    // margin-left: .5rem!important;}
    func getHTMLText(you:String,youWeekAgo:String,usersBottom:String,yourNetwork:String,usersTop:String,youMonthAgo:String,min:Int,max:Int,youFinal:Int) -> String {
        
        let aktivoScore = """
        <!doctype html>
        <head>
        <style>
        body {font-family: 'Poppins-Regular'; src: url(Poppins-Regular.ttf);color:#000000;}
        .ml-2 {
        margin-right: 10px!important;
        }
        .set_position h6 {
        margin-bottom: -0.8rem;
        }
        
        .chart-head {
        color: #8492af;
        font-weight: bold;
        font-size: 18px;
        }
        .main_border {
        border-radius: 7px;
        max-height: 15px;
        }
        .first_sec {
        height: 12px;
        background-color: lightgray;
        border-bottom-left-radius: 7px;
        border-top-left-radius: 7px;
        }
        .divider {
        /*position: absolute;*/
        left: 0;
        border-left: 1px solid black;
        top: -5px;
        bottom: -5px;
        background: white;
        }
        
        
        .second_sec {
        height: 12px;
        background-color: #9f9e9e;
        }
        .third_sec {
        height: 12px;
        background-color: #5d5d5d;
        }
        .fourth_sec {
        height: 12px;
        background-color: #191414;
        border-bottom-right-radius: 7px;
        border-top-right-radius: 7px;
        }
        
        .set_position {
        position: absolute;
        }
        .border-left1 {
        border-left: 1px solid black;
        height:90px;
        width: 5px !important;
        }
        .border-left1:hover {
        cursor: pointer;
        }
        .Chartcircle {
        display: inline-block;
        width: 7px;
        height: 7px;
        background: black;
        border-radius: 10px;
        position: absolute;
        left: -3px;
        }
        .Chartcircle {
        display: inline-block;
        width: 7px;
        height: 7px;
        background: black;
        border-radius: 10px;
        position: absolute;
        left: -3px;
        }
        .fs-10 {
        font-size: 10px;
        white-space: nowrap;
        }
        .col-3 {
        width:25%!important;
        display:inline-block;
        float:left;
        }
        .margin_top {
        margin-top: -15px;
        }
        
        .float-right {
        float:right;
        }
        
        .fs16 {
        font-size:16px;
        }
        
        .margin_top1
        {
        margin-top: -35px;
        }
        #scoreminScore,#scoreMaxbarWidth {
        color:black!important;
        text-decoration:none!important;
        }
        
        .hiddenScore {
        
        }
        
        </style>
        </head>
        <body>
        
        <!--My network start-->
        <div class="mt-2 myNetwork">
        
        <div class="row no-gutter  Graph">
        
        <div class="">

        <div class="container" style="position: relative; width: 90%; padding: 0px;  margin: 0px auto 0;">
        <span id="scoreminScore">\(min)</span>
        <span class="float-right" id="scoreMaxbarWidth">\(max)</span>
        <meta name="format-detection" content="telephone=no" />

        <div class="row main_border no-gutters">
        <div class="col-3">
        <div class="first_sec">
        </div>
        </div>
        <div class="col-3">
        <div class="divider">
        </div>
        <div class="second_sec">
        </div>
        </div>
        <div class="col-3">
        <div class="divider">
        </div>
        <div class="third_sec">
        </div>
        </div>
        <div class="col-3">
        <div class="divider">
        </div>
        <div class="fourth_sec">
        </div>
        </div>
        </div>
        
        <div class="row">
        <div class="set_position" id="you" style="left: \(you); z-index: 106">
        <div class="border-left1" id="score_you" style="height: 25px; width: 5px">
        
        <div class="hiddenScore" style="position:absolute;top:-40px;left:-15px;font-weight:700">\(youFinal)</div>
        </div>
        <span class="Chartcircle"></span>
        <div class="ml-2 margin_top1" \(getInt(percentage: you) > 80 ? CSS : "") >
        <h6 class="fs16 fw600">You</h6>
        </div>
        </div>
        <div class="set_position" id="users_btm" style="left: \((usersBottom)); z-index: 101">
        <div class="border-left1" id="score_usersBtm" style="height: 80px; width: 1px">
        <span class="hiddenScore"></span>
        </div>
        <span class="Chartcircle"></span>
        <div class="ml-2 margin_top" \(getInt(percentage: usersBottom) > 80 ? CSS : "") >
        <h6 class="fs14 fw600">Users </h6>
        
        <span class="fs-10">bottom 10%</span>
        </div>
        </div>
        <div class="set_position" id="you_weekago" style="left: \((youWeekAgo)); z-index: 103">
        <div class="border-left1" id="score_weekago" style="height: 110px; width: 1px">
        <span class="hiddenScore"></span>
        </div>
        <span class="Chartcircle"></span>
        <div class="ml-2 margin_top" \(getInt(percentage: youWeekAgo) > 80 ? CSS : "") >
        <h6 class="fs14 fw600">You </h6>
        
        <span class="fs-10">a week ago</span>
        </div>
        </div>
        <div class="set_position" id="you_monthago" style="left:\(youMonthAgo); z-index: 105">
        <div class="border-left1" id="score_monthago" style="height: 50px; width: 1px">
        <span class="hiddenScore"></span>
        </div>
        <span class="Chartcircle"></span>
        <div class="ml-2 margin_top" \(getInt(percentage: youMonthAgo) > 80 ? CSS : "") >
        <h6 class="fs14 fw600">You </h6>
        
        <span class="fs-10">a month ago</span>
        </div>
        </div>
        <div class="set_position" id="users_top" style="left: \(usersTop); z-index: 105">
        <div class="border-left1" id="score_usersTop" style="height: 180px; width: 1px">
        <span class="hiddenScore"></span>
        
        </div>
        <span class="Chartcircle"></span>
        <div class="ml-2 margin_top" \(getInt(percentage: usersTop) > 80 ? CSS : "") >
        <h6 class="fs14 fw600">Users </h6>
        
        <span class="fs-10">top 10%</span>
        </div>
        </div>
        
        <div class="set_position" id="network" style="left: \(yourNetwork); z-index: 102">
        
        <div class="border-left1" id="score_network" style="height: 140px; width: 1px">
        <span class="hiddenScore"></span>
        </div>
        <span class="Chartcircle"></span>
        <div class="ml-2 margin_top" \(getInt(percentage: yourNetwork) > 80 ? CSS : "") >
        <h6 class="fs14 fw600">Your Network</h6>
        </div>
        </div>
        
        </div>
        </div>
        
        <script>
        </script>
        </body>
        <script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.4.1.min.js"></script>

        <script>
        $(".border-left1").click(
        $(".hiddenScore").css("display","block");
        $(".hiddenScore").text("5")
        }
        
        </script>
        </html>
        """
        
        //let cssStr = convertHtmlCss(htmlText: aktivoScore)
        return aktivoScore
    }
    
    
    
//
//    $(this).append($("<span style='position:absolute;top:-50px;left:-5px;white-space:nowrap;word-break:keep-all;font-weight:700;background-color:rgba(0,0,0,.8);color:white;padding:2px 5px;border-radius:5px' > " + Math.round($(this).find(".hiddenScore").text("5")) + "</span>"));
//}, function () {
//    $(this).find("span:last").remove();
    
    /*
     func getHTMLText(you:String,youWeekAgo:String,usersBottom:String,yourNetwork:String,usersTop:String,youMonthAgo:String) -> String {
     let aktivoScore = """
     <!doctype html>
     <head>
     <style>
     body {font-family: 'Poppins-Regular'; src: url(Poppins-Regular.ttf);color:#000000;}
     .ml-2 {
     margin-left: .5rem!important;
     }
     
     .chart-head {
     color: #8492af;
     font-weight: bold;
     font-size: 18px;
     }
     .main_border {
     border-radius: 7px;
     max-height: 15px;
     }
     .first_sec {
     height: 12px;
     background-color: lightgray;
     border-bottom-left-radius: 7px;
     border-top-left-radius: 7px;
     }
     .divider {
     position: absolute;
     left: 0;
     border-left: 1px solid black;
     top: -5px;
     bottom: -5px;
     background: white;
     }
     .second_sec {
     height: 12px;
     background-color: #9f9e9e;
     }
     .third_sec {
     height: 12px;
     background-color: #5d5d5d;
     }
     .fourth_sec {
     height: 12px;
     background-color: #191414;
     border-bottom-right-radius: 7px;
     border-top-right-radius: 7px;
     }
     .set_position {
     position: absolute;
     }
     .border-left1 {
     border-left: 1px solid black;
     width: 5px !important;
     }
     .border-left1:hover {
     cursor: pointer;
     }
     .Chartcircle {
     display: inline-block;
     width: 7px;
     height: 7px;
     background: black;
     border-radius: 10px;
     position: absolute;
     left: -3px;
     }
     .Chartcircle {
     display: inline-block;
     width: 7px;
     height: 7px;
     background: black;
     border-radius: 10px;
     position: absolute;
     left: -3px;
     }
     .fs-10 {
     font-size: 10px;
     white-space: nowrap;
     }
     .col-3 {
     width:25%!important;
     display:inline-block;
     float:left;
     }
     .float-right {
     float:right;
     }
     
     </style>
     </head>
     <body>
     
     <!--My network start-->
     <div class="mt-2 myNetwork">
     
     <div class="row no-gutter  py-3 Graph">
     
     <div class="">
     
     <div class="container" style="position: relative; padding: 0px;  margin-top: -10px;">
     <span id="scoreminScore">0</span>
     <span class="float-right " id="scoreMaxbarWidth">100</span>
     <div class="row main_border no-gutters">
     <div class="col-3">
     <div class="first_sec">
     </div>
     </div>
     <div class="col-3">
     <div class="divider">
     </div>
     <div class="second_sec">
     </div>
     </div>
     <div class="col-3">
     <div class="divider">
     </div>
     <div class="third_sec">
     </div>
     </div>
     <div class="col-3">
     <div class="divider">
     </div>
     <div class="fourth_sec">
     </div>
     </div>
     </div>
     
     <div class="row">
     <div class="set_position" id="you" style="left: \(you); z-index: 106">
     <div class="border-left1" id="score_you" style="height: 20px; width: 5px">
     
     <span class="hiddenScore"></span>
     </div>
     <span class="Chartcircle"></span>
     <div class="ml-2 margin_top">
     <div class= "ml-2" \(getInt(percentage: you) > 80 ? CSS : CSS1) >
     
     <h6 class="fs14 fw600">You</h6>
     </div>
     </div>
     <div class="set_position" id="users_btm" style="left: \(usersBottom); z-index: 101">
     <div class="border-left1" id="score_usersBtm" style="height: 80px; width: 1px">
     <span class="hiddenScore"></span>
     </div>
     <span class="Chartcircle"></span>
     <div class="ml-2 margin_top">
     <h6 class="fs14 fw600">Users </h6>
     <div class= "ml-2"  \(getInt(percentage: usersBottom) > 80 ? CSS : CSS1) >
     
     <span class="fs-10">bottom 10%</span>
     </div>
     </div>
     <div class="set_position" id="you_weekago" style="left: \(youWeekAgo); z-index: 103">
     <div class="border-left1" id="score_weekago" style="height: 110px; width: 1px">
     <span class="hiddenScore"></span>
     </div>
     <span class="Chartcircle"></span>
     <div class="ml-2 margin_top">
     <h6 class="fs14 fw600">You </h6>
     <div class= "ml-2"  \(getInt(percentage: youWeekAgo) > 80 ? CSS : CSS1) >
     
     <span class="fs-10">a week ago</span>
     </div>
     </div>
     <div class="set_position" id="you_monthago" style="left:\(youMonthAgo); z-index: 105">
     <div class="border-left1" id="score_monthago" style="height: 50px; width: 1px">
     <span class="hiddenScore"></span>
     </div>
     <span class="Chartcircle"></span>
     <div class="ml-2 margin_top">
     <h6 class="fs14 fw600">You </h6>
     <div class= "ml-2" \(getInt(percentage: youMonthAgo) > 80 ? CSS : CSS1) >
     
     <span class="fs-10">a month ago</span>
     </div>
     </div>
     <div class="set_position" id="users_top" style="left: \(usersTop); z-index: 105">
     <div class="border-left1" id="score_usersTop" style="height: 180px; width: 1px">
     <span class="hiddenScore"></span>
     
     </div>
     <span class="Chartcircle"></span>
     <div class="ml-2 margin_top">
     <h6 class="fs14 fw600">Users </h6>
     <div class= "ml-2" \(getInt(percentage: usersTop) > 80 ? CSS : CSS1) >
     
     <span class="fs-10">top 10%</span>
     </div>
     </div>
     
     <div class="set_position" id="network" style="left: \(yourNetwork); z-index: 102">
     <div class="border-left1" id="score_network" style="height: 140px; width: 1px">
     <span class="hiddenScore"></span>
     </div>
     <span class="Chartcircle"></span>
     <div class="ml-2 margin_top">
     <div class= "ml-2"  \(getInt(percentage: yourNetwork) > 80 ? CSS : CSS1) >
     <h6 class="fs14 fw600">Your Network</h6>
     </div>
     </div>
     
     </div>
     </div>
     
     <script>
     </script>
     </body>
     </html>
     """
     
     //let cssStr = convertHtmlCss(htmlText: aktivoScore)
     return aktivoScore
     }
     */
}


//import Charts

//class MyValueFormatter: IValueFormatter {
//    var xValueForToday: Double?  // Set a value
//
//    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
//        if entry.x == xValueForToday {
//            return "Today"
//        } else {
//            return String(value)
//        }
//    }
//}

//=============== WEEK STATS ==============================
extension StatsFitnessVC {

    
    
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }

        return array
    }

    //Return array of month for collection view with isEnabled tap or not

    func weekRange(from: Date, to: Date) -> [WeekDateStruct] {
        
        var structArray = [WeekDateStruct]()
        
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [WeekDateStruct]() }

        var tempDate = from

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: tempDate)!
            
            let obj = WeekDateStruct.init(startDate: tempDate.startOfWeek(weekday: 1), endDate: tempDate.endOfWeek(weekday: 1), weekNumber: tempDate.weekNumber(),index: structArray.count)
            
            print("===========")
            print(obj.startDate.getSimpleDate())
            print(obj.endDate.getSimpleDate())
            print(obj.weekNumber)
            print("===========")
            structArray.append(obj)
        }

        return structArray
    }

    //Return array of month for collection view with isEnabled tap or not
    func monthRange(from: Date, to: Date) -> [MonthDataStruct] {
        
        var structArray = [MonthDataStruct]()

        if from > to { return [MonthDataStruct]() }

        var tempDate = from

        while tempDate < to {
               
            print("===========")
            print(tempDate.monthStr)
            
            var isEnabled = false
            if tempDate.year < Date().year {
            isEnabled = true
            }
            else if tempDate.year == Date().year { //if current year Apr 2019
                if tempDate.month1 <= Date().month1 { //enable Jan to Apr
                isEnabled = true
                }
                else { //Disabled after Apr
                isEnabled = false
                }
            }
            else {
            isEnabled = false
            }
            
            
            let  obj = MonthDataStruct.init(startDate: Date(), endDate: Date(), monthNumber: tempDate.month1, monthStr: tempDate.monthStr, index: structArray.count,isEnabled: isEnabled)
            tempDate = Calendar.current.date(byAdding: .month, value: 1, to: tempDate)!

            structArray.append(obj)
            print("===========")

        }

        return structArray
    }

    
}

struct MonthDataStruct {
    var startDate = Date()
    var endDate = Date()
    var monthNumber : Int?
    var monthStr = String()
    var index : Int?
    var isEnabled  = false
}

struct WeekDateStruct {
     var startDate = Date()
     var endDate = Date()
     var weekNumber : Int?
     var index : Int?
 }


extension Date {
  var millisecondsSince1970:Int {
      return Int((self.timeIntervalSince1970 * 1000.0).rounded())
  }

  init(milliseconds:Int) {
      self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
  }

  func startOfWeek(weekday: Int?) -> Date {
      var cal = Calendar.current
      var component = cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
      component.to12am()
      cal.firstWeekday = weekday ?? 1
      return cal.date(from: component)!
  }
    
    func weekNumber() -> Int {
        let component = Calendar.current.component(.weekOfYear, from: self)
        return component
    }

  func endOfWeek(weekday: Int) -> Date {
      let cal = Calendar.current
      var component = DateComponents()
      component.weekOfYear = 1
      component.day = -1
      component.to12pm()
      return cal.date(byAdding: component, to: startOfWeek(weekday: weekday))!
   }
}

  internal extension DateComponents {
    mutating func to12am() {
      self.hour = 0
      self.minute = 0
      self.second = 0
  }

  mutating func to12pm(){
      self.hour = 23
      self.minute = 59
      self.second = 59
  }
}



