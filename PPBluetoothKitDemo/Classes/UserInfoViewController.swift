//
//  UserInfoViewController.swift
//  PPBluetoothKitDemo
//
//  Created by  lefu on 2023/7/4.
//

import UIKit

class userModel: NSObject, NSCoding {
    static let shared = userModel()
    
    var height: Int = 175
    var age: Int = 20
    var sex: Int = 0
    var isAthleteMode: Bool = false
    var isPregnantMode: Bool = false
    
    // MARK: - NSCoding
    
    required override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.height = aDecoder.decodeInteger(forKey: "height")
        self.age = aDecoder.decodeInteger(forKey: "age")
        self.sex = aDecoder.decodeInteger(forKey: "sex")
        self.isAthleteMode = aDecoder.decodeBool(forKey: "isAthleteMode")
        self.isPregnantMode = aDecoder.decodeBool(forKey: "isPregnantMode")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.height, forKey: "height")
        aCoder.encode(self.age, forKey: "age")
        aCoder.encode(self.sex, forKey: "sex")
        aCoder.encode(self.isAthleteMode, forKey: "isAthleteMode")
        aCoder.encode(self.isPregnantMode, forKey: "isPregnantMode")
    }
}
class UserInfoViewController: UIViewController {

    @IBOutlet weak var heightTF: UITextField!
    
    @IBOutlet weak var ageTF: UITextField!
    
    @IBOutlet weak var sement1: UISegmentedControl!
    @IBOutlet weak var sement2: UISegmentedControl!

    @IBOutlet weak var sement3: UISegmentedControl!

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let text = self.heightTF.text {
            
            userModel.shared.height = text.count > 0 ? Int(text)! : userModel.shared.height

        }
        
        if let text = self.ageTF.text {
            
            userModel.shared.age = text.count > 0 ? Int(text)! : userModel.shared.age

        }
        
        
        let userDefaults = UserDefaults.standard
        let data = try! NSKeyedArchiver.archivedData(withRootObject: userModel.shared, requiringSecureCoding: false)
        userDefaults.set(data, forKey: "userModel.shared")
        userDefaults.synchronize()
        
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.heightTF.text = "\(userModel.shared.height)"
        self.ageTF.text = "\(userModel.shared.age)"

        self.sement1.selectedSegmentIndex = userModel.shared.sex
        self.sement2.selectedSegmentIndex = userModel.shared.isAthleteMode ? 1 : 0

        self.sement3.selectedSegmentIndex = userModel.shared.isPregnantMode ? 1 : 0

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func sexSegmentClick(_ sender: UISegmentedControl) {
        
        userModel.shared.sex = sender.selectedSegmentIndex
        
    }
    
    @IBAction func isAthleteModeSegmentClick(_ sender: UISegmentedControl) {
        
        userModel.shared.isAthleteMode = sender.selectedSegmentIndex == 0 ? false : true

    }
    
    @IBAction func isPregnantModeSegmentClick(_ sender: UISegmentedControl) {
        
        
        userModel.shared.isPregnantMode = sender.selectedSegmentIndex == 0 ? false : true

    }
}
