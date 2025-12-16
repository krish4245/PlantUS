//
//  Add-Plant-Ques-1ViewController.swift
//  PlantApp
//
//  Created by SDC-USER on 26/11/25.
//

import UIKit

class Add_plant_q1_ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    let siteStore = SiteStore.shared

    @IBOutlet weak var siteOptionsCollectionView: UICollectionView!
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    var buttondata = dataStore.getQues1button()
    var selectedIndex: IndexPath?
    var selectedSite: String?
    var answers = AddPlantAnswerModel()
   

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        

//        nextButton.image = UIImage(systemName: "chevron.right")
//        nextButton.tintColor = .systemGreen   // or .black
//        nextButton.imageInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: -6)

//        navigationItem.rightBarButtonItems = [nextButton]
        
        
        // Do any additional setup after loading the view.
        siteOptionsCollectionView.dataSource = self
        siteOptionsCollectionView.delegate = self
        registerCell()
    }
    
    
    @IBAction func nextButtonTapped(_ sender: UIBarButtonItem) {
        // 1️⃣ Make sure user selected a site
        if selectedIndex == nil {
               showSelectionAlert()
               return
           }
//
//           // 2️⃣ Get selected site name
//           guard let siteName = selectedSite else { return }
//
//           // 3️⃣ Get selected icon
//           let selectedIcon = buttondata[selectedIndex!.row].image
//
//           // 4️⃣ Choose a color (temporary)
//           let siteColor = UIColor.systemGreen

//           // 5️⃣ Check if site already exists
//           if !siteStore.sites.contains(where: { $0.name.lowercased() == siteName.lowercased() }) {
//
//               // 6️⃣ Create new site
//               siteStore.addSite(
//                   name: siteName,
//                   color: siteColor,
//                   icon: selectedIcon
//               )
//
//               print("🌱 New site added:", siteName)
//
//           } else {
//               print("⚠️ Site already exists — not creating again:", siteName)
//           }
        // 7️⃣ Debug
//        print("Saved site:", siteName)
        
        answers.selectedSite = selectedSite        // <-- THIS stays same variable
        answers.selectedIcon = buttondata[selectedIndex!.row].image
        
        // 8️⃣ Go to next screen
            performSegue(withIdentifier: "toNextScreen", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNextScreen" {
            if let nextVC = segue.destination as? Add_plant_q2_ViewController {
                nextVC.answers = self.answers   // Passing the entire model
            }
        }
    }

    
    
    
    
    func registerCell(){
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
        
        // Tell UICollectionView which cell is selected
           if let selected = selectedIndex, selected == indexPath {
               collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
           } else {
               collectionView.deselectItem(at: indexPath, animated: false)
           }
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
    
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == buttondata.count-1{
            presentCustomSiteModal()
            return
        }
        
        
        // Save selected index
        selectedIndex = indexPath
        // Store selected site string
        selectedSite = buttondata[indexPath.row].site
        
        // Refresh UI
            collectionView.reloadData()
        
        // Animate the selected cell (after reload)
          if let cell = collectionView.cellForItem(at: indexPath) as? addplantbuttonCollectionViewCell {
              cell.animateSelection()
          }
        print("Selected site:", selectedSite)
    }
    
    func presentCustomSiteModal() {
        let vc = CustomSiteModalViewController(nibName: "CustomSiteModalViewController", bundle: nil)
         
         if let sheet = vc.sheetPresentationController {
             sheet.detents = [.medium()]               // half screen
             sheet.prefersGrabberVisible = true        // small grab handle at top
             sheet.preferredCornerRadius = 35
         }
        
        vc.onSiteEntered = { [weak self] customName in
                guard let self = self else { return }

                // 1️⃣ Save custom site text
                self.selectedSite = customName
                
                // 2️⃣ Mark last item (Custom Site) as selected
                self.selectedIndex = IndexPath(row: self.buttondata.count - 1, section: 0)
                
                // 3️⃣ Reload UI to reflect selection
                self.siteOptionsCollectionView.reloadData()

                print("Custom site selected:", customName)
            }

//         vc.onSiteEntered = { enteredSite in
//             self.selectedSite = enteredSite
//             print("Custom site entered:", enteredSite)
//         }
         
         present(vc, animated: true)
    }
    
    
    
    
   

}
