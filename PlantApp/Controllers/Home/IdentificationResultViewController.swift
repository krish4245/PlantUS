// IdentificationResultViewController.swift
import UIKit

final class IdentificationResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let options: [(label: String, confidence: Float)]
    private let capturedImage: UIImage
    var onViewDetail: ((String?) -> Void)?

    private let tableView = UITableView(frame: .zero, style: .plain)

    init(options: [(String, Float)], image: UIImage) {
        self.options = options
        self.capturedImage = image
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let iv = UIImageView(image: capturedImage)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Recognition"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()

        let closeBtn = UIButton(type: .system)
        closeBtn.setTitle("Close", for: .normal)
        closeBtn.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeBtn.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(iv)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(closeBtn)

        NSLayoutConstraint.activate([
            iv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            iv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            iv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            iv.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),

            titleLabel.topAnchor.constraint(equalTo: iv.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: iv.leadingAnchor),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: iv.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: iv.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: closeBtn.topAnchor, constant: -12),

            closeBtn.leadingAnchor.constraint(equalTo: iv.leadingAnchor),
            closeBtn.trailingAnchor.constraint(equalTo: iv.trailingAnchor),
            closeBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            closeBtn.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc private func closeTapped() { dismiss(animated: true) }

    // MARK: Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { options.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (label, confidence) = options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let pct = Int(confidence * 100)
        cell.textLabel?.text = "\(indexPath.row+1). \(label) — \(pct)%"
        cell.textLabel?.numberOfLines = 2
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosen = options[indexPath.row].label
        onViewDetail?(chosen)
        dismiss(animated: true)
    }
}
