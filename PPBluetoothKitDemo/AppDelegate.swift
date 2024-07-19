//
//  AppDelegate.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/6/3.
//

import UIKit
import PPBluetoothKit

// Please be sure to replace it with your AppKey and AppSecrect
let DemoAppKey = "lefub60060202a15ac8a"
let DemoAppSecrect = "UCzWzna/eazehXaz8kKAC6WVfcL25nIPYlV9fXYzqDM="

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        let userDefaults = UserDefaults.standard

        
        // 本Demo提供的appKey、appSecrect和配置文件默认体验1个月
        //请务必更换您自己的AppKey、AppSecret、配置文件路径，否则您的应用可能无法正常使用本SDK功能。需要增加设备配置请联系我司销售顾问
//        The appKey, appSecrect and configuration files provided by this demo have a default experience of 1 month.
//        Please be sure to replace your own AppKey, AppSecret, and configuration file path, otherwise your application may not be able to use this SDK function normally. If you need to add equipment configuration, please contact our sales consultant
        
        let path = Bundle.main.path(forResource: "lefu", ofType: "config") ?? ""
        PPBluetoothManager.loadDevice(withAppKey: DemoAppKey, appSecrect: DemoAppSecrect, filePath: path)

        
        if userDefaults.object(forKey: "userModel.shared") == nil{
            
            let data = try! NSKeyedArchiver.archivedData(withRootObject: userModel.shared, requiringSecureCoding: false)
            userDefaults.set(data, forKey: "userModel.shared")
            userDefaults.synchronize()
        }else{
            if let data = userDefaults.data(forKey: "userModel.shared") {
                let person = try! NSKeyedUnarchiver.unarchiveObject(with: data) as! userModel
                userModel.shared.sex = person.sex
                userModel.shared.height = person.height
                userModel.shared.age = person.age
                userModel.shared.isAthleteMode = person.isAthleteMode
                userModel.shared.isPregnantMode = person.isPregnantMode

            }
        }

        
        let demoIndexVC = DemoIndexViewController.instantiate()
        let navVc = UINavigationController(rootViewController: demoIndexVC)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navVc
        window?.makeKeyAndVisible()
        
        return true
    }

 
}



