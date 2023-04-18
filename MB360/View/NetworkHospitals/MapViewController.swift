//
//  MapViewController.swift
//  MyBenefits
//
//  Created by Semantic on 07/06/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var mapNotFoundImageView: UIImageView!
    @IBOutlet weak var m_addressLbl: UILabel!
    var m_resultDict = NSDictionary()
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title="link5Name".localized()
        navigationItem.leftBarButtonItem = getBackButton()
       
        self.tabBarController?.tabBar.isHidden=true
        menuButton.isHidden=true
    }
    func getLeftBarButton()->UIBarButtonItem
    {
        let button1 = UIBarButtonItem(image:UIImage(named: "menu"), style: .plain, target: self, action: #selector(leftButtonClicked)) // action:#selector(Class.MethodName) for swift 3
        
        
        return button1
    }
    @objc func leftButtonClicked()
    {
       
        
    }
    @objc private func homeButtonClicked(sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
        tabBarController!.selectedIndex = 2
    }
    
    @objc override func backButtonClicked()
    {
        
        self.tabBarController?.tabBar.isHidden=false
        menuButton.isHidden=false
        _ = navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool)
    {
        showPleaseWait(msg: "Please wait...")
       print(m_resultDict)
        let address = m_resultDict["HospitalAddress"]
        
        m_addressLbl.text=address as? String
        
//        print(address,m_resultDict)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address as! String)
            {
                
            placemarks, error in
                
                
            let placemark = placemarks?.first
               
//            let lat = placemark?.location?.coordinate.latitude
//            let lon = placemark?.location?.coordinate.longitude
                
                let lat = self.m_resultDict["Latitude"]
                let lon = self.m_resultDict["Longitude"]
                let lat1 :NSString = lat as! NSString
                let lon1 :NSString = lon as! NSString
            print("Lat: \(lat), Lon: \(lon)")
            
            if(lat != nil && lon != nil)
            {
                let camera = GMSCameraPosition.camera(withLatitude: lat1.doubleValue , longitude: lon1.doubleValue, zoom: 15.0)
            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            self.view = mapView
            
            // Creates a marker in the center of the map.
                
            let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: lat1.doubleValue, longitude: lon1.doubleValue)
            marker.title = self.m_resultDict["HospitalName"] as? String
                // placemark?.subAdministrativeArea
            marker.snippet = address as? String
            marker.map = mapView
          
                self.mapNotFoundImageView.isHidden=true
            
            
            }
            else
            {
                self.mapNotFoundImageView.isHidden=false
               

            
            }
            self.hidePleaseWait()
        }
    }
    
    func viewWillAppear(animated: Bool)
    {
        mapView.addObserver(self, forKeyPath: "myLocation", options:NSKeyValueObservingOptions(rawValue: 0), context:nil)
        navigationItem.rightBarButtonItem=getRightBarButton()
    }
    
   

}
