//
//  webServices.swift
//  MyBenefits360
//
//  Created by home on 05/12/22.
//  Copyright © 2022 Semantic. All rights reserved.
//

import Foundation

class webServices : NSObject{
    
    func getDataForEnrollment(_ Appendurl : String,completion: @escaping (_ data: Data, _ error: String)->()){
        //let url = "https://portal.mybenefits360.com/mb360apiV1/api/EnrollmentDetails/\(Appendurl)"
        let url = Appendurl
        print(url)
        var urlRequest = URLRequest(url: URL(string: url)!)
        
        let datatask = URLSession.shared.dataTask(with: urlRequest, completionHandler: {
            (data, httpUrlResponse, error ) in
//            guard let dataResponse = data,
//                  error == nil else {
//                print(error?.localizedDescription ?? "Response Error")
//                return }
            if error == nil{
                print(String(data: data!, encoding: .utf8)!)
                let resp = httpUrlResponse as! HTTPURLResponse
                let status = resp.statusCode
                
                switch status{
                case 200:
                    completion(data!,"")
                    break
                default:
                    completion(data!,"error")
                    break
                }
            }else{
                completion(Data(),error!.localizedDescription)
            }
        })
        datatask.resume()
        
    }
    



    func postDataForEnrollment(_ url : String,_ dict : [String:Any],completion: @escaping (_ data: Data, _ error: String)->()){
        let UrlStr = "https://portal.mybenefits360.com/mb360apiV2/api/EnrollmentDetails/\(url)"
        print("UrlStr: ",UrlStr)
        var str = UrlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print("str: ",str)
        let serviceUrl = NSURL(string:str as String)//URL(string: UrlStr)!
        print("serviceUrl: ",serviceUrl)
        let parameters: [String: Any] = dict
        var request = URLRequest(url: serviceUrl! as URL)//URLRequest(url: URL(string: url)!)//URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        let authString = String(format: "%@:%@", m_authUserName_Portal, m_authPassword_Portal)
        let authData = authString.data(using: String.Encoding.utf8)!
        let base64AuthString = authData.base64EncodedString()
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
       
        request.setValue("Basic \(base64AuthString)", forHTTPHeaderField: "Authorization")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        request.timeoutInterval = 20
        let session = URLSession.shared
        let datatask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, httpUrlResponse, error ) in
            //            guard let dataResponse = data,
            //                  error == nil else {
            //                print(error?.localizedDescription ?? "Response Error")
            //                return }
            if error == nil{
                print("postDataForEnrollment :",String(data: data!, encoding: .utf8)!)
                let resp = httpUrlResponse as! HTTPURLResponse
                let status = resp.statusCode
                print("status: ",status)
                switch status{
                case 200:
                    completion(data!,"")
                    break
                default:
                    completion(data!,"error")
                    break
                }
            }else{
                completion(Data(),error!.localizedDescription)
            }
        })
        datatask.resume()
    }
}
