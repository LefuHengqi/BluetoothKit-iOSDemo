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
            
            // Only dual-frequency algorithm (PPDeviceCalcuteType.alternate4_1) needs to pass "impedance100EnCode"
            
            fatModel =  PPBodyFatModel(userModel: userModel,
                                       deviceCalcuteType: deviceCalcuteType4,
                                       deviceMac: "c1:c1:c1:c1",
                                       weight: CGFloat(self.myUserModel.weight),
                                       heartRate: heartRate,
                                       andImpedance: self.myUserModel.impedance,
                                       impedance100EnCode: self.myUserModel.impedance100)
            
        }
        
        //Get the range of each body indicator
        let detailModel = PPBodyDetailModel(bodyFatModel: fatModel)
        let weightParam = detailModel.ppBodyParam_Weight
        print("weight-currentValue:\(weightParam.currentValue) weight-range:\(weightParam.standardArray)")
//        print("data:\(detailModel.data)")
        
        let ss = CommonTool.getDesp(fatModel: fatModel, userModel: userModel)

        
        self.textView.text = ss
     
//        print("\(ss)")
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

