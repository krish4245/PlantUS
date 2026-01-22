////
//  MyGardenViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 26/11/25.
//
import UIKit

class MyGardenViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var myGardenCollectionView: UICollectionView!
    
    @IBOutlet weak var emptyLabel: UILabel!
    let siteStore = SiteStore.shared

    
    override func viewDidLoad() {
           super.viewDidLoad()
       

        
        myGardenCollectionView.delegate = self
        myGardenCollectionView.dataSource = self

             
        registerCell() 
        configureGridLayout()
        
        updateEmptyState()
          
       }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         
         //  Reload data every time this screen appears
         myGardenCollectionView.reloadData()
        
        updateEmptyState()
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
//           cell.backgroundColor = site.cardColor.color
           
       
        // Live count from PlantStore
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

    private func updateEmptyState() {
        let isEmpty = siteStore.sites.isEmpty
        
        emptyLabel.isHidden = !isEmpty
        myGardenCollectionView.isHidden = isEmpty
    }

    
    

       

}
