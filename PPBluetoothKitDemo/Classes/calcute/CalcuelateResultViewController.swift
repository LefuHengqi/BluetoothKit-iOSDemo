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
        
        let inputModel = PPCalculateInputModel()
        inputModel.age = self.myUserModel.age
        inputModel.height = self.myUserModel.height
        inputModel.gender = PPDeviceGenderType.init(rawValue: UInt(self.myUserModel.sex)) ?? .female
        inputModel.isAthleteMode = self.myUserModel.isAthleteMode == 1 ?true:false
        inputModel.bodyAgeMethod = .default // Set Body Age Calculation Method​​
        
        let heartRate = self.myUserModel.heartRate
        
        
        
        var fatModel:PPBodyFatModel!
        
        if self.selectType == .calcuteType4DC{

            inputModel.secret = CommonTool.getSecret(calcuteType: PPDeviceCalcuteType.direct)
            inputModel.deviceCalcuteType = PPDeviceCalcuteType.direct
            inputModel.weight = CGFloat(self.myUserModel.weight)
            inputModel.impedance = self.myUserModel.impedance
            inputModel.deviceMac = "c1:c1:c1:c1"
            inputModel.heartRate = heartRate
            
            
        }else if self.selectType == .calcuteType8AC{
            
            let deviceCalcuteType8 = self.deviceCalcuteType ?? .alternate8
            
            inputModel.secret = CommonTool.getSecret(calcuteType: deviceCalcuteType8)
            inputModel.deviceCalcuteType = deviceCalcuteType8
            inputModel.weight = CGFloat(self.myUserModel.weight)
            inputModel.z20KhzLeftArmEnCode = self.myUserModel.z20KhzLeftArmEnCode
            inputModel.z20KhzRightArmEnCode = self.myUserModel.z20KhzRightArmEnCode
            inputModel.z20KhzLeftLegEnCode = self.myUserModel.z20KhzLeftLegEnCode
            inputModel.z20KhzRightLegEnCode = self.myUserModel.z20KhzRightLegEnCode
            inputModel.z20KhzTrunkEnCode = self.myUserModel.z20KhzTrunkEnCode
            inputModel.z100KhzLeftArmEnCode = self.myUserModel.z100KhzLeftArmEnCode
            inputModel.z100KhzRightArmEnCode = self.myUserModel.z100KhzRightArmEnCode
            inputModel.z100KhzLeftLegEnCode = self.myUserModel.z100KhzLeftLegEnCode
            inputModel.z100KhzRightLegEnCode = self.myUserModel.z100KhzRightLegEnCode
            inputModel.z100KhzTrunkEnCode = self.myUserModel.z100KhzTrunkEnCode
            inputModel.deviceMac = ""
            inputModel.heartRate = heartRate

            
        }else{
            
            let deviceCalcuteType4 = self.deviceCalcuteType ?? .alternate
            
            // Only dual-frequency algorithm (PPDeviceCalcuteType.alternate4_1) needs to pass "impedance100EnCode"
            inputModel.secret = CommonTool.getSecret(calcuteType: deviceCalcuteType4)
            inputModel.deviceCalcuteType = deviceCalcuteType4
            inputModel.weight = CGFloat(self.myUserModel.weight)
            inputModel.impedance = self.myUserModel.impedance
            inputModel.impedance100EnCode = self.myUserModel.impedance100
            inputModel.deviceMac = "c1:c1:c1:c1"
            inputModel.heartRate = heartRate

            
            
            
        }
        
        fatModel = PPBodyFatModel(inputModel: inputModel)
        
//        let bodyDataJson = CommonTool.loadJSONFromFile(filename: "body_lang_zh.json")
        let bodyDataJson = CommonTool.loadJSONFromFile(filename: "body_lang_en.json")
        
        //Get the range of each body indicator
        let detailModel = PPBodyDetailModel(bodyFatModel: fatModel)
        let weightParam = detailModel.ppBodyParam_Weight
        print("weight-currentValue:\(weightParam.currentValue) range:\(weightParam.standardArray)  standardTitle:\(bodyDataJson[weightParam.standardTitle] ?? "") standSuggestion:\(bodyDataJson[weightParam.standSuggestion] ?? "") standeValuation:\(bodyDataJson[weightParam.standeValuation] ?? "")")
//        print("data:\(detailModel.data)")
        
        let ss = CommonTool.getDesp(fatModel: fatModel, inputModel: inputModel)

        
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

