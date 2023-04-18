//
//  ViewCartModel.swift
//  MyBenefits
//
//  Created by SemanticMAC MINI on 19/10/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import Foundation

struct ViewCartMD_Model {
    var FamilySrNo : String?
    var PersonName : String?
    var TempOrderID : String?
    var PersonSrNO : String?
    var FlatHouse : String?
    var Area : String?
    var Landmark : String?
    var Pincode : String?
    var City : String?
    var State : String?
    var EmailId : String?
    var Mobile : String?
    var Remark : String?
    var CartId : String?
    var Images = [PrescriptionImages]()
    var statusIsPlaced : String?
    var AddCartOn : String?
}

struct PrescriptionImages {
    var imageUrl : String?
}
