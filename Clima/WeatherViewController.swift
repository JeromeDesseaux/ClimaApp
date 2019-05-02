//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    //Constants
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "aa03df8d87f17486863d4854b396e448"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    

    //TODO: Declare instance variables here
    let locationManager : CLLocationManager = CLLocationManager()
    let weatherDataModel : WeatherDataModel = WeatherDataModel()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData(url:String, params:[String:String]){
        Alamofire.request(url, method: .get, parameters: params).responseJSON(completionHandler: {
            response in
            if response.result.isSuccess{
                if let data = response.result.value {
                    let json : JSON = JSON(data)
                    self.udpateWeatherData(json: json)
                }
                print("You've got data")
            }else{
                print("There was an error while retrieving your current weather data.")
            }
        })
    }
    

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func udpateWeatherData(json: JSON){
        if let temperature = json["main"]["temp"].double {
            self.weatherDataModel.temperature = Int(temperature - 273.15)
            self.weatherDataModel.city = json["name"].stringValue
            self.weatherDataModel.condition = json["weather"][0]["id"].intValue
            self.weatherDataModel.weatherIconName =  self.weatherDataModel.updateWeatherIcon(condition: self.weatherDataModel.condition)
            self.updateUIWithWeatherData()
        }else{
            cityLabel.text = "Weather unavailable"
        }
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData(){
        cityLabel.text = self.weatherDataModel.city
        temperatureLabel.text = "\(self.weatherDataModel.temperature)"
        weatherIcon.image = UIImage(named: self.weatherDataModel.weatherIconName)
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            self.locationManager.stopUpdatingLocation()
            
            // Defining latitude and longitude
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            // Setting up URL parameters
            let urlParameters : [String:String] = ["lat":latitude,"lon":longitude,"appid":self.APP_ID]
            self.getWeatherData(url: self.WEATHER_URL, params: urlParameters)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location unavailable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    
    
    
    
    
}


