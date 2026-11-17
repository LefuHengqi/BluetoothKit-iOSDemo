//
//  CalcuteSelectDeviceViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/7/28.
//

import UIKit

class CalcuteSelectDeviceViewController: UIViewController {

    @IBOutlet weak var dc4Btn: UIButton!
    @IBOutlet weak var ac4Btn: UIButton!
    @IBOutlet weak var ac8Btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dc4Btn.setTitle(Localization.string("dc_4_algorithm"), for: .normal)
        self.ac4Btn.setTitle(Localization.string("ac_4_algorithm"), for: .normal)
        self.ac8Btn.setTitle(Localization.string("ac_8_algorithm"), for: .normal)
    }
    
    @IBAction func DC4Click(_ sender: Any) {
        
        
        
        
        let vc = CalcuteInfoViewController.instantiate()
        
        vc.selectType = .calcuteType4DC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func AC4Cllick(_ sender: Any) {
        let vc = CalcuteInfoViewController.instantiate()
        
        vc.selectType = .calcuteType4AC
        
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func AC8Cllick(_ sender: Any) {
        let vc = CalcuteInfoViewController.instantiate()
        
        vc.selectType = .calcuteType8AC
        
        self.navigationController?.pushViewController(vc, animated: true)

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

extension CalcuteSelectDeviceViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }
    
    static var storyboardIdentifier: String {
        return "CalcuteSelectDeviceViewController"
    }
    
    
    
}
