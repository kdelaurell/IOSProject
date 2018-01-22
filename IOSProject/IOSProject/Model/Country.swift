//
//  Country.swift
//  IOSProject
//
//  Created by Kyle De Laurell on 1/4/18.
//  Copyright © 2018 Kyle De Laurell. All rights reserved.
//

import Foundation

enum JSONDataError: Error {
    case missing(String)
    case invalid(String, Any)
}

struct Country{
    //initialize variables
    private var _alpha2Code : String
    private var _alpha3Code : String
    private var _altSpellings : [String]
    private var _area : Int
    private var _borders : [String]
    private var _callingCodes : [String]
    private var _capital : String
    private var _currencies : [String]
    private var _demonym : String
    private var _gini : Double
    private var _languages : [String]
    private var _coordinates : (Double, Double)
    private var _name : String
    private var _nativeName : String
    private var _numericCode : String //relook at this
    private var _population : Int
    private var _region : String
    private var _relevance : String
    private var _subRegion : String
    private var _timezones : [String]
    private var _topLevelDomain : [String]
    private var _translations : NSDictionary
    
    //get methods for values
    
    var alpha2Code : String{
        return _alpha2Code
    }
    var alpha3Code : String{
        return _alpha3Code
    }
    var altSpellings : [String]{
        return _altSpellings
    }
    var area : Int{
        return _area
    }
    var borders : [String]{
        return _borders
    }
    var callingCodes : [String]{
        return _callingCodes
    }
    var capital : String{
        return _capital
    }
    var currencies : [String]{
        return _currencies
    }
    var demonym : String{
        return _demonym
    }
    var gini : Double{
        return _gini
    }
    var languages : [String]{
        return _languages
    }
    var coordinates : (Double, Double){
        return _coordinates
    }
    var name : String{
        return _name
    }
    var nativeName : String {
        return _nativeName
    }
    var numericCode : String{
        return _numericCode
    } //relook at this
    var population : Int{
        return _population
    }
    var region : String{
        return _region
    }
    var relevance : String{
        return _relevance
    }
    var subRegion : String{
        return _subRegion
    }
    var timezones : [String]{
        return _timezones
    }
    var topLevelDomain : [String]{
        return _topLevelDomain
    }
    var translations : NSDictionary{
        return _translations
    }
    
    //initialize Country
    init(json: [String : Any]) throws {
        guard let Testalpha2Code = json["alpha2Code"] as? String else {
            throw JSONDataError.missing("alpha2Code")
        }
        guard let TestaltSpellings = json["altSpellings"] as? [String] else {
            throw JSONDataError.missing("altSpellings")
        }
        if let Testarea = json["area"] as? Int{
            self._area = Testarea
        } else {
            self._area = 0
        }
        guard let Testcapital = json["capital"] as? String else {
            throw JSONDataError.missing("capital")
        }
        guard let Testlatlng = json["latlng"] as? [Double] else {
            throw JSONDataError.missing("latlng")
        }
        guard Testlatlng.count == 2 else{
            throw JSONDataError.invalid("latlng", Testlatlng)
        }
        
        let newCoordinates = (Testlatlng[0], Testlatlng[1])
        guard case (-90...90, -180...180) = newCoordinates else {
            throw JSONDataError.invalid("coordinate", newCoordinates)
        }
        guard let Testname = json["name"] as? String else {
            throw JSONDataError.missing("name")
        }
        guard let Testpopulation = json["population"] as? Int else {
            throw JSONDataError.missing("population")
        }
        guard let Testregion = json["region"] as? String else {
            throw JSONDataError.missing("region")

        }
        guard let TestsubRegion = json["subregion"] as? String else {
            throw JSONDataError.missing("subregion")
        }
        
        //guarded variables - specifically used in application
        self._alpha2Code = Testalpha2Code
        self._altSpellings = TestaltSpellings
        self._capital = Testcapital
        self._coordinates = newCoordinates
        self._name = Testname
        self._region = Testregion
        self._population = Testpopulation
        self._subRegion = TestsubRegion

        
        
        //unguarded variables - not currently used in application
        //provided value in case of nil returned by optional
        self._gini = json["gini"] as? Double ?? 0.0
        self._alpha3Code = json["alpha3Code"] as? String ?? ""
        self._borders = json["borders"] as? [String] ?? []
        self._callingCodes = json["callingCodes"] as? [String] ?? []
        self._currencies = json["currencies"] as? [String] ?? []
        self._demonym = json["demonym"] as? String ?? ""
        self._languages = json["languages"] as? [String] ?? []
        self._nativeName = json["nativeName"] as? String ?? ""
        self._numericCode = json["numericCode"] as? String ?? ""
        self._relevance = json["relevance"] as? String ?? ""
        self._timezones = json["timezones"] as? [String] ?? []
        self._topLevelDomain = json["topLevelDomain"] as? [String] ?? []
        self._translations = json["translations"] as? NSDictionary ?? [:]
    }
}
