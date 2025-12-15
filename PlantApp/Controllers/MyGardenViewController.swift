////
//  MyGardenViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 26/11/25.
//
import UIKit

class MyGardenViewController: UIViewController {

   
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    private let spaces: [GardenSpace] = [
           GardenSpace(name: "Bedroom",     imageName: "bedroom"),
           GardenSpace(name: "Living room", imageName: "living_room"),
           GardenSpace(name: "Balcony",     imageName: "balcony"),
           GardenSpace(name: "Window sill", imageName: "window_sill"),
           GardenSpace(name: "Kitchen",     imageName: "kitchen"),
           GardenSpace(name: "Office",      imageName: "office")
       ]
    
    let spaceIcons = [
            "bed.double.fill",      // Bedroom
            "sofa.fill",            // Living room
            "sun.max.fill",         // Balcony
            "square.grid.2x2",      // Window sill (or pick another)
            "fork.knife",           // Kitchen
            "laptopcomputer"        // Office
        ]

        // your pastel colors array from before
        let cardColors: [UIColor] = [
            UIColor(red: 0.65, green: 0.74, blue: 0.99, alpha: 1.0), // etc…
            // …
        ]

       override func viewDidLoad() {
           super.viewDidLoad()

           view.backgroundColor = .systemBackground

           collectionView.dataSource = self
           collectionView.delegate = self

           // If you registered via storyboard, this line is NOT needed.
           // Only needed if you have a xib:
           // collectionView.register(UINib(nibName: "GardenSpaceCellCollectionViewCell", bundle: nil),
           //                         forCellWithReuseIdentifier: "GardenSpaceCellCollectionViewCell")

           if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
               layout.scrollDirection = .vertical
               layout.minimumInteritemSpacing = 16
               layout.minimumLineSpacing = 20
               layout.sectionInset = UIEdgeInsets(top: 8, left: 24, bottom: 24, right: 24)
           }
       }
   }

   // MARK: - DataSource

extension MyGardenViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return spaces.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let reuseId = "GardenSpaceCell"
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseId,
            for: indexPath
        ) as? GardenSpaceCellCollectionViewCell else {
            return UICollectionViewCell()
        }

        let space = spaces[indexPath.item]
        let image = UIImage(named: space.imageName)
        cell.configure(name: space.name, image: image)

        return cell
    }
}


   // MARK: - Layout (2-column grid)

   extension MyGardenViewController: UICollectionViewDelegateFlowLayout {

       func collectionView(_ collectionView: UICollectionView,
                           layout collectionViewLayout: UICollectionViewLayout,
                           sizeForItemAt indexPath: IndexPath) -> CGSize {

           let horizontalInset: CGFloat = 24 * 2      // left + right
           let columnSpacing: CGFloat = 16            // space between  the two cards
           let availableWidth = collectionView.bounds.width - horizontalInset - columnSpacing

           let width = availableWidth / 2.0
           let height: CGFloat = 130

           // Keep cards taller than wide (like Figma)
           return CGSize(width: width, height: height)
       }

       func collectionView(_ collectionView: UICollectionView,
                           didSelectItemAt indexPath: IndexPath) {
           
           // Navigation to GardenSiteViewController temporarily removed.
           // You can add it back later when the destination controller is ready.
       }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
