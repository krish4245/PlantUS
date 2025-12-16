import UIKit
import Foundation

extension Notification.Name {
    static let plantAdded = Notification.Name("plantAdded")
}

class PlantDetailViewController: UIViewController {

    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var benefitLabel: UILabel!
//    @IBOutlet weak var confidenceLabel: UILabel!
//    @IBOutlet weak var closeButton: UIButton!

    private var model: PlantModel?
//    private var confidence: Double?//    @IBAction func addPlantTapped(_ sender: Any) {
//        // Optional: include plant name in userInfo if you want to show it in the toast
//        let plantName = model?.name ?? "Plant"
//        NotificationCenter.default.post(name: .plantAdded, object: nil, userInfo: ["name": plantName])
//
//        // Close the screen: pop if pushed, otherwise dismiss
//        if let nav = navigationController, nav.viewControllers.firstIndex(of: self) != nil, nav.viewControllers.count > 1 {
//            // pop back to previous (SearchViewController)
//            navigationController?.popViewController(animated: true)
//        } else if presentingViewController != nil {
//            dismiss(animated: true, completion: nil)
//        } else {
//            // fallback
//            navigationController?.popViewController(animated: true)
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // image view setup
        plantImageView.contentMode = .scaleAspectFill
        plantImageView.layer.cornerRadius = 12
        plantImageView.clipsToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(onPlantAdded(_:)), name: .plantAdded, object: nil)

        // wire close in a safe way (don't add duplicate targets)
//        closeButton.removeTarget(nil, action: nil, for: .allEvents)
//        closeButton.addTarget(self, action: #selector(onClose), for: .touchUpInside)

        // run entrance animation setup (safe-guard if labels are nil)
        setupEntranceInitialState()

        // Apply model right away (handles case where configure(...) was called before view loaded)
        applyModel()
    }

    @objc private func onPlantAdded(_ note: Notification) {
        let name = (note.userInfo?["name"] as? String) ?? "Plant"
        showToast(message: "\(name) added")
    }

    private func showToast(message: String, duration: TimeInterval = 1.5) {
        let label = UILabel()
        label.text = message
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center

        let container = UIView()
        container.backgroundColor = UIColor.systemGreen
        container.layer.cornerRadius = 12
        container.clipsToBounds = true
        container.alpha = 0

        container.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
        ])

        // Add to window so it appears above the tab bar/navigation
//        guard let window = view.window ?? UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
//        window.addSubview(container)
//        container.translatesAutoresizingMaskIntoConstraints = false
//
//        let bottomInset = window.safeAreaInsets.bottom + 60
//        NSLayoutConstraint.activate([
//            container.centerXAnchor.constraint(equalTo: window.centerXAnchor),
//            container.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -bottomInset),
//            container.widthAnchor.constraint(lessThanOrEqualToConstant: 340)
//        ])

        // Animate in
        UIView.animate(withDuration: 0.22) {
            container.alpha = 1
            container.transform = CGAffineTransform(translationX: 0, y: -6)
        }

        // Remove after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            UIView.animate(withDuration: 0.22, animations: {
                container.alpha = 0
                container.transform = CGAffineTransform(translationX: 0, y: 6)
            }, completion: { _ in
                container.removeFromSuperview()
            })
        }
    }

    /// Public configuration used by other VCs
    func configure(with model: PlantModel) {
        self.model = model
//        self.confidence = confidence

        // If view is loaded then populate immediately
        if isViewLoaded {
            applyModel()
        }
    }

    // MARK: - UI population
    private func applyModel() {
        guard isViewLoaded else { return }
        guard let m = model else {
            // clear UI if no model
            plantNameLabel.text = nil
            descriptionLabel.text = nil
            benefitLabel.text = nil
//            confidenceLabel.isHidden = true
            plantImageView.image = UIImage(systemName: "leaf.circle.fill")
            return
        }

        plantNameLabel.text = m.name
        descriptionLabel.text = m.description ?? "No description available."
        benefitLabel.text = m.benefit ?? "No specific benefit available."

        // Try remote URL first, then local asset fallback
        if let urlStr = m.imageURL, let url = URL(string: urlStr), url.scheme != nil {
            loadImage(url: url)
        } else if let imgName = m.imageURL, let img = UIImage(named: imgName) {
            plantImageView.image = img
        } else {
           print("Use default image")
        }

        // small content animation after populating
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            self.plantNameLabel.alpha = 1
            self.plantNameLabel.transform = .identity
            self.descriptionLabel.alpha = 1
            self.descriptionLabel.transform = .identity
        })
    }

    // MARK: - Image loading (background)
    private func loadImage(url: URL) {
        // lightweight fetch on background queue
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: url), let img = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.plantImageView.image = img
                }
            } else {
                // failed to load remote image — keep fallback
                DispatchQueue.main.async {
                    if self.plantImageView.image == nil {
                        self.plantImageView.image = UIImage(systemName: "leaf.circle.fill")
                        self.plantImageView.tintColor = .systemGreen
                    }
                }
            }
        }
    }

    // MARK: - Close handling (pop if pushed, dismiss if presented)
    @objc private func onClose() {
        if let nav = navigationController, nav.viewControllers.firstIndex(of: self) != nil, nav.viewControllers.count > 1 {
            // If this VC is inside a navigation stack and not the root, pop it
            navigationController?.popViewController(animated: true)
        } else if presentingViewController != nil {
            // Presented modally, dismiss
            dismiss(animated: true, completion: nil)
        } else {
            // Fallback: try to pop anyway
            navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - Entrance animation helpers
    private func setupEntranceInitialState() {
        // Safe guards in case outlets are nil
        if let name = plantNameLabel {
            name.transform = CGAffineTransform(translationX: 0, y: 12).scaledBy(x: 0.98, y: 0.98)
            name.alpha = 0
        }
        if let desc = descriptionLabel {
            desc.transform = CGAffineTransform(translationX: 0, y: 12)
            desc.alpha = 0
        }
    }
}

