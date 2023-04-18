//
//  HealthCheckupOptVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 20/06/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

class HealthCheckupOptVC: UIViewController,MobileNumberVerifyDelegate,NewMemberAddedProtocol,UITabBarDelegate,UITabBarControllerDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartBottomView: UIView!
    @IBOutlet weak var lblNoOfItems: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var cartStackView: UIStackView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    var packageModelArray = [HealthCheckupModel]()
    var personDetailsModel = PersonCheckupModel()
    var hcPackageDetailsModel = HealthCheckupModel()
    var summaryModelObject = SummaryModel()
    
    //Add member
    var relationModelArray = [RelationDataModel]()
    var serverDate = ""
    var relationStringArray = [String]()
    var isAddMember = 0
    
    var cartBarButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.inActiveTintColorGreen()
        tabBarController?.view.backgroundColor = UIColor.white
        navigationController?.view.setGradientBackground1(colorTop: Color.greenTop.value, colorBottom:Color.greenBottom.value)
        print("In HealthCheckupOptVC..health checkup")
        super.viewDidLoad()
        isReloadFamilyDetails = 1
        setupFamilyDetails()
        self.cartBottomView.isHidden = true
        bottomConstraint.constant = 0

        let nibName = UINib(nibName: "SelectMemberForHCCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "SelectMemberForHCCell")
        
       if isAddMember == 0 {
        setupMiddleButton()
        }
        
        
        //Add gesture on bottom stackview
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(cartTapped))
        self.cartStackView.addGestureRecognizer(gesture1)
        
        let nibName1 = UINib(nibName: "CellForHealthCheckupSelection", bundle:nil)
        tableView.register(nibName1, forCellReuseIdentifier: "CellForHealthCheckupSelection")
        
        
        self.tableView.estimatedRowHeight = 100;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tabBarController?.delegate = self as? UITabBarControllerDelegate

        //Remove Extra space on tablview Content inset
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view..Will..Appear=\(isAddMember)")
        //if isAddMember == 0 { //Add only if Home Screen
        menuButton.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        tabBarController?.view.backgroundColor = UIColor.white
        super.viewWillAppear(true)
        //}
    }
    
    //MARK:- Mobile number Delegate
    func mobileNumberVerified() {
        //reload data
        getPackagesWithFamilyDetailsFromServer(isMoveToHospitalList: true)
    }
    //MARK:- Protocol Methods
    func newMemberAdded() {
        getPackagesWithFamilyDetailsFromServer(isMoveToHospitalList: false)
    }
    
    //MARK- add Shimmer
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("In HealthCheckupOptVC")
        print("VDA..=\(isAddMember)")
        
        //Get Data from Server
       // if isReloadFamilyDetails == 1 {
            
            getPackagesWithFamilyDetailsFromServer(isMoveToHospitalList: false)
            
       // }
        
        //Get Data for Bottom bar view
        getSummaryDataFromServer()
        
        if isAddMember == 1 {
            getRelationDataFromServer()
        }
        
        
    }
    
    func setupFamilyDetails()
    {
        self.navigationController?.navigationBar.applyGradient()
        self.navigationController?.navigationBar.navBarDropShadow()
        //cartBottomView.backgroundColor = Color.bottomColor.value
        
        
        self.cartBarButton =  UIBarButtonItem(image:UIImage(named: "cartW") , style: .plain, target: self, action: #selector(cartTapped))
        self.cartBarButton.imageInsets =  UIEdgeInsetsMake(0, 0, 0, 0)
        //UIEdgeInsetsMake(4, 4, 6, 4)
        
        
        //let notiBtn =  UIBarButtonItem(image:UIImage(named: "notification") , style: .plain, target: self, action: #selector(notificationTapped))
        
        
        navigationItem.rightBarButtonItems = [cartBarButton]
        
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
            lbNavTitle.textColor = UIColor.white
            lbNavTitle.numberOfLines = 0
            lbNavTitle.center = CGPoint(x: 0, y: 0)
            lbNavTitle.textAlignment = .left
            lbNavTitle.font = UIFont(name:"Poppins-SemiBold", size: 17.0)
        
        lbNavTitle.text = "Available Packages"
        self.navigationItem.titleView = lbNavTitle
        
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        
        //self.navigationItem.title = "Available Packages"
        print("In \(lbNavTitle.text ?? "Available Packages for Family") HealthCheckupOptVC")

        self.navigationController?.navigationBar.changeFont()
        
        //self.navigationController?.navigationBar.layer.shouldRasterize=false
        
        
    }
    
    @objc func notificationTapped() {
        
    }
    
    @objc func cartTapped() {
        let summaryVC : SummaryViewController = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"SummaryViewController") as! SummaryViewController
        
        menuButton.isHidden = true
        tabBarController?.tabBar.isHidden = true
        //bottomConstraint.constant = 0
        self.navigationController?.pushViewController(summaryVC, animated: true)
    }
    
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func homeButtonClicked(sender: UIButton)
    {
        tabBarController!.selectedIndex = 2
        //menuButton.backgroundColor = UIColor.red
        //Change menu button image
        let origImage = UIImage(named:"Home-2")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        menuButton.setImage(tintedImage, for: .normal)
        // menuButton.tintColor = Color.buttonBackgroundGreen.value
        menuButton.tintColor = UIColor.white
    }
    
}


//MARK:- TableView DataSource
extension HealthCheckupOptVC : UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- TableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        //package + overview cell
        return packageModelArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1 //for overview
        }
        
        return packageModelArray[section-1].personModelArray.count + 1
        
    }
    
    //Before updating two buttons
    /*
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cityCell = tableView.dequeueReusableCell(withIdentifier: "CellForOverviewHHC", for: indexPath) as! CellForOverviewHHC
            cityCell.btnOverview.addTarget(self, action: #selector(overViewTapped(_:)), for: .touchUpInside)
            
            return cityCell
            
        }
        else {
            
            if indexPath.row == 0 { //  price cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellForHCCard", for: indexPath) as! CellForHCCard
                //shadowForCell(view: cell.backView)
                cell.viewPackageIncludes.tag = indexPath.section - 1
                let gesture1 = UITapGestureRecognizer(target: self, action: #selector(viewPackageDidTapped(_:)))
                cell.viewPackageIncludes.isUserInteractionEnabled=true
                cell.viewPackageIncludes.addGestureRecognizer(gesture1)
                
                cell.lblPackName.text = packageModelArray[indexPath.section - 1].PackageName
                cell.lblAmount.text = (packageModelArray[indexPath.section - 1].PackagePrice ?? "")
                cell.lblGender.text = packageModelArray[indexPath.section - 1].GenderText
                
                cell.isUserInteractionEnabled = true
                
                if packageModelArray[indexPath.section - 1].personModelArray.count == 0 {
                    cell.selectPackageFor.text = "Member not found"
                }
                else {
                    cell.selectPackageFor.text = "Select Package For"
                    
                }
                
                return cell
            }
            else { //name cell

                
                let cell: CellForHealthCheckupSelection = tableView.dequeueReusableCell(withIdentifier: "CellForHealthCheckupSelection", for: indexPath) as! CellForHealthCheckupSelection
                
                //let cell: CellForHealthCheckupSelection = tableView.dequeueReusableCell(withIdentifier: "CellForHealthCheckupSelection", for: indexPath) as! CellForHealthCheckupSelection
                
                cell.lblName.text = packageModelArray[indexPath.section - 1].personModelArray[indexPath.row - 1].PersonName
                
                
                
                if let isBooked = packageModelArray[indexPath.section - 1].personModelArray[indexPath.row - 1].IsSelectedInWellness as? Bool {
                    if isBooked {
                        cell.checkBoxImageView.setImage(UIImage(named: "black checkbox checked"), for: .normal)
                        
                    }
                    else {
                        cell.checkBoxImageView.setImage(UIImage(named: "black checkbox"), for: .normal)
                        
                    }
                }
                
                if let isSelectedByUser = packageModelArray[indexPath.section - 1].personModelArray[indexPath.row - 1].isSelectedByUser as? Bool {
                    if isSelectedByUser {
                        cell.checkBoxImageView.setImage(UIImage(named: "black checkbox checked"), for: .normal)
                        cell.heightForScheduleView.constant = 35.0
                        cell.scheduleView.isHidden = false
                        
                    }
                    else {
                        cell.checkBoxImageView.setImage(UIImage(named: "black checkbox"), for: .normal)
                        cell.heightForScheduleView.constant = 0
                        cell.scheduleView.isHidden = true
                    }
                }
                else {
                    cell.checkBoxImageView.setImage(UIImage(named: "black checkbox"), for: .normal)
                    
                    cell.heightForScheduleView.constant = 0
                    cell.scheduleView.isHidden = true
                    
                }
                
                cell.topNameView.tag = indexPath.row - 1
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(namecellTapped(_:)))
                cell.topNameView.addGestureRecognizer(tapRecognizer)
                
                cell.scheduleView.tag = indexPath.row - 1
                let tapRecognizersc = UITapGestureRecognizer(target: self, action: #selector(sccellTapped(_:)))
                cell.scheduleView.addGestureRecognizer(tapRecognizersc)
                
                
                if packageModelArray[indexPath.section - 1].personModelArray[indexPath.row - 1].paidNotScheduled == "1" {
                    cell.btnDelete.setImage(UIImage(named: "paidpaid"), for: .normal)
                    cell.btnDelete.isUserInteractionEnabled = false
                    
                }
                else {
                    
                    //Check Conditions
                    let condition = packageModelArray[indexPath.section - 1].personModelArray[indexPath.row - 1].AppointmentStatusBadge
                    if condition != "" {
                        cell.btnDelete.isHidden = false
                        
                        switch condition! {
                        case "SCHEDULED":
                            //  cell.btnDelete.isHidden = true
                            //holder.ivappschedule.setVisibility(View.VISIBLE);
                            cell.btnDelete.setImage(UIImage(named: "ic_schedulenewHC"), for: .normal)
                            cell.btnDelete.isUserInteractionEnabled = false
                            break
                        case "CONFIRMED":
                            //holder.ivappconfirm.setVisibility(View.VISIBLE);
                            // cell.btnDelete.isHidden = true
                            cell.btnDelete.setImage(UIImage(named: "ic_confirmnew"), for: .normal)
                            cell.btnDelete.isUserInteractionEnabled = false
                            
                            break
                        case "REJECTED":
                            //holder.ivappreject.setVisibility(View.VISIBLE);
                            cell.btnDelete.isHidden = true
                            
                            break
                        case "APPOINTMENT DONE":
                            //holder.ivappappdone.setVisibility(View.VISIBLE);
                            // cell.btnDelete.isHidden = true
                            cell.btnDelete.setImage(UIImage(named: "ic_app_donenew"), for: .normal)
                            cell.btnDelete.isUserInteractionEnabled = false
                            
                            break
                        case "APPOINTMENT NOT DONE":
                            //holder.ivappreject.setVisibility(View.VISIBLE);
                            //   cell.btnDelete.isHidden = true
                            cell.btnDelete.setImage(UIImage(named: "ic_schedulenewHC"), for: .normal)
                            cell.btnDelete.isUserInteractionEnabled = false
                            
                            break
                        default:
                            cell.btnDelete.setImage(UIImage(named: "ic_delete"), for: .normal)
                            cell.btnDelete.isUserInteractionEnabled = true
                            
                            break
                        }
                    }
                    else {
                        
                        if packageModelArray[indexPath.section - 1].personModelArray[indexPath.row - 1].SponserdByFlag == "CS" {
                            cell.btnDelete.setImage(UIImage(named: "ic_comp_sponsnew"), for: .normal)
                            cell.btnDelete.isUserInteractionEnabled = false
                            cell.btnDelete.isHidden = false
                            
                        }
                        else {
                            
                            if packageModelArray[indexPath.section - 1].personModelArray[indexPath.row - 1].CanBeDeletedFalg == 1 {
                                cell.btnDelete.isHidden = false
                                cell.btnDelete.isUserInteractionEnabled = true
                                cell.btnDelete.setImage(UIImage(named: "ic_delete"), for: .normal)
                                
                            }
                            else {
                                cell.btnDelete.isHidden = true
                            }
                            
                        }
                        
                    }
                    
                }//else
                
                if packageModelArray[indexPath.section - 1].personModelArray[indexPath.row - 1].IsDisabled! {
                    cell.isUserInteractionEnabled = false
                    cell.checkBoxImageView.setImage(UIImage(named: "checkbox"), for: .normal)
                    
                    //checkbox
                }
                else {
                    
                    cell.isUserInteractionEnabled = true
                }
                
                cell.btnDelete.tag = indexPath.row
                cell.btnDelete.addTarget(self, action: #selector(self.deleteNowDidTapped(_:)), for: .touchUpInside)
                cell.btnDelete.isUserInteractionEnabled = true
                
                return cell
                
                
                return cell
            } //else END
        }
    } */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cityCell = tableView.dequeueReusableCell(withIdentifier: "CellForOverviewHHC", for: indexPath) as! CellForOverviewHHC
            cityCell.btnOverview.addTarget(self, action: #selector(overViewTapped1(_:)), for: .touchUpInside)
            cityCell.btnRates.addTarget(self, action: #selector(overViewTapped2(_:)), for: .touchUpInside)
            cityCell.btnRef.addTarget(self, action: #selector(overViewTapped3(_:)), for: .touchUpInside)
            cityCell.btnRef.makeHHCCircularButton()
            /*
            cityCell.bgView.layer.masksToBounds = false
            cityCell.bgView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
            cityCell.bgView.layer.shadowOpacity = 30
            cityCell.bgView.layer.shadowOffset = CGSize(width: 0.0, height: 2)
            cityCell.bgView.layer.shadowRadius = 3
            cityCell.bgView.layer.cornerRadius = 20
             */
            return cityCell
            
        }
        else {
            
            if indexPath.row == 0 { //  price cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellForHCCard", for: indexPath) as! CellForHCCard
                //shadowForCell(view: cell.backView)
                cell.viewPackageIncludes.tag = indexPath.section - 1
                let gesture1 = UITapGestureRecognizer(target: self, action: #selector(viewPackageDidTapped(_:)))
                cell.viewPackageIncludes.isUserInteractionEnabled=true
                cell.viewPackageIncludes.addGestureRecognizer(gesture1)
                
                cell.lblPackName.text = packageModelArray[indexPath.section - 1].PackageName
                
                if let price = packageModelArray[indexPath.section - 1].PackagePrice {
                    var formattedPrice =  price.replace(string: "₹", replacement: "").currencyInputFormatting()
                    formattedPrice = "₹ " + formattedPrice
                    cell.lblAmount.text = formattedPrice
                }
                
                //cell.lblAmount.text = (packageModelArray[indexPath.section - 1].PackagePrice ?? "")
                
                cell.lblGender.text = packageModelArray[indexPath.section - 1].GenderText
                if cell.lblGender.text?.lowercased() == "male/female" {
                    cell.genderBackView.backgroundColor = hexStringToUIColor(hex: "9c27b0")
                }else if cell.lblGender.text?.lowercased() == "female"{
                    cell.genderBackView.backgroundColor = hexStringToUIColor(hex: "f584cd")
                }else{
                    cell.genderBackView.backgroundColor = hexStringToUIColor(hex: "337ab7")
                }
                
                cell.isUserInteractionEnabled = true
                
                if packageModelArray[indexPath.section - 1].personModelArray.count == 0 {
                    cell.selectPackageFor.text = "Member not found"
                }
                else {
                    cell.selectPackageFor.text = "Package Applicable"
                }
                
                return cell
            }
            else { //name cell

                let cell: CellForHealthCheckupSelection = tableView.dequeueReusableCell(withIdentifier: "CellForHealthCheckupSelection", for: indexPath) as! CellForHealthCheckupSelection
                        cell.lblName.text = packageModelArray[indexPath.section - 1].personModelArray[indexPath.row - 1].PersonName
                        
            
                        
                        if let isBooked = packageModelArray[indexPath.section - 1].personModelArray[indexPath.row - 1].IsSelectedInWellness as? Bool {
                            if isBooked {
                                cell.checkBoxImageView.setImage(UIImage(named: "black checkbox checked"), for: .normal)
                                //cell.heightForScheduleView.constant = 35.0
                                //cell.scheduleView.isHidden = false
                            }
                            else {
                                cell.checkBoxImageView.setImage(UIImage(named: "black checkbox"), for: .normal)
                                //cell.heightForScheduleView.constant = 0
                                //cell.scheduleView.isHidden = true
                            }
                        }
                   
                        if let isSelectedByUser = packageModelArray[indexPath.section - 1].personModelArray[indexPath.row - 1].isSelectedByUser as? Bool {
                            if isSelectedByUser {
                                cell.checkBoxImageView.setImage(UIImage(named: "black checkbox checked"), for: .normal)
                                cell.heightForScheduleView.constant = 35.0
                                cell.scheduleView.isHidden = false

                            }
                            else {
                                cell.checkBoxImageView.setImage(UIImage(named: "black checkbox"), for: .normal)
                                cell.heightForScheduleView.constant = 0
                                cell.scheduleView.isHidden = true
                            }
                        }
                        else {
                            cell.checkBoxImageView.setImage(UIImage(named: "black checkbox"), for: .normal)

                            cell.heightForScheduleView.constant = 0
                            cell.scheduleView.isHidden = true

                        }
                        
                        cell.topNameView.tag = indexPath.row
                        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(namecellTapped(_:)))
                        cell.topNameView.addGestureRecognizer(tapRecognizer)
                        
                        cell.scheduleView.tag = indexPath.row
                        let tapRecognizersc = UITapGestureRecognizer(target: self, action: #selector(sccellTapped(_:)))
                        cell.scheduleView.addGestureRecognizer(tapRecognizersc)

                       
                      
                        print("BADGE.....")
                        print(packageModelArray[indexPath.section - 1].personModelArray[indexPath.row - 1].paidNotScheduled)
                        print(packageModelArray[indexPath.section - 1].personModelArray[indexPath.row - 1].AppointmentStatusBadge)
                        
                        if packageModelArray[indexPath.section - 1].personModelArray[indexPath.row - 1].paidNotScheduled == "1" {
                            cell.btnDelete.setImage(UIImage(named: "ic_prepaidnew"), for: .normal)
                            cell.btnDelete.isHidden = false
                            cell.btnDelete.isUserInteractionEnabled = false
                        }
                        else {
                        //Check Conditions
                        let condition = packageModelArray[indexPath.section - 1].personModelArray[indexPath.row - 1].AppointmentStatusBadge
                        if condition != "" {
                            cell.btnFirst.isHidden = false

                            switch condition!.uppercased() {
                             case "SCHEDULED":
                            //  cell.btnFirst.isHidden = true
                              //holder.ivappschedule.setVisibility(View.VISIBLE);
                              cell.btnFirst.setImage(UIImage(named: "ic_schedulenewHC"), for: .normal)
                              cell.btnFirst.isUserInteractionEnabled = false
                              break
                              case "CONFIRMED":
                              //holder.ivappconfirm.setVisibility(View.VISIBLE);
                                 // cell.btnFirst.isHidden = true
                                  cell.btnFirst.setImage(UIImage(named: "ic_confirmnew"), for: .normal)
                                  cell.btnFirst.isUserInteractionEnabled = false

                              break
                              case "REJECTED":
                              //holder.ivappreject.setVisibility(View.VISIBLE);
                                  cell.btnFirst.isHidden = true

                              break
                              case "APPOINTMENT DONE":
                              //holder.ivappappdone.setVisibility(View.VISIBLE);
                                 // cell.btnFirst.isHidden = true
                                  cell.btnFirst.setImage(UIImage(named: "ic_app_donenew"), for: .normal)
                                  cell.btnFirst.isUserInteractionEnabled = false

                              break
                              case "APPOINTMENT NOT DONE":
                              //holder.ivappreject.setVisibility(View.VISIBLE);
                               //   cell.btnFirst.isHidden = true
                                  cell.btnFirst.setImage(UIImage(named: "ic_schedulenewHC"), for: .normal)
                                  cell.btnFirst.isUserInteractionEnabled = false

                              break
                              default:
                                  cell.btnFirst.setImage(UIImage(named: "ic_delete"), for: .normal)
                                  cell.btnFirst.isUserInteractionEnabled = true

                              break
                              }
                        }
                        else {
                            //If Condition is blank
                            cell.btnFirst.setImage(UIImage(named: ""), for: .normal)
                            }
                            
                            if self.packageModelArray[indexPath.section - 1].personModelArray[indexPath.row - 1].SponserdByFlag == "CS" {
                                cell.btnDelete.setImage(UIImage(named: "ic_comp_sponsnew"), for: .normal)
                                cell.btnDelete.isUserInteractionEnabled = false
                                cell.btnDelete.isHidden = false
                            }
                            else if self.packageModelArray[indexPath.section - 1].personModelArray[indexPath.row - 1].SponserdByFlag == "PP" {
                                cell.btnDelete.setImage(UIImage(named: "ic_prepaidnew"), for: .normal)
                                cell.btnDelete.isUserInteractionEnabled = false
                                cell.btnDelete.isHidden = false
                            }
                            else {
                                cell.btnDelete.setImage(UIImage(named: ""), for: .normal)
                                cell.btnDelete.isUserInteractionEnabled = false
                                cell.btnDelete.isHidden = false
                            }
                                
                                //Set Delete Functionality
                            if self.packageModelArray[indexPath.section - 1].personModelArray[indexPath.row - 1].CanBeDeletedFalg == 1 {
                                cell.btnDelete.isHidden = false
                                cell.btnDelete.isUserInteractionEnabled = true
                                cell.btnDelete.setImage(UIImage(named: "ic_delete"), for: .normal)
                                //cell.stackWidth.constant = 60.0
                            }
                            else {
                                cell.btnDelete.isUserInteractionEnabled = false
                                cell.btnDelete.isHidden = false
                                //cell.stackWidth.constant = 30.0
                            }
                            
                }//else
                
                //Disable Cell
                if self.packageModelArray[indexPath.section - 1].personModelArray[indexPath.row - 1].IsDisabled! {
                    cell.isUserInteractionEnabled = false
                    cell.checkBoxImageView.setImage(UIImage(named: "hcOpted"), for: .normal)
                }
                else {
                    cell.isUserInteractionEnabled = true
                }

                cell.btnDelete.tag = indexPath.row
                cell.btnDelete.addTarget(self, action: #selector(self.deleteNowDidTapped(_:)), for: .touchUpInside)
                
                //Last Row
                let rows = tableView.numberOfRows(inSection: indexPath.section)
                if indexPath.row == rows - 1 {
                    print("Last")
                    cell.bottomLineView.isHidden = false
                   // cell.isLast = true
                   //cell.layer.addBorder(edge: .bottom, color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), thickness: 1.0)
                }
                else {
                    print("Not Last")

                    cell.bottomLineView.isHidden = true

                  // cell.layer.addBorder(edge: .bottom, color: UIColor.clear, thickness: 1.0)
                }
            //cell.reloadInputViews()

                return cell
                
            } //else END
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 60
        }
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 5))
        //footerView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        footerView.backgroundColor = UIColor.clear
        return footerView
        
        
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//
//       return 5
//
//     }
    
    @objc func overViewTapped1(_ sender : UIButton) {
        showOverview(title: "first")
    }
    
    @objc func overViewTapped2(_ sender : UIButton) {
        showOverview(title: "second")
    }
    
    @objc func overViewTapped3(_ sender : UIButton) {
        showOverview(title: "third")
    }
    
    func showOverview(title:String)
    {
        let vc = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
        vc.tabString = title
        self.navigationController?.pushViewController(vc, animated: true)

       // navigationController?.pushViewController(vc, animated: true)
    }
}

extension HealthCheckupOptVC {
    @objc private func namecellTapped(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: tableView)
        
        guard let clickedIndexPath = tableView.indexPathForRow(at: touchPoint) else {
            return
        }
        print("index path.section ==%ld", clickedIndexPath.section)
        print("index path.row ==%ld", clickedIndexPath.row)
        
        
        if packageModelArray[clickedIndexPath.section - 1].personModelArray[clickedIndexPath.row - 1].isSelectedByUser == true {
            packageModelArray[clickedIndexPath.section - 1].personModelArray[clickedIndexPath.row - 1].isSelectedByUser = false
            
            // if self.dependantTappedDelegate != nil {
            // let obj = packageModelArray[clickedIndexPath.section].personModelArray[clickedIndexPath.row]
            //  self.dependantCellTapped(packageSr:obj.PackageSrNo!, depdantSrNo: obj.PersonSRNo!, isSelected: false)
            //}
        }
        else {
            packageModelArray[clickedIndexPath.section - 1 ].personModelArray[clickedIndexPath.row - 1].isSelectedByUser = true
            
            //self.personModelArray[index.row].isSelectedByUser = true
            
            //               if self.dependantTappedDelegate != nil {
            //                   let obj = self.personModelArray[index.row]
            //                   self.dependantTappedDelegate?.dependantCellTapped(packageSr:obj.PackageSrNo!, depdantSrNo: obj.PersonSRNo!, isSelected: true)
            //               }
        }
        
        self.tableView.reloadData()
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        self.tableView.layoutSubviews()
        self.tableView.reloadInputViews()
        //self.tableView.reloadData()

    }
    
    //MARK:- Protocol Method
    func dependantCellTapped(packageSr: String, depdantSrNo: Int, isSelected: Bool) {
        
        for i in 0..<packageModelArray.count {
            let packageObj = packageModelArray[i]
            if packageObj.PackageSrNo == packageSr {
                for j in 0..<packageObj.personModelArray.count {
                    let personObj = packageObj.personModelArray[j]
                    if personObj.PersonSRNo == depdantSrNo {
                        print("Before Update")
                        print(packageModelArray)
                        
                        self.packageModelArray[i].personModelArray[j].isSelectedByUser = isSelected
                        
                        print("After Update")
                        print(packageModelArray)
                    }
                }
            }
        }
        
    }
    
    @objc private func sccellTapped(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: tableView)
        
        guard let clickedIndexPath = tableView.indexPathForRow(at: touchPoint) else {
            return
        }
        print("index path.section ==%ld", clickedIndexPath.section - 1)
        print("index path.row ==%ld", clickedIndexPath.row - 1)
        
        let personCheckupModel = packageModelArray[clickedIndexPath.section - 1].personModelArray[clickedIndexPath.row - 1]
        
        if personCheckupModel.IsMobEmailConf != 1 {
            let vc = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"VerifyMobileNoViewController") as! VerifyMobileNoViewController
            vc.memberDetailsModel = personCheckupModel
            vc.modalPresentationStyle = .custom
            vc.mobileNumberDelegate = self
            self.personDetailsModel = personCheckupModel
            self.hcPackageDetailsModel = packageModelArray[clickedIndexPath.section - 1]
            
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
        else {
            let vc = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"HospitalsListViewController") as! HospitalsListViewController
            vc.memberDetailsModel = personCheckupModel
            vc.hcPackageDetailsModel = packageModelArray[clickedIndexPath.section - 1]
            
            vc.isFromFamily = 1
            self.personDetailsModel = personCheckupModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    //MARK:- Delete Now
    @objc private func deleteNowDidTapped(_ sender : UIButton) {
        
        let touchPoint = sender.convert(CGPoint.zero, to: self.tableView)
        
        
        guard let clickedIndexPath = tableView.indexPathForRow(at: touchPoint) else {
            return
        }
        
        
        
        print("index path.section ==%ld", clickedIndexPath.section - 1)
        print("index path.row ==%ld", clickedIndexPath.row - 1)
        
        
        let obj = packageModelArray[clickedIndexPath.section - 1].personModelArray[clickedIndexPath.row - 1]
        if obj.CanBeDeletedFalg == 1 {
            
            let vc = UIStoryboard.init(name: "CustomPopups", bundle: nil).instantiateViewController(withIdentifier:"DeleteConfirmationPopupVC") as! DeleteConfirmationPopupVC
            vc.yesNoDelegate = self
            vc.memberId = (obj.PersonSRNo ?? 0).description
            vc.modalPresentationStyle = .custom
            vc.modalTransitionStyle = .crossDissolve
            navigationController?.present(vc, animated: true, completion: nil)

            
            
           // let personSr = obj.PersonSRNo?.description
           // self.deleteFamilyMember(personSRNo: personSr!, indexPath: clickedIndexPath)
        }
        else {
            
        }
    }
}


extension HealthCheckupOptVC {
    
    private func getSummaryDataFromServer() {
        //http://mybenefits360.in/mbapi/api/v1/HealthCheckup/GetSummary?FamilySrNo=5560
        
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
            return
        }
        
        //let url = APIEngine.shared.getSummaryDetailsURL(familySRNo: familySrNo as! String, groupCode: "STT")
        let url = APIEngine.shared.getSummaryDetailsURL(familySRNo: familySrNo as! String, groupCode: self.getGroupCode())
        //let url = APIEngine.shared.getSummaryDetailsURL(familySRNo: "17878", groupCode: "NAYASA1")
        
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServerWithoutLoader(url: url, view: self) { (response, error) in
            
            if let messageDictionary = response?["message"].dictionary
            {
                
                if let status = messageDictionary["Status"]?.bool
                {
                    if status == true {
                        if let summaryDict = response?["Summary"].dictionary {
                            
                            var companySponsoredArray = [PersonSummary]()
                            var selfSponsoredArray = [PersonSummary]()
                            
                            //Company Sponsored Array
                            if let companyArray = summaryDict["CompanySponseredPerson"]?.arrayValue {
                                for company in companyArray {
                                    let obj = PersonSummary.init(Name: company["Name"].stringValue, Price: company["Price"].stringValue)
                                    companySponsoredArray.append(obj)
                                }//for
                            }//companyArray
                            
                            if let selfArray = summaryDict["SelfSponseredPerson"]?.arrayValue {
                                for person in selfArray {
                                    let obj = PersonSummary.init(Name: person["Name"].stringValue, Price: person["Price"].stringValue)
                                    selfSponsoredArray.append(obj)
                                }//for
                            }//selfArray
                            
                            
                            let total = summaryDict["Total"]?.stringValue
                            let paid = summaryDict["paid"]?.stringValue
                            let youpay = summaryDict["Youpay"]?.stringValue
                            let confirmbutton = summaryDict["ShowConfirmButton"]?.boolValue
                            
                            if let payAmt = summaryDict["Youpay"]?.string {
                                //self.youPayAmount = Double(payAmt) as! Double
                                
                                //Currency Converter
                                if let myDouble = Double(payAmt) {
                                    let currencyFormatter = NumberFormatter()
                                    currencyFormatter.usesGroupingSeparator = true
                                    currencyFormatter.numberStyle = .currency
                                    // localize to your grouping and decimal separator
                                    currencyFormatter.locale = Locale.current
                                    // We'll force unwrap with the !, if you've got defined data you may need more error checking
                                    var priceString = currencyFormatter.string(from: NSNumber(value: myDouble))
                                    
                                    priceString = priceString?.replacingOccurrences(of: ".00", with: "")
                                    self.lblAmount.text = String(format: "%@",priceString ?? "")
                                }//if let
                            }
                            
                            
                            self.summaryModelObject = SummaryModel.init(Total: total, paid: paid, Youpay: youpay, ShowConfirmButton: confirmbutton ?? true, CompanySponsoredArray: companySponsoredArray, SelfSponsoredArray: selfSponsoredArray)
                            
                            
                            if self.summaryModelObject.ShowConfirmButton == true {
                                self.cartBottomView.isHidden = false
                                self.bottomConstraint.constant = 40
                                if Device.IS_IPHONE_X || Device.IS_IPHONE_XsMax {
                                    //self.bottomConstraint.constant = (self.tabBarController?.tabBar.frame.height)!
                                    self.bottomConstraint.constant = 40
                                    
                                }
                                else {
                                    //Error found 1oct
                                    //Thread 1: EXC_BREAKPOINT (code=1, subcode=0x100861788)
                                    
                                    if let height = self.tabBarController?.tabBar.frame.height {
                                        self.bottomConstraint.constant = height
                                    }
                                    //to avoid crash
                                   // self.bottomConstraint.constant = (self.tabBarController?.tabBar.frame.height)!
                                }
                                
                                
                                //  self.lblAmount.text = String(format: "₹%@",self.summaryModelObject.Youpay ?? "")
                                
                                let noOfItems = self.summaryModelObject.CompanySponsoredArray.count + self.summaryModelObject.SelfSponsoredArray.count
                                
                                if noOfItems > 1 {
                                
                                    self.lblNoOfItems.text = String(format: "%@ Items",String(noOfItems))
                                    self.cartBarButton.setBadge(text: noOfItems.description)
                                }
                                else {
                                    self.lblNoOfItems.text = String(format: "%@ Item",String(noOfItems))
                                    self.cartBarButton.removeBadge()
                                    //self.cartBarButton.setBadge(text: "")
                                }
                                
                            }
                            else {
                                self.cartBarButton.removeBadge()
                                self.cartBottomView.isHidden = true
                                self.bottomConstraint.constant = 0
                            }
                            
                        }
                        
                        
                    }//true
                    else {
                        self.cartBottomView.isHidden = true
                        self.bottomConstraint.constant = 0
                        //Summary record not found
                    }
                }
            }//msgDic
        }
    }
    
    private func getRelationDataFromServer() {
        
        guard let familySrNo = UserDefaults.standard.value(forKey: "ExtFamilySrNo") else {
            return
        }
        
        
        let url = APIEngine.shared.getAllRelationsURL(familySrNo: familySrNo as! String)
        print(url)
        ServerRequestManager.serverInstance.getRequestDataFromServer(url: url, view: self) { (response, error) in
            
            if let messageDictionary = response?["message"].dictionary
            {
                
                if let status = messageDictionary["Status"]?.bool
                {
                    if status == true {
                        
                        if let date = response?["ServerDate"]["Date"].stringValue {
                            self.serverDate = date
                        }
                        
                        if let relationArray = response?["Relations"].arrayValue {
                            //To Remove relation duplicates
                            self.relationModelArray.removeAll()
                            self.relationStringArray.removeAll()
                            
                            
                            for relation in relationArray {
                                let obj = RelationDataModel.init(relationId: relation["RelationId"].stringValue, relationName: relation["RelationName"].stringValue)
                                self.relationStringArray.append(relation["RelationName"].stringValue)
                                self.relationModelArray.append(obj)
                            }
                            
                            //Move to add Member screen
                            self.showAddMemberScreen()
                        }
                        
                    }
                    else {
                        //Relations record not found
                    }
                }
            }//msgDic
        }
    }
    
    //MARK:- ADD Member
    private func showAddMemberScreen() {
        if isAddMember == 1 {
            let vc = UIStoryboard.init(name: "Wellness", bundle: nil).instantiateViewController(withIdentifier:"AddMemberViewController") as! AddMemberViewController
            vc.relationDropDown.dataSource = self.relationStringArray
            vc.dataSourceArray = self.relationStringArray
            vc.serverDate = self.serverDate
            vc.relationModelArray = self.relationModelArray
            vc.modalPresentationStyle = .custom
            vc.memberDelegate = self
            
            self.navigationController?.present(vc, animated: true, completion: nil)
           isAddMember = 0
        }
    }
}


extension HealthCheckupOptVC:DeleteMemberConfirmationProtocol {
    
    func dontDeleteMemberTapped() {
        
    }
    
    func deleteMemberTapped(memberId: String) {
        if memberId != "" && memberId != nil {
            self.deleteFamilyMember(personSRNo: memberId)
        }
    }
}

extension CALayer {

  func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {

    let border = CALayer()

    switch edge {
    case UIRectEdge.top:
        border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)

    case UIRectEdge.bottom:
        border.frame = CGRect(x:0, y: frame.height - thickness, width: frame.width, height:thickness)

    case UIRectEdge.left:
        border.frame = CGRect(x:0, y:0, width: thickness, height: frame.height)

    case UIRectEdge.right:
        border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)

    default: do {}
    }

    border.backgroundColor = color.cgColor

    addSublayer(border)
 }
}

