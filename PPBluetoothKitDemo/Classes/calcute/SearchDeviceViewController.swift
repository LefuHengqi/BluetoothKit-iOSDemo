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

extension SearchDeviceViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.XM_FoundDeviceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            
        case .peripheralHamburger:
            caType = "PeripheralHamburger"

        case .peripheralIce:
            caType = "PeripheralIce"

        case .peripheralJambul:
            caType = "PeripheralJambul"

     
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell")!
        
        
        cell.textLabel?.numberOfLines = 0
        
        cell.textLabel?.text = "Name:\(model.0.deviceName)\t\tRSSI:\(model.0.rssi)\nmac:\(model.0.deviceMac)\nsettingId:\(model.0.deviceSettingId)\nadvLength:\(model.0.advLength)\t\tsign:\(model.0.sign)\nPeripheralType:\(caType)"
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
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
        @unknown default:
            
            
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


