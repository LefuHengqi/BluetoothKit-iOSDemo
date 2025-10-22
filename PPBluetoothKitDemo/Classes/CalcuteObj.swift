//
//  CalcuteObj.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/7/4.
//

import UIKit
import PPBluetoothKit
import PPCalculateKit

class CalcuteObj: NSObject {

    
    class func XM_SaveScaleMeasurementData(model: PPBluetoothScaleBaseModel)->PPBodyFatModel{
        
        let isAthleteMode = userModel.shared.isAthleteMode
        
        let isPregnantMode = userModel.shared.isPregnantMode
        
        let height = userModel.shared.height
        
        let age = userModel.shared.age
        
        let gender = userModel.shared.age
        
        let unit:PPDeviceUnit = .unitKG
        
        
        let inputModel = PPCalculateInputModel()
        inputModel.secret = CommonTool.getSecret(calcuteType: selectDevice?.0.deviceCalcuteType ?? .alternate)
        inputModel.isAthleteMode = isAthleteMode
        inputModel.isPregnantMode = isPregnantMode
        inputModel.height = height
        inputModel.age = age
        inputModel.gender = PPDeviceGenderType(rawValue: UInt(gender)) ?? .female
        inputModel.unit = unit
        inputModel.deviceCalcuteType = selectDevice?.0.deviceCalcuteType ?? .alternate
        inputModel.deviceMac = selectDevice!.0.deviceMac
        inputModel.heartRate = model.heartRate
        inputModel.weight = CGFloat(model.weight) / 100.0
        inputModel.impedance = model.impedance
        inputModel.impedance100EnCode = model.impedance100EnCode
        inputModel.footLen = model.footLen
        inputModel.bodyAgeMethod = .default

        
        let fatModel = PPBodyFatModel(inputModel: inputModel)
        
        
        return fatModel
    }
}
