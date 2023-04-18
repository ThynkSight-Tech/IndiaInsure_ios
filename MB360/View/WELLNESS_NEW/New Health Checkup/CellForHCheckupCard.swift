//
//  CellForHCheckupCard.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 23/04/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit

protocol DependantTappedProtocol {
    func dependantCellTapped(packageSr:String,depdantSrNo:Int,isSelected:Bool)
    func scheduleNowTapped(packageSr:String,depdantSrNo:Int,packageInfo:HealthCheckupModel,isMoveToHospital:Bool,personCheckupModel:PersonCheckupModel)

}

class CellForHCheckupCard: UICollectionViewCell,UITableViewDataSource,UITableViewDelegate,MobileNumberVerifyDelegate {
   
    

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var packageIncludesView: UIView!
    @IBOutlet weak var innerBorderView: UIView!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var leftImgView: UIImageView!

    @IBOutlet weak var lblPackageName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    
    var personModelArray = [PersonCheckupModel]()
    
    var packageInfo = HealthCheckupModel()

    var dependantTappedDelegate : DependantTappedProtocol? = nil
    
    override func awakeFromNib() {
        print(" In CellForHCheckupCard")
        let nibName = UINib(nibName: "CellForHealthCheckupSelection", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "CellForHealthCheckupSelection")
       // innerBorderView.layer.borderColor = #colorLiteral(red: 0, green: 0.8515233994, blue: 0.5666388869, alpha: 1)
        innerBorderView.layer.borderWidth = 1.0
        
        //self.contentView.clipsToBounds = true

      //  genderView.clipsToBounds = true
        
        genderView.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.2470588235, blue: 0.4941176471, alpha: 1)
        priceView.backgroundColor = Color.buttonBackgroundGreen.value

        //packageIncludesView.layer.borderColor = #colorLiteral(red: 0.2823529412, green: 0.5294117647, blue: 1, alpha: 1)
        
        packageIncludesView.layer.borderColor = #colorLiteral(red: 0.2509803922, green: 0.8784313725, blue: 0.8156862745, alpha: 1)
        packageIncludesView.layer.borderWidth = 1.0
        packageIncludesView.layer.cornerRadius = 4.0
        
        self.genderView.layer.cornerRadius = 2.0
        self.priceView.layer.cornerRadius = 2.0

        //self.ShadowForView()
        self.dropShadow()
        //drawLines()
    }
    
    func drawLines() {
        // 1
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 280, height: 250))

        let img = renderer.image { ctx in
            // 2
            ctx.cgContext.move(to: CGPoint(x: 20.0, y: 20.0))
            ctx.cgContext.addLine(to: CGPoint(x: 260.0, y: 230.0))
            ctx.cgContext.addLine(to: CGPoint(x: 100.0, y: 200.0))
            ctx.cgContext.addLine(to: CGPoint(x: 20.0, y: 20.0))

            ctx.cgContext.setLineWidth(10)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)

            // 3
            ctx.cgContext.strokePath()
        }

        leftImgView.image = img
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if personModelArray.count == 0 {
            tableView.setEmptyView(title: "Member not found", message: "Member not found")
            return 0
        }
        tableView.restore()
        return personModelArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: CellForHealthCheckupSelection = tableView.dequeueReusableCell(withIdentifier: "CellForHealthCheckupSelection", for: indexPath) as! CellForHealthCheckupSelection
        cell.lblName.text = personModelArray[indexPath.row].PersonName
        
//        if indexPath.row == 1 {
//            cell.heightForScheduleView.constant = 35.0
//            cell.scheduleView.isHidden = false
//
//        }
//        else {
           // cell.heightForScheduleView.constant = 0
            //cell.scheduleView.isHidden = true
//
//        }
        
        if let isBooked = self.personModelArray[indexPath.row].IsSelectedInWellness as? Bool {
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
        /*
        if self.personModelArray[indexPath.row].SponserdByFlag == "CS" {
            cell.btnFirst.setImage(UIImage(named: "ic_comp_sponsnew"), for: .normal)
            cell.btnFirst.isUserInteractionEnabled = false
        }
        else {
            cell.btnFirst.isUserInteractionEnabled = true
            cell.btnFirst.setImage(UIImage(named: "ic_delete"), for: .normal)
        }
        */
        if let isSelectedByUser = self.personModelArray[indexPath.row].isSelectedByUser as? Bool {
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

       
        /*
        if self.personModelArray[indexPath.row].CanBeDeletedFalg == 1 && self.personModelArray[indexPath.row].SponserdByFlag != "CS"{
            cell.btnFirst.isUserInteractionEnabled = true
            cell.btnFirst.isHidden = false
            cell.btnFirst.setImage(UIImage(named: "ic_delete"), for: .normal)

        }
        else {
            cell.btnFirst.isUserInteractionEnabled = false
        }
        */
        print("BADGE.....")
        print(self.personModelArray[indexPath.row].paidNotScheduled)
        print(self.personModelArray[indexPath.row].AppointmentStatusBadge)
        
        if self.personModelArray[indexPath.row].paidNotScheduled == "1" {
            //cell.btnFirst.setImage(UIImage(named: "paidpaid"), for: .normal)
            cell.btnDelete.setImage(UIImage(named: "ic_prepaidnew"), for: .normal)
            cell.btnDelete.isUserInteractionEnabled = false
        }
        else {
        //Check Conditions
        let condition = self.personModelArray[indexPath.row].AppointmentStatusBadge
        if condition != "" {
            cell.btnFirst.isHidden = false

            switch condition! {
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
            
            if self.personModelArray[indexPath.row].SponserdByFlag == "CS" {
                cell.btnFirst.setImage(UIImage(named: "ic_comp_sponsnew"), for: .normal)
                cell.btnFirst.isUserInteractionEnabled = false
                cell.btnFirst.isHidden = false
                cell.btnDelete.isHidden = true

            }
            else {
                
                if self.personModelArray[indexPath.row].CanBeDeletedFalg == 1 {
                    cell.btnDelete.isHidden = false
                    cell.btnDelete.isUserInteractionEnabled = true
                    cell.btnDelete.setImage(UIImage(named: "ic_delete"), for: .normal)
                    //cell.stackWidth.constant = 60.0
                }
                else {
                    
                    cell.btnDelete.isHidden = false
                   // cell.stackWidth.constant = 60.0
                }
                
            }
            
            }
            
//            if self.personModelArray[indexPath.row].CanBeDeletedFalg == 1 && self.personModelArray[indexPath.row].SponserdByFlag != "CS"  {
//                cell.btnFirst.isHidden = false
//
//            }
//            else {
//                if self.personModelArray[indexPath.row].SponserdByFlag == "CS" {
//                cell.btnFirst.isHidden = false
//                }
//                else {
//                    if self.personModelArray[indexPath.row].CanBeDeletedFalg == 1 {
//                        cell.btnFirst.isHidden = false
//
//                    }
//                    else {
//                    cell.btnFirst.isHidden = true
//                    }
//                }
//            }
        }//else

        if self.personModelArray[indexPath.row].IsDisabled! {
                   cell.isUserInteractionEnabled = false
            cell.checkBoxImageView.setImage(UIImage(named: "hcOpted"), for: .normal)

            //checkbox
               }
               else {
            //            cell.checkBoxImageView.setImage(UIImage(named: "black checkbox"), for: .normal)

                   cell.isUserInteractionEnabled = true
               }

        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.deleteNowDidTapped(_:)), for: .touchUpInside)
        cell.btnDelete.isUserInteractionEnabled = true
        cell.btnFirst.isUserInteractionEnabled = true
        return cell
    }
    //MARK:- Delete Now
    @objc private func deleteNowDidTapped(_ sender : UIButton) {
        let obj = personModelArray[sender.tag]
        if obj.CanBeDeletedFalg == 1 {
            let personSr = obj.PersonSRNo?.description
            let index = IndexPath(row: sender.tag, section: 0)
            self.deleteFamilyMember(personSRNo: personSr!, indexPath: index)
        }
        else {
            
        }
    }
    
    @objc private func sccellTapped(_ sender: UITapGestureRecognizer) {
        let index = IndexPath(row: sender.view!.tag, section: 0)
        
        let obj = personModelArray[index.row]
       
       if obj.IsMobEmailConf != 1 {
        //Move to Mobile Number Verification..
        if self.dependantTappedDelegate != nil {
            self.dependantTappedDelegate?.scheduleNowTapped(packageSr: obj.PackageSrNo!, depdantSrNo: obj.PersonSRNo!, packageInfo: packageInfo, isMoveToHospital: false, personCheckupModel: obj)
        }
       }
       else {
        //Move To Hospitals
        if self.dependantTappedDelegate != nil {

           self.dependantTappedDelegate?.scheduleNowTapped(packageSr: obj.PackageSrNo!, depdantSrNo: obj.PersonSRNo!, packageInfo: packageInfo, isMoveToHospital: true, personCheckupModel: obj)
        }

       }


    }
    
    func mobileNumberVerified() {
           
       }
    
    @objc private func namecellTapped(_ sender: UITapGestureRecognizer) {
        let index = IndexPath(row: sender.view!.tag, section: 0)
               
              
        
        if self.personModelArray[index.row].isSelectedByUser == true {
            self.personModelArray[index.row].isSelectedByUser = false
            
            if self.dependantTappedDelegate != nil {
                let obj = self.personModelArray[index.row]
                self.dependantTappedDelegate?.dependantCellTapped(packageSr:obj.PackageSrNo!, depdantSrNo: obj.PersonSRNo!, isSelected: false)
            }
        }
        else {
            self.personModelArray[index.row].isSelectedByUser = true
            
            if self.dependantTappedDelegate != nil {
                let obj = self.personModelArray[index.row]
                self.dependantTappedDelegate?.dependantCellTapped(packageSr:obj.PackageSrNo!, depdantSrNo: obj.PersonSRNo!, isSelected: true)
            }
        }
        
        
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if self.personModelArray[indexPath.row].isSelectedByUser == true {
//            self.personModelArray[indexPath.row].isSelectedByUser = false
//
//            if self.dependantTappedDelegate != nil {
//                let obj = self.personModelArray[indexPath.row]
//                self.dependantTappedDelegate?.dependantCellTapped(packageSr:obj.PackageSrNo!, depdantSrNo: obj.PersonSRNo!, isSelected: false)
//            }
//        }
//        else {
//            self.personModelArray[indexPath.row].isSelectedByUser = true
//
//            if self.dependantTappedDelegate != nil {
//                let obj = self.personModelArray[indexPath.row]
//                self.dependantTappedDelegate?.dependantCellTapped(packageSr:obj.PackageSrNo!, depdantSrNo: obj.PersonSRNo!, isSelected: true)
//            }
//        }
//
//
//        self.tableView.reloadData()
        
    }
    
    //MARK:- Delete Family Member
    private func deleteFamilyMember(personSRNo:String,indexPath:IndexPath) {
        print("Insert EMP Info")
        
        let url = APIEngine.shared.deleteFamilyMemberURL(personSRNo:personSRNo)
        print(url)
        
        ServerRequestManager.serverInstance.deleteDataToServerWithoutLoader(url: url, onComplition: { (response, error) in
            
            if let status = response?["Status"].bool
            {
                if status == true {
                    self.personModelArray.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
                else {
                    //Failed to delete person info
                }
            }
        })
    }
}
