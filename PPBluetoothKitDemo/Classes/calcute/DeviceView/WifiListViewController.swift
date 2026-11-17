//
//  WifiListViewController.swift
//  PPBluetoothKitDemo
//
//  Created by lefu on 2026/11/13
//  


import UIKit
import SnapKit

final class WifiListViewController: UIViewController {

    var XM_Torre: PPBluetoothPeripheralTorre?
    var XM_Borre: PPBluetoothPeripheralBorre?
    var XM_Dorre: PPBluetoothPeripheralDorre?
    var XM_Ice: PPBluetoothPeripheralIce?
    
    private var wifiList: [PPWifiInfoModel] = []

    private let tipLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.string("choose_wifilist")
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        table.register(WifiCell.self, forCellReuseIdentifier: WifiCell.reuseIdentifier)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 62
        table.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 12, right: 0)
        return table
    }()

    private let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localization.string("refresh"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = Localization.string("menu_distributionNetwork")
        setupSubviews()
        setupConstraints()
        bindActions()
        
        self.getWifiList()
    }

    private func setupSubviews() {
        view.addSubview(tipLabel)
        view.addSubview(tableView)
        view.addSubview(refreshButton)
    }

    private func setupConstraints() {
        tipLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        refreshButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(tipLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(refreshButton.snp.top).offset(-8)
        }
    }

    private func bindActions() {
        refreshButton.addTarget(self, action: #selector(refreshTapped), for: .touchUpInside)
    }

    @objc private func refreshTapped() {
        self.getWifiList()
    }
    
    func getWifiList() {
        
        
        if let XM_Torre = self.XM_Torre {
            self.view.makeToastActivity(.center)
            
            XM_Torre.dataFindSurroundDevice {[weak self] wifiList in
                guard let `self` = self else { return }
                
                self.view.hideToastActivity()
                
                self.wifiList = wifiList
                self.tableView.reloadData()
            }
        }
        
        if let XM_Borre = self.XM_Borre {
            self.view.makeToastActivity(.center)
            
            XM_Borre.dataFindSurroundDevice {[weak self] wifiList in
                guard let `self` = self else { return }
                
                self.view.hideToastActivity()
                
                self.wifiList = wifiList
                self.tableView.reloadData()
            }
        }
        
        if let XM_Dorre = self.XM_Dorre {
            self.view.makeToastActivity(.center)
            
            XM_Dorre.dataFindSurroundDevice {[weak self] wifiList in
                guard let `self` = self else { return }
                
                self.view.hideToastActivity()
                
                self.wifiList = wifiList
                self.tableView.reloadData()
            }
        }
        
        if let XM_Ice = self.XM_Ice {
            self.view.makeToastActivity(.center)
            
            XM_Ice.dataFindSurroundDevice({[weak self] wifiList, status in
                guard let `self` = self else { return }
                
                self.view.hideToastActivity()
                
                self.wifiList = wifiList
                self.tableView.reloadData()
            })
        }
        
    }

}

extension WifiListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        wifiList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WifiCell.reuseIdentifier, for: indexPath) as! WifiCell
        
        let wifi = wifiList[indexPath.row]
        cell.configure(ssid: wifi.ssid)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let wifi = wifiList[indexPath.row]
        
        let vc = ConfigViewController()
        vc.wifiInfo = wifi
        vc.XM_Torre = self.XM_Torre
        vc.XM_Borre = self.XM_Borre
        vc.XM_Dorre = self.XM_Dorre
        vc.XM_Ice = self.XM_Ice
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
