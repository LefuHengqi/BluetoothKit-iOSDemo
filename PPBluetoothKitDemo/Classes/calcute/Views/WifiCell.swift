//
//  WifiCell.swift
//  PPBluetoothKitDemo
//
//  Created by lefu on 2026/11/13
//  


import UIKit
import SnapKit

final class WifiCell: UITableViewCell {

    static let reuseIdentifier = "WifiCell"

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.06
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private let arrowView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .tertiaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        contentView.addSubview(cardView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(arrowView)
    }

    private func setupConstraints() {
        cardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-6)
            make.height.greaterThanOrEqualTo(50)
        }

        arrowView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-14)
            make.centerY.equalToSuperview()
            make.width.equalTo(8)
            make.height.equalTo(14)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(14)
            make.trailing.lessThanOrEqualTo(arrowView.snp.leading).offset(-12)
            make.bottom.equalToSuperview().offset(-14)
        }
    }

    func configure(ssid: String) {
        nameLabel.text = ssid
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
    }
}
