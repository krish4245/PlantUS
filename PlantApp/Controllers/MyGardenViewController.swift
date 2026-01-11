////
//  MyGardenViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 26/11/25.
//
import UIKit

class MyGardenViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var myGardenCollectionView: UICollectionView!
    let siteStore = SiteStore.shared

    
    override func viewDidLoad() {
           super.viewDidLoad()
       
        
//        PlantStore.shared.generateDummyPlants(for: siteStore.sites)
        
        myGardenCollectionView.delegate = self
        myGardenCollectionView.dataSource = self

             
        registerCell() // func to register the xib cell
        configureGridLayout()
          
       }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         
         // ⭐ Reload data every time this screen appears
         myGardenCollectionView.reloadData()
     }
   
    func registerCell(){
        myGardenCollectionView.register(UINib(nibName: "MyGardenCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyGardenCell")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return siteStore.sites.count
       }
    
    func collectionView(_ collectionView: UICollectionView,
                           cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

           let cell = collectionView.dequeueReusableCell(
               withReuseIdentifier: "MyGardenCell",
               for: indexPath
           ) as! MyGardenCollectionViewCell
           
           let site = siteStore.sites[indexPath.item]
           
           // Configure UI
            cell.iconButton.setImage(UIImage(systemName: site.icon), for: .normal)

           cell.siteNameLabel.text = site.name
           cell.backgroundColor = site.cardColor.color
           
       
        // ✅ Live count from PlantStore
          let plantsInSite = PlantStore.shared.plants(for: site.id)
          let totalCount = plantsInSite.reduce(0) { $0 + $1.quantity }
          cell.plantCountLabel.text = "\(totalCount)"


           
           return cell
       }
    
    // MARK: Select site → Push detail page
      
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          print("Tapped:", siteStore.sites[indexPath.item].name)
          print("NAV CONTROLLER:", navigationController)

          let selectedSite = siteStore.sites[indexPath.item]
          
          let storyboard = UIStoryboard(name: "Main", bundle: nil)

          let vc = storyboard.instantiateViewController(
                 withIdentifier: "SiteDetailViewController"
             ) as! SiteDetailViewController


              vc.site = selectedSite
              
              navigationController?.pushViewController(vc, animated: true)
      }
    
    
    
    private func configureGridLayout() {
        let layout = UICollectionViewFlowLayout()

        let spacing: CGFloat = 16
        let columns: CGFloat = 2

        // padding from left & right
        let horizontalPadding: CGFloat = 16

        let totalSpacing = (columns - 1) * spacing + (horizontalPadding * 2)
        let itemWidth = floor((myGardenCollectionView.bounds.width - totalSpacing) / columns)

        layout.itemSize = CGSize(width: itemWidth, height: 100)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: 0, right: horizontalPadding)

        myGardenCollectionView.collectionViewLayout = layout
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureGridLayout()
    }

    
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let itemsPerRow: CGFloat = 2
//           let interItemSpacing: CGFloat = 16  // spacing between 2 cards
//        let _: CGFloat = 16 * 2 // because contentInset adds padding
//
//           let totalSpacing = interItemSpacing * (itemsPerRow - 1) // only middle spacing
//
//        let width = floor((collectionView.bounds.width - totalSpacing) / itemsPerRow)
//           return CGSize(width: floor(width), height: 120)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 16
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 16
//    }
       

}
