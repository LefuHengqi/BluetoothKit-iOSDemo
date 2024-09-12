//
//  DFUViewController.swift
//  bluetooth-kit-iosdemo
//
//  Created by  lefu on 2024/9/9.
//

import UIKit
import PPBluetoothKit
import SSZipArchive

struct DFUPackageModel: Codable {
    let deviceSource: String
    let packageVersion: String
    let packages: Packages
}

struct Packages: Codable {
    let mcu: PackageInfo?
    let ble: PackageInfo?
    let res: PackageInfo?
}

struct PackageInfo: Codable {
    let filename: String
    let version: String
}




class DFUViewController: UIViewController {
    
    var XM_Obj: Any?
    
    @IBOutlet weak var consoleView: UITextView!

    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectPath = ""
    
    var fileArray = [String]()
    
    var XM_DFUZipFilePath: String?
    
    var XM_DFUUnzipFilePath : String?
    
    var XM_DFUConfig : DFUPackageModel?
    
    var conslogStr = ""

    var mcuUpdate = true

    var bleUpdate = true
    
    var resUpdate = true

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first

        
        self.listFiles(inDirectory: path!)

        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        consoleView.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
              
              
        consoleView.layer.borderWidth = 1
              
             
        consoleView.layer.cornerRadius = 12
              
              
        consoleView.layer.masksToBounds = true
        
        
        self.tableView.tableFooterView = UIView()
        

        // Do any additional setup after loading the view.
    }
    
    func listFiles(inDirectory directory: String) {
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(atPath: directory)

        while let element = enumerator?.nextObject() as? String {
            print(element)
            
            if element.hasSuffix(".zip"){
                fileArray.append(element)
            }
                
                
        }
    }

    
    @IBAction func mcuSwitch(_ sender: UISwitch) {
        
        self.mcuUpdate = sender.isOn
    }
    
    @IBAction func bleSwitch(_ sender: UISwitch) {
        self.bleUpdate = sender.isOn

    }
    
    @IBAction func resSwitch(_ sender: UISwitch) {
        
        self.resUpdate = sender.isOn

    }
    @IBAction func startBtnClick(_ sender: Any) {
        
        if self.selectPath.count <= 0{
            
            self.addConsoleLog(ss: "请选择文件")

            return
        }
        
        if let torre = XM_Obj as? PPBluetoothPeripheralTorre{
            
            
            if let docPath = self.loadDFUZipFile(path: selectPath){
                
                
                do {
                    try traverseDirectory(docPath)
                } catch {
                    print("Error: \(error)")
                }
                
                
                if let config = self.XM_DFUConfig, let unzipPath = self.XM_DFUUnzipFilePath{
                   
                    let mcuPath = "\(unzipPath)/\(config.packages.mcu?.filename ?? "")"
                    let blePath = "\(unzipPath)/\(config.packages.ble?.filename ?? "")"
                    let resPath = "\(unzipPath)/\(config.packages.res?.filename ?? "")"
                    
                    
                    var versions = [String]()
                    
//                    if let mcu = config.packages.mcu{
//                        versions.append("999")
//
//                        
//                    }else{
//                        versions.append("000")
//
//                    }
//                    
//                    if let ble = config.packages.ble{
//                        versions.append("999")
//
//                        
//                    }else{
//                        versions.append("000")
//
//                    }
//                    
//                    if let res = config.packages.res{
//                        versions.append("999")
//
//                        
//                    }else{
//                        versions.append("000")
//
//                    }

                    if self.mcuUpdate{
                        versions.append("999")
                    }else{
                        versions.append("000")

                    }
                    
                    if self.bleUpdate{
                        versions.append("999")
                    }else{
                        versions.append("000")

                    }
                    
                    if self.resUpdate{
                        versions.append("999")
                    }else{
                        versions.append("000")

                    }
                    
                    
                    
                    if versions.count >= 3{
                        
                        let package = PPTorreDFUPackageModel()
                        package.mcuPath = mcuPath
                        package.mcuVersion = versions[0]
                        package.blePath = blePath
                        package.bleVersion = versions[1]
                        package.resPath = resPath
                        package.resVersion = versions[2]
                        

                        
                        torre.dataDFUStart { [weak self]  size in
                            
                            guard let `self` = self else {return}
                            let XM_Size = size
                            
                            torre.dataDFUCheck({ status, fileType, version, offset in
                                
                                let XM_Status = 1
            //                    let XM_FileType = fileType
            //                    let XM_Version = version
            //                    let XM_Offset = offset
                                
                                torre.dataDFUSend(package, maxPacketSize: XM_Size, transferContinueStatus: XM_Status, deviceVersion: "001.001.001",handler: { (progress, isSuccess) in
                                    
                                    
                                    if (isSuccess && progress == 1){
                                        
                                        self.addConsoleLog(ss: "ota完成")

                                    }
                                    
                                    if (progress > 0 && progress <= 1){
                                        
                                        self.addConsoleLog(ss: String.init(format: "\(versions)progress:%0.2f", progress))
                                        
                                        self.progressView.progress = Float(progress)
                                    
                                    }
                                    
                                    if (progress == -1 && !isSuccess){
                                        
                                        self.addConsoleLog(ss: "ota失败")

                             
                                        
                                    }
                                    
                                })
                                
                            })
                        }
                        
                    }
                    
                   
                }
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

extension DFUViewController{
    
    func addConsoleLog(ss:String){

    
        self.consoleView.text = ss

   }
    
    func scrollBottom(){
        self.consoleView.text = self.conslogStr
        
        let bottomOffset = CGPoint(x: 0, y: consoleView.contentSize.height - consoleView.bounds.size.height)
          if bottomOffset.y > 0 {
              consoleView.setContentOffset(bottomOffset, animated: true)
          }
    }
    
    func loadDFUZipFile(path: String) -> String?{
        
        // 使用示例
        
        let path1 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first

        
        let zipPath = path1! + "/" + path
        let destinationPath = path1! + "/" + path.replacingOccurrences(of: ".zip", with: "")

        let success = unzipFile(atPath: zipPath, toDestination: destinationPath)
        
        
//        self.XM_DFUUnzipFilePath = destinationPath + "/" + path.replacingOccurrences(of: ".zip", with: "")

        if success {
            print("解压成功！")
            return destinationPath
        } else {
            print("解压失败！")
            return nil
        }
    }
    
    func unzipFile(atPath filePath: String, toDestination destinationPath: String) -> Bool {
        
        let success = SSZipArchive.unzipFile(atPath: filePath, toDestination: destinationPath)
              
        return success
    }
    
    func traverseDirectory(_ path: String) throws {
        let fileManager = FileManager.default
        
        let files = try fileManager.contentsOfDirectory(atPath: path)
        for file in files {
            let fullPath = "\(path)/\(file)"
            var isDirectory: ObjCBool = false
            if fileManager.fileExists(atPath: fullPath, isDirectory: &isDirectory) {
                if isDirectory.boolValue {
                    // 如果是目录，则递归遍历
                    try traverseDirectory(fullPath)
                    
                    self.XM_DFUUnzipFilePath = fullPath
                } else {
                    // 如果是文件，则输出文件名
                    if file == "package.json"{
                        let fileURL = URL(fileURLWithPath: fullPath)

                        // 读取 JSON 文件数据
                        let jsonData = try! Data(contentsOf: fileURL)

                        let decoder = JSONDecoder()
                        let config = try! decoder.decode(DFUPackageModel.self, from: jsonData)
                        self.XM_DFUConfig = config
                        
                    }
                    
                }
            }
        }
    }
    
    
    
    
}

extension DFUViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PathTavleCell")
        
        let label = cell?.contentView.viewWithTag(100) as! UILabel
        
        label.text = self.fileArray[indexPath.row]
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectPath = self.fileArray[indexPath.row]
    }
}


extension DFUViewController:DemoStoryboardInstantiable{
    static var storyboardName: String {
        return "BluetoothKitDemo"
    }
    
    static var storyboardIdentifier: String {
        return "DFUViewController"
    }
    
    
    
}
