//
//  WeatherViewController.swift
//  TACWeather
//
//  Created by Hadi on 31/01/2019.
//  Copyright © 2019 Hadi. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    private let weatherAPI = WeatherAPI()
    var location: CLLocation!
    var currentWeatherInCelsius: Double?
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weatherAPI.fetchWeather(for: location) { (weather, error) in
            
            if error != nil{

                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }

            if let tempInKelvin = weather?.main.temp{
                
                let tempInCelsius = tempInKelvin - 273.15
                let tempInInt = Int(tempInCelsius)
                self.currentWeatherInCelsius = tempInCelsius
                DispatchQueue.main.async {
                    self.temperatureLabel.text = "\(tempInInt) ℃"
                }

            }
        
        }
        
    }
    
    @IBAction func didChangeTemperatureUnit(_ sender: UISegmentedControl) {
        
        guard let currentWeatherInCelsius = currentWeatherInCelsius else{
            
            print("No weather record found")
            return
        }
        
        if sender.selectedSegmentIndex == 0{
            
            //Celcius
            let tempInInt = Int(currentWeatherInCelsius)
            self.temperatureLabel.text = "\(tempInInt) ℃"
            
        }else{
            
            //Fahrenheit
            let tempInFahrenheit = (1.8 * currentWeatherInCelsius) + 32
            let tempInInt = Int(tempInFahrenheit)
            self.temperatureLabel.text = "\(tempInInt) ℉"
            
        }
        
    }
    
    @IBAction func didTapBackButton(){
        
        self.dismiss(animated: true, completion: nil)
        
    }

}
