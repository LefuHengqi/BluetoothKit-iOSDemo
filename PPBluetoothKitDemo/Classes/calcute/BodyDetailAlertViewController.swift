import UIKit

class BodyDetailAlertViewController: UIViewController {

    private let alertTitle: String
    private let items: [(title: String, value: String)]

    private let dimmingView = UIView()
    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let separatorView = UIView()
    private let closeButton = UIButton(type: .system)
    private var cardWidthConstraint: NSLayoutConstraint?

    init(title: String, items: [(title: String, value: String)]) {
        self.alertTitle = title
        self.items = items
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()

        self.dimmingView.alpha = 0
        self.cardView.alpha = 0
        self.cardView.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.2) {
            self.dimmingView.alpha = 1
            self.cardView.alpha = 1
            self.cardView.transform = .identity
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.cardWidthConstraint?.constant = min(self.view.bounds.width - 48, 420)
    }

    private func setupUI() {
        self.view.backgroundColor = .clear

        self.dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        self.dimmingView.translatesAutoresizingMaskIntoConstraints = false
        self.dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert)))
        self.view.addSubview(self.dimmingView)

        self.cardView.backgroundColor = .white
        self.cardView.layer.cornerRadius = 16
        self.cardView.layer.masksToBounds = true
        self.cardView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.cardView)

        self.titleLabel.text = self.alertTitle
        self.titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        self.titleLabel.textColor = UIColor(red: 0.07, green: 0.07, blue: 0.08, alpha: 1)
        self.titleLabel.textAlignment = .left
        self.titleLabel.numberOfLines = 0
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.cardView.addSubview(self.titleLabel)

        self.contentStackView.axis = .vertical
        self.contentStackView.alignment = .fill
        self.contentStackView.spacing = 14
        self.contentStackView.translatesAutoresizingMaskIntoConstraints = false

        for item in self.items {
            self.contentStackView.addArrangedSubview(self.makeRow(title: item.title, value: item.value))
        }

        self.scrollView.alwaysBounceVertical = false
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.contentStackView)
        self.cardView.addSubview(self.scrollView)

        self.separatorView.backgroundColor = UIColor(white: 0.92, alpha: 1)
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        self.cardView.addSubview(self.separatorView)

        self.closeButton.setTitle("Close", for: .normal)
        self.closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        self.closeButton.setTitleColor(UIColor(red: 0, green: 0.48, blue: 1, alpha: 1), for: .normal)
        self.closeButton.addTarget(self, action: #selector(self.dismissAlert), for: .touchUpInside)
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.cardView.addSubview(self.closeButton)

        let cardWidth = self.cardView.widthAnchor.constraint(equalToConstant: 320)
        self.cardWidthConstraint = cardWidth

        let scrollViewHeight = self.scrollView.heightAnchor.constraint(equalTo: self.contentStackView.heightAnchor)
        scrollViewHeight.priority = .defaultHigh

        NSLayoutConstraint.activate([
            self.dimmingView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.dimmingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.dimmingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.dimmingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

            self.cardView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.cardView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.cardView.heightAnchor.constraint(lessThanOrEqualTo: self.view.heightAnchor, multiplier: 0.85),
            cardWidth,

            self.titleLabel.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 20),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 20),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -20),

            self.scrollView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
            self.scrollView.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 20),
            self.scrollView.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -20),
            self.scrollView.bottomAnchor.constraint(equalTo: self.separatorView.topAnchor, constant: -16),

            self.contentStackView.topAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.topAnchor),
            self.contentStackView.leadingAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.leadingAnchor),
            self.contentStackView.trailingAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.trailingAnchor),
            self.contentStackView.bottomAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.bottomAnchor),
            self.contentStackView.widthAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.widthAnchor),
            scrollViewHeight,

            self.separatorView.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.separatorView.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            self.separatorView.heightAnchor.constraint(equalToConstant: 1),

            self.closeButton.topAnchor.constraint(equalTo: self.separatorView.bottomAnchor),
            self.closeButton.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.closeButton.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            self.closeButton.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor),
            self.closeButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func makeRow(title: String, value: String) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        titleLabel.textColor = UIColor(red: 0.55, green: 0.55, blue: 0.57, alpha: 1)
        titleLabel.textAlignment = .left
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 15)
        valueLabel.textColor = UIColor(red: 0.07, green: 0.07, blue: 0.08, alpha: 1)
        valueLabel.textAlignment = .left
        valueLabel.numberOfLines = 0
        valueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let row = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        row.axis = .vertical
        row.alignment = .fill
        row.spacing = 4
        return row
    }

    @objc private func dismissAlert() {
        self.dismiss(animated: true)
    }
}
