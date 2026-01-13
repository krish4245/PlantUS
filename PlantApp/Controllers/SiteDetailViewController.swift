//
//  SiteDetailViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 12/12/25.
//

import UIKit
import Foundation

class SiteDetailViewController: UIViewController,   UICollectionViewDelegate,
                                UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var site: MyGardenSite! // passed from myGarden
    let plantStore =  PlantStore.shared
   
    private var plants: [UserPlant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        
        collectionView.collectionViewLayout = layout
        
        
        
        title = site.name
        collectionView.delegate = self
        collectionView.dataSource = self
        
        registerCell()
        loadPlants()

    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          loadPlants()
      }
    
    func registerCell() {
        collectionView.register(siteDetailCollectionViewCell.nib(), forCellWithReuseIdentifier: siteDetailCollectionViewCell.identifier )
    }

    private func loadPlants() {
        plants = PlantStore.shared.plants(for: site.id)
        print("📍 SiteDetailVC loadPlants() -> total=\(plants.count)")
          for p in plants {
              print("   • \(p.plantId) qty=\(p.quantity)")
          }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                           numberOfItemsInSection section: Int) -> Int {
           return plants.count
       }
    
    func collectionView(_ collectionView: UICollectionView,
                         cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
         let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: siteDetailCollectionViewCell.identifier,
             for: indexPath
         ) as! siteDetailCollectionViewCell
         
         let userPlant = plants[indexPath.item]
        
        cell.configure(with: userPlant)
              return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        
        let selectedPlant = plants[indexPath.item]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let sheetVC = storyboard.instantiateViewController(withIdentifier: "PlantActionSheetVC") as! PlantActionSheetViewController

          sheetVC.userPlant = selectedPlant
        sheetVC.onUpdate = { [weak self] in
               self?.loadPlants()
           }
            
        if let sheet = sheetVC.sheetPresentationController {
               sheet.detents = [.medium()]
               sheet.prefersGrabberVisible = true
           }

           present(sheetVC, animated: true)
    }
    
    
 
    
    // MARK: Cell Layout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemsPerRow: CGFloat = 2
        let spacing: CGFloat = 8

        let totalSpacing = spacing * (itemsPerRow + 1)
        let availableWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
        let itemWidth = (availableWidth - totalSpacing) / itemsPerRow

        return CGSize(width: floor(itemWidth), height: 220)
    }

    
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          16
      }

      func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
          16
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


