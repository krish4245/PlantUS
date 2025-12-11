// IdentificationResultViewController.swift
import UIKit

final class IdentificationResultViewController: UIViewController {
    private let nameText: String?
    private let confidence: Float
    private let capturedImage: UIImage
    var onViewDetail: ((String?) -> Void)?

    init(name: String?, confidence: Float, image: UIImage) {
        self.nameText = name
        self.confidence = confidence
        self.capturedImage = image
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let iv = UIImageView(image: capturedImage)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = nameText ?? "Not recognized"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let confLabel = UILabel()
        confLabel.text = nameText == nil ? "" : String(format: "Confidence: %.0f%%", confidence * 100)
        confLabel.font = UIFont.systemFont(ofSize: 14)
        confLabel.textColor = .secondaryLabel
        confLabel.translatesAutoresizingMaskIntoConstraints = false

        let viewBtn = UIButton(type: .system)
        viewBtn.setTitle("View", for: .normal)
        viewBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        viewBtn.translatesAutoresizingMaskIntoConstraints = false

        let doneBtn = UIButton(type: .system)
        doneBtn.setTitle("Close", for: .normal)
        doneBtn.translatesAutoresizingMaskIntoConstraints = false

        viewBtn.addTarget(self, action: #selector(viewTapped), for: .touchUpInside)
        doneBtn.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        view.addSubview(iv); view.addSubview(titleLabel); view.addSubview(confLabel); view.addSubview(viewBtn); view.addSubview(doneBtn)

        NSLayoutConstraint.activate([
            iv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            iv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            iv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            iv.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),

            titleLabel.topAnchor.constraint(equalTo: iv.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: iv.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: iv.trailingAnchor),

            confLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            confLabel.leadingAnchor.constraint(equalTo: iv.leadingAnchor),
            confLabel.trailingAnchor.constraint(equalTo: iv.trailingAnchor),

            viewBtn.topAnchor.constraint(equalTo: confLabel.bottomAnchor, constant: 20),
            viewBtn.leadingAnchor.constraint(equalTo: iv.leadingAnchor),
            viewBtn.heightAnchor.constraint(equalToConstant: 48),

            doneBtn.centerYAnchor.constraint(equalTo: viewBtn.centerYAnchor),
            doneBtn.trailingAnchor.constraint(equalTo: iv.trailingAnchor),
            doneBtn.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc private func viewTapped() {
        onViewDetail?(nameText)
        dismiss(animated: true)
    }
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}
