//
//  ScaleCoconutViewController.swift
//  PPBluetoothKitDemo
//
//  Created by 杨青山 on 2023/8/9.
//

import UIKit
import PPBluetoothKit


class ScaleCoconutViewController:UIViewController{

    @IBOutlet weak var weightLabe: UILabel!
    
    @IBOutlet weak var consoleTextView: UITextView!
    
    var deviceModel : PPBluetoothAdvDeviceModel?
    
    var complete :Bool?{
        didSet{
            guard let com = complete else {
                return;
            }
            DispatchQueue.main.async {
                if (com == true) {
                    self.weightLabe.textColor = UIColor.green

                } else {
                    self.weightLabe.textColor = UIColor.red

                }

            }
        }
    }
    
    var conslogStr = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.XM_Coconut?.scaleDataDelegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        

    }

    var XM_PPBluetoothScaleBaseModel :PPBluetoothScaleBaseModel? {
        
        didSet {
            
            guard let model = XM_PPBluetoothScaleBaseModel else{
                
        
                return
            }
            DispatchQueue.main.async {
                
                self.displayScaleModel(model, isLock: self.complete ?? false)
                
                if let com = self.complete{
                 
                    if com{
                        self.addConsoleLog(ss: "monitorLockData")

                    }else{
                        self.addConsoleLog(ss: "monitorProcessData")

                    }
                }
                
                
                self.addStatusCmd(ss: model.description)
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
        
        self.weightLabe.text = weightStr
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}




extension ScaleCoconutViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }
    static var storyboardIdentifier: String {
        return "ScaleCoconutViewController"
    }
}

extension ScaleCoconutViewController{
    
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
        self.consoleTextView.text = self.conslogStr
        
        let bottomOffset = CGPoint(x: 0, y: consoleTextView.contentSize.height - consoleTextView.bounds.size.height)
          if bottomOffset.y > 0 {
              consoleTextView.setContentOffset(bottomOffset, animated: true)
          }
    }
}
