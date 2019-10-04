//
//  ViewController.swift
//  weather
//
//  Created by codinghands on 01/10/19.
//  Copyright © 2019 codinghands. All rights reserved.
//

import UIKit

class ViewController: UIViewController,maincity {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var climateType: UILabel!
    @IBOutlet weak var showButton: UIButton!
    var citycart = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        showButton.layer.cornerRadius = 5.0
        if let citylist =  UserDefaults.standard.array(forKey: "citylist") as? [[String : Any]]{
//        if citycart.isEmpty{
            citycart = citylist
            print(self.citycart)
            self.cityLabel.text =  self.citycart[0]["cityname"] as? String
            self.climateType.text = self.citycart[0]["citydesc"] as? String
            self.temperatureLabel.text  = String(self.citycart[0]["citytemperature"] as! Double)
        }else{
            cityLabel.text =  "Coding Hands"
            climateType.text = "cool"
            temperatureLabel.text  = "27°C"
        }
    }
    
    @IBAction func showButton(_ sender: UIButton) {
        
    }
    
    func selectcityfunction(name: String, temperature: Double, description: String) {
        self.temperatureLabel.text = String(temperature)
        self.cityLabel.text = name
        self.climateType.text = description
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show"{
            let vc = segue.destination as! CityViewController
            vc.delegate2nd = self
        }
    }
}

