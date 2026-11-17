//
//  DeviceHistoryDataViewController.swift
//  PPBluetoothKitDemo
//
//
//

import UIKit
import SnapKit
import PPBluetoothKit
import PPCalculateKit

enum DeviceHistoryDataType {

    case left
    case right
}


class DeviceHistoryDataViewController: UIViewController {

    var deviceModel:PPBluetoothAdvDeviceModel?
    var userInfo:PPTorreSettingModel?
    var onFetchLeftHistory: (() -> Void)?
    var onFetchRightHistory: (() -> Void)?

    
    private(set) var currentType: DeviceHistoryDataType = .left

    var currentItems: [PPBluetoothScaleBaseModel] = []

    private lazy var leftButton: UIButton = {
        let title = (self.deviceModel?.peripheralType == .peripheralIce || self.deviceModel?.peripheralType == .peripheralApple || self.deviceModel?.peripheralType == .peripheralCoconut) ? Localization.string("Retrieve_historical") : Localization.string("history_fetch_user")
        return self.makeButton(title: title, action: #selector(leftButtonTapped))
    }()

    private lazy var rightButton: UIButton = {
        let title = (self.deviceModel?.peripheralType == .peripheralIce || self.deviceModel?.peripheralType == .peripheralApple || self.deviceModel?.peripheralType == .peripheralCoconut) ? Localization.string("delete_historical_device") : Localization.string("history_fetch_guest")
        return self.makeButton(title: title, action: #selector(rightButtonTapped))
    }()

    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let listContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.25).cgColor
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorColor = UIColor.black.withAlphaComponent(0.2)
        tableView.separatorInset = .zero
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DeviceHistoryDataCell.self,
                           forCellReuseIdentifier: DeviceHistoryDataCell.reuseIdentifier)
        return tableView
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.string("history_note")
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(white: 0.6, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    // MARK: - 生命周期

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Localization.string("history_title")
        view.backgroundColor = .white

        setupSubviews()
        setupConstraints()

        reloadList()
    }

    func setHistory(_ items: [PPBluetoothScaleBaseModel], type: DeviceHistoryDataType) {

        currentItems = items

        reloadList()
    }

    private func setupSubviews() {

        buttonStackView.addArrangedSubview(leftButton)
        buttonStackView.addArrangedSubview(rightButton)

        tableView.backgroundView = emptyLabel

        view.addSubview(buttonStackView)
        view.addSubview(listContainerView)
        listContainerView.addSubview(tableView)
    }

    private func setupConstraints() {

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }

        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func makeButton(title: String, action: Selector) -> UIButton {

        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.withAlphaComponent(0.6).cgColor
        button.layer.cornerRadius = 8
        button.titleLabel?.numberOfLines = 2
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    @objc private func leftButtonTapped() {
        self.leftButton.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.leftButton.isUserInteractionEnabled = true
        }
        
        switchTo(.left)
        onFetchLeftHistory?()
    }

    @objc private func rightButtonTapped() {
        self.rightButton.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.rightButton.isUserInteractionEnabled = true
        }
        
        
        switchTo(.right)
        onFetchRightHistory?()
    }

    private func switchTo(_ type: DeviceHistoryDataType) {

        currentType = type
        updateButtonSelection()
        reloadList()
    }

    private func updateButtonSelection() {

        updateButton(leftButton, isSelected: currentType == .left)
        updateButton(rightButton, isSelected: currentType == .right)
    }

    private func updateButton(_ button: UIButton, isSelected: Bool) {

        button.backgroundColor = isSelected ? .black.withAlphaComponent(0.3) : .white
        button.layer.borderColor = isSelected
            ? UIColor.black.cgColor
            : UIColor.black.withAlphaComponent(0.6).cgColor
    }

    private func reloadList() {

        emptyLabel.isHidden = !currentItems.isEmpty

        tableView.reloadData()
    }
    
    func calculateResult(user:PPTorreSettingModel, scaleModel:PPBluetoothScaleBaseModel, advModel:PPBluetoothAdvDeviceModel) {
        
        let calculateWeightKg = Float(scaleModel.weight) / 100
        
        let inputModel = PPCalculateInputModel()
        inputModel.secret = CommonTool.getSecret(calcuteType: advModel.deviceCalcuteType)
        inputModel.isAthleteMode = user.isAthleteMode
        inputModel.isPregnantMode = user.isPregnantMode
        inputModel.height = user.height
        inputModel.age = user.age
        inputModel.gender = user.gender
        inputModel.bodyAgeMethod = PPBodyAgeMethod(rawValue: UInt(advModel.getBodyAgeTypeCode())) ?? .default
        
        var fatModel:PPBodyFatModel? = nil
        if (PPCalculateTools.is8Electrodes(with: advModel.deviceCalcuteType)) {
            // Calculate body data (Eight electrodes)
            
            
            inputModel.deviceCalcuteType = advModel.deviceCalcuteType
            inputModel.weight = CGFloat(calculateWeightKg)
            inputModel.z20KhzLeftArmEnCode = scaleModel.z20KhzLeftArmEnCode
            inputModel.z20KhzRightArmEnCode = scaleModel.z20KhzRightArmEnCode
            inputModel.z20KhzLeftLegEnCode = scaleModel.z20KhzLeftLegEnCode
            inputModel.z20KhzRightLegEnCode = scaleModel.z20KhzRightLegEnCode
            inputModel.z20KhzTrunkEnCode = scaleModel.z20KhzTrunkEnCode
            inputModel.z100KhzLeftArmEnCode = scaleModel.z100KhzLeftArmEnCode
            inputModel.z100KhzRightArmEnCode = scaleModel.z100KhzRightArmEnCode
            inputModel.z100KhzLeftLegEnCode = scaleModel.z100KhzLeftLegEnCode
            inputModel.z100KhzRightLegEnCode = scaleModel.z100KhzRightLegEnCode
            inputModel.z100KhzTrunkEnCode = scaleModel.z100KhzTrunkEnCode
            inputModel.deviceMac = advModel.deviceMac
            inputModel.heartRate = scaleModel.heartRate
            inputModel.footLen = scaleModel.footLen

            
            fatModel = PPBodyFatModel(inputModel: inputModel)
        } else {
            // Calculate body data (Four electrodes)


            inputModel.deviceCalcuteType = advModel.deviceCalcuteType
            inputModel.weight = CGFloat(calculateWeightKg)
            inputModel.impedance = scaleModel.impedance
            inputModel.impedance100EnCode = scaleModel.impedance100EnCode
            inputModel.deviceMac = advModel.deviceMac
            inputModel.heartRate = scaleModel.heartRate
            inputModel.footLen = scaleModel.footLen

            
            fatModel = PPBodyFatModel(inputModel: inputModel)
        }
        
        guard let fatModel = fatModel else {
            print("fatModel is nil")
            return
        }

        // Obtain information such as the judgment range and evaluation of each physical indicator.If the standardArray of the PPBodyDetailModel object is empty, then this metric has no judgment range.
        // 获取每个身体指标的判定范围和评价等信息，如果PPBodyDetailModel对象的standardArray为空，则该指标没有判定范围
        let detailModel = PPBodyDetailModel(bodyFatModel: fatModel)

        
        // Go to details page. 跳转详情页
        let bodyDetailVC = BodyDetailViewController()
        bodyDetailVC.errorType = fatModel.errorType
        bodyDetailVC.detailModel = detailModel
        self.navigationController?.pushViewController(bodyDetailVC, animated: true)
    }
}

// MARK: - UITableViewDataSource / UITableViewDelegate

extension DeviceHistoryDataViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return currentItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: DeviceHistoryDataCell.reuseIdentifier,
                                                 for: indexPath) as! DeviceHistoryDataCell

        let model = currentItems[indexPath.row]
        let noMemberId = self.currentType == .right || self.deviceModel?.peripheralType == .peripheralIce || self.deviceModel?.peripheralType == .peripheralApple || self.deviceModel?.peripheralType == .peripheralCoconut
        
        cell.configure(with: model, hideMemberId: noMemberId)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = currentItems[indexPath.row]
        
        guard let deviceModel = self.deviceModel else {
            return
        }
        
        if let user = self.userInfo, model.memberId == user.memberID {
            
            // Historical data for a specific member, matched by memberID
            // 某一个成员的历史数据，匹配 memberID

            self.calculateResult(user: user, scaleModel: model, advModel: deviceModel)
            
        } else if let memberID = model.memberId, !memberID.isEmpty {
            
            // Historical data for a specific member
            // This demo uses fixed personal information to calculate body metrics; in a real-world application, the information of the specific individual to whom the historical data belongs should be used instead.
            
            // 某一个成员历史数据
            // Demo使用固定个人信息进行计算身体数据，实际业务使用该组历史数据所属成员的信息
            
            let user = PPTorreSettingModel()
            user.isAthleteMode = false
            user.isPregnantMode = false
            user.height = 168
            user.age = 22
            user.gender = PPDeviceGenderType.female
            
            self.calculateResult(user: user, scaleModel: model, advModel: deviceModel)
            
        } else {
            
            // Visitor Data
            // This demo uses fixed personal information to calculate body metrics; in a real-world application, the information of the specific individual to whom the historical data belongs should be used instead.
            
            // 游客数据
            // Demo使用固定个人信息进行计算身体数据，实际业务使用该组历史数据所属成员的信息
            
            let user = PPTorreSettingModel()
            user.isAthleteMode = false
            user.isPregnantMode = false
            user.height = 168
            user.age = 22
            user.gender = PPDeviceGenderType.female
            
            self.calculateResult(user: user, scaleModel: model, advModel: deviceModel)
            
        }
        
    }
}

