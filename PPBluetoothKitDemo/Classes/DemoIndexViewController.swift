//
//  DemoIndexViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/6/3.
//

import UIKit
import PPBluetoothKit

public class DemoIndexViewController: UIViewController {
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
 
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.Request()
    }

    
    func Request() {
        
//        以下为拉取设备配置信息，仅供Demo使用
//        The following is to pull device configuration information, for Demo use only
        
        let filePath = GetPath()
        
        let content = try? String(contentsOfFile: filePath, encoding: .utf8)
        
        if let content = content, content.count > 0 {
            
            PPBluetoothManager.loadDevice(withAppKey: DemoAppKey, appSecrect: DemoAppSecrect, filePath: filePath)
            
        }

        guard let url = URL(string: "http://nat.lefuenergy.com:10081/unique-admin/openApi/openAppKeySetting/download?appKey=lefub60060202a15ac8a") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    
                    if let code = dict["code"] as? Int, code == 200, let content = dict["msg"] as? String, content.count > 0 {
                        
                        try content.write(toFile: filePath, atomically: true, encoding: .utf8)
    
                    }

                } else {
                    print("json-fail")
                }
                
            } catch {
                
                print("catch error")
            }
        }

        task.resume()
    }
    
    
    func GetPath()->String {
        
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return ""
        }
        
        let name = "/device.txt"
        let localPath = cachePath + "/file"

        if (FileManager.default.fileExists(atPath: localPath)) {
            
            return localPath + name
        }
        
        do {
            try FileManager.default.createDirectory(atPath: localPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return cachePath + name
        }
        
        return localPath + name
    }

}

extension DemoIndexViewController:DemoStoryboardInstantiable{
    public static var storyboardName: String {
        return "BluetoothKitDemo"
    }
    
    public static var storyboardIdentifier: String {
        return "DemoIndexViewController"
    }
    
    
    
}

