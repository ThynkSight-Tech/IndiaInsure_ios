//
//  ExploreModel.swift
//  MyBenefits360
//
//  Created by Shubham Tambade on 09/01/23.
//  Copyright © 2023 Semantic. All rights reserved.
//

import Foundation

// MARK: - GetEmployeeDCPackagesStruct
struct ExplorePackagesStruct{
    var status: Bool
    var message: String
    var data: [DatumModel]

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case data = "Data"
    }
}

// MARK: - Datum
struct DatumModel{
    var packagePlanSrNo, pkgName, dcPkgPrice, includeGst: String?
    var pkgEmpMappSrNo, pkgPlanSrNo, extEmployeeSrNo, uniqueid: String?
    var extPerSrNo, personName, relationid, cellphoneNumber: String?
    var movementDoneOn, status: String?
    var details = [DetailModel]()

}

// MARK: - Detail
struct DetailModel{
    var packagePlanSrNo: Int?
    var pkgName, experiance, catogary, dcPkgPrice: String?
    var includeGst, calls, validityMonth, dependent: String?
}
