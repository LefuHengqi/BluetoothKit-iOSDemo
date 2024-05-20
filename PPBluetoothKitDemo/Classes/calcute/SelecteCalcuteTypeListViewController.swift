//
//  SelecteCalcuteTypeListViewController.swift
//  PPBluetoothKitDemo
//
//  Created by lefu on 2024/2/29
//  


import Foundation
import PPBluetoothKit

class SelecteCalcuteTypeListViewController:UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataArray = [(String, PPDeviceCalcuteType)]()
    var selectedHandler:((Int,String)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
    }
 
}

extension SelecteCalcuteTypeListViewController:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dataArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelecteCalcuteCell", for: indexPath) as! SelecteCalcuteCell
        cell.infoLabel.text = model.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let model = self.dataArray[indexPath.row]
        
        self.selectedHandler?(indexPath.row, model.0)
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SelecteCalcuteTypeListViewController:DemoStoryboardInstantiable {
    
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }
    
    static var storyboardIdentifier: String {
        return "SelecteCalcuteTypeListViewController"
    }
    
}
