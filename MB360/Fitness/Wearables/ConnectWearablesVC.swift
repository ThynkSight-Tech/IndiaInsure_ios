//
//  ConnectWearablesVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 24/07/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit
import AktivoCoreSDK

protocol UpdatedConnectionProtocol {
    func connectionUpdated()
    func backTappedDelegate()

}

protocol DeviceConnectedProtocol {
    func deviceConnected()
}

class ConnectWearablesVC: UIViewController,DeviceConnectedProtocol {
  
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var fitnessDevices = [FitnessTracker]()
    var delegateObj : UpdatedConnectionProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.layer.cornerRadius = 12.0
        tableview.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
        tableview.layer.borderWidth = 0.5
        
        self.title = "Connected Apps"
        
        //tableview.reloadData()
        //self.tableViewHeight.constant = self.tableview.contentSize.height
        
        //hide back button
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [Color.redBottom.value,Color.redTop.value])

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDeviceList()

    }
    
    //Delegate Methods
    func deviceConnected() {
        print("connected...")
        if delegateObj != nil {
                   delegateObj?.connectionUpdated()
               }
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @objc func backTapped() {
        if delegateObj != nil {
            delegateObj?.backTappedDelegate()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    private func displayAlert(platform:FitnessTracker.Platform) {
        
        let msg = "Aktivo will be unable to fetch your activity data from your \(platform) app. Do you wish to disconnect your \(platform) app?"
        
        let alert = UIAlertController(title: "Warning", message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in

            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Disconnect", style: .destructive, handler: { action in
            
            self.disconnectDevice(platform:platform)
            
        }))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    
    
}

//MARK:- Get Devices
extension ConnectWearablesVC {
    private func getDeviceList() {
        self.showPleaseWait(msg: "")
        Aktivo.loadFitnessTrackers { (response, error) in
            print(response)
            self.fitnessDevices.removeAll()
            self.hidePleaseWait()
            if let devices = response {
                
                self.fitnessDevices = devices
                self.tableview.reloadData()
            }
            else if let error = error {
            // Handle error
                self.displayActivityAlert(title: "The connection to the server failed. Try again after some time")
            }
                
            else {
                print("Failed")
            }
            
        }
    }
    
    private func disconnectDevice(platform: FitnessTracker.Platform) {
        self.showPleaseWait(msg: "")
        Aktivo.disconnectFitnessPlatform(platform) { [weak self](success, error) in
            
            self?.hidePleaseWait()
            if success {
                // Fitbit disconnected successfully
                let str = String(format: "%@ disconnected successfully", platform.rawValue.capitalizingFirstLetter())
                self?.displayActivityAlert(title: str)
                self?.getDeviceList()
            } else if let error = error {
                // Handle error
                self?.displayActivityAlert(title: "The connection to the server failed. Try again after some time")
            }
            else {
                print("Failed")
            }
            
        }
    }
}


//MARK:- TableView Delegate
extension ConnectWearablesVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return fitnessDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WearableCell", for: indexPath) as! WearableCell
        
        if indexPath.section == 0
        {
            //User entered device name
            //cell.lblDeviceName.text = UIDevice.current.name
            //Model Name By Apple
            cell.lblDeviceName.text = UIDevice.modelName
            cell.platformCenterConstant.constant = -10
            cell.btnConnect.setTitle("Connected", for: .normal)
            cell.btnConnect.backgroundColor = UIColor.white
            cell.btnConnect.setTitleColor(#colorLiteral(red: 0.003921568627, green: 0.6784313725, blue: 0.3529411765, alpha: 1), for: .normal)
            
            cell.lblAppleHealth.isHidden = false

            if UIDevice.current.hasNotch {
                cell.imgDevice.image = UIImage(named:"iPhoneX")
            }
            else{
                cell.imgDevice.image = UIImage(named:"iPhone6")
            }
        }
            
        else {
            cell.platformCenterConstant.constant = 0

            cell.lblAppleHealth.isHidden = true
            cell.lblDeviceName.text = self.fitnessDevices[indexPath.row].platform.rawValue.capitalizingFirstLetter()
            if self.fitnessDevices[indexPath.row].connectionStatus == .connected {
            cell.btnConnect.setTitle("Disconnect", for: .normal)
            }
            else {
            cell.btnConnect.setTitle("Connect", for: .normal)

            }
            cell.btnConnect.tag = indexPath.row
            cell.btnConnect.addTarget(self, action: #selector(btnConnectTapped(_:)), for: .touchUpInside)

            switch fitnessDevices[indexPath.row].platform {
            case .Fitbit:
                cell.imgDevice.image = UIImage(named: "symbol_of_fitbit")
                
            case .Garmin:
                cell.imgDevice.image = UIImage(named: "GRMN_garmin")

            default:
                break
            }

        }
        
        return cell
    }
    
   @objc private func btnConnectTapped(_ sender : UIButton) {
    let index = sender.tag
    if fitnessDevices[index].connectionStatus == .connected {
        //Call Disconnect API
       // let vc1 = UIStoryboard.init(name: "Badge", bundle: nil).instantiateViewController(withIdentifier: "ConnectDeviceWebViewVC") as! ConnectDeviceWebViewVC
       // self.navigationController?.pushViewController(vc1, animated: true)
        //fitnessDevices[index].platform == .Fitbit ? (vc1.isFitbit = true) : (vc1.isFitbit = false)
        
        displayAlert(platform:fitnessDevices[index].platform)
        
        print("Disconnect")
    }
    else {
        //Call Connect API
        print("Connect")
        let vc1 = UIStoryboard.init(name: "Badge", bundle: nil).instantiateViewController(withIdentifier: "ConnectDeviceWebViewVC") as! ConnectDeviceWebViewVC
        fitnessDevices[index].platform == .Fitbit ? (vc1.isFitbit = true) : (vc1.isFitbit = false)
        vc1.isDeviceConnectedDelegate = self
        self.navigationController?.pushViewController(vc1, animated: true)

    }
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
        
    
    
}


class WearableCell: UITableViewCell {
    
   
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var imgDevice: UIImageView!
    @IBOutlet weak var btnConnect: UIButton!
    @IBOutlet weak var lblAppleHealth: UILabel!
    @IBOutlet weak var platformCenterConstant: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnConnect.layer.cornerRadius = 10.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
           
       }
}
