//
//  OngoingMedicine.swift
//  MyBenefits360
//
//  Created by SemanticMAC MINI on 23/10/19.
//  Copyright © 2019 Semantic. All rights reserved.
//

import Foundation

struct OngoingMedicineModel {
    var Name : String?
    var EstimatedDate : String?
    var PlacedOrderDate : String?
    var CustomerId : String?
    var PeOrderId : String?
    var Address : String?
    var OrderInfoSrNo : String?
    var Images = [PrescriptionImages]()
    var Status = [StatusModel]()
    var isExpand = false
    var orderInfoModel : OrderInfoModel?
    var RXId : String?
}

struct StatusModel {
    var Date : String?
    var Status : String?
}

//Added on 8th Dec - Charudatta API update
struct OrderInfoModel {
    var OrderInfoSrNo : String? //Int
    var EstimatedDate : String?
    var DiscountAmount : String?
    var TotalAmount : String?
    var MovementDoneOn : String?
    var PayableAmount : String?
    var OrderStatus : String?
    var DeliveryCharge : String?
}

/*
 {
   "OrderNo" : "MBMD00001068",
   "Images" : [
     "D:\/web\/mybenefits360wellness\/wellness\/Document\/MedicineDelivery\/PlacedOrder1068_1.png"
   ],
   "Name" : "Pranit Hirve",
   "Address" : "104, 9th Floor, Galaxy Apt., Ganesh Temple, PUNE-411061",
   "OrderInfoSrNo" : "1068",
   "Orderinfo" : {
     "OrderInfoSrNo" : 1068,
     "EstimatedDate" : "",
     "DiscountAmount" : "",
     "TotalAmount" : "",
     "MovementDoneOn" : "23\/11\/2020",
     "PayableAmount" : "",
     "OrderStatus" : "CANCELLED-U",
     "DeliveryCharge" : ""
   },
   "PlacedOrderDate" : "28\/10\/2020",
   "RXId" : "DRAFT4115SA",
   "CustomerId" : "34080",
   "PeOrderId" : "866"
 }
 */
