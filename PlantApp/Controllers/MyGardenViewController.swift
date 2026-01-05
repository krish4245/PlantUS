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
        title = "My Garden"
        
//        PlantStore.shared.generateDummyPlants(for: siteStore.sites)
        
        myGardenCollectionView.delegate = self
        myGardenCollectionView.dataSource = self
             
        registerCell() // func to register the xib cell
          
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
           
       
        cell.plantCountLabel.text = "\(site.plantCount)"

           
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let padding: CGFloat = 16 * 3 // left + right + middle
        let availableWidth = collectionView.frame.width - padding
        let width = availableWidth / 2

        return CGSize(width: width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
       

}
