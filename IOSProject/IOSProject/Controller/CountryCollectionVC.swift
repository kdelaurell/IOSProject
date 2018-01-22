//
//  CountryCollectionVC.swift
//  IOSProject
//
//  Created by Kyle De Laurell on 1/5/18.
//  Copyright © 2018 Kyle De Laurell. All rights reserved.
//

import UIKit

class CountryCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    //--------------------------------------------------------------------------
    //--------------------Initialize Variables----------------------------------
    //--------------------------------------------------------------------------
    private var countryData : [Country] = []
    private var searchCountryData : [Country] = []
    private var countryImageData : Dictionary<String, UIImage> = [:]
    private var itemsPerRow : CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    //--------------------------------------------------------------------------
    //--------------------View Functions----------------------------------------
    //--------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCollectionViewCellsPerRow()
        //load country cell
        self.collectionView?.register(CountryCell.self)
        
        //receive Data and reload collection View
        DataService.ds.startCountryDataLoad { (data) in
            self.countryData = data
            self.searchCountryData = data
            for country in self.countryData{
                DataService.ds.startCountryPhotoLoad(countryCode: country.alpha2Code.lowercased(), completionBlock: { (countryImage)  in
                    self.countryImageData[country.alpha2Code] = countryImage
                    if(self.countryData.count == self.countryImageData.count){
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                })
            }
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setCollectionViewCellsPerRow()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    

    //--------------------------------------------------------------------------
    //--------------------Segue Function----------------------------------------
    //--------------------------------------------------------------------------
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        if(segue.identifier == "CVToDetailSegue"){
            if let destVC = segue.destination as? CountryDetailVC{
                guard let index = sender as? Int else{
                    print("ERROR receiving index of selected country")
                    return
                }
                destVC.countryData = self.searchCountryData[index]
                destVC.countryImage = self.countryImageData[self.searchCountryData[index].alpha2Code]
            }
        }
    }
    
    //--------------------------------------------------------------------------
    //--------------------Developer Functions----------------------------------------
    //--------------------------------------------------------------------------
    @objc func orientationChange(){
        self.setCollectionViewCellsPerRow()
        self.collectionView?.reloadData()
    }
    // MARK: UICollectionViewDataSource
    
    private func setCollectionViewCellsPerRow(){
        switch UIDevice.current.orientation{
        case .portrait:
            self.itemsPerRow = 3
        case .portraitUpsideDown:
            self.itemsPerRow = 3
        case .landscapeLeft:
            self.itemsPerRow = 5
        case .landscapeRight:
            self.itemsPerRow = 5
        default:
            self.itemsPerRow = 3
        }
    }
    
    
    //--------------------------------------------------------------------------
    //--------------------Collection View Functions----------------------------------------
    //--------------------------------------------------------------------------
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchCountryData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CountryCell
        // Configure the cell
        var image : UIImage?
        if self.countryImageData.count > indexPath.row{
            image = self.countryImageData[self.searchCountryData[indexPath.row].alpha2Code]
        }else{
            image = UIImage(named: "placeholder.png")!
        }
        cell.configureCell(name: self.searchCountryData[indexPath.row].name, photo: image!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CollectionViewSearchHeader", for: indexPath)
            
            return headerView
        }
        
        return UICollectionReusableView()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "CVToDetailSegue", sender: indexPath.row)
    }
    
}


extension CountryCollectionVC : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else{
            print("Search Text Error")
            return
        }
        if(!text.isEmpty){
            //reload your data source if necessary
            self.searchCountryData = self.countryData.filter({ (country) -> Bool in
                let name = country.name as NSString
                
                let range = name.range(of: text, options: .caseInsensitive)
                return range.location != NSNotFound
            })
           self.collectionView?.reloadData()
        }else{
            self.searchCountryData = self.countryData
            self.collectionView?.reloadData()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
            self.searchCountryData = self.countryData
            self.collectionView?.reloadData()
        }
    }
}
