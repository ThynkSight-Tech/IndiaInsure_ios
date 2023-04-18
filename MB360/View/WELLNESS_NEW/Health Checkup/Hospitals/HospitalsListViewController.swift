//
//  HospitalsListViewController.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 04/06/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import UIKit
import SkeletonView
import Foundation

//TableView Cell For Hospital List
class CellForHospitals: UITableViewCell {
    @IBOutlet weak var lblHospitalName: UILabel!
    @IBOutlet weak var backgroundBorderView: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblSchedule: UILabel!
    
    override func awakeFromNib() {
        
        
        self.backgroundBorderView.customDropShadow()
        
        self.lblSchedule.textColor = Color.fontColor.value
       self.backgroundBorderView.layer.cornerRadius = 10.0
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//Hospital name List View controller
class HospitalsListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,CityNameSelectedProtocol {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.estimatedRowHeight = 120.0
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet weak var lblNoOfHospitals: UILabel!
    
    var serverDate = ""
    var hospitalModelArray = [HospitalModel]()
    var searchActive : Bool = false
    var filterHospitalModelArray = [HospitalModel]() //hospital array for search bar
    var personDetailsModel = FamilyDetailsModel()
    var selectedCityName = ""
    
    
    //Used this flag on Select Date Screen for Schedule Appointment.
    //Set This Flag From When user coming from family details screen and Appointment screen.
    //set zero from family and set one from appointment
    var isFromFamily = 0
    var selectedAppointmentModel = AppointmentModel()
    
    var isLoaded = 0
    var isFromLocation = 0 //if user coming from location then load data or not.
    
    //MARK:- New Change Oe_Group May 2020
    var memberDetailsModel = PersonCheckupModel()
    var hcPackageDetailsModel = HealthCheckupModel()

    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        menuButton.isHidden = true
        isReloadFamilyDetails = 0

        super.viewDidLoad()
        self.navigationController?.navigationBar.changeFont()
        
        tableView.isSkeletonable = true
        let nibName = UINib(nibName: "shimeerDefaultCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "shimeerDefaultCell")

        self.searchBar.layer.cornerRadius = searchBar.frame.height / 2
        self.searchBar.backgroundColor = UIColor.white
//        self.searchBar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        //self.searchBar.layer.shadowOpacity = 10
        //self.searchBar.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        //self.searchBar.layer.shadowRadius = 2
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.black
            textfield.backgroundColor = UIColor.white
            textfield.font = UIFont(name: "Poppins-Regular",size: 15.0)
        }
        
        
        //searchBar.layer.borderWidth = 1
        //searchBar.layer.borderColor = UIColor.lightGray.cgColor
        searchBar.backgroundImage=UIImage()
        searchBar.backgroundColor = UIColor.white
        
        self.searchBar.delegate = self as UISearchBarDelegate
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
       addDoneButtonOnKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("VDA..In HospitalsListViewController")
    
        
        //Get Location
        if isFromLocation == 0 {

        if isFromFamily == 1 {
            guard let cityName:String = UserDefaults.standard.value(forKey: "city") as? String else {
                setTitleView(cityName: "Select City")
                print("Location Not Found")
                return
            }
            self.selectedCityName = cityName
            self.view.showShimmer()

            //Set TitleView
            setTitleView(cityName: cityName)
            
            //Get Hospital List From Server
            getHospitalsListFromServer(cityName: cityName)
            
        }
        else {
            //Set TitleView
            
            guard let selectedCity:String = self.selectedAppointmentModel.DaignosticCenterCity else {
                print("City Not Found")
                return
            }
            
            self.selectedCityName = selectedCity
            self.view.showShimmer()

            setTitleView(cityName: selectedCityName)
            
            //Get Hospital List From Server
            getHospitalsListFromServer(cityName: selectedCityName)
            
        }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        isLoaded = 0
    }
    
    //City Selection Delegate
    func citySelected(cityName:String)
    {
        isFromLocation = 1
        self.selectedCityName = cityName
        setTitleView(cityName: cityName)
        //Get Hospital List From Server
        getHospitalsListFromServer(cityName: selectedCityName)
    }
    
    //MARK:- Set Title View
    private func setTitleView(cityName:String) {
//        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height:40))
//
//        mainView.backgroundColor = UIColor.clear
//
//        let locationButton = UIButton(frame: CGRect(x: 0, y: 0, width: mainView.frame.width, height: mainView.frame.height))
//
//        let locationLbl = UILabel(frame:CGRect(x: 0, y: 0, width: mainView.frame.width - 20, height: mainView.frame.height))
//        locationLbl.text = cityName
//        locationLbl.font =  UIFont(name: "Poppins-Medium", size: 15.0)
//        locationLbl.numberOfLines = 2
//        locationLbl.textAlignment = .right
//        locationLbl.backgroundColor = UIColor.clear
//        locationLbl.textColor = UIColor.white
//
//        let arrowImg = UIImage.init(named: "arrow")
//        let arrowImageView = UIImageView(frame:CGRect(x: locationLbl.frame.width + 5, y: (mainView.frame.height/2)-5, width: 15, height: 15))
//        arrowImageView.image = arrowImg
//        arrowImageView.contentMode = .scaleAspectFit
//
//
//        mainView.addSubview(locationLbl)
//        mainView.addSubview(locationButton)
//        mainView.addSubview(arrowImageView)
//
//        //location label centered to mainview
//        let centerX = NSLayoutConstraint(item: locationLbl, attribute: .centerX, relatedBy: .equal, toItem: mainView, attribute: .centerX, multiplier: 1, constant: -20)
//        let centerY = NSLayoutConstraint(item: locationLbl, attribute: .centerY, relatedBy: .equal, toItem: mainView, attribute: .centerY, multiplier: 1, constant: 0)
//
//
//        //Image constraint center aligned to Label
//        let xConstraint = NSLayoutConstraint(item: arrowImageView, attribute: .centerX, relatedBy: .equal, toItem: locationLbl, attribute: .centerX, multiplier: 1, constant: 0)
//        let yConstraint = NSLayoutConstraint(item: arrowImageView, attribute: .centerY, relatedBy: .equal, toItem: locationLbl, attribute: .centerY, multiplier: 1, constant: 0)
//
//        NSLayoutConstraint.activate([centerX,centerY])
//        NSLayoutConstraint.activate([xConstraint,yConstraint])
//
//
//        locationButton.addTarget(self, action: #selector(changeLocationTapped), for: .touchUpInside)
//
        //self.navigationItem.titleView = mainView
        
        let arrowImg = UIImage.init(named: "arrow")
        setTitle1(cityName, andImage: arrowImg!)

    }
    
    //MARK:- Change Location
    //When user tap on change location
    @objc func changeLocationTapped() {
        
        self.searchBar.text = ""
        self.searchActive = false
        self.searchBar.resignFirstResponder()
        
        let vc : SelectLocationViewController = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier: "SelectLocationViewController") as! SelectLocationViewController
        vc.selectedCity = selectedCityName
        vc.cityNameDelegate = self
        
        
        
    self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func backTapped() {
        isRefreshAppointment = 0
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Tableview Delegate and Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive {
            self.setHeaderLabel(cellCount: filterHospitalModelArray.count)
            return self.filterHospitalModelArray.count
        }
        self.setHeaderLabel(cellCount: hospitalModelArray.count)
        
        return self.hospitalModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForHospitals", for: indexPath) as! CellForHospitals
        
        if searchActive {
            cell.lblHospitalName.text = filterHospitalModelArray[indexPath.row].Name
            cell.lblAddress.text = filterHospitalModelArray[indexPath.row].Address
            
        }
        else {
            cell.lblHospitalName.text = hospitalModelArray[indexPath.row].Name
            cell.lblAddress.text = hospitalModelArray[indexPath.row].Address
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier: "SelectDateViewController") as! SelectDateViewController
        vc.personDetailsModel = self.personDetailsModel
        vc.selectedHospitalModel = self.hospitalModelArray[indexPath.row]
        vc.isFromFamily = self.isFromFamily
        //If user navigate from Appointments screen
        vc.serverDate = serverDate.convertStringToDate()
        vc.selectedAppointmentModel = self.selectedAppointmentModel
        vc.hcPackageDetailsModel = self.hcPackageDetailsModel
        vc.memberDetailsModel = self.memberDetailsModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:- Search Bar Delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchActive = true
        //self.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchActive = false
        //self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
        // self.tableView.reloadData()
        
    }

    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if hospitalModelArray.count > 0 {
            self.filterHospitalModelArray = hospitalModelArray.filter{(($0.Name?.localizedCaseInsensitiveContains(searchText))!) || (($0.Address?.localizedCaseInsensitiveContains(searchText))!) }
            
            if searchText.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                searchActive = false
            }
            else {
                searchActive = true
            }
            tableView.reloadData()
        }
    }
    
    
    //MARK:- Get Data From Server
    private func getHospitalsListFromServer(cityName :String) {
        
        let url = APIEngine.shared.getHealthCheckupURL(cityName: cityName)
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServerWithoutLoader(url: url, view: self) { (response, error) in
            
            if let messageDictionary = response?["message"].dictionary
            {
                if let status = messageDictionary["Status"]?.bool
                {
                    if status == true {
                        
                        if let date = response?["ServerDate"]["Date"].stringValue {
                            self.serverDate = date
                        }
                        
                        if let hospitalsArray = response?["DaignosticCenterList"].arrayValue {
                            self.hospitalModelArray.removeAll()
                            for hospitalDict in hospitalsArray {
                                let obj = HospitalModel.init(City: hospitalDict["City"].stringValue, Name: hospitalDict["Name"].stringValue, CenterSrNo: hospitalDict["CenterSrNo"].stringValue, Address: hospitalDict["Address"].stringValue, Location: hospitalDict["Location"].stringValue, Pincode: hospitalDict["Pincode"].stringValue)
                                self.hospitalModelArray.append(obj)
                            }
                            
                            self.isLoaded = 1
                            self.setHeaderLabel(cellCount: hospitalsArray.count)
                            self.view.hideSkeleton()
                            self.view.stopSkeletonAnimation()
                            
                            self.tableView.reloadData()
                        }
                    }
                    else {
                        let msg = messageDictionary["Message"]?.stringValue
                        self.displayActivityAlert(title: msg ?? "Daignostic Center List not found")
                    }
                    
                }
                
            }
        }//msgDic
    }
    
    //Add Done Button On Keyboard
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = #colorLiteral(red: 0.2431372549, green: 0.8509803922, blue: 0.6941176471, alpha: 1)
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        // doneToolbar.tintColor = #colorLiteral(red: 0.2431372549, green: 0.8509803922, blue: 0.6941176471, alpha: 1)
        
        searchBar.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        searchActive = false
        
        searchBar.resignFirstResponder()
    }
    
    //Set Number Of Hospital Label
    private func setHeaderLabel(cellCount : Int)
    {
        let attrs1 = [NSAttributedStringKey.font : UIFont(name: "Poppins-Regular", size: 16.0), NSAttributedStringKey.foregroundColor : UIColor.darkGray]
        
        let attrs2 = [NSAttributedStringKey.font : UIFont(name: "Poppins-Medium", size: 17.0), NSAttributedStringKey.foregroundColor : UIColor.black]
        
        let attributedString1 = NSMutableAttributedString(string:"Total ", attributes:attrs1 as [NSAttributedStringKey : Any])
        
        let attributedString2 = NSMutableAttributedString(string:" Diagnostic Centers", attributes:attrs1 as [NSAttributedStringKey : Any])
        
        let stringCount = String(cellCount)
        let countString = NSMutableAttributedString(string:"\(stringCount)", attributes:attrs2 as [NSAttributedStringKey : Any])
        
        attributedString1.append(countString)
        attributedString1.append(attributedString2)
        self.lblNoOfHospitals.attributedText = attributedString1
    }
    
 
}

extension HospitalsListViewController {
    func setTitle1(_ title: String, andImage image: UIImage) {
        

        let titleLbl = UILabel()
        titleLbl.text = title.capitalizingFirstLetter()
        titleLbl.textColor = UIColor.white
        titleLbl.font = UIFont.init(name: "Poppins-Medium", size: 17.0)
        
        let tintedArrowImage = image.withRenderingMode(.alwaysTemplate)

        let imageView = UIImageView(image: tintedArrowImage)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.white

        
        //Location
        let locationImgView = UIImageView(image: UIImage(named: "bluePlaceholder"))
        locationImgView.contentMode = .scaleAspectFit
        
        let size = CGSize(width: 22, height: 25)
        locationImgView.image! = (locationImgView.image?.imageResize(sizeChange: size))!
        
        let tintedImage = locationImgView.image?.withRenderingMode(.alwaysTemplate)
        locationImgView.image = tintedImage
        locationImgView.tintColor = UIColor.white
        
        
        let titleView = UIStackView(arrangedSubviews: [locationImgView,titleLbl,imageView])
        titleView.axis = .horizontal
        titleView.spacing = 7.0
        

        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(changeLocationTapped))
        titleView.addGestureRecognizer(gesture1)
      
        
        navigationItem.titleView = titleView
        print("In \(navigationItem.title ?? "") HospitalsListViewController")

    }
    
    
}

extension UIImage {
    
    func imageResize (sizeChange:CGSize)-> UIImage{
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
}

extension UIView {
    func customDropShadow(scale: Bool = true)
    {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        layer.shadowOpacity = 10
        layer.shadowOffset = CGSize(width: 0.0, height: 1)
        layer.shadowRadius = 2
        
        layer.cornerRadius = 6.0
        
    }
}

extension HospitalsListViewController: SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        // return "CellForFamilyDetailsCell1"
        return "shimeerDefaultCell"
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoaded == 0 {
            return 120

        }
        return UITableViewAutomaticDimension
    }
}
