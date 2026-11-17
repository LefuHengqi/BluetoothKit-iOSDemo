//
//  DeviceMemberViewController.swift
//  PPBluetoothKitDemo
//
//  Created by lefu on 2026/11/12
//  


import UIKit
import SnapKit
import PPBluetoothKit
import Toast_Swift

final class DeviceMemberViewController: UIViewController {

    var XM_Borre:PPBluetoothPeripheralBorre?
    
    private var userInfoList: [PPTorreSettingModel] = []
    private var testUsers:[PPTorreSettingModel] = []
    
    private let tipLabel: UILabel = {
        let label = UILabel()
        label.text = ""
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
        table.register(DeviceUserCell.self, forCellReuseIdentifier: DeviceUserCell.reuseIdentifier)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 80
        table.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        return table
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.string("member_empty_note")
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .red
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private let syncButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localization.string("Sync_user"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localization.string("Clear_users"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    private let bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Localization.string("Member_Management")
        
        view.backgroundColor = .systemGroupedBackground
        setupSubviews()
        setupConstraints()
        bindActions()

        if self.XM_Borre != nil {
            let maxCount = self.XM_Borre?.deviceAdv.getMaxMemberCount() ?? 0
            self.tipLabel.text = Localization.string("borre_max_member", maxCount > 0 ? maxCount : 10 )
        }
        
        self.createUsers()
        self.fetchUserList()
    }

    private func setupSubviews() {
        view.addSubview(tipLabel)
        view.addSubview(tableView)
        view.addSubview(bottomStack)
        bottomStack.addArrangedSubview(syncButton)
        bottomStack.addArrangedSubview(clearButton)
        
        tableView.backgroundView = emptyLabel
    }

    private func setupConstraints() {

        tipLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.rightMargin.equalToSuperview().offset(-16)
        }
        bottomStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
            make.height.equalTo(50)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(tipLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomStack.snp.top).offset(-8)
        }
    }

    private func bindActions() {
        syncButton.addTarget(self, action: #selector(syncNewUserTapped), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearAllUsersTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func syncNewUserTapped() {

        // The demo uses simulated users, while the actual production environment incorporates specific user information.
        // Demo使用模拟用户，实际业务同步具体的用户信息
        
        let newUsers = testUsers.filter { user in
            !self.userInfoList.contains { $0.memberID == user.memberID }
        }
        
        guard let newUser = newUsers.first else { return }
        
        // Synchronize users
        // 同步用户
        if let XM_Borre = self.XM_Borre {
            self.view.makeToastActivity(.center)
            
            XM_Borre.dataSyncUserInfo(newUser) {[weak self] status, errorType in
                guard let `self` = self else { return }
                
                if status == 0 {
                    self.userInfoList.append(newUser)
                    self.tableView.reloadData()
                    self.view.makeToast(Localization.string("success"))
                } else if errorType == .storageFull {
                    self.view.makeToast(Localization.string("user_limit_reached"))
                } else {
                    self.view.makeToast(Localization.string("failed_check"))
                }
                
                self.view.hideToastActivity()
            }
        }
        
        
    }

    @objc private func clearAllUsersTapped() {
        
        // Clear all user information
        // 清除所有用户信息
        if let XM_Borre = self.XM_Borre {
            XM_Borre.codeClearDeviceData(1) {[weak self] status in
                guard let `self` = self else { return }
                
                if status == 0 {
                    self.view.makeToast(Localization.string("success"))
                    
                    self.fetchUserList()
                } else {
                    self.view.makeToast(Localization.string("fail"))
                }
            }
        }
        
    }

    func createUsers() {
        
        let u1 = PPTorreSettingModel()
        u1.memberID = "1234567890"
        u1.userID = "abcdefghijklmn"
        u1.userName = "Tom"
        u1.isAthleteMode = false
        u1.isPregnantMode = false
        u1.height = 180
        u1.age = 28
        u1.gender = PPDeviceGenderType.female
        u1.targetWeight = 60
        u1.idealWeight = 50
        u1.birthYear = 1998
        u1.birthMonth = 1
        u1.birthDay = 20
        u1.pIndex = 1 // Index

        let u2 = PPTorreSettingModel()
        u2.memberID = "m0000501"
        u2.userID = "20000002"
        u2.userName = "Mong"
        u2.isAthleteMode = false
        u2.isPregnantMode = false
        u2.height = 175
        u2.age = 12
        u2.gender = PPDeviceGenderType.female
        u2.targetWeight = 60
        u2.idealWeight = 50
        u2.birthYear = 1998
        u2.birthMonth = 1
        u2.birthDay = 20
        u2.pIndex = 2 // Index
        
        let u3 = PPTorreSettingModel()
        u3.memberID = "l0000503"
        u3.userID = "30000003"
        u3.userName = "Long"
        u3.isAthleteMode = false
        u3.isPregnantMode = false
        u3.height = 175
        u3.age = 12
        u3.gender = PPDeviceGenderType.female
        u3.targetWeight = 60
        u3.idealWeight = 50
        u3.birthYear = 1998
        u3.birthMonth = 1
        u3.birthDay = 20
        u3.pIndex = 3 // Index
        
        let u4 = PPTorreSettingModel()
        u4.memberID = "n0000504"
        u4.userID = "40000004"
        u4.userName = "Nike"
        u4.isAthleteMode = false
        u4.isPregnantMode = false
        u4.height = 175
        u4.age = 12
        u4.gender = PPDeviceGenderType.female
        u4.targetWeight = 60
        u4.idealWeight = 50
        u4.birthYear = 1998
        u4.birthMonth = 1
        u4.birthDay = 20
        u4.pIndex = 4 // Index
        
        let u5 = PPTorreSettingModel()
        u5.memberID = "s0000505"
        u5.userID = "50000005"
        u5.userName = "Ste"
        u5.isAthleteMode = false
        u5.isPregnantMode = false
        u5.height = 180
        u5.age = 28
        u5.gender = PPDeviceGenderType.female
        u5.targetWeight = 60
        u5.idealWeight = 50
        u5.birthYear = 1998
        u5.birthMonth = 1
        u5.birthDay = 20
        u5.pIndex = 5 // Index
        
        let u6 = PPTorreSettingModel()
        u6.memberID = "j0000501"
        u6.userID = "10000001"
        u6.userName = "Jack"
        u6.isAthleteMode = false
        u6.isPregnantMode = false
        u6.height = 175
        u6.age = 12
        u6.gender = PPDeviceGenderType.female
        u6.targetWeight = 60
        u6.idealWeight = 50
        u6.birthYear = 1998
        u6.birthMonth = 1
        u6.birthDay = 20
        u6.pIndex = 6 // Index

        self.testUsers = [u1, u2, u3, u4, u5, u6]
    }
    
    func fetchUserList() {
        
        self.view.makeToastActivity(.center)

        if let XM_Borre = self.XM_Borre {
            // Retrieve the list of members on the device. Note: Some devices do not support this method; for these, device member management (adding, deleting, or modifying) must be performed via the cloud.
            // 获取设备中成员列表，注意：部分设备不支持该方法，需要在云端管理设备成员(增/删/改)
            
            XM_Borre.dataFetchUserInfoList({[weak self] list in
                guard let `self` = self else { return }
                
                print("dataFetchUserInfoList-count:\(list.count)")
                
                self.userInfoList = list
                self.tableView.reloadData()
                
                self.view.hideToastActivity()
                
                
            })
        }
        
    }
}

extension DeviceMemberViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.emptyLabel.isHidden = !self.userInfoList.isEmpty
        
        return userInfoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeviceUserCell.reuseIdentifier, for: indexPath) as! DeviceUserCell
        
        let user = userInfoList[indexPath.row]
        var text = "User ID:\(user.userID)\nMember ID:\(user.memberID)"
        
        if let user = self.testUsers.first(where: { uu in
            return uu.userID == user.userID && uu.memberID == user.memberID
        }) {
            text = "\(text)\nName:\(user.userName)"
        }
        
        
        cell.configure(text: text)

        cell.onDelete = { [weak self] in
            guard let `self` = self else { return }
            
            // Delete specified member
            // 删除指定成员
            
            let userModel = PPTorreSettingModel()
            userModel.userAccount(user.userID, memberId: user.memberID)
            if let XM_Borre = self.XM_Borre {
                XM_Borre.dataDeleteUser(userModel) {[weak self] status in
                    guard let `self` = self else { return }
                    
                    if status == 0 {
                        self.view.makeToast(Localization.string("Deleted_successfully"))
                        
                        self.userInfoList.removeAll { uu in
                            return uu.memberID == userModel.memberID
                        }
                        self.tableView.reloadData()
                    } else {
                        self.view.makeToast(Localization.string("Deletion_failed"))
                    }
                    
                }
            }
            
        }
        return cell
    }
}
