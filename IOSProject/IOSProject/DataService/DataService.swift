//
//  DataService.swift
//  IOSProject
//
//  Created by Kyle De Laurell on 1/4/18.
//  Copyright © 2018 Kyle De Laurell. All rights reserved.
//



import Foundation
import UIKit

class DataService{
    static let ds = DataService()
    //--------------------------------------------------------------------------
    //--------------------Get Country Photos------------------------------------
    //--------------------------------------------------------------------------
    func startCountryPhotoLoad(countryCode : String, completionBlock: @escaping (UIImage)->Void) {
        guard let url = URL(string: countryImageURL + countryCode + ".gif") else{
            print("URL error")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //create URL Session
        let task = URLSession.shared.dataTask(with: request) { (responseData, response, error) in
            //Check for errors
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            //Check for good HTTP Response
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print(response as Any)
                    return
            }
            //transform json data
            if let imageData = responseData{
                if let countryImage = UIImage(data: imageData){
                    completionBlock(countryImage)
                }
            }
            
            
            
        }
        
        task.resume()
    }
    
    //--------------------------------------------------------------------------
    //--------------------GET JSON DATA FROM URL--------------------------------
    //--------------------------------------------------------------------------
    
    func startCountryDataLoad(completionBlock: @escaping ([Country])->Void){
        
        //Set up URL and request
        guard let url = URL(string: countryDataURL) else{
            print("URL Error")
            return
        }
        var request = URLRequest(url: url)
        
        //Add HTTP Request Headers and Method
        request.addValue(XMKey, forHTTPHeaderField: "X-Mashape-Key")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        //create URL Session
        let task = URLSession.shared.dataTask(with: request) { (responseData, response, error) in
            var countryData : [Country] = []
            
            //Check for errors
            if error != nil{
                print(error)
                return
            }
            
            //Check for good HTTP Response
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    return
            }
            
            
            //transform json data and use to create country models
            do {
                if let json = try JSONSerialization.jsonObject(with: responseData!) as? [[String:Any]]{
                    for j in json{
                        do{
                            let newCountry = try Country(json: j)
                            print(newCountry)
                            countryData.append(newCountry)
                        }
                        catch{
                           print(error)
                        }
                    }
                    completionBlock(countryData)
                }else{
                    print("KYLE: ERROR transforming data to JSON")
                }
            } catch {
                print(error.localizedDescription)
            }

        }
        
        task.resume()
        
    }
}
