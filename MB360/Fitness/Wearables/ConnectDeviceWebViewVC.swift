//
//  ConnectDeviceWebViewVC.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 24/07/20.
//  Copyright © 2020 Semantic. All rights reserved.
//

import UIKit
import AktivoCoreSDK
import WebKit

class ConnectDeviceWebViewVC: UIViewController, WKUIDelegate, WKNavigationDelegate {
 

    var isFitbit = false
    var deviceToConnect = FitnessTracker.Platform?.self
    
    var m_webView: WKWebView!

    var fitnessSuccess = ""
    var fitnessFailure = ""
        
    var isDeviceConnectedDelegate : DeviceConnectedProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFitbit {
            self.title = "Enter your Fitbit account details"
            getWebViewURL(device: .Fitbit)
            
        }
        else {
            self.title = "Enter your Garmin account details"
            getWebViewURL(device: .Garmin)
        }
        
        //hide back button
        let btn =  UIBarButtonItem(image:UIImage(named: "back button") , style: .plain, target: self, action: #selector(backTapped))
        navigationItem.leftBarButtonItem = btn
        
        
    }
    
    
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func openWebView(authUrl:URL) {
        //FOR WKWEBVIEW
             let webconfig = WKWebViewConfiguration()
             // m_webView = WKWebView(frame: CGRect(x: 4, y: 4, width: self.viewForWebView.bounds.width - 4, height: self.viewForWebView.bounds.height - 20), configuration: webconfig)
              m_webView = WKWebView()
              m_webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

             m_webView.frame = CGRect(origin: CGPoint.zero, size: self.view.frame.size)

              m_webView.uiDelegate = self as WKUIDelegate
              m_webView.navigationDelegate = self as WKNavigationDelegate

             self.view.addSubview(m_webView)
              m_webView.translatesAutoresizingMaskIntoConstraints = false
              m_webView.clipsToBounds = false
             
             //let myURL = URL(string: "http://www.apple.com")
             let myRequest = URLRequest(url: authUrl)
             m_webView.load(myRequest)
    }
    
    
    //MARK:- API Call
    private func getWebViewURL(device:FitnessTracker.Platform)
    {
        self.showPleaseWait(msg: "")
        Aktivo.getFitnessPlatformAuthWebURLInfo(platform: device) { (result, error) in
            
            self.hidePleaseWait()
            if let response = result {
                print(response)
                let webUrl = response.authWebURL
                self.fitnessSuccess = response.redirectURLSuccess.absoluteString
                self.fitnessFailure = response.redirectURLError.absoluteString
                self.openWebView(authUrl: webUrl)
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
    

}


extension ConnectDeviceWebViewVC {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    //func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
          //print(navigationAction)
       // print(WKNavigationActionPolicy())
      //}
    
    func webView(_ webView: WKWebView,decidePolicyFor navigationAction: WKNavigationAction,decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        print("Found.....")
          guard let url = navigationAction.request.url else {
              decisionHandler(.allow)
            print("SS__FF...")

              return
          }

          if url.absoluteString.contains(fitnessSuccess) {
              // this means login successful
            print("SUCCESS")
            decisionHandler(.cancel)
            
            if isFitbit {
                let str = String(format: "Fitbit app connected")
                self.displayActivityAlert(title: str)
            }
            else {
                let str = String(format: "Garmin app connected")
                self.displayActivityAlert(title: str)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.isDeviceConnectedDelegate != nil {
                self.isDeviceConnectedDelegate?.deviceConnected()
            self.dismiss(animated: true, completion: nil)
                }
            }
          }
          else if url.absoluteString.contains(fitnessFailure) {
            // this means login successful
            print("ERROR")
            decisionHandler(.cancel)
            self.displayActivityAlert(title: "Failed to connect")
            
            self.navigationController?.popViewController(animated: false)
          }
          else {
            print("FAILED...")
            decisionHandler(.allow)
            //self.navigationController?.popViewController(animated: false)
            
        }
        
        
      }
    

    
}
