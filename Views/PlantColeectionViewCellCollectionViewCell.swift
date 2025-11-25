//
//  PlantColeectionViewCellCollectionViewCell.swift
//  PlantApp
//
//  Created by SDC-USER on 24/11/25.
//

import UIKit

class PlantCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    private var imageTask: URLSessionDataTask?

    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 16
        cardView.layer.masksToBounds = true
        plantImageView.contentMode = .scaleAspectFill
        plantImageView.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        plantImageView.image = nil
        nameLabel.text = nil
        subtitleLabel.text = nil
    }

    func configure(with plant: Plant) {
        nameLabel.text = plant.name
        subtitleLabel.text = plant.subtitle

        if let localImage = UIImage(named: plant.imageName) {
            plantImageView.image = localImage
            return
        } else {
            // Debug aid: see which names fail
            print("DEBUG: UIImage(named:) failed for asset '\(plant.imageName)'")
        }

        if let url = URL(string: plant.imageName), url.scheme != nil {
            plantImageView.image = nil
            imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let self = self,
                      let data = data,
                      let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.plantImageView.image = image
                }
            }
            imageTask?.resume()
        } else {
            plantImageView.image = nil
        }
    }
}
