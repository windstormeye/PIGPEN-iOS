//
//  PIGPetAroundService.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/13.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import Foundation

extension PJPet {
    struct Around: Codable {
        var pet: PJPet.Pet
        var distance: Float
        
        init() {
            pet = PJPet.Pet()
            distance = 0
        }
    }
}


private extension String {
    static let around = "pet/around"
}

extension PJPet {
    class func around(uid: String,
                      latitude: String,
                      longitude: String,
                      page: Int,
                      complationHandler: @escaping ([Around]) -> Void,
                      failedHandler: @escaping (PJNetwork.Error) -> Void) {
        let parameters = [
            "uid": uid,
            "page": String(page),
            "latitude": latitude,
            "longitude": longitude
        ]
        PJNetwork.shared.requstWithGet(path: .around,
                                       parameters: parameters,
                                       complement: { (dataDic) in
                                        if dataDic["msgCode"]?.intValue == 0 {
                                            var models = [Around]()
                                            let dicts = dataDic["msg"]!.arrayValue
                                            for dict in dicts {
                                                let model = dataConvertToModel(Around(),
                                                                               from: try! dict.rawData())
                                                if model != nil {
                                                    models.append(model!)
                                                }
                                            }
                                            complationHandler(models)
                                        } else {
                                            let error = PJNetwork.Error(errorCode: dataDic["msgCode"]?.intValue ?? 0, errorMsg: dataDic["msg"]?.string ?? "未知错误")
                                            failedHandler(error)
                                        }
        }) { (errorString) in
            failedHandler(PJNetwork.Error(errorCode: 0, errorMsg: "未知错误"))
        }
    }
}
