//
//  DeviceOpenViewController.swift
//  PPBluetoothKitDemo
//
//  Created by lefu on 2024/3/6
//  


import Foundation
import PPBluetoothKit

public enum DeviceOpenVCType:Int {
    case torre
}

public class DeviceOpenViewController:UIViewController {
    weak var currentVC:OpenTestTorreViewController?
    
    public var type:DeviceOpenVCType = .torre
    public var deviceMac:String = ""
    public var deviceAccuracyType:PPDeviceAccuracyType = .point005
    public var deviceName:String = ""
    public var deviceFuncType:PPDeviceFuncType = PPDeviceFuncType(rawValue: 223)
    public var peripheral: CBPeripheral?
    public var connected:Bool? = false {
        didSet {
            
            guard let connect = connected else {
                return
            }
            
            self.currentVC?.XM_IsConnect = connect
            
            
        }
    }
    
    public var willDeinitHanlder:(()->Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if type == .torre {
            let devModel = PPBluetoothAdvDeviceModel()
            devModel.deviceMac = self.deviceMac
            devModel.deviceAccuracyType = self.deviceAccuracyType
            devModel.deviceName = self.deviceName
            devModel.deviceFuncType = self.deviceFuncType
            
            let vc = OpenTestTorreViewController.instantiate()
            
            vc.deviceModel = devModel
            vc.peripheral = self.peripheral
            vc.XM_IsConnect = self.connected ?? true
            vc.title = self.title
            vc.view.frame = self.view.bounds
            self.view.addSubview(vc.view)
            self.addChild(vc)
            
            self.currentVC = vc
            
        }
        
    }
    
    deinit {
        self.willDeinitHanlder?()
    }
}


extension DeviceOpenViewController:DemoStoryboardInstantiable{
    public static var storyboardName: String {
        return "BluetoothKitDemo"
    }
    
    public static var storyboardIdentifier: String {
        return "DeviceOpenViewController"
    }

}
