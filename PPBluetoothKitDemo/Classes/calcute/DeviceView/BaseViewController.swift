//
//  BaseViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/8/10.
//

import UIKit
import PPBluetoothKit

enum DeviceMenuType:String{
    
    case connectDevice = "connect Device"
    case startMeasure = "start measure"
    case SyncTime = "Sync time"
    case FetchHistory = "Fetch History"
    case changeUnit = "Change unit"
    case DeleteHistoryData = "Delete History Data"
    
    case toZero = "to Zero"
    
    case distributionNetwork = "distribution network"
    case changeBuzzerGate = "change Buzzer Gate"

    case getNetworkInfo = "get network info"
    case restoreFactory = "Restore Factory"
}


class BaseViewController: UIViewController {
    
    @IBOutlet weak var consoleView: UITextView!
    var conslogStr = ""

    @IBOutlet weak var collectionView: UICollectionView!
    
    var deviceModel : PPBluetoothAdvDeviceModel!

    lazy var scaleManager:PPBluetoothConnectManager = PPBluetoothConnectManager()
    
    @IBOutlet weak var connectStateLbl: UILabel!
    
    @IBOutlet weak var weightLbl: UILabel!
    var unit = PPDeviceUnit.unitKG
    

    var XM_IsConnect: Bool = false 

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        consoleView.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        
        consoleView.layer.borderWidth = 1
        
        consoleView.layer.cornerRadius = 12
        
        consoleView.layer.masksToBounds = true
        
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 2) {
            self.collectionView.reloadData()

        }
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




extension BaseViewController{
    
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
        self.consoleView.text = self.conslogStr
        
        let bottomOffset = CGPoint(x: 0, y: consoleView.contentSize.height - consoleView.bounds.size.height)
          if bottomOffset.y > 0 {
              consoleView.setContentOffset(bottomOffset, animated: true)
          }
    }
}
