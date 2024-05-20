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
    
    func toUnitStr(unitType:Int, accuracyType:Int, forWeight:Bool = false, kgRounding:Bool = false)->String{
        
        let unit = UnitType.init(rawValue: unitType)
        
        let deviceType = PPDeviceAccuracyType(rawValue: UInt(accuracyType))
        
        switch(unit){
            
        case .Unit_KG:
            
            if(deviceType == .point005){
                
                if forWeight{
                    
                    if self > 100{
                      
                        return String.init(format: "%0.1f", floor(self *   10) / 10)

                    }
                    
                    return String.init(format: "%0.2f", self)
                }else{
                    
                    return String.init(format: "%0.1f", self)
                }
                
            }else{
                return String.init(format: "%0.1f", self)
                
            }
            
        case .Unit_lb:
            if(deviceType == .point005){
                
                
                let weight = roundf(self * 100 + 5) / 10
                
                let  roundWeightInt = Int(weight)
                
                let floorWeightFloat = Float(roundWeightInt) / 10
                
                
                let floorWeight =  floorf(floorWeightFloat * 10 * 22046 / 10000)
                
                let floorWeightInt = Int(floorWeight)
                
                let floorWeightF = Float(floorWeightInt) / 10
                
                return String.init(format: "%0.1f", floorWeightF)
                
                
            }else{
                

                
                var floorWeight = self * 10 * 22046 / 10000
                
                let intFloor = Int(floor(floorWeight))
                
                if(intFloor % 2 > 0){
                    floorWeight = floorWeight + 1
                }
                
                let weight = Float(floorWeight) / 10
                
                
                var IntWeight = Int(weight * 10)
                
                
                

                
                return String.init(format: "%0.1f", Float(IntWeight) / 10)
                
            }

        case .Unit_st:
            
            if(deviceType == .point005){
                
                

                
                let weight = roundf(self * 100 + 5)/10
                
                let roundWeightInt = Int(weight)
                
                let floorWeightFloat = Float(roundWeightInt) / 10
                
                let lb =  floorWeightFloat * 10 * 22046 / 1000
                
                let st = Int(floorf(lb / 14))
                
                let stFloat = Float(st) / 100
                
                return String.init(format: "%0.2f", stFloat)
                
            }else{
                
                
                
                
                
                var lb = self * 10 * 22046 / 10000
                    
    //                    lb.round()
                
                
                
                var  roundWeightInt = Int(floor(lb))

                if(roundWeightInt % 2 > 0){
                    roundWeightInt = roundWeightInt + 1
                }
                    
                    let weight = Float(roundWeightInt) / 10.0
                
                return String.init(format: "%0.1f", weight)
            }
            
        case .Unit_Jin:
            // fix:#I8LI0E，斤只保留一位小数，与Android保持一致
                return String.init(format: "%0.1f", self*2)
                
        case .Unit_stlb:
            
            if(deviceType == .point005){
                
                let weight = roundf(self * 100 + 5) / 10
                
                let  roundWeightInt = Int(weight)
                
                let floorWeightFloat = Float(roundWeightInt) / 10
                
                let floorWeight =  floorf(floorWeightFloat * 10 * 22046 / 10000)
                
                let floorWeightInt = Int(floorWeight)
                
                let stPart = floorWeightInt / 140
                
                let lbPart =  Float(floorWeightInt).truncatingRemainder(dividingBy: 140.0) / 10.0

                return String.init(format: "%ld:%.1f", stPart,lbPart )
                
            }else{
                
                var floorWeight = self * 10 * 22046 / 10000

                let intFloor = Int(floorf(floorWeight))
                
                if(intFloor % 2 > 0){
                    
                    floorWeight = floorWeight + 1
                }
                
                let floorWeightInt = Int(floorWeight)
                
                let stPart = floorWeightInt / 140
                
                let lbPart =  Float(floorWeightInt).truncatingRemainder(dividingBy: 140.0) / 10.0

                return String.init(format: "%ld:%.1f", stPart,lbPart )
            }
            
        case .none:
            
            return ""
        }
    }

    func toCurrentUserString(accuracyType : Int, unitType:Int, forWeight:Bool = false, kgRounding:Bool = false)->String{
        
        return self.toUnitStr(unitType: unitType, accuracyType: accuracyType, forWeight: forWeight, kgRounding:kgRounding)

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
