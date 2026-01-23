import UIKit

final class CalendarDateBoxView: UIView {

    init(isCompleted: Bool) {
        super.init(frame: .zero)

        layer.cornerRadius = 8
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = isCompleted
            ? UIColor.systemBlue.withAlphaComponent(0.15)
            : UIColor.systemGray6

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 36),
            widthAnchor.constraint(equalToConstant: 36)
        ])

        if isCompleted {
            addTick()
        }
    }

    private func addTick() {
        let imageView = UIImageView(
            image: UIImage(systemName: "checkmark")
        )
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit

        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 14),
            imageView.widthAnchor.constraint(equalToConstant: 14)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
