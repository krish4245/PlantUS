//
//  Add-Plant-Ques-1ViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 26/11/25.
//

import UIKit

class Add_Plant_Ques_1ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var siteOptionsCollectionView: UICollectionView!
    
    var buttondata = dataStore.getQues1button()
    @objc func nextAction() {
        print("Next tapped")
        // navigate to next screen here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let nextButton = UIBarButtonItem(
            title: "Next",
            style: .plain,
            target: self,
            action: #selector(nextAction)
        )

//        nextButton.image = UIImage(systemName: "chevron.right")
//        nextButton.tintColor = .systemGreen   // or .black
//        nextButton.imageInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: -6)

        navigationItem.rightBarButtonItems = [nextButton]
        
        
        // Do any additional setup after loading the view.
        siteOptionsCollectionView.dataSource = self
        siteOptionsCollectionView.delegate = self
        registerCells()
    }
    
    func registerCells(){
        siteOptionsCollectionView.register(UINib(nibName: "addplantbuttonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "addSite_cell")
        
    }
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttondata.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addSite_cell", for: indexPath) as! addplantbuttonCollectionViewCell
        let item = buttondata[indexPath.row]
        cell.plantSiteLabel.text = item.site
        cell.plantSiteButton.setImage(UIImage(systemName: item.image), for: .normal)
        cell.plantSiteButton.tintColor = .black
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath : IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 40 // left + right + inter-item spacing
           let itemWidth = (collectionView.frame.width - totalSpacing) / 3

           return CGSize(width: itemWidth, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    
    
    
   

}
