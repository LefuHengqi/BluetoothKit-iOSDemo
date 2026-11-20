//
//  ConfigViewController.swift
//  PPBluetoothKitDemo
//
//  Created by lefu on 2026/11/13
//  


import UIKit
import SnapKit

final class ConfigViewController: UIViewController {

    var wifiInfo:PPWifiInfoModel?
    var XM_Torre: PPBluetoothPeripheralTorre?
    var XM_Borre: PPBluetoothPeripheralBorre?
    var XM_Dorre: PPBluetoothPeripheralDorre?
    var XM_Ice: PPBluetoothPeripheralIce?
    
    private let tipLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.string("enter_wifi_pwd")
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private let ssidField: UITextField = {
        let field = UITextField()
        field.font = UIFont.systemFont(ofSize: 16)
        field.textColor = .label
        field.returnKeyType = .next
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.isEnabled = false
        return field
    }()

    private let passwordField: UITextField = {
        let field = UITextField()
        field.font = UIFont.systemFont(ofSize: 16)
        field.textColor = .label
        field.isSecureTextEntry = true
        field.returnKeyType = .next
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.placeholder = Localization.string("field_enter_pwd")
        return field
    }()

    private let domainField: UITextField = {
        let field = UITextField()
        field.font = UIFont.systemFont(ofSize: 16)
        field.textColor = .label
        field.returnKeyType = .done
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.keyboardType = .URL
        field.placeholder = Localization.string("enter_domain")
        return field
    }()

    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localization.string("start_config"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = Localization.string("menu_distributionNetwork")
        setupSubviews()
        setupConstraints()
        bindActions()
        
        self.ssidField.text = self.wifiInfo?.ssid
        self.domainField.text = "http://120.79.144.170:6032"
    }

    private func setupSubviews() {
        view.addSubview(tipLabel)
        view.addSubview(makeFieldCard(title:Localization.string("domain"), field: domainField))
        view.addSubview(makeFieldCard(title:Localization.string("ssid"), field: ssidField))
        view.addSubview(makeFieldCard(title:Localization.string("password"), field: passwordField))
        view.addSubview(startButton)
        view.addSubview(resultLabel)
        
        self.navigationController?.viewControllers.removeAll { vc in
            return vc.isKind(of: WifiListViewController.self)
        }
    }

    private func makeFieldCard(title: String, field: UITextField) -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 12
        card.layer.masksToBounds = false
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.06
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 6

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        card.addSubview(titleLabel)
        card.addSubview(field)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
        }

        field.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-14)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(14)
            make.bottom.equalToSuperview().offset(-14)
        }

        return card
    }

    private func setupConstraints() {
        let cards = view.subviews.compactMap { $0 }.filter { $0.backgroundColor == .white }

        tipLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        guard cards.count == 3 else { return }

        cards[0].snp.makeConstraints { make in
            make.top.equalTo(tipLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        cards[1].snp.makeConstraints { make in
            make.top.equalTo(cards[0].snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        cards[2].snp.makeConstraints { make in
            make.top.equalTo(cards[1].snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        startButton.snp.makeConstraints { make in
            make.top.equalTo(cards[2].snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(startButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    private func bindActions() {
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        ssidField.delegate = self
        passwordField.delegate = self
        domainField.delegate = self
    }

    func prefill(ssid: String) {
        ssidField.text = ssid
    }

    @objc private func startTapped() {
        self.resultLabel.text = ""
        view.endEditing(true)
        
        let ssid = ssidField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let password = passwordField.text ?? ""
        let domain = domainField.text?.trimmingCharacters(in: .whitespaces) ?? ""

        let wifiModel = PPWifiInfoModel()
        wifiModel.ssid = ssid
        wifiModel.password = password

        if let XM_Torre = self.XM_Torre {
            self.view.makeToastActivity(.center)
            XM_Torre.dataConfigNetWork(wifiModel, domain: domain) {[weak self] status, errorData in
                guard let `self` = self else { return }
                
                self.view.hideToastActivity()
                
                self.resultLabel.text = status == .registSuccess ? Localization.string("network_success") : "\(Localization.string("fail"))-status:\(status)"
            }
        }
        
        if let XM_Borre = self.XM_Borre {
            self.view.makeToastActivity(.center)
            XM_Borre.dataConfigNetWork(wifiModel, domain: domain) {[weak self] status, errorData in
                guard let `self` = self else { return }
                
                self.view.hideToastActivity()
                
                self.resultLabel.text = status == .registSuccess ? Localization.string("network_success") : "\(Localization.string("fail"))-status:\(status)"
            }
        }
        
        if let XM_Dorre = self.XM_Dorre {
            self.view.makeToastActivity(.center)
            XM_Dorre.dataConfigNetWork(wifiModel, domain: domain) {[weak self] status, errorData in
                guard let `self` = self else { return }
                
                self.view.hideToastActivity()
                
                self.resultLabel.text = status == .registSuccess ? Localization.string("network_success") : "\(Localization.string("fail"))-status:\(status)"
            }
        }
        
        if let XM_Ice = self.XM_Ice {
            self.view.makeToastActivity(.center)
            
            XM_Ice.changeDNS(domain) {[weak self] success in
                guard let `self` = self else { return }
                
                if !success {
                    print("domain fail")
                    
                    self.view.hideToastActivity()
                    self.resultLabel.text = "\(Localization.string("fail"))"
                    return
                }
                
                XM_Ice.configNetWork(wifiModel, withHandler: {[weak self] isSuccess, sn, state in
                    guard let `self` = self else { return }
                    
                    self.view.hideToastActivity()
                    
                    self.resultLabel.text = isSuccess == true ? "\(Localization.string("network_success"))-sn:\(sn)" : "\(Localization.string("fail"))-status:\(state)"
                })
            }
            
            
        }
    }

}

extension ConfigViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == ssidField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            domainField.becomeFirstResponder()
        } else {
            domainField.resignFirstResponder()
        }
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
