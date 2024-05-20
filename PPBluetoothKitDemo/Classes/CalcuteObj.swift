//
//  CalcuteObj.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/7/4.
//

import UIKit
import PPBluetoothKit


class CalcuteObj: NSObject {

    
    class func XM_SaveScaleMeasurementData(model: PPBluetoothScaleBaseModel)->PPBodyFatModel{
        
        let isAthleteMode = userModel.shared.isAthleteMode
        
        let isPregnantMode = userModel.shared.isPregnantMode
        
        let height = userModel.shared.height
        
        let age = userModel.shared.age
        
        let gender = userModel.shared.age
        
        let unit:PPDeviceUnit = .unitKG
        
        
        let settingModel = PPBluetoothDeviceSettingModel()
        settingModel.isAthleteMode = isAthleteMode
        settingModel.isPregnantMode = false
        settingModel.height = height
        settingModel.age = age
        settingModel.gender = PPDeviceGenderType(rawValue: UInt(gender)) ?? .female
        settingModel.unit = unit
        
        

        let fatModel = PPBodyFatModel(userModel: settingModel,
                                      deviceCalcuteType: selectDevice!.0.deviceCalcuteType,
                                      deviceMac: selectDevice!.0.deviceMac,
                                      weight: CGFloat(model.weight) / 100.0,
                                      heartRate: model.heartRate,
                                      andImpedance: model.impedance)
        
        
        return fatModel
    }
}
