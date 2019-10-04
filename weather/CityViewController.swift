//
//  CityViewController.swift
//  weather
//
//  Created by codinghands on 01/10/19.
//  Copyright © 2019 codinghands. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol maincity{
    func selectcityfunction(name: String,temperature:Double,description:String)
    
}

class CityViewController: UITableViewController,cityselection {
    var citycart = [[String:Any]]()
    var delegate2nd: maincity?
    var showtempcelsius = true
    var city = [String: Any]()
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "cd5f597c21b6f1c08b2fd098e6d1981c"
    var params = [String:String]()
    let weatherdatamodel = WeatherDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let headerNib = UINib.init(nibName: "footerView", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "footerView")
    }
    override func viewWillAppear(_ animated: Bool) {
        if let citylist =  UserDefaults.standard.array(forKey: "citylist") as? [[String : Any]]{
            //        if citycart.isEmpty{
            citycart = citylist
            print(self.citycart)
            self.tableView.reloadData()
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return citycart.count
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footerView") as! footerView
        footerView.celldelegate = self
        return footerView
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "citydesccell", for: indexPath)
            as! CityDescTableViewCell
        cell.CityLabel.text =  citycart[indexPath.row]["cityname"] as? String
        cell.timestamp.text = citycart[indexPath.row]["citydesc"] as? String
        if showtempcelsius{
            cell.temperature.text  = String(citycart[indexPath.row]["citytemperature"] as! Int) + "°C"
        }else{
            cell.temperature.text  = String(citycart[indexPath.row]["citytemperature"] as! Int + 273) + " F"
        }
        cell.climateimageView.image = UIImage(named: citycart[indexPath.row]["cityimage"] as! String)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate2nd?.selectcityfunction(name: citycart[indexPath.row]["cityname"] as! String, temperature: Double(citycart[indexPath.row]["citytemperature"] as! Int), description: citycart[indexPath.row]["citydesc"] as! String)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            citycart.remove(at: indexPath.row)
            UserDefaults.standard.set(citycart, forKey: "citylist")
            tableView.deleteRows(at: [indexPath], with: .fade)
            UserDefaults.standard.synchronize()
        }
    }
    
    func selectcityfunction(object:String) {
        params = ["q":object, "appid": APP_ID]
        getWeatherData(url: WEATHER_URL, param: params )
    }
    func getWeatherData(url:String,param: [String:String]){
        print("apicalling")
        Alamofire.request(url,method: .get,
                          parameters: param).responseJSON { response in
                            guard response.result.isSuccess
                                else {
                                    print("Error while fetching weatherdata: \(String(describing: response.result.error))")
                                    return
                            }
                            let weatherJSON : JSON = JSON(response.result.value!)
                            print(weatherJSON)
                            self.updateWeatherData(json: weatherJSON)
        }
    }
    
    //Write the updateWeatherData method here:
    
    func updateWeatherData(json: JSON){
        print("json parsing")
        if let tempResult = json["main"]["temp"].double{
            weatherdatamodel.temperature = Int(tempResult - 273.15)
            let cityResult = json["name"].stringValue
            weatherdatamodel.cityName =  cityResult
            let weatherResult = json["weather"][0]["id"].intValue
            weatherdatamodel.weatherCondition = weatherResult
            weatherdatamodel.weatherIcon =  weatherdatamodel.updateWeatherIcon(condition: weatherResult)
            let weatherDesc = json["weather"][0]["main"].stringValue
            weatherdatamodel.weatherDescription = weatherDesc
            updateUI()
        }else{
            //self.cityLabel.text = "LOcation errror"
        }
    }
    //Write the updateUIWithWeatherData method here:
    func updateUI()
        
    {
        city = (["cityname": weatherdatamodel.cityName, "citytemperature": weatherdatamodel.temperature, "citydesc": weatherdatamodel.weatherDescription,"cityimage":weatherdatamodel.weatherIcon])
        let dict:[[String:AnyObject]] = citycart.filter{($0["cityname"] as! String) == weatherdatamodel.cityName } as [[String : AnyObject]]
        if dict.isEmpty{
            citycart.append(city)
        }else{
            print("duplicate")
        }
        UserDefaults.standard.set(citycart, forKey: "citylist")
        // UserDefaults.standard.synchronize()
        self.tableView.reloadData()
        //self.dismiss(animated: true, completion: nil)
    }
}
extension CityViewController:footerViewDelegate{
 func degreeAction() {
        showtempcelsius = true
        self.tableView.reloadData()
    }
    
    func farenheitAction() {
        showtempcelsius = false
        self.tableView.reloadData()
    }
    
    func searchAction() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "search") as! SearchTableViewController
        self.present(vc, animated: true, completion: nil)
        vc.delegatevar = self
    }
}
