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
    
    case queryDeviceTime = "Query Device Time"
    case deleteWIFI = "Delete WIFI"
    case queryWifiConfig = "Query Wifi Config"
    
    case queryDNS = "Query DNS"
    case TestOTA = "Start Test OTA"
    case UserOTA = "Start User OTA"
    
    case syncUserInfo = "Sync user info"
    case syncFood = "Sync Food"
    case selectUser = "Select User"
    case deleteUser = "Delete User"
    case fetchFoodIDList = "Fetch FoodID List"
    case deleteFood = "Delete Food"
}


class BaseViewController: UIViewController {
    
    @IBOutlet weak var consoleView: UITextView!
    var conslogStr = ""

    @IBOutlet weak var collectionView: UICollectionView!
    
    var deviceModel : PPBluetoothAdvDeviceModel!

    lazy var scaleManager:PPBluetoothConnectManager = PPBluetoothConnectManager()
    
    @IBOutlet weak var connectStateLbl: UILabel!
    
    @IBOutlet weak var weightLbl: UILabel!
    var unit = PPDeviceUnit.unitG
    

    var XM_IsConnect: Bool = false 

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        consoleView.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        
        consoleView.layer.borderWidth = 1
        
        consoleView.layer.cornerRadius = 12
        
        consoleView.layer.masksToBounds = true
        
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 2) {
            if self.collectionView != nil {
                self.collectionView.reloadData()
            }

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
         DispatchQueue.main.async {
             self.conslogStr.append("\ndelegate:\(ss)\n")

             self.scrollBottom()
         }
    }
    
    func addBleCmd(ss:String){
        DispatchQueue.main.async {
            self.conslogStr.append("\nfunction:\(ss)\n")
            
            self.scrollBottom()
        }

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
