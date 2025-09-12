//
//  CommonTool.swift
//  PPBluetoothKitDemo
//
//  Created by lefu on 2024/8/15
//  


import Foundation
import PPBluetoothKit
import PPCalculateKit

class CommonTool {
    class func getDesp(fatModel:PPBodyFatModel, inputModel:PPCalculateInputModel)->String {
        
        let arr = [ "PP_ERROR_TYPE_NONE",
                    "PP_ERROR_TYPE_AGE" ,
                    "PP_ERROR_TYPE_HEIGHT",
                    "PP_ERROR_TYPE_WEIGHT",
                    "PP_ERROR_TYPE_SEX",
                    "PP_ERROR_TYPE_PEOPLE_TYPE",
                    "PP_ERROR_TYPE_IMPEDANCE_TWO_LEGS",
                    "PP_ERROR_TYPE_IMPEDANCE_TWO_ARMS",
                    "PP_ERROR_TYPE_IMPEDANCE_LEFT_BODY",
                    "PP_ERROR_TYPE_IMPEDANCE_LEFT_ARM",
                    "PP_ERROR_TYPE_IMPEDANCE_RIGHT_ARM",
                    "PP_ERROR_TYPE_IMPEDANCE_LEFT_LEG",
                    "PP_ERROR_TYPE_IMPEDANCE_RIGHT_LEG",
                    "PP_ERROR_TYPE_IMPEDANCE_TRUNK",
                    "PP_ERROR_TYPE_HOME",
                    "PP_ERROR_TYPE_PRODUCT",
                    "PP_ERROR_TYPE_Ohter"
        ]
        
        var index = fatModel.errorType.rawValue
        if index > arr.count {
            index = arr.count - 1
        }
        
        let ss = """
        
        errorType = "\(arr[index])"
        isAthleteMode = "\(inputModel.isAthleteMode)"
        ppSDKVersion = \(fatModel.ppSDKVersion)
        ppWeightKgList = \(fatModel.ppWeightKgList)
        ppBMI = \(fatModel.ppBMI)
        ppBMIList = \(fatModel.ppBMIList)
        ppFat = \(fatModel.ppFat)
        ppFatList = \(fatModel.ppFatList)
        ppBodyfatKg = \(fatModel.ppBodyfatKg)
        ppBodyfatKgList = \(fatModel.ppBodyfatKgList)
        ppMusclePercentage = \(fatModel.ppMusclePercentage)
        ppMusclePercentageList = \(fatModel.ppMusclePercentageList)
        ppMuscleKg = \(fatModel.ppMuscleKg)
        ppMuscleKgList = \(fatModel.ppMuscleKgList)
        ppBodySkeletal = \(fatModel.ppBodySkeletal)
        ppBodySkeletalList = \(fatModel.ppBodySkeletalList)
        ppBodySkeletalKg = \(fatModel.ppBodySkeletalKg)
        ppBodySkeletalKgList = \(fatModel.ppBodySkeletalKgList)
        ppWaterPercentage = \(fatModel.ppWaterPercentage)
        ppWaterPercentageList = \(fatModel.ppWaterPercentageList)
        ppWaterKg = \(fatModel.ppWaterKg)
        ppWaterKgList = \(fatModel.ppWaterKgList)
        ppProteinPercentage = \(fatModel.ppProteinPercentage)
        ppProteinPercentageList = \(fatModel.ppProteinPercentageList)
        ppProteinKg = \(fatModel.ppProteinKg)
        ppProteinKgList = \(fatModel.ppProteinKgList)
        ppLoseFatWeightKg = \(fatModel.ppLoseFatWeightKg)
        ppLoseFatWeightKgList = \(fatModel.ppLoseFatWeightKgList)
        ppBodyFatSubCutPercentage = \(fatModel.ppBodyFatSubCutPercentage)
        ppBodyFatSubCutPercentageList = \(fatModel.ppBodyFatSubCutPercentageList)
        ppBodyFatSubCutKg = \(fatModel.ppBodyFatSubCutKg)
        ppBodyFatSubCutKgList = \(fatModel.ppBodyFatSubCutKgList)
        ppHeartRate = \(fatModel.ppHeartRate)
        ppHeartRateList = \(fatModel.ppHeartRateList)
        ppBMR = \(fatModel.ppBMR)
        ppBMRList = \(fatModel.ppBMRList)
        ppVisceralFat = \(fatModel.ppVisceralFat)
        ppVisceralFatList = \(fatModel.ppVisceralFatList)
        ppBoneKg = \(fatModel.ppBoneKg)
        ppBoneKgList = \(fatModel.ppBoneKgList)
        ppBodyMuscleControl = \(fatModel.ppBodyMuscleControl)
        ppFatControlKg = \(fatModel.ppFatControlKg)
        ppBodyStandardWeightKg = \(fatModel.ppBodyStandardWeightKg)
        ppControlWeightKg = \(fatModel.ppControlWeightKg)
        ppBodyType = \(fatModel.ppBodyType.rawValue)
        ppFatGrade = \(fatModel.ppFatGrade.rawValue)
        ppBodyHealth = \(fatModel.ppBodyHealth.rawValue)
        ppBodyAge = \(fatModel.ppBodyAge)
        ppBodyAgeList = \(fatModel.ppBodyAgeList)
        ppBodyScore = \(fatModel.ppBodyScore)
        ppBodyScoreList = \(fatModel.ppBodyScoreList)
        
        ========calcuteType8AC=========
        
        ppCellMassKg = \(fatModel.ppCellMassKg)
        ppCellMassKgList = \(fatModel.ppCellMassKgList)
        ppDCI = \(fatModel.ppDCI)
        ppMineralKg = \(fatModel.ppMineralKg)
        ppMineralKgList = \(fatModel.ppMineralKgList)
        ppObesity = \(fatModel.ppObesity)
        ppObesityList = \(fatModel.ppObesityList)
        ppWaterECWKg = \(fatModel.ppWaterECWKg)
        ppWaterECWKgList = \(fatModel.ppWaterECWKgList)
        ppWaterICWKg = \(fatModel.ppWaterICWKg)
        ppWaterICWKgList = \(fatModel.ppWaterICWKgList)
        ppBodyFatKgLeftArm = \(fatModel.ppBodyFatKgLeftArm)
        ppBodyFatKgLeftLeg = \(fatModel.ppBodyFatKgLeftLeg)
        ppBodyFatKgRightArm = \(fatModel.ppBodyFatKgRightArm)
        ppBodyFatKgRightLeg = \(fatModel.ppBodyFatKgRightLeg)
        ppBodyFatKgTrunk = \(fatModel.ppBodyFatKgTrunk)
        ppBodyFatRateLeftArm = \(fatModel.ppBodyFatRateLeftArm)
        ppBodyFatRateLeftLeg = \(fatModel.ppBodyFatRateLeftLeg)
        ppBodyFatRateRightArm = \(fatModel.ppBodyFatRateRightArm)
        ppBodyFatRateRightLeg = \(fatModel.ppBodyFatRateRightLeg)
        ppBodyFatRateTrunk = \(fatModel.ppBodyFatRateTrunk)
        ppMuscleKgLeftArm = \(fatModel.ppMuscleKgLeftArm)
        ppMuscleKgLeftLeg = \(fatModel.ppMuscleKgLeftLeg)
        ppMuscleKgRightArm = \(fatModel.ppMuscleKgRightArm)
        ppMuscleKgRightLeg = \(fatModel.ppMuscleKgRightLeg)
        ppMuscleKgTrunk = \(fatModel.ppMuscleKgTrunk)
        
        """
        
        return ss
    }
    
    
    class func loadJSONFromFile(filename: String) -> [String: Any] {
        
        if let url = Bundle.main.url(forResource: filename, withExtension: "") {
            do {
                
                let data = try Data(contentsOf: url)
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    return json
                }
            } catch {
                
                print("Error reading JSON: \(error)")
            }
        }
        
        return [:]
    }
    
    class func getSecret(calcuteType:PPDeviceCalcuteType)->String {
        
        if PPCalculateTools.is8Electrodes(with: calcuteType) {
            if calcuteType == .alternate8 {
                return DemoSecretAlternate8
            } else {
                return DemoSecretAlternate8Common
            }
        } else if calcuteType == .alternate4_1 {
            
            return DemoSecretAlternate4_1
        } else if calcuteType == .alternate4_0 {
            
            return DemoSecretAlternate4_0
        } else {
            
            return DemoSecretAlternate4Common
        }
        
        
    }
    
}
