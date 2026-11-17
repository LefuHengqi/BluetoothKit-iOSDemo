//
//  DeviceUserCell.swift
//  PPBluetoothKitDemo
//
//  Created by lefu on 2026/11/12
//  


import UIKit
import SnapKit

final class DeviceUserCell: UITableViewCell {

    static let reuseIdentifier = "DeviceUserCell"

    var onDelete: (() -> Void)?

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localization.string("delete"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.tintColor = .systemRed
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemRed.cgColor
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupSubviews()
        setupConstraints()
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        contentView.addSubview(cardView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(deleteButton)
    }

    private func setupConstraints() {
        cardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-6)
        }

        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(56)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(14)
            make.trailing.lessThanOrEqualTo(deleteButton.snp.leading).offset(-12)
            make.bottom.equalToSuperview().offset(-14)
        }

        deleteButton.setContentHuggingPriority(.required, for: .horizontal)
        deleteButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    func configure(text: String) {
        nameLabel.text = text
    }

    @objc private func deleteTapped() {
        onDelete?()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        onDelete = nil
    }
}
