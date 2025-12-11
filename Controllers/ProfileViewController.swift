import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - UI
    private let closeButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "xmark"), for: .normal)
        b.tintColor = .label
        b.backgroundColor = UIColor.systemGray6
        b.layer.cornerRadius = 22
        b.translatesAutoresizingMaskIntoConstraints = false
        b.accessibilityIdentifier = "profile_close_button"
        return b
    }()

    private let avatarView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 44
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .systemBlue
        iv.accessibilityIdentifier = "profile_avatar"
        return iv
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 20, weight: .semibold)
        l.textColor = .label
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let emailLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let items: [String] = [
        "Complete your profile",
        "Pause Notifications",
        "Theme",
        "Help & About",
        "Privacy & Permissions",
    ]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        configureAppearance()
        layout()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // make header area visually like your Figma: white rounded card effect
        if let sheet = sheetPresentationController {
            sheet.preferredCornerRadius = 22
        }
    }

    // MARK: - Setup
    private func configureAppearance() {
        // keep top of profile view white so avatar and header stand out
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }

    private func layout() {
        view.addSubview(closeButton)
        view.addSubview(avatarView)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(tableView)

        // example text
        nameLabel.text = "Krishna Upadhyay"
        emailLabel.text = "krishna.27.5.2005@gmail.com"

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),

            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36),
            avatarView.widthAnchor.constraint(equalToConstant: 88),
            avatarView.heightAnchor.constraint(equalToConstant: 88),

            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 12),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 18),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Actions
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}

// MARK: - Table
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count + 1 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        if indexPath.row < items.count {
            cell.textLabel?.text = items[indexPath.row]
            cell.imageView?.image = symbolForRow(indexPath.row)
            cell.textLabel?.textAlignment = .natural
        } else {
            // Sign Out row center
            cell.textLabel?.text = "Sign Out"
            cell.textLabel?.textAlignment = .center
            cell.accessoryType = .none
            cell.imageView?.image = nil
            cell.textLabel?.textColor = .systemRed
        }
        return cell
    }

    private func symbolForRow(_ index: Int) -> UIImage? {
        switch index {
        case 0: return UIImage(systemName: "percent.circle")
        case 1: return UIImage(systemName: "bell.slash")
        case 2: return UIImage(systemName: "paintbrush")
        case 3: return UIImage(systemName: "questionmark.circle")
        case 4: return UIImage(systemName: "shield.lefthalf.fill")
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // handle actions here
        if indexPath.row == items.count {
            // sign out
            print("Sign out tapped")
        }
    }
}
