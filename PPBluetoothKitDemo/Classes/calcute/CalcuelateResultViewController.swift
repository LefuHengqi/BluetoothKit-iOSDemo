//
//  CalcuelateResultViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/7/28.
//

import UIKit
import PPBluetoothKit
import PPCalculateKit

class CalcuelateResultViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    var selectType = calcuteType.calcuteType8AC
    
    var myUserModel : UserModel!
    
    var deviceCalcuteType:PPDeviceCalcuteType?

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        self.showReslut()
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
      

        // Do any additional setup after loading the view.
    }
    
    
    func showReslut(){
        let userModel =  PPBluetoothDeviceSettingModel()
        
        userModel.age = self.myUserModel.age
        userModel.height = self.myUserModel.height
        userModel.gender = PPDeviceGenderType.init(rawValue: UInt(self.myUserModel.sex))!
        userModel.isAthleteMode = self.myUserModel.isAthleteMode == 1 ?true:false
        
        let heartRate = self.myUserModel.heartRate
        
        var fatModel:PPBodyFatModel!
        
        if self.selectType == .calcuteType4DC{
            
            fatModel = PPBodyFatModel(userModel: userModel,
                                      deviceCalcuteType: PPDeviceCalcuteType.direct,
                                      deviceMac: "c1:c1:c1:c1",
                                      weight: CGFloat(self.myUserModel.weight),
                                      heartRate: heartRate,
                                      andImpedance: self.myUserModel.impedance)
            
            
            
            
            
        }else if self.selectType == .calcuteType8AC{
            
            let deviceCalcuteType8 = self.deviceCalcuteType ?? .alternate8
            
            fatModel  = PPBodyFatModel(userModel: userModel,
                                       deviceMac: "",
                                       weight: CGFloat(self.myUserModel.weight),
                                       heartRate: heartRate, 
                                       deviceCalcuteType: deviceCalcuteType8,
                                       z20KhzLeftArmEnCode: self.myUserModel.z20KhzLeftArmEnCode,
                                       z20KhzRightArmEnCode: self.myUserModel.z20KhzRightArmEnCode,
                                       z20KhzLeftLegEnCode: self.myUserModel.z20KhzLeftLegEnCode,
                                       z20KhzRightLegEnCode: self.myUserModel.z20KhzRightLegEnCode,
                                       z20KhzTrunkEnCode: self.myUserModel.z20KhzTrunkEnCode,
                                       z100KhzLeftArmEnCode: self.myUserModel.z100KhzLeftArmEnCode,
                                       z100KhzRightArmEnCode: self.myUserModel.z100KhzRightArmEnCode,
                                       z100KhzLeftLegEnCode: self.myUserModel.z100KhzLeftLegEnCode,
                                       z100KhzRightLegEnCode: self.myUserModel.z100KhzRightLegEnCode,
                                       z100KhzTrunkEnCode: self.myUserModel.z100KhzTrunkEnCode)
        }else{
            let deviceCalcuteType4 = self.deviceCalcuteType ?? .alternate
            
            fatModel =  PPBodyFatModel(userModel: userModel,
                                       deviceCalcuteType: deviceCalcuteType4,
                                       deviceMac: "c1:c1:c1:c1",
                                       weight: CGFloat(self.myUserModel.weight),
                                       heartRate: heartRate,
                                       andImpedance: self.myUserModel.impedance)
            
        }
        
        //Get the range of each body indicator
        let detailModel = PPBodyDetailModel(bodyFatModel: fatModel)
        let weightParam = detailModel.ppBodyParam_Weight
        print("weight-currentValue:\(weightParam.currentValue) weight-range:\(weightParam.standardArray)")
//        print("data:\(detailModel.data)")
        
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
                    "PP_ERROR_TYPE_IMPEDANCE_TRUNK",]
        
        let ss = """
        
        errorType = "\(arr[fatModel.errorType.rawValue])"
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
        
        
        
        self.textView.text = ss
     
    }


}

extension CalcuelateResultViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }
    
    static var storyboardIdentifier: String {
        return "CalcuelateResultViewController"
    }
    
    
    
}

