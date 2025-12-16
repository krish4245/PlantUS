//
//  SiteDetailViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 12/12/25.
//

import UIKit

class SiteDetailViewController: UIViewController,   UICollectionViewDelegate,
                                UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var site: MyGardenSite!
    let plantStore =  PlantStore.shared
    var sitePlants: [Plant_2] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = site.name
        collectionView.delegate = self
              collectionView.dataSource = self
        
        registerCell()
              loadData()

      
    }
    
    func registerCell() {
        collectionView.register(
            UINib(nibName: "siteDetailCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "PlantCell"
        )
    }

    func loadData() {
            sitePlants = plantStore.plants(for: site.id)
            collectionView.reloadData()
        }
    
    func collectionView(_ collectionView: UICollectionView,
                           numberOfItemsInSection section: Int) -> Int {
           return sitePlants.count
       }
    
    func collectionView(_ collectionView: UICollectionView,
                         cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
         let cell = collectionView.dequeueReusableCell(
             withReuseIdentifier: "PlantCell",
             for: indexPath
         ) as! siteDetailCollectionViewCell
         
         let plant = sitePlants[indexPath.item]

         // 🔥 Set UI
         if let data = plant.imageData {
             cell.plantImageView.image = UIImage(data: data)
         }

         cell.plantNameLabel.text = plant.name
//         cell.healthLabel.text = "Healthy"              // placeholder
//         cell.lastWateredLabel.text = "yesterday"        // placeholder

         cell.layer.cornerRadius = 20
         cell.layer.masksToBounds = true
         
         return cell
     }
    
    // MARK: Cell Layout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = (collectionView.frame.width - 40) / 2
        return CGSize(width: width, height: 220)
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


