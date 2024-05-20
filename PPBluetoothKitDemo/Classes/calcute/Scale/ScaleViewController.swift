//
//  ScaleViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/7/3.
//

import UIKit
import PPBluetoothKit

class ScaleViewController: UIViewController {

    @IBOutlet weak var consoleView: UITextView!

    @IBOutlet weak var weightLbl: UILabel!
    
    var deviceModel : PPBluetoothAdvDeviceModel?
    
    var XM_Torre: PPBluetoothPeripheralTorre?
    
    var conslogStr = ""

    var isBabyMode = false
    
    var step = 0
    
    var weight:Float = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.XM_Torre?.scaleDataDelegate = self

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.XM_Torre?.codeStopMeasure { statu in
        
        }
        
        self.XM_Torre?.codeExitBabyModel { statu in
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func scaleBtnClick(_ sender: Any) {
        
        
        self.XM_Torre?.codeStopMeasure { statu in
        
        }
        
        self.XM_Torre?.codeExitBabyModel { statu in
            
        }
        
        self.isBabyMode = false
        
        
        self.addBleCmd(ss: "codeStartMeasure")

        self.XM_Torre?.codeStartMeasure({ status in
            
            self.addStatusCmd(ss: "\(status)")

        })
    }
    
    @IBAction func babyWeightBtnClick(_ sender: Any) {
        
        self.XM_Torre?.codeStopMeasure { statu in
        
        }
        
        self.XM_Torre?.codeExitBabyModel { statu in
            
        }
        
        self.step = 0
        
        self.weight = 0
        
        self.isBabyMode = true
        
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global().async {
            
            self.addBleCmd(ss: "codeEnableBabyModel 0")


            self.XM_Torre?.codeEnableBabyModel(0, weight: 0, withHandler: { statu in
                
                self.addStatusCmd(ss: "\(statu)")

                semaphore.signal()
            })
            
            _ = semaphore.wait(timeout: DispatchTime.now() + 1)

            self.addBleCmd(ss: "codeStartMeasure")

            self.XM_Torre?.codeStartMeasure({ statu in
                self.addStatusCmd(ss: "\(statu)")

            })
            
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

extension ScaleViewController:PPBluetoothScaleDataDelegate{
    
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
            
            
            if self.isBabyMode{
                
                if self.step == 0{
                    self.addBleCmd(ss: "codeEnableBabyModel  1")
                    self.XM_Torre?.codeEnableBabyModel(1, weight: model.weight, withHandler: { statu in
                        
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


extension ScaleViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }
    
    static var storyboardIdentifier: String {
        return "ScaleViewController"
    }
    
    
    
}


extension ScaleViewController{
    
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
