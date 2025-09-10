//
//  DeviceBananaViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/8/10.
//

import UIKit
import PPBluetoothKit
import PPCalculateKit

class DeviceBananaViewController: BaseViewController {
    var XM_Banana : PPBluetoothPeripheralBanana!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let banana = PPBluetoothPeripheralBanana.init(device: self.deviceModel)
        self.XM_Banana = banana
        self.XM_Banana.updateStateDelegate = self
        self.XM_Banana.scaleDataDelegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    func displayScaleModel(_ scaleModel:PPBluetoothScaleBaseModel, advModel: PPBluetoothAdvDeviceModel, isLock:Bool) {
        
        let calculateWeightKg = Float(scaleModel.weight)/100
        
        var weightStr = calculateWeightKg.toCurrentUserString(accuracyType: Int(self.deviceModel.deviceAccuracyType.rawValue), unitType: Int(scaleModel.unit.rawValue),forWeight: true) + " \(Int(scaleModel.unit.rawValue).getUnitStr())"
        
        weightStr = isLock ? "weight lock:" + weightStr : "weight process:" + weightStr
        
        // Measurement completed
        if scaleModel.isEnd {
            
            // Calculate body data (Four electrodes)
            let inputModel = PPCalculateInputModel()
            inputModel.secret = CommonTool.getSecret(calcuteType: advModel.deviceCalcuteType)
            inputModel.isAthleteMode = false
            inputModel.isPregnantMode = false
            inputModel.height = 160
            inputModel.age = 20
            inputModel.gender = .female
            inputModel.deviceCalcuteType = advModel.deviceCalcuteType
            inputModel.weight = CGFloat(calculateWeightKg)
            inputModel.impedance = scaleModel.impedance
            inputModel.impedance100EnCode = scaleModel.impedance100EnCode
            inputModel.deviceMac = advModel.deviceMac
            inputModel.heartRate = scaleModel.heartRate
            inputModel.footLen = scaleModel.footLen

            
            let fatModel = PPBodyFatModel(inputModel: inputModel)
            
            let bodyDataJson = CommonTool.loadJSONFromFile(filename: "body_lang_en.json")
            
            //Get the range of each body indicator
            let detailModel = PPBodyDetailModel(bodyFatModel: fatModel)
            let weightParam = detailModel.ppBodyParam_Weight
            print("weight-currentValue:\(weightParam.currentValue) range:\(weightParam.standardArray)  standardTitle:\(bodyDataJson[weightParam.standardTitle] ?? "") standSuggestion:\(bodyDataJson[weightParam.standSuggestion] ?? "") standeValuation:\(bodyDataJson[weightParam.standeValuation] ?? "")")
            //        print("data:\(detailModel.data)")
            
            
            let ss = CommonTool.getDesp(fatModel: fatModel, inputModel: inputModel)
            self.addStatusCmd(ss: ss)
        } else {
            
            if (scaleModel.isHeartRating) {
                
                weightStr = weightStr + "\nMeasuring heart rate..."
            } else if (scaleModel.isFatting) {
                
                weightStr = weightStr + "\nMeasuring body fat..."
            }
            
        }
        
        self.weightLbl.text = weightStr
    }
    
    deinit{
        
        // 恢复设备的默认行为
        UIApplication.shared.isIdleTimerDisabled = false
        
        self.XM_Banana.scaleDataDelegate = nil;
        self.XM_Banana.updateStateDelegate = nil;
        self.XM_Banana.stopSearch()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DeviceBananaViewController:PPBluetoothUpdateStateDelegate{
    
    func centralManagerDidUpdate(_ state: PPBluetoothState) {
        
        if (state == .poweredOn){
            
            self.addConsoleLog(ss: "centralManagerDidUpdate")
            
            self.addBleCmd(ss: "receivedDeviceData")

            
            self.XM_Banana.receivedDeviceData()
            self.connectStateLbl.text = "connected"
            self.connectStateLbl.textColor = UIColor.green

        }
        
      
    }
    
}


extension DeviceBananaViewController: PPBluetoothScaleDataDelegate{
    
    func monitorProcessData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        self.displayScaleModel(model, advModel: advModel, isLock: false)
        self.weightLbl.textColor = .red

    }
    
    func monitorLockData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
     
        self.displayScaleModel(model, advModel: advModel, isLock: true)
        self.weightLbl.textColor = .green

    
    }
    
}


extension DeviceBananaViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }

    static var storyboardIdentifier: String {
        return "DeviceBananaViewController"
    }



}

