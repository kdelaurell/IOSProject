//
//  CountryDetailVC.swift
//  IOSProject
//
//  Created by Kyle De Laurell on 1/6/18.
//  Copyright © 2018 Kyle De Laurell. All rights reserved.
//

import UIKit
import MapKit


class CountryDetailVC: UIViewController, MKMapViewDelegate {

    //--------------------------------------------------------------------------
    //--------------------Initialize Variables----------------------------------
    //--------------------------------------------------------------------------
    var countryImage : UIImage?
    var countryData : Country?
    
    //--------------------------------------------------------------------------
    //--------------------View Functions----------------------------------------
    //--------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting Title to country
        
        self.navigationItem.title = self.countryData?.name
        
        //set up each section of the details view
        self.view.backgroundColor = UIColor.lightGray
        let scrollView = UIScrollView(frame: self.view.frame)
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        scrollView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        self.setupFlagDisplay(scrollView)
        self.setupCountryName(scrollView)
        self.setupCountryData(scrollView)
        self.setupMapDisplay(scrollView)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
            if let view = self.view.subviews.first{
                view.frame = self.view.frame
            }else{
                print("Error reloading scroll view on rotation")
            }
        }) { (context) in
            
        }
    }
    
    //--------------------------------------------------------------------------
    //--------------------Developer Functions-----------------------------------
    //--------------------------------------------------------------------------
    
    private func setupFlagDisplay(_ scrollView : UIScrollView){
        //create views and add shadow
        guard let image = self.countryImage else {
            print("Country Flag Image Missing")
            return
        }
        let countryFlagImage = UIImageView(image: image)
        countryFlagImage.contentMode = .scaleAspectFit
        countryFlagImage.layer.shadowOpacity = 0.8
        countryFlagImage.layer.shadowRadius = 5.0
        countryFlagImage.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        scrollView.addSubview(countryFlagImage)

        //add constraints to view
        let margins = self.view.safeAreaLayoutGuide
        countryFlagImage.translatesAutoresizingMaskIntoConstraints = false
        countryFlagImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        countryFlagImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        countryFlagImage.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        countryFlagImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5).isActive = true
        
        
    }
    
    private func setupCountryName(_ scrollView : UIScrollView){
        //create Box for name View
        let nameView = UIView()
        nameView.layer.shadowOpacity = 0.8
        nameView.layer.shadowRadius = 5.0
        nameView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        nameView.backgroundColor = UIColor.white
        
        
        //add Label
        let cName = UILabel()
        cName.textColor = UIColor.black
        cName.textAlignment = .center
        cName.font = cName.font.withSize(30)
        guard let countryName = self.countryData?.name else{
            print("Country Name Missing")
            return
        }
        cName.text = countryName
        cName.sizeToFit()
        nameView.addSubview(cName)
        
        //add all the alternate spelling names
        
        guard let altSpellings = self.countryData?.altSpellings else{
            print("Alternate Country Name Spellings Missing")
            return
        }
        for altSpelling in altSpellings{
            let altSpellingLabel = UILabel()
            altSpellingLabel.textColor = UIColor.darkGray
            altSpellingLabel.textAlignment = .center
            altSpellingLabel.font = altSpellingLabel.font.withSize(10)
            altSpellingLabel.text = altSpelling
            nameView.addSubview(altSpellingLabel)
            altSpellingLabel.sizeToFit()
            altSpellingLabel.translatesAutoresizingMaskIntoConstraints = false

        }
        scrollView.addSubview(nameView)
        
        //ensure view constraints are not automatically created
        nameView.translatesAutoresizingMaskIntoConstraints = false
        cName.translatesAutoresizingMaskIntoConstraints = false
        
        //add label constraints
        let margins = self.view.safeAreaLayoutGuide
        cName.topAnchor.constraint(equalTo: nameView.topAnchor, constant: 5).isActive = true
        cName.widthAnchor.constraint(equalToConstant: cName.intrinsicContentSize.width).isActive = true
        cName.heightAnchor.constraint(greaterThanOrEqualToConstant: cName.intrinsicContentSize.height).isActive = true
        cName.centerXAnchor.constraint(equalTo: nameView.centerXAnchor).isActive = true
        
        //add nameview Constraints
        guard let subView = scrollView.subviews.first?.bottomAnchor else{
            print("No subviews in Scroll View")
            return
        }
        nameView.topAnchor.constraint(equalTo: subView, constant: 10).isActive = true
        nameView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 5).isActive = true
        nameView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -5).isActive = true
        nameView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        
        //add constraints for each alternate spelling
        var count = 1
        let last = altSpellings.count
        for _ in altSpellings{
            nameView.subviews[count].topAnchor.constraint(equalTo: nameView.subviews[count - 1].bottomAnchor, constant: 5).isActive = true
            nameView.subviews[count].leadingAnchor.constraint(equalTo: nameView.leadingAnchor, constant: 5).isActive = true
            nameView.subviews[count].trailingAnchor.constraint(equalTo: nameView.trailingAnchor, constant: 5).isActive = true
            if(count == last){
                nameView.subviews[count].bottomAnchor.constraint(equalTo: nameView.bottomAnchor, constant: -5).isActive = true
            }
            count = count + 1
        }
        
    }
    
    private func setupMapDisplay(_ scrollView : UIScrollView){
        //create map view
        let countryMapView = MKMapView()
        countryMapView.delegate = self
        scrollView.addSubview(countryMapView)
        
        //set location
        
        guard let lat = self.countryData?.coordinates.0, let long = self.countryData?.coordinates.1 else{
            print("Country Data missing Location")
            return
        }
        let location = CLLocation(latitude: lat, longitude: long)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        countryMapView.addAnnotation(annotation)
        

        //ensure constraints are not automatically created
        countryMapView.translatesAutoresizingMaskIntoConstraints = false

        
        //add constraints to map view
        let margins = self.view.safeAreaLayoutGuide
        let numViews = scrollView.subviews.count - 2
        countryMapView.topAnchor.constraint(equalTo: scrollView.subviews[numViews].bottomAnchor, constant: 10).isActive = true
        countryMapView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        countryMapView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 5).isActive = true
        countryMapView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -5).isActive = true
        countryMapView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
        
        guard let area = self.countryData?.area else{
            print("Area missing")
            return
        }
        
        let regionRad = Double(area) + 100000
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRad, regionRad)
        guard case (-90...90, -180...180) = (region.center.latitude, region.center.longitude) else {
            return
        }
        guard case (-90...90, -180...180) = (region.span.latitudeDelta, region.span.longitudeDelta) else {
            let newregion = MKCoordinateRegionMakeWithDistance(location.coordinate, 0, 0)
            countryMapView.setRegion(newregion, animated: true)
            return
        }

        countryMapView.setRegion(region, animated: true)
    }
    
    private func setupCountryData(_ scrollView: UIScrollView){
        //create Box for name View
        let DataView = UIView()
        DataView.layer.shadowOpacity = 0.8
        DataView.layer.shadowRadius = 5.0
        DataView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        DataView.backgroundColor = UIColor.white
        
        //add region Label
        let capitalLabel = UILabel()
        capitalLabel.lineBreakMode = .byWordWrapping
        capitalLabel.numberOfLines = 0
        capitalLabel.textColor = UIColor.black
        capitalLabel.textAlignment = .left
        guard let capital = self.countryData?.capital else{
            print("Country Capital Missing")
            return
        }
        capitalLabel.text = "Capital : " + capital
        DataView.addSubview(capitalLabel)
        
        //add region Label
        let regionLabel = UILabel()
        regionLabel.textColor = UIColor.black
        regionLabel.numberOfLines = 0
        regionLabel.lineBreakMode = .byWordWrapping
        regionLabel.textAlignment = .left
        guard let region = self.countryData?.region, let subRegion = self.countryData?.subRegion, let population = self.countryData?.population else{
            print("region/subregion Data Missing")
            return
        }
        regionLabel.text = "Region/SubRegion : " + region + "/" + subRegion
        DataView.addSubview(regionLabel)

        //add region Label
        let populationLabel = UILabel()
        populationLabel.textColor = UIColor.black
        populationLabel.numberOfLines = 0
        populationLabel.lineBreakMode = .byWordWrapping
        populationLabel.textAlignment = .left
        populationLabel.text = "Population : " + String(population)
        DataView.addSubview(populationLabel)
        
        
        
        scrollView.addSubview(DataView)

        DataView.translatesAutoresizingMaskIntoConstraints = false

        
        
        let margins = self.view.safeAreaLayoutGuide
        let numViews = scrollView.subviews.count - 2
        
        for num in 0...(DataView.subviews.count - 1){
            DataView.subviews[num].translatesAutoresizingMaskIntoConstraints = false
            if(num == 0){
                DataView.subviews[num].topAnchor.constraint(equalTo: DataView.topAnchor, constant: 5).isActive = true
            }else{
                DataView.subviews[num].topAnchor.constraint(equalTo: DataView.subviews[num - 1].bottomAnchor, constant: 5).isActive = true
            }
            DataView.subviews[num].leadingAnchor.constraint(equalTo: DataView.leadingAnchor, constant: 5).isActive = true
            DataView.subviews[num].trailingAnchor.constraint(equalTo: DataView.trailingAnchor, constant: -5).isActive = true
            DataView.subviews[num].heightAnchor.constraint(greaterThanOrEqualToConstant: DataView.subviews[num].intrinsicContentSize.height).isActive = true
            if(num == DataView.subviews.count - 1){
                DataView.subviews[num].bottomAnchor.constraint(equalTo: DataView.bottomAnchor, constant: -5).isActive = true
            }
        }

        DataView.topAnchor.constraint(equalTo: scrollView.subviews[numViews].bottomAnchor, constant: 10).isActive = true
        DataView.heightAnchor.constraint(greaterThanOrEqualToConstant: DataView.intrinsicContentSize.height).isActive = true
        DataView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 5).isActive = true
        DataView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -5).isActive = true
        DataView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
    }

}
