//
//  FoundedViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/7/3.
//

import UIKit
import PPBluetoothKit

var selectDevice : (PPBluetoothAdvDeviceModel,CBPeripheral)?

class FoundedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var scaleManager:PPBluetoothConnectManager = PPBluetoothConnectManager()

    var XM_FoundDeviceArray  =  [(PPBluetoothAdvDeviceModel,CBPeripheral)]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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

extension FoundedViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.XM_FoundDeviceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let model = self.XM_FoundDeviceArray[indexPath.row]
        
        cell!.textLabel?.numberOfLines = 0
        
        cell!.textLabel?.text = "bleName:\(model.0.deviceName)\nmac:\(model.0.deviceMac)\nRSSI:\(model.0.rssi)"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectDevice = self.XM_FoundDeviceArray[indexPath.row]
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}


extension FoundedViewController:PPBluetoothUpdateStateDelegate,PPBluetoothSurroundDeviceDelegate{
    
    
    
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
