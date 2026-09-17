//
//  SearchDeviceViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/7/29.
//

import UIKit
import PPBluetoothKit



class SearchDeviceViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    lazy var scaleManager:PPBluetoothConnectManager = PPBluetoothConnectManager()


    var XM_FoundDeviceArray  =  [(PPBluetoothAdvDeviceModel,CBPeripheral)]()

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.scaleManager.stopSearch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scaleManager.updateStateDelegate = self;
        self.scaleManager.surroundDeviceDelegate = self;
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 340
        self.tableView.register(SearchDeviceCardCell.self, forCellReuseIdentifier: SearchDeviceCardCell.reuseIdentifier)
    

    }
    
    
    func getProductAndType(deviceCalcuteType:PPDeviceCalcuteType)->(Int,String) {

        switch deviceCalcuteType {
        case .unknow:
            return (-1, "unknow")
        case .inScale:
            return (-1, "inScale")
        case .direct:
            return (-1, "direct")
        case .alternate:
            return (-1, "alternate")
        case .alternate8:
            return (1, "alternate8")
        case .alternateNormal:
            return (-1, "alternateNormal")
        case .needNot:
            return (-1, "needNot")
        case .alternate8_0:
            return (4, "alternate8_0")
        case .alternate8_1:
            return (3, "alternate8_1")
        case .alternate4_0:
            return (-1, "alternate4_0")
        case .alternate4_1:
            return (-1, "alternate4_1")
        case .alternate8_2:
            return (7, "alternate8_2")
        case .alternate8_3:
            return (5, "alternate8_3")
        case .alternate8_4:
            return (6, "alternate8_4")
        case .alternate8_5:
            return (6, "alternate8_5")
        default:
            return (-1,"")
        }

    }

    func getWifiProtocalType(peripheralType: PPDevicePeripheralType)->String {
        
        switch peripheralType {
        case .peripheralApple, .peripheralCoconut:
            return "V2.0/V3.0 Protocol"
        case .peripheralIce, .peripheralTorre, .peripheralBorre, .peripheralDorre:
            return "Torre/V4.0 Protocol"
        default:
            return "Unknown"
        }

    }
    
    func getCalculateAPI(calcuteType: PPDeviceCalcuteType)->String {
        switch calcuteType {
        case .direct:
            return "DC Four-Electrode Algorithm v2.0"
        case .alternate, .alternateNormal, .alternate4_0:
            return "AC Four-Electrode Algorithm"
        case .alternate4_1:
            return "Dual-Frequency AC Four-Electrode Algorithm"
        case .alternate8, .alternate8_0, .alternate8_1, .alternate8_2, .alternate8_3, .alternate8_4:
            return "AC Eight-Electrode Algorithm"
        case .alternate8_5:
            return "AC Eight-Electrode Algorithm Smooth"
        default:
            return "AC Four-Electrode Algorithm"
        }
    }

}

extension SearchDeviceViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.XM_FoundDeviceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchDeviceCardCell.reuseIdentifier, for: indexPath) as! SearchDeviceCardCell
        
        let model = self.XM_FoundDeviceArray[indexPath.row]
        var caType = ""

        switch(model.0.peripheralType){
        case .peripheralApple:
            caType = "PeripheralApple"
            break
        case .peripheralBanana:
            caType = "PeripheralBanana"
            break
        case .peripheralCoconut:
            caType = "PeripheralCoconut"
            break
        case .peripheralDurian:
            caType = "PeripheralDurian"
            break
        case .peripheralEgg:
            caType = "PeripheralEgg"
            break
        case .peripheralFish:
            caType = "PeripheralFish"
            break
        case .peripheralGrapes:
            caType = "PeripheralGrapes"
            break
        case .peripheralTorre:
            caType = "PeripheralTorre"
            break
        case .peripheralDorre:
            caType = "PeripheralDorre"
            break
        case .peripheralHamburger:
            caType = "PeripheralHamburger"
        case .peripheralIce:
            caType = "PeripheralIce"
        case .peripheralJambul:
            caType = "PeripheralJambul"
        case .peripheralBorre:
            caType = "PeripheralBorre"
        case .peripheralKorre:
            caType = "PeripheralKorre"
        case .peripheralLorre:
            caType = "PeripheralLorre"
        case .peripheralMorre:
            caType = "PeripheralMorre"
        default:
            caType = "Unknow"
        }

        
        let authStr = model.0.needAuth ? "Need" : "No Need"
        let httpStr = model.0.httpType == 1 ? "https" : "http"
        let adns = model.0.isSupportADN ? "Yes" : "No"
        let wifiProtolStr = self.getWifiProtocalType(peripheralType: model.0.peripheralType)
        let api = self.getCalculateAPI(calcuteType: model.0.deviceCalcuteType)
        let ret = self.getProductAndType(deviceCalcuteType: model.0.deviceCalcuteType)
        
        
        var cardModel = SearchDeviceCardModel()
        cardModel.platform = SearchDeviceCardModel.Platform(deviceName: "\(model.0.deviceName)", advLength: "\(model.0.advLength)", sign: "\(model.0.sign)")
        cardModel.basic = SearchDeviceCardModel.Basic(mac: "\(model.0.deviceMac)", rssi: "\(model.0.rssi)", peripheralType: caType, needAuth: authStr)
        cardModel.network = nil
        if PPBluetoothManager.hasWifiFunc(model.0.deviceFuncType) {
            cardModel.network = SearchDeviceCardModel.Network(wifiProtocolType: wifiProtolStr, httpScheme: httpStr, supportADN: adns)
        }
        
        cardModel.calcute = nil
        if model.0.deviceType != .CA {
            cardModel.calcute = SearchDeviceCardModel.Calcute(calculateType: ret.1, calculateAPI: api, product: "\(ret.0)")
        }

        cell.configCard(with: cardModel)

        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let model = self.XM_FoundDeviceArray[indexPath.row]
        
        
        
        
        UIPasteboard.general.string = model.0.description
        
        switch(model.0.peripheralType){
            
        case .peripheralApple:
            let vc = DeviceAppleViewController.instantiate()
            vc.title = model.0.deviceName
            vc.deviceModel = model.0
            self.navigationController?.pushViewController(vc, animated: true);
            break
        case .peripheralBanana:
            let vc = DeviceBananaViewController.instantiate()
            
            vc.title = model.0.deviceName
            
            vc.deviceModel = model.0
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
            break
        case .peripheralCoconut:
            let vc = DeviceCoconutViewController.instantiate()
            vc.title = model.0.deviceName
            vc.deviceModel = model.0
            self.navigationController?.pushViewController(vc, animated: true);
            break
        case .peripheralDurian:
            let vc = DeviceDurianViewController.instantiate()
            vc.title = model.0.deviceName
            
            vc.deviceModel = model.0
            self.navigationController?.pushViewController(vc
                                                          , animated: true)
            
            break
        case .peripheralEgg:
            let vc = DeviceEggViewController.instantiate()
            vc.title = model.0.deviceName
            vc.deviceModel = model.0
            self.navigationController?.pushViewController(vc, animated: true);
            break
        case .peripheralFish:
            let vc = DeviceFishViewController.instantiate()
            
            
            vc.title = model.0.deviceName
            vc.deviceModel = model.0
            self.navigationController?.pushViewController(vc, animated: true);
            break
        case .peripheralGrapes:
            let vc = DeviceGrapesViewController.instantiate()
            
            
            vc.title = model.0.deviceName
            vc.deviceModel = model.0
            self.navigationController?.pushViewController(vc, animated: true);
            
            break
        case .peripheralTorre:
            let vc = DeviceTorreViewController.instantiate()
            
            vc.title = model.0.deviceName
            
            vc.deviceModel = model.0
            
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .peripheralBorre:
            let vc = DeviceBorreViewController.instantiate()
            
            vc.title = model.0.deviceName
            
            vc.deviceModel = model.0
            
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case .peripheralDorre:
            let vc = DeviceDorreViewController.instantiate()
            
            vc.title = model.0.deviceName
            
            vc.deviceModel = model.0
            
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .peripheralHamburger:
            let vc = DeviceHamburgerViewController.instantiate()
            
            vc.title = model.0.deviceName
            
            vc.deviceModel = model.0
            
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
      
        case .peripheralIce:
            let vc = DeviceIceViewController.instantiate()
            
            vc.title = model.0.deviceName
            
            vc.deviceModel = model.0
            
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .peripheralJambul:
            let vc = DeviceJambulViewController.instantiate()
            
            vc.title = model.0.deviceName
            
            vc.deviceModel = model.0
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
            break
        case .peripheralKorre:
            
            let vc = DeviceKorreViewController.instantiate()
            vc.title = model.0.deviceName
            vc.deviceModel = model.0
            self.navigationController?.pushViewController(vc, animated: true)
        case .peripheralLorre:
            
            let vc = DeviceLorreViewController.instantiate()
            vc.title = model.0.deviceName
            vc.deviceModel = model.0
            self.navigationController?.pushViewController(vc, animated: true)
            
        @unknown default:
            
            print("undefined")
            break
        }
        
   
     
    }
    
    
}


extension SearchDeviceViewController:PPBluetoothUpdateStateDelegate,PPBluetoothSurroundDeviceDelegate{
    
    
    
    func centralManagerDidUpdate(_ state: PPBluetoothState) {
        
        if (state == .poweredOn){
            self.scaleManager.searchSurroundDevice()
        }
    }
    
    func centralManagerDidFoundSurroundDevice(_ device: PPBluetoothAdvDeviceModel!, andPeripheral peripheral: CBPeripheral!) {
        
        if !self.XM_FoundDeviceArray.contains(where: { model in
            
            model.1.name == peripheral.name
        }){
            self.XM_FoundDeviceArray.append((device,peripheral))
            
        }
     
      
        self.tableView.reloadData()

    }
    
}


extension SearchDeviceViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }
    
    static var storyboardIdentifier: String {
        return "SearchDeviceViewController"
    }
    
    
    
}


