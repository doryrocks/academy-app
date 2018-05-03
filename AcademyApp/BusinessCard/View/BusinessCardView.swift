import UIKit
import Hero

class BusinessCardView: UIScrollView {
    // MARK: - Variables
    // MARK: public
    private var viewModel = BusinessCardVM()

    var content: BusinessCardContent? {
        didSet {
            if let content = content {
                setupContent(content)
            } else {
                setupEmptyContent()
            }
        }
    }

    // var slackButtonTapped: (()->Void)?

    // MARK: private

    private lazy var loadingView: UIActivityIndicatorView = self.makeLoadingView()
    private lazy var stackView: UIStackView = UIStackView()
    private lazy var avatarImageView: UIImageView = self.makeAvatarImageView()
    private lazy var nameLabel: UILabel = self.makeNameLabel()
    private lazy var slackButton: UIButton = self.makeSlackButton()
    private lazy var emailButton: UIButton = self.makeEmailButton()
    private lazy var phoneButton: UIButton = self.makePhoneButton()
    private lazy var positionLabel: UILabel = self.makePositionLabel()
    private lazy var separator: UIView = self.makeSeparatorView()
    private lazy var scoresViews: [ScoreView] = self.makeScoresViews()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Content
    // MARK: private

    private func setupEmptyContent() {
        subviews.forEach {
            $0.removeFromSuperview()
        }
        addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loadingView.startAnimating()
    }

    private func setupContent(_ content: BusinessCardContent) {
        loadingView.stopAnimating()
        loadingView.removeFromSuperview()

        if stackView.superview == nil {
            let contactStackView = UIStackView()
            contactStackView.alignment = .center
            contactStackView.axis = .horizontal
            contactStackView.spacing = viewModel.spacing.low

            [slackButton, emailButton, phoneButton].forEach {
                contactStackView.addArrangedSubview($0)
            }

            addSubview(stackView)
            stackView.alignment = .center
            stackView.axis = .vertical
            stackView.spacing = viewModel.spacing.mid

            [avatarImageView, nameLabel, contactStackView, positionLabel, separator].forEach {
                stackView.addArrangedSubview($0)
            }
            scoresViews.forEach {
                stackView.addArrangedSubview($0)
                stackView.setCustomSpacing(viewModel.spacing.low, after: $0)
            }
            stackView.setCustomSpacing(viewModel.spacing.high, after: nameLabel)

            setupConstratins()
        }
        updateContent(content)
    }

    private func setupConstratins() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 2 * viewModel.spacing.high).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.widthAnchor.constraint(equalToConstant: 2 * avatarImageView.layer.cornerRadius).isActive = true
        avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor).isActive = true

        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -2 * viewModel.displayPadding).isActive = true

        scoresViews.forEach { rowView in
            rowView.translatesAutoresizingMaskIntoConstraints = false
            rowView.heightAnchor.constraint(equalToConstant: viewModel.buttonHeight).isActive = true
            rowView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -2 * viewModel.displayPadding).isActive = true
        }
    }

    private func updateContent(_ content: BusinessCardContent) {
        avatarImageView.kf.setImage(with: URL(string: content.imageUrl), placeholder: nil, options: nil, progressBlock: nil) { (image, _, _, url) in
            self.setNeedsLayout()
        }
        nameLabel.text = content.name
        positionLabel.text = content.position
        zip(scoresViews, content.scores).forEach {
            $0.0.content = $0.1
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        [slackButton, emailButton, phoneButton].forEach {
            $0.centerVertically()
        }
    }

    // MARK: Views builders

    private func makeLoadingView() -> UIActivityIndicatorView {
        let rVal = UIActivityIndicatorView()
        rVal.activityIndicatorViewStyle = .gray
        return rVal
    }

    private func makeAvatarImageView() -> UIImageView {
        let rVal = UIImageView()
        rVal.contentMode = .scaleAspectFit
        rVal.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        rVal.layer.borderWidth = 1
        rVal.layer.cornerRadius = 75
        return rVal
    }

    private func makeNameLabel() -> UILabel {
        let rVal = UILabel()
        rVal.textColor = UIColor(named: "academy")
        rVal.font = .systemFont(ofSize: viewModel.fontSize.xLarge)
        return rVal
    }

    private func makeButton() -> UIButton {
        let rVal = UIButton()
        rVal.setTitleColor(.black, for: .normal)
        rVal.setTitleColor(UIColor.black.withAlphaComponent(0.6), for: .highlighted)
        rVal.titleLabel?.font = .systemFont(ofSize: viewModel.fontSize.medium)
        return rVal
    }

    private func makeSlackButton() -> UIButton {
        let rVal = makeButton()
        rVal.setTitle("Slack", for: .normal)
        rVal.kf.setImage(with: viewModel.getSlackIconUrl(), for: .normal, placeholder: nil, options: nil, progressBlock: nil) { (_, _, _, _) in
            self.setNeedsLayout()
        }
        return rVal
    }

    private func makeEmailButton() -> UIButton {
        let rVal = makeButton()
        rVal.setTitle("E-mail", for: .normal)
        rVal.kf.setImage(with: viewModel.getEmailIconUrl(), for: .normal, placeholder: nil, options: nil, progressBlock: nil) { (_, _, _, _) in
            self.setNeedsLayout()
        }
        rVal.addTarget(self, action: Selector(("emailButtonTapped")), for: .touchUpInside)
        return rVal
    }

    private func makePhoneButton() -> UIButton {
        let rVal = makeButton()
        rVal.setTitle("Telefon", for: .normal)
        rVal.kf.setImage(with: viewModel.getPhoneIconUrl(), for: .normal, placeholder: nil, options: nil, progressBlock: nil) { (_, _, _, _) in
            self.setNeedsLayout()
        }
        return rVal
    }

    private func makePositionLabel() -> UILabel {
        let rVal = UILabel()
        rVal.font = .boldSystemFont(ofSize: viewModel.fontSize.large)
        return rVal
    }

    private func makeSeparatorView() -> UIView {
        let rVal = UIView()
        rVal.backgroundColor = UIColor(named: "academy")
        return rVal
    }

    private func makeScoresViews() -> [ScoreView] {
        return content!.scores.map { _ in
            ScoreView()
        } 
    }
    
    private func emailButtonTapped() {
        if let url = URL(string: "mailto:\(String(describing: content?.email))") {
            UIApplication.shared.open(url)
        }
    }
}

private class ScoreView: UIView {
    // MARK: - Variables
    // MARK: public
    private var viewModel = BusinessCardVM()
    var content: Score? {
        didSet {
            setupContent()
        }
    }

    // MARK: private

    private lazy var leftLabel: UILabel = self.makeLeft()
    private lazy var rightLabel: UILabel = self.makeRight()

    // MARK: Content

    private func setupContent() {
        if subviews.isEmpty {
            addSubview(leftLabel)
            addSubview(rightLabel)

            leftLabel.translatesAutoresizingMaskIntoConstraints = false
            leftLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
            leftLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            leftLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

            rightLabel.translatesAutoresizingMaskIntoConstraints = false
            rightLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
            rightLabel.leadingAnchor.constraint(equalTo: leftLabel.trailingAnchor).isActive = true
            rightLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            rightLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
        updateContent()
    }

    private func updateContent() {
        leftLabel.text = "\(content!.emoji) skóre"
        rightLabel.text = String(content?.value ?? 0)
    }

    private func makeLeft() -> UILabel {
        let rVal = UILabel()
        rVal.font = .systemFont(ofSize: viewModel.fontSize.medium)
        return rVal
    }

    private func makeRight() -> UILabel {
        let rVal = UILabel()
        rVal.font = .boldSystemFont(ofSize: viewModel.fontSize.medium)
        rVal.textAlignment = .right
        return rVal
    }
}
