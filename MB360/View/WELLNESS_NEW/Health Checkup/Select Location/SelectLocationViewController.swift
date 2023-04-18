//
//  SelectLocationViewController.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 05/06/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
protocol CityNameSelectedProtocol {
    func citySelected(cityName:String)
}
protocol CityNursingNameSelectedProtocol {
    func citySelected(cityName:String,cityModel:CityListModel)
}
class SelectLocationViewController: UITableViewController,TagListViewDelegate {

    
    @IBOutlet weak var firstTagListView: TagListView!
    
    @IBOutlet weak var secondTagListView: TagListView!
    
    var allCityArray = [String]()
    var metroCityArray = [String]()
    var tempMetroArray = ["pune","mumbai","kolkata","hyderabad","delhi","chennai","bengaluru"]
    
    var selectedCity = ""
    
    var isExpandCell = 0
    
    @IBOutlet weak var plusImageview: UIImageView!
    
    var cityNameDelegate : CityNameSelectedProtocol? = nil
    var cityNursingDelegate : CityNursingNameSelectedProtocol? = nil

    var isFromNursing = false
    var nursingType : NursingType?
    var cityModelArray = [CityListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Location"
        print("\(self.title ?? "") SelectLocationViewController")
        self.navigationController?.navigationBar.changeFont()

        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        self.tabBarController?.tabBar.isHidden = true
        menuButton.isHidden = true
        
        if isFromNursing { //HHC
        getNursingLocationListFromServer()
        }
        else { //Healthcheckup
        getLocationListFromServer()
        }
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func tagSetup() {
        firstTagListView.delegate = self
        firstTagListView.textFont = UIFont(name: "Poppins-Regular", size: 13.0)!
        firstTagListView.addTags(metroCityArray)
        firstTagListView.alignment = .center
        firstTagListView.backgroundColor = UIColor.white
        //firstTagListView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        //firstTagListView.layer.borderWidth = 1.0
        firstTagListView.selectedBorderColor = Color.buttonBackgroundGreen.value
        firstTagListView.cornerRadius = 18.0
        firstTagListView.tagSelectedBackgroundColor = Color.buttonBackgroundGreen.value
        secondTagListView.tagSelectedBackgroundColor = Color.buttonBackgroundGreen.value

        secondTagListView.delegate = self
        secondTagListView.textFont = UIFont(name: "Poppins-Regular", size: 13.0)!
        secondTagListView.addTags(allCityArray)
        secondTagListView.alignment = .center
        secondTagListView.backgroundColor = UIColor.white
        //secondTagListView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
       // secondTagListView.layer.borderWidth = 1.0
        secondTagListView.selectedBorderColor = Color.buttonBackgroundGreen.value
        secondTagListView.cornerRadius = 18.0


        //Set By Default Selected location
//        if metroCityArray.contains(selectedCity.capitalizingFirstLetter()) {
//            if let index = metroCityArray.index(of: selectedCity.capitalizingFirstLetter()) {
//                firstTagListView.tagViews[index].isSelected = true
//
//            }
//        }
        if metroCityArray.contains(selectedCity) {
            if let index = metroCityArray.index(of: selectedCity) {
                firstTagListView.tagViews[index].isSelected = true

            }
        }
        else {
            if let index = allCityArray.index(of: selectedCity.capitalizingFirstLetter()) {
                secondTagListView.tagViews[index].isSelected = true
                
            }
            //secondTagListView.tagViews[index].isSelected = true

        }
        
        self.tableView.reloadData()
        
    }
    
   
    @IBAction func expandCellTapped(_ sender: Any) {
        if isExpandCell == 0 {
            isExpandCell = 1
            self.plusImageview.image = UIImage(named: "minus")

        }
        else {
            isExpandCell = 0
            self.plusImageview.image = UIImage(named: "plus")

        }
        self.tableView.reloadData()

    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableViewAutomaticDimension
        }
        else {
            if isExpandCell == 0 {
                return 63
            }
            else {
                return UITableViewAutomaticDimension
            }
        }
    }
    
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
        /*
        if tagView == self.firstTagListView {
            for tg in firstTagListView.tagViews {
                if tg != tagView {
                    tg.isSelected = false
                }
                else {
                    tg.isSelected = true
                }
            }
            self.selectedCity = title
        }
        else {
            
          // self.firstTagListView.tagViews.map({$0.isSelected = false})
            */
        
        for stg in firstTagListView.tagViews {
            if stg != tagView {
                stg.isSelected = false
            }
            else {
                stg.isSelected = true
            }
        }
        
            for stg in secondTagListView.tagViews {
                if stg != tagView {
                    stg.isSelected = false
                }
                else {
                    stg.isSelected = true
                }
            }
        
            self.selectedCity = title
        
        if isFromNursing { //For HHC
            if self.cityNursingDelegate != nil {
                
                let obj = cityModelArray.filter({$0.City?.lowercased() == title.lowercased()})
                if obj.count > 0 {
                self.cityNursingDelegate?.citySelected(cityName: title, cityModel: obj[0])
                self.navigationController?.popViewController(animated: true)
                }

            }
        }
        else { //for other services
        if self.cityNameDelegate != nil {
            
            self.cityNameDelegate?.citySelected(cityName: title)
            self.navigationController?.popViewController(animated: true)

        }
        }
       // }
        
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        //tagListView.selectedTags().removeAll()
        //tagListView.tagViews.removeAll()
        
        sender.removeTagView(tagView)
    }

    
    //Get Data From Server
    private func getLocationListFromServer() {
        
        let url = APIEngine.shared.getLocationListURL()
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            
            if let messageDictionary = response?["message"].dictionary
            {
                if let status = messageDictionary["Status"]?.bool
                {
                    if status == true {
                        
                        if let citiesArray = response?["CitiyList"].arrayValue {
                            
                            for city in citiesArray {
                                
                                let cityStr = city.stringValue.lowercased()
                                if self.tempMetroArray.contains(cityStr) {
                                    self.metroCityArray.append(city.stringValue)
                                }
                                else {
                                    self.allCityArray.append(city.stringValue)
                                }
                                    
                            }
                            
                            print(self.metroCityArray)
                            print(self.allCityArray)
                            
                            self.metroCityArray = self.metroCityArray.sorted()
                            self.allCityArray = self.allCityArray.sorted()
                            self.tagSetup()
                           
                        }
                    }
                    else {
                        //let msg = messageDictionary["Message"]?.stringValue
                        self.displayActivityAlert(title: m_errorMsg)
                    }
                    
                }
                
            }
        }//msgDic
    }
    
    //Get Data From Server
    private func getNursingLocationListFromServer() {
        
        let url = APIEngine.shared.getCityListForNursing(nursingType:nursingType!)
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            
            if let messageDictionary = response?["message"].dictionary
            {
                if let status = messageDictionary["Status"]?.bool
                {
                    if status == true {
                        
                        self.metroCityArray.removeAll()
                        self.allCityArray.removeAll()
                        self.cityModelArray.removeAll()
                        
                        if let citiesArray = response?["Cities"].arrayValue {
                            
                            for city in citiesArray {
                                
                                if let isMetro = city["Is_metro"].string {
                                    if isMetro == "1" {
                                        self.metroCityArray.append(city["City"].stringValue)
                                        
                                    }
                                    else {
                                        self.allCityArray.append(city["City"].stringValue)
                                    }
                                }
                                else {
                                    self.allCityArray.append(city["City"].stringValue)
                                }
                                
                                let obj = CityListModel.init(City: city["City"].stringValue, Is_metro: city["Is_metro"].stringValue, Srno: city["Srno"].stringValue)
                                self.cityModelArray.append(obj)
 
                            }
                            
                            print(self.metroCityArray)
                            print(self.allCityArray)
                            
                            self.metroCityArray = self.metroCityArray.sorted()
                            self.allCityArray = self.allCityArray.sorted()
                            self.tagSetup()
                        }
                    }
                    else {
                       // let msg = messageDictionary["Message"]?.stringValue
                        self.displayActivityAlert(title: m_errorMsg)
                    }
                    
                }
                
            }
        }//msgDic
    }
    
}


struct CityListModel {
    var City :String?
    var Is_metro :String?
    var Srno :String?
}
