//
//  Extensions.swift
//  PPBluetoothKitDemo
//
//  Created by lefu on 2023/12/1
//  


import Foundation
import UIKit
import PPBluetoothKit


enum UnitType:Int{
  
    
    case Unit_KG = 0
    case Unit_lb = 1
    case Unit_st = 11
    case Unit_Jin = 3
    case Unit_stlb = 2
 
}


extension Float{
    
    func toUnitStr(unitType:Int, accuracyType:Int, forWeight:Bool = false, smallWeightCode:Int = 0, displayDecimalPlaces:Int = 1)->String{
        
        let unit = UnitType.init(rawValue: unitType)
        
        let deviceType = PPDeviceAccuracyType(rawValue: UInt(accuracyType))
        
        switch(unit){
            
        case .Unit_KG:
            
            if(self < 10 && smallWeightCode == 1 && forWeight){

                return String.init(format: "%0.2f", self)
                
            } else if(deviceType == .point005){
                
                if forWeight{
                    
                    if self > 100{
                        
                        if displayDecimalPlaces == 2 {
                            return String.init(format: "%0.2f", self)
                        }
                        
                        return String.init(format: "%0.1f", floor(self *   10) / 10)
                    }
                    
                    return String.init(format: "%0.2f", self)
                }else{
                    
                    return String.init(format: "%0.1f", self)
                }
                
            }else{
                
                if forWeight {
                    
                    if self > 100, displayDecimalPlaces == 2 {
                        return String.init(format: "%0.2f", self)
                    }

                    return XM_KeepPoint1S(tempKg: self)
                } else {
                    
                    return String.init(format: "%0.1f", self)
                }
                
            }
            
        case .Unit_lb:
            if (self < 10 && smallWeightCode == 1 && forWeight) {
                
                let weightInt = Int(self * 100 + 0.5)
                let lb100 = (weightInt * 22046 + 25000) / 10000 / 5 * 5;
                let lbFloat = Float(lb100) / 100.0
                
                return String.init(format: "%0.2f", lbFloat)

            } else if(deviceType == .point005){
                
                
                let weight = (self * 100 + 5) / 10
                
                let  roundWeightInt = Int(weight+0.005)
                
                let floorWeightFloat = Float(roundWeightInt) / 10
                
                
                let floorWeight =  Int(floorWeightFloat * 10 * 22046 / 10000)
                
                let floorWeightInt = Int(floorWeight)
                
                let floorWeightF = Float(floorWeightInt) / 10
                
                return String.init(format: "%0.1f", floorWeightF)
                
                
            }else{
                

                
                let floorWeight = self * 10 * 22046 / 10000
                
                var intFloor = Int(floorWeight)
                
                if(intFloor % 2 > 0){
                    intFloor = intFloor + 1
                }

                let weight = Float(intFloor) / 10.0
                
                return String.init(format: "%0.1f", weight)
                
            }

        case .Unit_st:
            
            if(deviceType == .point005){

                let weight = (self * 100 + 5)/10
                
                let roundWeightInt = Int(weight + 0.005)
                
                let floorWeightFloat = Float(roundWeightInt) / 10
                
                let lb =  floorWeightFloat * 10 * 22046 / 1000
                let temp = lb / 14
                let st = Int(temp)
                
                let stFloat = Float(st) / 100
                
                return String.init(format: "%0.2f", stFloat)
                
            }else{

                let lb:Int = Int(Int((self * 100 + 5) / 10) * 22046 / 1000)
                
                var stInt = lb / 14
                if (stInt % 2 != 0) {
                    stInt += 1;
                }
                
                let tempKg = Float(stInt) / 100.0
                
                return String.init(format: "%0.2f", tempKg)
            }
            
        case .Unit_Jin:
            if(self < 10 && smallWeightCode == 1 && forWeight){

                return String.init(format: "%0.2f", self*2)
            }

                return String.init(format: "%0.1f", self*2)
                
        case .Unit_stlb:
            
            if(deviceType == .point005){
                
                let grams = self * 1000
                let toLong = Int64(grams + 50 + 0.05)
                let step1 = (toLong / 100) * 100
                let lbWeight = (step1 * 22046) / 10000
                let stValue = lbWeight / 14000
                let lbValue = lbWeight % 14000
                let lbValueDouble = Double(lbValue) / 1000.0
                let divided = (lbValueDouble * 10).rounded(.towardZero) / 10
                return String(format: "%d:%.1f", stValue, divided)
                
            }else{
                
                let l = Int(self * 1000 + 0.05)
                let toLong = l + 50
                let lbWeight = (toLong / 100 * 100 * 22046) / 10000
                let stValue = lbWeight / 14000
                let lbValue = lbWeight % 14000
                
                let divide = Float(lbValue) / 1000.0
                let divideValue = Float(Int(divide * 10)) / 10.0
                
                return String.init(format: "%ld:%.1f", stValue, divideValue)
                
            }
            
        case .none:
            
            return ""
        }
    }
    
    func XM_KeepPoint1S(tempKg: Float) -> String {
        
        var XM_Kg = (tempKg * 10000 + 5) / 10000
        if tempKg < 0 {
            XM_Kg = (tempKg * 10000 - 5) / 10000
        }
        let XM_10Kg = Int(XM_Kg * 10)
        let XM_DoubleKgValue = Float(XM_10Kg) / 10.0

        let XM_ValueStr = String.init(format: "%.1f", XM_DoubleKgValue)
        
        return XM_ValueStr
    }

    func toCurrentUserString(accuracyType : Int, unitType:Int, forWeight:Bool = false, smallWeightCode:Int = 0, displayDecimalPlaces:Int = 1)->String{
        
        return self.toUnitStr(unitType: unitType, accuracyType: accuracyType, forWeight: forWeight, smallWeightCode: smallWeightCode, displayDecimalPlaces: displayDecimalPlaces)

    }
    
}



extension Int{
    func getUnitStr()->String {
        
        switch self {
        case 0:
            return "kg"
        case 1:
            return "lb"
        case 2:
            return "st:lb"
        case 3:
            return "jin"
        case 4:
            return "g"
        case 5:
            return "lb:oz"
        case 6:
            return "oz"
        case 11:
            return "st"
        default:
            return ""
        }
        
    }
    
    
    func toFoodUnitStr(deviceAccuracyType:PPDeviceAccuracyType, unit: PPDeviceUnit, deviceName:String, isPlus:Bool) -> (String, String){
        let dic = PPUnitTool.weightStrNew(with: CGFloat(self), accuracyType: deviceAccuracyType, andUnit: unit, deviceName: deviceName)
        var weightStr = ""
        if unit == PPDeviceUnit.unitLBOZ {
            weightStr = "\(isPlus ? "":"-")\(dic["lboz_lb"] ?? ""):\(dic["lboz_oz"] ?? "")"
        } else {
            weightStr = "\(isPlus ? "":"-")\(dic["weight"] ?? "")"
            if dic["weight"] as? Float == 0{
                weightStr = "0"
            }
        }
        var unitStr = "g"
        if (unit == PPDeviceUnit.unitG) {
            unitStr = "g"
        }else if(unit == PPDeviceUnit.unitOZ){
            unitStr = "oz"

        }else if(unit == PPDeviceUnit.unitMLMilk){

            unitStr = "ml(milk)"
        }else if(unit == PPDeviceUnit.unitMLWater){
            
            unitStr = "ml(water)"
        }else if(unit == PPDeviceUnit.unitFLOZWater){
            
            unitStr = "fl.oz(water)"
        }else if(unit == PPDeviceUnit.unitFLOZMilk){
            
            unitStr = "fl.oz(milk)"
        }else if(unit == PPDeviceUnit.unitLBOZ){
            
            unitStr = "lb:oz"
        }else if(unit == PPDeviceUnit.unitLB){
            
            unitStr = "lb"
        }
        return (weightStr, unitStr)
    }
}

public protocol DemoStoryboardInstantiable {

    static var storyboardName: String { get }
    static var storyboardIdentifier: String { get }
}

public extension DemoStoryboardInstantiable {

  
    static func instantiate() -> Self {

        var bundle:Bundle? = nil
        if let sClass = Self.self as? AnyClass  {
            
            bundle = Bundle(for: sClass)
        }

        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)

        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
    
}
