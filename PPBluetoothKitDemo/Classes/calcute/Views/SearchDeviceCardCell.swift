//
//  SearchDeviceCardCell.swift
//  PPBluetoothKitDemo
//
//  Created by lefu on 2026/9/17.
//


import UIKit

// MARK: - Model

/// one key-value item, e.g. "MAC: CF:88:77:66:55:44"
struct DeviceCardItem {
    var key: String
    var value: String
}

/// card cell model, a nil module means the module is hidden
struct SearchDeviceCardModel {

    struct Platform {
        var deviceName: String = ""
        var advLength: String = ""
        var sign: String = ""
    }

    struct Basic {
        var mac: String = ""
        var rssi: String = ""
        var peripheralType: String = ""
        var needAuth: String = ""
    }

    struct Network {
        var wifiProtocolType: String = ""
        var httpScheme: String = ""
        var supportADN: String = ""
    }

    struct Calcute {
        var calculateType: String = ""
        var calculateAPI: String = ""
        var product: String = ""
    }

    var platform: Platform? = Platform()
    var basic: Basic? = Basic()
    var network: Network? = Network()
    var calcute: Calcute? = Calcute()
}

// MARK: - Module view (title + gray content box)

class DeviceCardModuleView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 247.0 / 255.0, green: 247.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()

    private let rowStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()

    init(title: String) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(titleLabel)
        addSubview(contentView)
        contentView.addSubview(rowStackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            contentView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),

            rowStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            rowStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            rowStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            rowStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }

    /// each element is one row, the first item stays on the left
    /// and the rest flow right-to-left, the last item hugs the right edge
    func updateRows(_ rows: [[DeviceCardItem]]) {
        rowStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for row in rows {
            rowStackView.addArrangedSubview(makeRowView(row))
        }
    }

    private func makeRowView(_ items: [DeviceCardItem]) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        var previousItem: UIView?

        for item in items {
            let itemView = makeItemView(item)
            container.addSubview(itemView)

            itemView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
            itemView.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor).isActive = true

            if let previousItem = previousItem {
                itemView.leadingAnchor.constraint(greaterThanOrEqualTo: previousItem.trailingAnchor, constant: 8).isActive = true
            } else {
                itemView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            }

            previousItem = itemView
        }

        // the last item is pinned to the right edge
        if let lastItem = previousItem {
            lastItem.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
            lastItem.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        }

        return container
    }

    private func makeItemView(_ item: DeviceCardItem) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let keyLabel = UILabel()
        keyLabel.translatesAutoresizingMaskIntoConstraints = false
        keyLabel.text = "\(item.key):"
        keyLabel.font = UIFont.systemFont(ofSize: 14)
        keyLabel.textColor = .black
        keyLabel.setContentHuggingPriority(.required, for: .horizontal)

        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.text = item.value
        valueLabel.font = UIFont.systemFont(ofSize: 14)
        valueLabel.textColor = .black
        valueLabel.numberOfLines = 0
        valueLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        valueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        container.addSubview(keyLabel)
        container.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            keyLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            keyLabel.firstBaselineAnchor.constraint(equalTo: valueLabel.firstBaselineAnchor),

            valueLabel.topAnchor.constraint(equalTo: container.topAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: keyLabel.trailingAnchor, constant: 4),
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        return container
    }
}

// MARK: - Card cell

class SearchDeviceCardCell: UITableViewCell {

    static let reuseIdentifier = "SearchDeviceCardCell"

    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    /// modules stack, a hidden module collapses automatically
    private let moduleStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()

    private(set) lazy var platformModule = DeviceCardModuleView(title: "Add Devices To The Platform")
    private(set) lazy var basicModule = DeviceCardModuleView(title: "Basic Attributes")
    private(set) lazy var networkModule = DeviceCardModuleView(title: "Distribution Networks")
    private(set) lazy var calcuteModule = DeviceCardModuleView(title: "Computing Library")

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = UIColor(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)

        contentView.addSubview(cardView)
        cardView.addSubview(moduleStackView)

        moduleStackView.addArrangedSubview(platformModule)
        moduleStackView.addArrangedSubview(basicModule)
        moduleStackView.addArrangedSubview(networkModule)
        moduleStackView.addArrangedSubview(calcuteModule)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            moduleStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            moduleStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            moduleStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            moduleStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
        ])
    }

    func configCard(with model: SearchDeviceCardModel) {
        platformModule.isHidden = (model.platform == nil)
        if let platform = model.platform {
            platformModule.updateRows([
                [DeviceCardItem(key: "DeviceName", value: platform.deviceName)],
                [DeviceCardItem(key: "AdvLength", value: platform.advLength),
                 DeviceCardItem(key: "Sign", value: platform.sign)],
            ])
        }

        basicModule.isHidden = (model.basic == nil)
        if let basic = model.basic {
            basicModule.updateRows([
                [DeviceCardItem(key: "MAC", value: basic.mac),
                 DeviceCardItem(key: "RSSI", value: basic.rssi)],
                [DeviceCardItem(key: "PeripheralType", value: basic.peripheralType)],
                [DeviceCardItem(key: "NeedAuth", value: basic.needAuth)],
            ])
        }

        networkModule.isHidden = (model.network == nil)
        if let network = model.network {
            networkModule.updateRows([
                [DeviceCardItem(key: "WifiProtocolType", value: network.wifiProtocolType)],
                [DeviceCardItem(key: "HttpScheme", value: network.httpScheme)],
                [DeviceCardItem(key: "SupportADN", value: network.supportADN)],
            ])
        }

        calcuteModule.isHidden = (model.calcute == nil)
        if let calcute = model.calcute {
            
            var array = [
                [DeviceCardItem(key: "CalculateType", value: calcute.calculateType)],
                [DeviceCardItem(key: "CalculateAPI", value: calcute.calculateAPI)],
            ]
            
            if (Int(calcute.product) ?? -1) >= 0 {
                array.append([DeviceCardItem(key: "Product", value: "\(calcute.product)")])
            }
            
            calcuteModule.updateRows(array)
        }
    }
}
