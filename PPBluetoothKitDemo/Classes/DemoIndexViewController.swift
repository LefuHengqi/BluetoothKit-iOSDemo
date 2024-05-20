//
//  DemoIndexViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/6/3.
//

import UIKit

public class DemoIndexViewController: UIViewController {
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
      
            
        
    }
 
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
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

