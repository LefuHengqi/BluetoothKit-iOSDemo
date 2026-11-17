//
//  DeviceHistoryDataCell.swift
//  PPBluetoothKitDemo
//
//  设备历史数据列表 Cell，高度随文案自动适应
//

import UIKit
import SnapKit

class DeviceHistoryDataCell: UITableViewCell {

    static let reuseIdentifier = "DeviceHistoryDataCell"

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_GB")
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return f
    }()


    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()

    private let weightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()

    private let extraLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private let headerStackView = UIStackView()
    private let contentStackView = UIStackView()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .default
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        accessoryType = .disclosureIndicator

        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupSubviews() {

        headerStackView.axis = .vertical
        headerStackView.spacing = 4
        headerStackView.alignment = .leading
        headerStackView.addArrangedSubview(dateLabel)
        headerStackView.addArrangedSubview(weightLabel)

        contentStackView.axis = .vertical
        contentStackView.spacing = 8
        contentStackView.alignment = .fill
        contentStackView.addArrangedSubview(headerStackView)
        contentStackView.addArrangedSubview(extraLabel)

        contentView.addSubview(contentStackView)
    }

    private func setupConstraints() {

        contentStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-12)
        }
    }


    func configure(with item: PPBluetoothScaleBaseModel, hideMemberId:Bool) {
        let timeStr = Self.timeFormatter.string(from: Date(timeIntervalSince1970: item.dateTimeInterval))
        let weightKg = CGFloat(item.weight) / 100.0

        dateLabel.text = Localization.string("history_time", timeStr)
        weightLabel.text = Localization.string("history_weight", String(format: "%.2f", weightKg), "kg")
        extraLabel.text = "Member ID:\(item.memberId ?? "")"
        extraLabel.isHidden = hideMemberId
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        weightLabel.text = nil
        extraLabel.text = nil
    }
}
