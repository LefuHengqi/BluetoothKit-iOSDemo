//
//  ScaleViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/7/3.
//

import UIKit
import PPBluetoothKit
import PPCalculateKit

class BorreScaleViewController: UIViewController {

    @IBOutlet weak var consoleView: UITextView!

    @IBOutlet weak var weightLbl: UILabel!
    
    var deviceModel : PPBluetoothAdvDeviceModel?
    
    var XM_Obj: Any?
    
    var conslogStr = ""

    var isBabyMode = false
    
    var step = 0
    
    var weight:Float = 0
    
    let user : PPTorreSettingModel = {
        
        let uu = PPTorreSettingModel()
        
        uu.isAthleteMode = false
        uu.isPregnantMode = false
        
        uu.height = 180
        uu.age = 20
        uu.gender = PPDeviceGenderType.female
        uu.unit = .unitKG
        
        uu.memberID = "1234567890"
        
        uu.userID = "abcdefghijklmn"
        
        uu.userName = "Tom"
        
        uu.targetWeight = 60
        
        uu.idealWeight = 50
        
        uu.pIndex = 05
        
        return uu
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let XM_Borre = self.XM_Obj as? PPBluetoothPeripheralBorre{
            XM_Borre.scaleDataDelegate = self

        }
        
        
        if let XM_Borre = self.XM_Obj as? PPBluetoothPeripheralDorre{
            XM_Borre.scaleDataDelegate = self

        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let XM_Borre = self.XM_Obj as? PPBluetoothPeripheralBorre{
            
           XM_Borre.codeStopMeasure { statu in
            
            }
            
            XM_Borre.codeExitBabyModel { statu in
                
            }
        }
        
        
        if let XM_Borre = self.XM_Obj as? PPBluetoothPeripheralDorre{
            
           XM_Borre.codeStopMeasure { statu in
            
            }
            
            XM_Borre.codeExitBabyModel { statu in
                
            }
        }
     
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func scaleBtnClick(_ sender: Any) {
        
        if let XM_Borre = self.XM_Obj as? PPBluetoothPeripheralBorre{
            
            XM_Borre.codeStopMeasure { statu in
            
            }
            
            XM_Borre.codeExitBabyModel { statu in
                
            }
            
            self.isBabyMode = false
            
            
            self.addBleCmd(ss: "codeStartMeasure")

            XM_Borre.codeStartMeasure({ status in
                
                self.addStatusCmd(ss: "\(status)")

            })
        }
        
        
        if let XM_Borre = self.XM_Obj as? PPBluetoothPeripheralDorre{
            
            XM_Borre.codeStopMeasure { statu in
            
            }
            
            XM_Borre.codeExitBabyModel { statu in
                
            }
            
            self.isBabyMode = false
            
            
            self.addBleCmd(ss: "codeStartMeasure")

            XM_Borre.codeStartMeasure({ status in
                
                self.addStatusCmd(ss: "\(status)")

            })
        }
     
    }
    
    @IBAction func babyWeightBtnClick(_ sender: Any) {
        
        
        if let XM_Borre = self.XM_Obj as? PPBluetoothPeripheralBorre{
            
            XM_Borre.codeStopMeasure { statu in
            
            }
            
            XM_Borre.codeExitBabyModel { statu in
                
            }
            
            self.step = 0
            
            self.weight = 0
            
            self.isBabyMode = true
            
            let semaphore = DispatchSemaphore(value: 0)
            
            DispatchQueue.global().async {
                
                self.addBleCmd(ss: "codeEnableBabyModel 0")


                XM_Borre.codeEnableBabyModel(0, weight: 0, withHandler: { statu in
                    
                    self.addStatusCmd(ss: "\(statu)")

                    semaphore.signal()
                })
                
                _ = semaphore.wait(timeout: DispatchTime.now() + 1)

                self.addBleCmd(ss: "codeStartMeasure")

                XM_Borre.codeStartMeasure({ statu in
                    self.addStatusCmd(ss: "\(statu)")

                })
                
            }
        }
        
        if let XM_Borre = self.XM_Obj as? PPBluetoothPeripheralDorre{
            
            XM_Borre.codeStopMeasure { statu in
            
            }
            
            XM_Borre.codeExitBabyModel { statu in
                
            }
            
            self.step = 0
            
            self.weight = 0
            
            self.isBabyMode = true
            
            let semaphore = DispatchSemaphore(value: 0)
            
            DispatchQueue.global().async {
                
                self.addBleCmd(ss: "codeEnableBabyModel 0")


                XM_Borre.codeEnableBabyModel(0, weight: 0, withHandler: { statu in
                    
                    self.addStatusCmd(ss: "\(statu)")

                    semaphore.signal()
                })
                
                _ = semaphore.wait(timeout: DispatchTime.now() + 1)

                self.addBleCmd(ss: "codeStartMeasure")

                XM_Borre.codeStartMeasure({ statu in
                    self.addStatusCmd(ss: "\(statu)")

                })
                
            }
        }
        
     

    }
    
    func displayScaleModel(_ scaleModel:PPBluetoothScaleBaseModel, isLock:Bool) {
        
        let calculateWeightKg = Float(scaleModel.weight)/100
        
        var weightStr = calculateWeightKg.toCurrentUserString(accuracyType: Int(self.deviceModel?.deviceAccuracyType.rawValue ?? 0), unitType: Int(scaleModel.unit.rawValue),forWeight: true) + " \(Int(scaleModel.unit.rawValue).getUnitStr())"
        
        weightStr = isLock ? "weight lock:" + weightStr : "weight process:" + weightStr
        
        if (scaleModel.isHeartRating) {
            
            weightStr = weightStr + "\nMeasuring heart rate..."
        } else if (scaleModel.isFatting) {
            
            weightStr = weightStr + "\nMeasuring body fat..."
        }
        
        self.weightLbl.text = weightStr
        
    }

}

extension BorreScaleViewController:PPBluetoothScaleDataDelegate{
    
    func monitorProcessData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        DispatchQueue.main.async {
            self.displayScaleModel(model, isLock: false)
            
            self.weightLbl.textColor = UIColor.red
            
        }
        
     
        self.addConsoleLog(ss: "monitorProcessData")
        
        self.addStatusCmd(ss: model.description)
        
    }
    
    func monitorLockData(_ model: PPBluetoothScaleBaseModel!, advModel: PPBluetoothAdvDeviceModel!) {
        
        DispatchQueue.main.async {

            self.displayScaleModel(model, isLock: true)

            
            self.weightLbl.textColor = UIColor.green
            
            self.addConsoleLog(ss: "monitorLockData")
            
            self.addStatusCmd(ss: model.description)
            
            var fat = PPBodyFatModel()
            
            if (PPCalculateTools.is8Electrodes(with: advModel.deviceCalcuteType)) {
                
                // Calculate body data (Eight electrodes)
                let inputModel = PPCalculateInputModel()
                inputModel.secret = CommonTool.getSecret(calcuteType: advModel.deviceCalcuteType)
                inputModel.isAthleteMode = self.user.isAthleteMode
                inputModel.isPregnantMode = self.user.isPregnantMode
                inputModel.height = self.user.height
                inputModel.age = self.user.age
                inputModel.gender = self.user.gender
                inputModel.deviceCalcuteType = advModel.deviceCalcuteType
                inputModel.weight = CGFloat(model.weight) / 100
                inputModel.z20KhzLeftArmEnCode = model.z20KhzLeftArmEnCode
                inputModel.z20KhzRightArmEnCode = model.z20KhzRightArmEnCode
                inputModel.z20KhzLeftLegEnCode = model.z20KhzLeftLegEnCode
                inputModel.z20KhzRightLegEnCode = model.z20KhzRightLegEnCode
                inputModel.z20KhzTrunkEnCode = model.z20KhzTrunkEnCode
                inputModel.z100KhzLeftArmEnCode = model.z100KhzLeftArmEnCode
                inputModel.z100KhzRightArmEnCode = model.z100KhzRightArmEnCode
                inputModel.z100KhzLeftLegEnCode = model.z100KhzLeftLegEnCode
                inputModel.z100KhzRightLegEnCode = model.z100KhzRightLegEnCode
                inputModel.z100KhzTrunkEnCode = model.z100KhzTrunkEnCode
                inputModel.deviceMac = advModel.deviceMac
                inputModel.heartRate = model.heartRate
                inputModel.footLen = model.footLen

                
                fat = PPBodyFatModel(inputModel: inputModel)
            } else {
                
                // Calculate body data (Four electrodes)
                let inputModel = PPCalculateInputModel()
                inputModel.secret = CommonTool.getSecret(calcuteType: advModel.deviceCalcuteType)
                inputModel.isAthleteMode = self.user.isAthleteMode
                inputModel.isPregnantMode = self.user.isPregnantMode
                inputModel.height = self.user.height
                inputModel.age = self.user.age
                inputModel.gender = self.user.gender
                inputModel.deviceCalcuteType = advModel.deviceCalcuteType
                inputModel.weight = CGFloat(model.weight) / 100
                inputModel.impedance = model.impedance
                inputModel.impedance100EnCode = model.impedance100EnCode
                inputModel.deviceMac = advModel.deviceMac
                inputModel.heartRate = model.heartRate
                inputModel.footLen = model.footLen

                fat = PPBodyFatModel(inputModel: inputModel)
            }

            
            let alertVC = UIAlertController(title: fat.description, message: "", preferredStyle: .alert)
            
            alertVC.addAction(UIAlertAction.init(title: "ok", style: .default))
            
            self.present(alertVC, animated: true)
            
            if self.isBabyMode{
                
                
                if let XM_Borre = self.XM_Obj as? PPBluetoothPeripheralBorre{
                    if self.step == 0{
                        self.addBleCmd(ss: "codeEnableBabyModel  1")
                        XM_Borre.codeEnableBabyModel(1, weight: model.weight, withHandler: { statu in
                            
                            self.addStatusCmd(ss: "\(statu)")
                        })
                        
                        self.step = 1
                    }
                    
                    
                    if self.step == 1{
                        
                        self.weightLbl.text = String.init(format: "weight lock:%0.2f", Float(model.weight) / 100.0 - self.weight)

                    }
                   
                    
                }
                
                
                if let XM_Borre = self.XM_Obj as? PPBluetoothPeripheralDorre{
                    if self.step == 0{
                        self.addBleCmd(ss: "codeEnableBabyModel  1")
                        XM_Borre.codeEnableBabyModel(1, weight: model.weight, withHandler: { statu in
                            
                            self.addStatusCmd(ss: "\(statu)")
                        })
                        
                        self.step = 1
                    }
                    
                    
                    if self.step == 1{
                        
                        self.weightLbl.text = String.init(format: "weight lock:%0.2f", Float(model.weight) / 100.0 - self.weight)

                    }
                   
                    
                }
                
              
            }


        }
            
        }
        
      
    
    
    
}


extension BorreScaleViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }
    
    static var storyboardIdentifier: String {
        return "BorreScaleViewController"
    }
    
    
    
}


extension BorreScaleViewController{
    
     func addConsoleLog(ss:String){
         self.conslogStr.append("\ndelegate:\(ss)\n")
         
       
         self.scrollBottom()
    }
    
    func addBleCmd(ss:String){
        self.conslogStr.append("\nfunction:\(ss)\n")

        self.scrollBottom()

    }
    
    
    func addStatusCmd(ss:String){
        self.conslogStr.append("\nstatus:\(ss)\n")

        self.scrollBottom()

    }
    
    func scrollBottom(){
        
        DispatchQueue.main.async {
            self.consoleView.text = self.conslogStr
            
            let bottomOffset = CGPoint(x: 0, y: self.consoleView.contentSize.height - self.consoleView.bounds.size.height)
              if bottomOffset.y > 0 {
                  self.consoleView.setContentOffset(bottomOffset, animated: true)
              }
        }
      
    }
}
