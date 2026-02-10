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
    
    func getLastCalculateInputModel()->PPCalculateInputModel {

        let heartRate = 76
        let lastTime = Date().timeIntervalSince1970 - 2100 // Time of the previous set of measurement data (unit: seconds). 上一组测量数据的时间(单位:秒)
        let deviceCalcuteType8 = self.deviceCalcuteType ?? .alternate8
        
        // This requires using the previously saved measurement data.Otherwise, the smooth impedance algorithm will not be used.
        // 此处需要使用已保存的上一次测量数据，否则不会走平滑阻抗算法
        let last = PPCalculateInputModel()
        last.secret = CommonTool.getSecret(calcuteType: deviceCalcuteType8)
        last.timeInterval = lastTime
        last.age = self.myUserModel.age
        last.height = self.myUserModel.height
        last.gender = PPDeviceGenderType.init(rawValue: UInt(self.myUserModel.sex)) ?? .female
        last.isAthleteMode = self.myUserModel.isAthleteMode == 1 ?true:false
        last.bodyAgeMethod = .default // Set Body Age Calculation Method
        last.deviceCalcuteType = deviceCalcuteType8
        last.weight = CGFloat(65)
        last.z20KhzLeftArmEnCode = 544018656 // Impedance from the last measured data. Set to 0 if no data was available from the last measurement.
        last.z20KhzRightArmEnCode = 1078788052 // Impedance from the last measured data. Set to 0 if no data was available from the last measurement.
        last.z20KhzLeftLegEnCode = 1637003200 // Impedance from the last measured data. Set to 0 if no data was available from the last measurement.
        last.z20KhzRightLegEnCode = 1617721244 // Impedance from the last measured data. Set to 0 if no data was available from the last measurement.
        last.z20KhzTrunkEnCode = 1615863103 // Impedance from the last measured data. Set to 0 if no data was available from the last measurement.
        last.z100KhzLeftArmEnCode = 275714227 // Impedance from the last measured data. Set to 0 if no data was available from the last measurement.
        last.z100KhzRightArmEnCode = 817852360 // Impedance from the last measured data. Set to 0 if no data was available from the last measurement.
        last.z100KhzLeftLegEnCode = 570158928 // Impedance from the last measured data. Set to 0 if no data was available from the last measurement.
        last.z100KhzRightLegEnCode = 1910601986 // Impedance from the last measured data. Set to 0 if no data was available from the last measurement.
        last.z100KhzTrunkEnCode = 1344363263 // Impedance from the last measured data. Set to 0 if no data was available from the last measurement.
        last.deviceMac = ""
        last.heartRate = heartRate
        
        return last
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
            // 4-electrode DC algorithm. 4电极直流算法
            
            inputModel.secret = CommonTool.getSecret(calcuteType: PPDeviceCalcuteType.direct)
            inputModel.deviceCalcuteType = PPDeviceCalcuteType.direct
            inputModel.weight = CGFloat(self.myUserModel.weight)
            inputModel.impedance = self.myUserModel.impedance
            inputModel.deviceMac = "c1:c1:c1:c1"
            inputModel.heartRate = heartRate
            
            fatModel = PPBodyFatModel(inputModel: inputModel)
        }else if self.selectType == .calcuteType8AC{
            // 8-electrode algorithm. 8电极算法
            
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
            inputModel.timeInterval = Date().timeIntervalSince1970 // The current measurement data time (in seconds). 当前测量数据的时间(单位:秒)
            
            if deviceCalcuteType8 == .alternate8_5 {
                // Smooth impedance algorithm. 平滑阻抗算法
                
                let lastInput = self.getLastCalculateInputModel()
                fatModel = PPBodyFatModel(smoothWithLast: lastInput, currentInputModel: inputModel)
            } else {
                fatModel = PPBodyFatModel(inputModel: inputModel)
            }
        }else{
            // 4-Electrode AC Algorithm. 4电极交流算法
            let deviceCalcuteType4 = self.deviceCalcuteType ?? .alternate
            
            // Only dual-frequency algorithm (PPDeviceCalcuteType.alternate4_1) needs to pass "impedance100EnCode"
            inputModel.secret = CommonTool.getSecret(calcuteType: deviceCalcuteType4)
            inputModel.deviceCalcuteType = deviceCalcuteType4
            inputModel.weight = CGFloat(self.myUserModel.weight)
            inputModel.impedance = self.myUserModel.impedance
            inputModel.impedance100EnCode = self.myUserModel.impedance100
            inputModel.deviceMac = "c1:c1:c1:c1"
            inputModel.heartRate = heartRate

            fatModel = PPBodyFatModel(inputModel: inputModel)
        }

        
//        let bodyDataJson = CommonTool.loadJSONFromFile(filename: "body_lang_zh.json")
        let bodyDataJson = CommonTool.loadJSONFromFile(filename: "body_lang_en.json")
        
        // Obtain information such as the judgment range and evaluation of each physical indicator.If the standardArray of the PPBodyDetailModel object is empty, then this metric has no judgment range.
        // 获取每个身体指标的判定范围和评价等信息，如果PPBodyDetailModel对象的standardArray为空，则该指标没有判定范围
        let detailModel = PPBodyDetailModel(bodyFatModel: fatModel)
        let weightParam = detailModel.ppBodyParam_Weight
        print("weight-currentValue:\(weightParam.currentValue) range:\(weightParam.standardArray)  standardTitle:\(bodyDataJson[weightParam.standardTitle] ?? "") standSuggestion:\(bodyDataJson[weightParam.standSuggestion] ?? "") standeValuation:\(bodyDataJson[weightParam.standeValuation] ?? "")")
        
        // Get all body indicator arrays(detailModel.data). 获取所有身体指标数组(detailModel.data)
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

