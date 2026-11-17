import UIKit

class BodyDetailItemCell: UICollectionViewCell {

    static let reuseIdentifier = "BodyDetailItemCell"
    static let minimumHeight: CGFloat = 124

    private static let nameFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    private static let valueFont = UIFont.systemFont(ofSize: 28, weight: .bold)
    private static let standardFont = UIFont.systemFont(ofSize: 14, weight: .medium)

    private static let horizontalInset: CGFloat = 16
    private static let verticalInset: CGFloat = 16
    private static let nameValueSpacing: CGFloat = 8
    private static let valueStandardSpacing: CGFloat = 10

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = BodyDetailItemCell.nameFont
        label.textColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = BodyDetailItemCell.valueFont
        label.textColor = UIColor(red: 0.07, green: 0.07, blue: 0.08, alpha: 1)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let standardLabel: UILabel = {
        let label = UILabel()
        label.font = BodyDetailItemCell.standardFont
        label.textColor = UIColor(red: 0.96, green: 0.65, blue: 0.14, alpha: 1)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }

    private func setupUI() {
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.masksToBounds = true

        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.valueLabel)
        self.contentView.addSubview(self.standardLabel)

        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: BodyDetailItemCell.verticalInset),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: BodyDetailItemCell.horizontalInset),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -BodyDetailItemCell.horizontalInset),

            self.valueLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: BodyDetailItemCell.nameValueSpacing),
            self.valueLabel.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor),
            self.valueLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -BodyDetailItemCell.horizontalInset),

            self.standardLabel.topAnchor.constraint(equalTo: self.valueLabel.bottomAnchor, constant: BodyDetailItemCell.valueStandardSpacing),
            self.standardLabel.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor),
            self.standardLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -BodyDetailItemCell.horizontalInset),
            self.standardLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -BodyDetailItemCell.verticalInset),
        ])
    }

    static func height(forName name: String, itemWidth: CGFloat) -> CGFloat {
        let textWidth = max(itemWidth - BodyDetailItemCell.horizontalInset * 2, 1)
        let nameHeight = (name as NSString).boundingRect(
            with: CGSize(width: textWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: BodyDetailItemCell.nameFont],
            context: nil
        ).height

        let contentHeight = BodyDetailItemCell.verticalInset * 2
            + ceil(nameHeight)
            + BodyDetailItemCell.nameValueSpacing
            + ceil(BodyDetailItemCell.valueFont.lineHeight)
            + BodyDetailItemCell.valueStandardSpacing
            + ceil(BodyDetailItemCell.standardFont.lineHeight)

        return max(ceil(contentHeight), BodyDetailItemCell.minimumHeight)
    }

    func configure(name: String, value: String, standard: String) {
        self.nameLabel.text = name
        self.valueLabel.text = value
        self.standardLabel.text = standard
    }
}
